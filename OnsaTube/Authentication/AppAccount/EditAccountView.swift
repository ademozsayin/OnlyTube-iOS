import DesignSystem
import Env
import Models
import Network
import NukeUI
import SwiftUI

@MainActor
public struct EditAccountView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(Theme.self) private var theme
    @Environment(UserPreferences.self) private var userPrefs
    
    @State private var viewModel = EditAccountViewModel()
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            Form {
                if viewModel.isLoading {
                    loadingSection
                } else {
                    imagesSection
                    aboutSection
                }
            }
            .environment(\.editMode, .constant(.active))
#if !os(visionOS)
            .scrollContentBackground(.hidden)
            .background(theme.secondaryBackgroundColor)
            .scrollDismissesKeyboard(.immediately)
#endif
            .navigationTitle("account.edit.navigation-title")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                toolbarContent
            }
            .alert("account.edit.error.save.title",
                   isPresented: $viewModel.saveError,
                   actions: {
                Button("alert.button.ok", action: {})
            }, message: { Text("account.edit.error.save.message") })
            .task {
                await viewModel.fetchAccount()
            }
        }
    }
    
    private var loadingSection: some View {
        Section {
            HStack {
                Spacer()
                ProgressView()
                Spacer()
            }
        }
#if !os(visionOS)
        .listRowBackground(theme.primaryBackgroundColor)
#endif
    }
    
    private var imagesSection: some View {
        Section {
            ZStack {
                HStack {
                    Spacer()
                    if let avatar = viewModel.avatar {
                        AvatarView(avatar, config: .account)
                    }
                    Spacer()
                }
                
                Menu {
                    Button("account.edit.avatar") {
                        viewModel.isChangingAvatar = true
                        viewModel.isPhotoPickerPresented = true
                    }
                    // Uncomment and adjust as needed
                    // Button("account.edit.header") {
                    //     viewModel.isChangingHeader = true
                    //     viewModel.isPhotoPickerPresented = true
                    // }
                } label: {
                    Image(systemName: "photo.badge.plus")
                        .foregroundStyle(.white)
                }
                .buttonStyle(.borderedProminent)
                .clipShape(Circle())
            }
            .overlay {
                if viewModel.isChangingAvatar {
                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(Color.black.opacity(0.40))
                        ProgressView()
                    }
                }
            }
            .listRowInsets(EdgeInsets())
        }
        .listRowBackground(theme.secondaryBackgroundColor)
        .photosPicker(isPresented: $viewModel.isPhotoPickerPresented,
                      selection: $viewModel.mediaPickers,
                      maxSelectionCount: 1,
                      matching: .any(of: [.images]),
                      photoLibrary: .shared())
    }
    
    @ViewBuilder
    private var aboutSection: some View {
        Section("account.edit.display-name") {
            TextField("account.edit.display-name", text: $viewModel.displayName)
        }
        .listRowBackground(theme.primaryBackgroundColor)
    }
    
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        CancelToolbarItem()
        
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                Task {
                    await viewModel.save()
                    dismiss()
                }
            } label: {
                if viewModel.isSaving {
                    ProgressView()
                } else {
                    Text("Save").bold()
                }
            }
        }
    }
}

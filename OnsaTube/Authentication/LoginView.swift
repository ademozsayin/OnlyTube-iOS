//
//  File.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 3.07.2024.
//
import SwiftUI
import DesignSystem
import Env
/// Screen for logging in to a WPCom account during the Jetpack setup flow
/// This is presented for users authenticated with WPOrg credentials.
@MainActor
struct LoginView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(AuthenticationManager.self) private var authenticationManager

    @State private var isPrimaryButtonLoading = false
    
    @State private var viewModel: LoginViewModel
    @Environment(Theme.self) private var theme
    @Environment(RouterPath.self) private var routerPath

    private enum Field: Hashable {
        case username
        case password
    }
    
    @FocusState private var focusedField: Field?
    @State private var showsSecureInput: Bool = true

    public init(siteUrl: String) {
        _viewModel = .init(initialValue: .init(siteUrl: siteUrl))
    }

    /// Attributed string for the description text
    private var descriptionAttributedString: NSAttributedString {
        let font: UIFont = .body
        let boldFont: UIFont = .preferredFont(forTextStyle: .body)
        let siteName = "Site Name"
        let description = "Description"
        
        let attributedString = NSMutableAttributedString(
            string: String(format: description, siteName),
            attributes: [.font: font,
                         .foregroundColor: UIColor.text.withAlphaComponent(0.8)
            ]
        )
        let boldSiteAddress = NSAttributedString(string: siteName, attributes: [.font: boldFont, .foregroundColor: UIColor.text])
        attributedString.replaceFirstOccurrence(of: siteName, with: boldSiteAddress)
        return attributedString
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Constants.blockVerticalPadding) {
                    JetpackInstallHeaderView()
                    
                    // title and description
                    VStack(alignment: .leading, spacing: Constants.contentVerticalSpacing) {
                        Text("Login")
                            .largeTitleStyle()
                        AttributedText(descriptionAttributedString)
                    }
                    
                    // text fields
                    VStack(alignment: .leading, spacing: 16) {
                        // Username field.
                        AuthenticationFormFieldView(viewModel: .init(header: "Email",
                                                                     placeholder: "Enter your email",
                                                                     keyboardType: .default,
                                                                     text: $viewModel.emailAddress,
                                                                     isSecure: false,
                                                                     errorMessage: nil,
                                                                     isFocused: focusedField == .username))
                        .focused($focusedField, equals: .username)
                        .disabled(viewModel.isLoggingIn)
                        
                        // Password field.
                        AuthenticationFormFieldView(viewModel: .init(header: "Password",
                                                                     placeholder: "Enter password",
                                                                     keyboardType: .default,
                                                                     text: $viewModel.password,
                                                                     isSecure: true,
                                                                     errorMessage: nil,
                                                                     isFocused: focusedField == .password))
                        .focused($focusedField, equals: .password)
                        .disabled(viewModel.isLoggingIn)
                    }
                    
                    Spacer()
                }
                .padding()
//                .withAppRouter()
            }
            .onChange(of: authenticationManager.currentAccount) { _, newValue in
                dismiss()
            }
            .navigationTitle("Login")
            .navigationBarTitleDisplayMode(.inline)
#if !os(visionOS)
            .scrollIndicators(.hidden) // Hide scroll indicators
            .background(theme.primaryBackgroundColor)
#endif
            .toolbar {
                CancelToolbarItem()
            }
            .safeAreaInset(edge: .bottom, content: {
                VStack {
                    Button {
                        focusedField = nil
                        Task {
                           await viewModel.login()
                        }
                       
                    } label: {
                        Text("Login")
                    }
                    .buttonStyle(PrimaryLoadingButtonStyle(isLoading: viewModel.isLoggingIn))
                    .disabled(viewModel.primaryButtonDisabled)
                    .padding(.top, Constants.contentVerticalSpacing)
                    
                    NavigationLink(destination:RegisterView()) {
                        Text("Don't have an account? ")
                            .foregroundColor(.primary) +
                        Text("Sign up")
                            .foregroundColor(theme.tintColor)
                            .fontWeight(.bold)
                    }
                    
                }
                .background(theme.primaryBackgroundColor)
                .padding()

            })
           
            .alert(viewModel.errorMessage, isPresented: $viewModel.shouldShowErrorAlert) {
                Button("Okay") {
                    viewModel.shouldShowErrorAlert.toggle()
                }
            }

        }
    }
    
}

private extension LoginView {
    enum Constants {
        static let blockVerticalPadding: CGFloat = 32
        static let contentVerticalSpacing: CGFloat = 8
        static let contentPadding: CGFloat = 16
    }
    
    enum Localization {
        static let emailLabel = NSLocalizedString(
            "Email Address or Username",
            comment: "Label for the email field on the WPCom email login screen of the Jetpack setup flow."
        )
        static let enterEmail = NSLocalizedString(
            "Enter email or username",
            comment: "Placeholder text for the email field on the WPCom email login screen of the Jetpack setup flow."
        )
    }
}


extension UIImage {
    /// Connection Icon
    ///
    static var wooLogoImage: UIImage {
        return UIImage(named: "AppIcon")!
    }
    
}

/// Header view on top of the screens in Jetpack Install flows
///
struct JetpackInstallHeaderView: View {
    /// Scale of the view based on accessibility changes
    @ScaledMetric private var scale: CGFloat = 1.0
    
    var isError: Bool = false
    
    var body: some View {
        HStack(spacing: Constants.headerContentSpacing) {
            Image(uiImage: UIImage(named: "AppIcon")!)
                .resizable()
                .frame(width: Constants.logoSize * scale, height: Constants.logoSize * scale)
            Image(uiImage: .iconConnection)
                .resizable()
                .flipsForRightToLeftLayoutDirection(true)
                .frame(width: Constants.connectionIconSize * scale, height: Constants.connectionIconSize * scale)

            Image(systemName: "exclamationmark.circle.fill")
                .resizable()
                .frame(width: Constants.logoSize * scale, height: Constants.logoSize * scale)
                .foregroundColor(Color(uiColor: .red))
                .renderedIf(isError)
            
            Spacer()
        }
    }
}

private extension JetpackInstallHeaderView {
    enum Constants {
        static let logoSize: CGFloat = 40
        static let wooIconSize: CGSize = .init(width: 30, height: 18)
        static let connectionIconSize: CGFloat = 10
        static let headerContentSpacing: CGFloat = 8
    }
}


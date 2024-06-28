//
//  SortingModeSelectionModifier.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 28.06.2024.
//

import SwiftUI
import DesignSystem

struct SortingModeSelectionModifier: ViewModifier {
    let sortingSubject: PreferencesStorageModel.Properties
    
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject private var PSM = PreferencesStorageModel.shared
    @State private var sortingMode: PreferencesStorageModel.Properties.SortingModes
    init(sortingSubject: PreferencesStorageModel.Properties) {
        self.sortingSubject = sortingSubject
        self.sortingMode = (PreferencesStorageModel.shared.propetriesState[sortingSubject] as? PreferencesStorageModel.Properties.SortingModes) ?? .oldest
    }
    
    @Environment(Theme.self) private var theme
    
    func body(content: Content) -> some View {
        if self.sortingSubject == .downloadsSortingMode || self.sortingSubject == .favoritesSortingMode {
            content
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing, content: {
                        Menu {
                            let selectionBinding: Binding<PreferencesStorageModel.Properties.SortingModes> = Binding(get: {
                                self.sortingMode
                            }, set: { newValue in
                                PSM.setNewValueForKey(self.sortingSubject, value: newValue)
                                self.sortingMode = newValue
                            })
                            Picker("", selection: selectionBinding) {
                                Label("Newest", systemImage: "arrow.up.to.line.compact").tag(PreferencesStorageModel.Properties.SortingModes.newest)
                                Label("Oldest", systemImage: "arrow.down.to.line.compact").tag(PreferencesStorageModel.Properties.SortingModes.oldest)
                                Label("Title", systemImage: "play.rectangle").tag(PreferencesStorageModel.Properties.SortingModes.title)
                                Label("Channel", systemImage: "person").tag(PreferencesStorageModel.Properties.SortingModes.channelName)
                            }
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(theme.labelColor == .white ? .white.opacity(0.1) : .black.opacity(0.35))
                                    .frame(width: 30)
                                Circle()
                                    .fill(.regularMaterial)
                                    .frame(width: 30)
                                Image(systemName: "line.3.horizontal.decrease") // or arrow.up.and.down.text.horizontal arrow.up.arrow.down.circle
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 18)
                            }
                        }
                    })
                }
                .onAppear {
                    self.sortingMode = (PreferencesStorageModel.shared.propetriesState[sortingSubject] as? PreferencesStorageModel.Properties.SortingModes) ?? .oldest
                }
        } else {
            content
        }
    }
}

extension View {
    /// Add a button to the top trailing toolbar to change the sort mode for the desired ``PreferencesStorageModel.Properties``, should be ``PreferencesStorageModel/Properties/favoritesSortingMode`` or ``PreferencesStorageModel/Properties/downloadsSortingMode``.
    func sortingModeSelectorButton(forPropertyType type: PreferencesStorageModel.Properties) -> some View {
        self.modifier(SortingModeSelectionModifier(sortingSubject: type))
    }
}

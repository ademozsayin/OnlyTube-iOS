//
//  DisplaySettingsView.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 10.06.2024.
//

import Combine
import DesignSystem
import Env
import Models
import Network
import Observation
//import StatusKit
import SwiftUI

@MainActor
@Observable class DisplaySettingsLocalValues {
    var tintColor = Theme.shared.tintColor
    var primaryBackgroundColor = Theme.shared.primaryBackgroundColor
    var secondaryBackgroundColor = Theme.shared.secondaryBackgroundColor
    var labelColor = Theme.shared.labelColor
    var lineSpacing = Theme.shared.lineSpacing
    var fontSizeScale = Theme.shared.fontSizeScale
}

@MainActor
struct DisplaySettingsView: View {
    typealias FontState = Theme.FontState
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(Theme.self) private var theme
    @Environment(UserPreferences.self) private var userPreferences
    
    @State private var localValues = DisplaySettingsLocalValues()
    
    @State private var isFontSelectorPresented = false
    
    var body: some View {
        ZStack(alignment: .top) {
            Form {
#if !os(visionOS)
                VideoFromSearchView(videoWithData: VideoPlayerModel.shared.sampleVideo2.withData())
                    .frame( height: 250 * 9/16 + 90, alignment: .center)
                    .allowsHitTesting(false)
                    .background(Color.pink)
                    .opacity(0)
                    .hidden()
                   
                themeSection
#endif
                fontSection
//                layoutSection
                platformsSection
                resetSection
            }
            .navigationTitle("settings.display.navigation-title")
#if !os(visionOS)
            .scrollContentBackground(.hidden)
            .background(theme.secondaryBackgroundColor)
#endif
            .task(id: localValues.tintColor) {
                do { try await Task.sleep(for: .microseconds(500)) } catch {}
                theme.tintColor = localValues.tintColor
            }
            .task(id: localValues.primaryBackgroundColor) {
                do { try await Task.sleep(for: .microseconds(500)) } catch {}
                theme.primaryBackgroundColor = localValues.primaryBackgroundColor
            }
            .task(id: localValues.secondaryBackgroundColor) {
                do { try await Task.sleep(for: .microseconds(500)) } catch {}
                theme.secondaryBackgroundColor = localValues.secondaryBackgroundColor
            }
            .task(id: localValues.labelColor) {
                do { try await Task.sleep(for: .microseconds(500)) } catch {}
                theme.labelColor = localValues.labelColor
            }
            .task(id: localValues.lineSpacing) {
                do { try await Task.sleep(for: .microseconds(500)) } catch {}
                theme.lineSpacing = localValues.lineSpacing
            }
            .task(id: localValues.fontSizeScale) {
                do { try await Task.sleep(for: .microseconds(500)) } catch {}
                theme.fontSizeScale = localValues.fontSizeScale
            }
#if !os(visionOS)
            examplePost
#endif
        }
    }
    
    private var examplePost: some View {
        VStack(spacing: 0) {
            VideoFromSearchView(videoWithData: VideoPlayerModel.shared.sampleVideo2.withData())
                .frame( height: 250 * 9/16 + 90, alignment: .center)
                .allowsHitTesting(false)
                .padding(.layoutPadding)
                .background(theme.primaryBackgroundColor)
                .cornerRadius(8)
                .padding(.horizontal, .layoutPadding)
                .padding(.top, .layoutPadding)
                .background(theme.secondaryBackgroundColor)
            Rectangle()
                .fill(theme.secondaryBackgroundColor)
                .frame(height: 30)
                .mask(LinearGradient(gradient: Gradient(colors: [theme.secondaryBackgroundColor, .clear]),
                                     startPoint: .top, endPoint: .bottom))
        }
    }
    
    @ViewBuilder
    private var themeSection: some View {
        @Bindable var theme = theme
        Section {
            Toggle("settings.display.theme.systemColor", isOn: $theme.followSystemColorScheme)
            themeSelectorButton
            Group {
                ColorPicker("settings.display.theme.tint", selection: $localValues.tintColor)
                ColorPicker("settings.display.theme.background", selection: $localValues.primaryBackgroundColor)
                ColorPicker("settings.display.theme.secondary-background", selection: $localValues.secondaryBackgroundColor)
                ColorPicker("settings.display.theme.text-color", selection: $localValues.labelColor)
            }
            .disabled(theme.followSystemColorScheme)
            .opacity(theme.followSystemColorScheme ? 0.5 : 1.0)
            .onChange(of: theme.selectedSet) {
                localValues.tintColor = theme.tintColor
                localValues.primaryBackgroundColor = theme.primaryBackgroundColor
                localValues.secondaryBackgroundColor = theme.secondaryBackgroundColor
                localValues.labelColor = theme.labelColor
            }
        } header: {
            Text("settings.display.section.theme")
        } footer: {
            if theme.followSystemColorScheme {
                Text("settings.display.section.theme.footer")
            }
        }
#if !os(visionOS)
        .listRowBackground(theme.primaryBackgroundColor)
#endif
    }
    
    private var fontSection: some View {
        Section("settings.display.section.font") {
            Picker("settings.display.font", selection: .init(get: { () -> FontState in
                if theme.chosenFont?.fontName == "OpenDyslexic-Regular" {
                    return FontState.openDyslexic
                } else if theme.chosenFont?.fontName == "AtkinsonHyperlegible-Regular" {
                    return FontState.hyperLegible
                } else if theme.chosenFont?.fontName == ".AppleSystemUIFontRounded-Regular" {
                    return FontState.SFRounded
                }
                return theme.chosenFontData != nil ? FontState.custom : FontState.system
            }, set: { newValue in
                switch newValue {
                    case .system:
                        theme.chosenFont = nil
                    case .openDyslexic:
                        theme.chosenFont = UIFont(name: "OpenDyslexic", size: 1)
                    case .hyperLegible:
                        theme.chosenFont = UIFont(name: "Atkinson Hyperlegible", size: 1)
                    case .SFRounded:
                        theme.chosenFont = UIFont.systemFont(ofSize: 1).rounded()
                    case .custom:
                        isFontSelectorPresented = true
                }
            })) {
                ForEach(FontState.allCases, id: \.rawValue) { fontState in
                    Text(fontState.title).tag(fontState)
                }
            }
            .navigationDestination(isPresented: $isFontSelectorPresented, destination: { FontPicker() })
            
            VStack {
                Slider(value: $localValues.fontSizeScale, in: 0.5 ... 1.5, step: 0.1)
                Text("settings.display.font.scaling-\(String(format: "%.1f", localValues.fontSizeScale))")
                    .font(.scaledBody)
            }
            .alignmentGuide(.listRowSeparatorLeading) { d in
                d[.leading]
            }
            
            VStack {
                Slider(value: $localValues.lineSpacing, in: 0.4 ... 10.0, step: 0.2)
                Text("settings.display.font.line-spacing-\(String(format: "%.1f", localValues.lineSpacing))")
                    .font(.scaledBody)
            }
            .alignmentGuide(.listRowSeparatorLeading) { d in
                d[.leading]
            }
        }
#if !os(visionOS)
        .listRowBackground(theme.primaryBackgroundColor)
#endif
    }

    
    @ViewBuilder
    private var platformsSection: some View {
        @Bindable var userPreferences = userPreferences
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            Section("settings.display.section.platform") {
                Toggle("settings.display.show-ipad-column", isOn: $userPreferences.showiPadSecondaryColumn)
            }
#if !os(visionOS)
            .listRowBackground(theme.primaryBackgroundColor)
#endif
        }
    }
    
    private var resetSection: some View {
        Section {
            Button {
                theme.restoreDefault()
            } label: {
                Text("settings.display.restore")
            }
        }
#if !os(visionOS)
        .listRowBackground(theme.primaryBackgroundColor)
#endif
    }
    
    private var themeSelectorButton: some View {
        NavigationLink(destination: ThemePreviewView()) {
            HStack {
                Text("settings.display.section.theme")
                Spacer()
                Text(theme.selectedSet.rawValue)
            }
        }
    }
}

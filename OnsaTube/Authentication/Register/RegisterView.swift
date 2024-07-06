//
//  RegisterView.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 5.07.2024.
//

import SwiftUI
import DesignSystem
import Env

@MainActor
struct RegisterView: View {
  
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(Theme.self) private var theme
    
    private enum Field: Hashable {
        case email
        case password
        case rePassword
        case displayName
    }
    
    @FocusState private var focusedField: Field?
 
    let termsAttributedString: NSAttributedString = createTermsAttributedString(siteURL: "https://github.com/ademozsayin/OnlyTube-iOS")
    
    
    private static func createTermsAttributedString(siteURL: String) -> NSAttributedString {
        let content = String.localizedStringWithFormat(Localization.termsContent, Localization.termsOfService, Localization.shareDetails)
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        let mutableAttributedText = NSMutableAttributedString(
            string: content,
            attributes: [.font: UIFont.footnote,
                         .foregroundColor: UIColor.secondaryLabel,
                         .paragraphStyle: paragraph]
        )
        
        mutableAttributedText.setAsLink(textToFind: Localization.termsOfService,
                                        linkURL: Constants.jetpackTermsURL + siteURL)
        mutableAttributedText.setAsLink(textToFind: Localization.shareDetails,
                                        linkURL: Constants.jetpackShareDetailsURL + siteURL)
        return mutableAttributedText
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
    
    
    @State private var viewModel: RegisterViewModel
    
    public init() {
        _viewModel = .init(initialValue: .init())
    }
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: Constants.blockVerticalPadding) {
                JetpackInstallHeaderView()
                // title and description
                VStack(alignment: .leading, spacing: Constants.contentVerticalSpacing) {
                    Text("Register")
                        .largeTitleStyle()
                    AttributedText(descriptionAttributedString)
                }
                
                // text fields
                VStack(alignment: .leading, spacing: 16) {
                    // Display name
                    AuthenticationFormFieldView(viewModel: .init(header: "Username",
                                                                 placeholder: "Display name",
                                                                 keyboardType: .default,
                                                                 text: $viewModel.displayName,
                                                                 isSecure: false,
                                                                 errorMessage: nil,
                                                                 isFocused: focusedField == .displayName))
                    .focused($focusedField, equals: .displayName)
                    .disabled(viewModel.isRegistering)
                    
                    // Username field.
                    AuthenticationFormFieldView(viewModel: .init(header: "Email",
                                                                 placeholder: "Enter your email",
                                                                 keyboardType: .default,
                                                                 text: $viewModel.email,
                                                                 isSecure: false,
                                                                 errorMessage: nil,
                                                                 isFocused: focusedField == .email))
                    .focused($focusedField, equals: .email)
                    .disabled(viewModel.isRegistering)
                    
                    // Password field.
                    AuthenticationFormFieldView(viewModel: .init(header: "Password",
                                                                 placeholder: "Enter password",
                                                                 keyboardType: .default,
                                                                 text: $viewModel.password,
                                                                 isSecure: true,
                                                                 errorMessage: nil,
                                                                 isFocused: focusedField == .password))
                    .focused($focusedField, equals: .password)
                    .disabled(viewModel.isRegistering)
                    
                    // Password field.
                    AuthenticationFormFieldView(viewModel: .init(header: "Re-Password",
                                                                 placeholder: "Enter password again",
                                                                 keyboardType: .default,
                                                                 text: $viewModel.rePassword,
                                                                 isSecure: true,
                                                                 errorMessage: nil,
                                                                 isFocused: focusedField == .rePassword))
                    .focused($focusedField, equals: .rePassword)
                    .disabled(viewModel.isRegistering)
                    
                }
                
                Spacer()
                
            }
        }
        .safeAreaInset(edge: .bottom, content: {
            VStack {
                Button {
                    focusedField = nil
                    Task {
                        await viewModel.register()
                        
                       
                    }
                } label: {
                    Text("Register")
                }
                .buttonStyle(PrimaryLoadingButtonStyle(isLoading: viewModel.isRegistering))
                .disabled(viewModel.primaryButtonDisabled)
                .padding(.top, Constants.contentVerticalSpacing)
                .background(Color(UIColor.systemBackground))
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Already have an account? ")
                        .foregroundColor(.primary) +
                    Text("Login")
                        .foregroundColor(theme.tintColor)
                        .fontWeight(.bold)
                }
                
                // Terms label
                AttributedText(termsAttributedString)
            }
            
        })
        .alert(viewModel.errorMessage, isPresented: $viewModel.shouldShowErrorAlert) {
            Button("Okay") {
                viewModel.shouldShowErrorAlert.toggle()
            }
        }
        .padding()
        .background(theme.primaryBackgroundColor)
        .navigationTitle("Register")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension RegisterView {
    enum Constants {
        static let blockVerticalPadding: CGFloat = 32
        static let contentVerticalSpacing: CGFloat = 8
        static let contentPadding: CGFloat = 16
        
        static let fieldDebounceDuration = 0.3
        static let jetpackTermsURL = "https://jetpack.com/redirect/?source=wpcom-tos&site="
        static let jetpackShareDetailsURL = "https://jetpack.com/redirect/?source=jetpack-support-what-data-does-jetpack-sync&site="
        static let wpcomErrorCodeKey = "WordPressComRestApiErrorCodeKey"
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
        
        static let loginToConnect = NSLocalizedString(
            "Log in with your WordPress.com account to connect Jetpack",
            comment: "Subtitle for the WPCom email login screen when Jetpack is not connected yet"
        )
        static let termsContent = NSLocalizedString(
            "By tapping the Log in button, you agree to our %1$@ and to %2$@.",
            comment: "Content of the label at the end of the Wrong Account screen. " +
            "Reads like: By tapping the Connect Jetpack button, you agree to our Terms of Service and to share details with WordPress.com.")
        static let termsOfService = NSLocalizedString(
            "Terms of Service",
            comment: "The terms to be agreed upon when tapping the Connect Jetpack button on the Wrong Account screen."
        )
        static let shareDetails = NSLocalizedString(
            "share details",
            comment: "The action to be agreed upon when tapping the Connect Jetpack button on the Wrong Account screen."
        )
    }
}


import SwiftUI
import DesignSystem

/// Necessary data for the account creation / authentication form field.
struct AuthenticationFormFieldViewModel {
    /// Title of the field.
    let header: String?
    /// Placeholder of the text field.
    let placeholder: String
    /// The type of keyboard.
    let keyboardType: UIKeyboardType
    /// Text binding for the text field.
    let text: Binding<String>
    /// Whether the content in the text field is secure, like password.
    let isSecure: Bool
    /// Optional error message shown below the text field.
    let errorMessage: String?
    /// Whether the content in the text field is focused.
    let isFocused: Bool
}

/// A field in the account creation / authentication form.
/// Currently, there are two fields - email and password.
struct AuthenticationFormFieldView: View {
    private let viewModel: AuthenticationFormFieldViewModel
    
    /// Whether the text field is *shown* as secure.
    /// When the field is secure, there is a button to show/hide the text field input.
    @State private var showsSecureInput: Bool = true
    
    // Tracks the scale of the view due to accessibility changes.
    @ScaledMetric private var scale: CGFloat = 1.0
    
    init(viewModel: AuthenticationFormFieldViewModel) {
        self.viewModel = viewModel
        self.showsSecureInput = viewModel.isSecure
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Layout.verticalSpacing) {
            viewModel.header.map { header in
                Text(header)
                    .foregroundColor(Color(.label))
                    .subheadlineStyle()
            }
            if viewModel.isSecure {
                ZStack(alignment: .trailing) {
                    // Text field based on the `isTextFieldSecure` state.
                    Group {
                        if showsSecureInput {
                            SecureField(viewModel.placeholder, text: viewModel.text)
                        } else {
                            TextField(viewModel.placeholder, text: viewModel.text)
                        }
                    }
                    .font(.body)
                    .textFieldStyle(RoundedBorderTextFieldStyle(
                        focused: viewModel.isFocused,
                        // Custom insets to leave trailing space for the reveal button.
                        insets: .init(top: RoundedBorderTextFieldStyle.Defaults.insets.top,
                                      leading: RoundedBorderTextFieldStyle.Defaults.insets.leading,
                                      bottom: RoundedBorderTextFieldStyle.Defaults.insets.bottom,
                                      trailing: Layout.secureFieldRevealButtonHorizontalPadding * 2 + Layout.secureFieldRevealButtonDimension * scale),
                        height: 44 * scale
                    ))
                    .keyboardType(viewModel.keyboardType)
                    
                    // Button to show/hide the text field content.
                    Button(action: {
                        showsSecureInput.toggle()
                    }) {
                        Image(systemName: showsSecureInput ? "eye.slash" : "eye")
                            .tint(Color(.textSubtle))
                            .frame(width: Layout.secureFieldRevealButtonDimension * scale,
                                   height: Layout.secureFieldRevealButtonDimension * scale)
                            .padding(.leading, Layout.secureFieldRevealButtonHorizontalPadding)
                            .padding(.trailing, Layout.secureFieldRevealButtonHorizontalPadding)
                    }
                }
            } else {
                TextField(viewModel.placeholder, text: viewModel.text)
                    .textFieldStyle(RoundedBorderTextFieldStyle(focused: viewModel.isFocused))
                    .keyboardType(viewModel.keyboardType)
            }
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .footnoteStyle(isEnabled: true, isError: true)
            }
        }
    }
}

private extension AuthenticationFormFieldView {
    enum Layout {
        static let verticalSpacing: CGFloat = 8
        static let secureFieldRevealButtonHorizontalPadding: CGFloat = 16
        static let secureFieldRevealButtonDimension: CGFloat = 18
    }
}

struct AccountCreationFormField_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationFormFieldView(viewModel: .init(header: "Your email address",
                                                     placeholder: "Email address",
                                                     keyboardType: .emailAddress,
                                                     text: .constant(""),
                                                     isSecure: false,
                                                     errorMessage: nil,
                                                     isFocused: true))
        VStack {
            AuthenticationFormFieldView(viewModel: .init(header: "Choose a password",
                                                         placeholder: "Password",
                                                         keyboardType: .default,
                                                         text: .constant("wwwwwwwwwwwwwwwwwwwwwwww"),
                                                         isSecure: true,
                                                         errorMessage: "Too simple",
                                                         isFocused: false))
            .environment(\.sizeCategory, .medium)
            
            AuthenticationFormFieldView(viewModel: .init(header: "Choose a password",
                                                         placeholder: "Password",
                                                         keyboardType: .default,
                                                         text: .constant("wwwwwwwwwwwwwwwwwwwwwwww"),
                                                         isSecure: true,
                                                         errorMessage: "Too simple",
                                                         isFocused: false))
            .environment(\.sizeCategory, .extraExtraExtraLarge)
        }
    }
}

/// Text field has a rounded border that has a thicker border and brighter border color when the field is focused.
@MainActor
struct RoundedBorderTextFieldStyle: TextFieldStyle {
    private let focused: Bool
    private let focusedBorderColor: Color
    private let unfocusedBorderColor: Color
    private let insets: EdgeInsets
    private let height: CGFloat?
    @Environment(Theme.self) private var theme
    
    /// - Parameters:
    ///   - focused: Whether the field is focused or not.
    ///   - focusedBorderColor: The border color when the field is focused.
    ///   - unfocusedBorderColor: The border color when the field is not focused.
    ///   - insets: The insets between the background border and the text input.
    ///   - height: An optional fixed height for the field.
    init(focused: Bool,
         focusedBorderColor: Color = Defaults.focusedBorderColor,
         unfocusedBorderColor: Color = Defaults.unfocusedBorderColor,
         insets: EdgeInsets = Defaults.insets,
         height: CGFloat? = nil) {
        self.focused = focused
        self.focusedBorderColor = focusedBorderColor
        self.unfocusedBorderColor = unfocusedBorderColor
        self.insets = insets
        self.height = height
    }
    
    nonisolated
    func _body(configuration: TextField<Self._Label>) -> some View {
        MainActor.assumeIsolated {
            configuration
                .padding(insets)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .strokeBorder(focused ? theme.tintColor: unfocusedBorderColor,
                                      lineWidth: focused ? 2: 1)
                        .frame(height: height)
                )
                .frame(height: height)
        }     
    }
}

extension RoundedBorderTextFieldStyle {
    enum Defaults {
        static let focusedBorderColor: Color = .init(uiColor: .brand)
        static let unfocusedBorderColor: Color = .gray
        static let insets = EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
    }
}

struct TextFieldStyles_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TextField("placeholder", text: .constant("focused"))
                .textFieldStyle(RoundedBorderTextFieldStyle(focused: true))
            TextField("placeholder", text: .constant("unfocused"))
                .textFieldStyle(RoundedBorderTextFieldStyle(focused: false))
            TextField("placeholder", text: .constant("focused with a different color"))
                .textFieldStyle(RoundedBorderTextFieldStyle(focused: true, focusedBorderColor: .orange))
                .environment(\.sizeCategory, .extraExtraExtraLarge)
            TextField("placeholder", text: .constant("unfocused with a different color"))
                .textFieldStyle(RoundedBorderTextFieldStyle(focused: false, unfocusedBorderColor: .cyan))
            TextField("placeholder", text: .constant("custom insets"))
                .textFieldStyle(RoundedBorderTextFieldStyle(focused: false, insets: .init(top: 20, leading: 0, bottom: 10, trailing: 50)))
                .frame(width: 150)
            HStack {
                TextField("placeholder", text: .constant("text field"))
                    .textFieldStyle(RoundedBorderTextFieldStyle(focused: true))
                SecureField("placeholder", text: .constant("secure"))
                    .textFieldStyle(RoundedBorderTextFieldStyle(focused: true))
            }
            .environment(\.sizeCategory, .extraExtraExtraLarge)
            HStack {
                TextField("placeholder", text: .constant("text field"))
                    .textFieldStyle(RoundedBorderTextFieldStyle(focused: true, height: 100))
                SecureField("placeholder", text: .constant("secure"))
                    .textFieldStyle(RoundedBorderTextFieldStyle(focused: true))
            }
            .environment(\.sizeCategory, .extraExtraExtraLarge)
        }
        .preferredColorScheme(.dark)
    }
}

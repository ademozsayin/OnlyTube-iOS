import Env
//import Models
import SwiftUI



public struct SecondaryColumnToolbarItem: ToolbarContent, Sendable {
    @Environment(\.isSecondaryColumn) private var isSecondaryColumn
    @Environment(UserPreferences.self) private var preferences
    
    public init() {}
    
    public var body: some ToolbarContent {
        ToolbarItem(placement: isSecondaryColumn ? .navigationBarLeading : .navigationBarTrailing) {
            Button {
                Task { @MainActor in
                    withAnimation {
                        preferences.showiPadSecondaryColumn.toggle()
                    }
                }
            } label: {
                Image(systemName: "sidebar.right")
            }
        }
    }
}

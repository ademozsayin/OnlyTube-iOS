
import Network
import SwiftUI

@MainActor
public extension View {
    func withPreviewsEnv() -> some View {
            environment(UserPreferences.shared)
    }
}

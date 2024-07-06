import SwiftUI

public struct CancelToolbarItem: ToolbarContent {
  @Environment(\.dismiss) private var dismiss

  public init() {}

  public var body: some ToolbarContent {
    ToolbarItem(placement: .navigationBarLeading) {
      Button("Cancel", role: .cancel, action: { dismiss() })
        .keyboardShortcut(.cancelAction)
    }
  }
}

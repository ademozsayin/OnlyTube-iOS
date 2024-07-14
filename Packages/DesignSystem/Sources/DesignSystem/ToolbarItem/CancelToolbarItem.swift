import SwiftUI

public struct CancelToolbarItem: ToolbarContent {
  @Environment(\.dismiss) private var dismiss

  public init() {}

  public var body: some ToolbarContent {
    ToolbarItem(placement: .navigationBarLeading) {
        Button(CancelToolbarItem.cancel, role: .cancel, action: { dismiss() })
        .keyboardShortcut(.cancelAction)
    }
  }
    
}


extension CancelToolbarItem {
    static let cancel = NSLocalizedString(
        "Cancel",
        comment: "Cancel"
    )
}

import DesignSystem
import Env
import Models
import Network
import SwiftUI

struct NotificationsRequestsRowView: View {
  @Environment(Theme.self) private var theme
  @Environment(RouterPath.self) private var routerPath

  let request: String

  var body: some View {
    HStack(alignment: .center, spacing: 8) {


      Spacer()
      
      Image(systemName: "chevron.right")
        .foregroundStyle(.secondary)
    }
    .onTapGesture {
    }
    .listRowInsets(.init(top: 12,
                         leading: .layoutPadding,
                         bottom: 12,
                         trailing: .layoutPadding))
    #if os(visionOS)
      .listRowBackground(RoundedRectangle(cornerRadius: 8)
        .foregroundStyle(.background))
    #else
        .listRowBackground(theme.primaryBackgroundColor)
    #endif
  }
}

import DesignSystem
import Models
import Network
import SwiftUI

@MainActor
public struct NotificationsRequestsListView: View {
  @Environment(Theme.self) private var theme

  enum ViewState {
    case loading
    case error
    case requests(_ data: [String])
  }

  @State private var viewState: ViewState = .loading

  public init() {}

  public var body: some View {
    List {
      switch viewState {
      case .loading:
        ProgressView()
        #if !os(visionOS)
          .listRowBackground(theme.primaryBackgroundColor)
        #endif
          .listSectionSeparator(.hidden)
      case .error:
        ErrorView(title: "notifications.error.title",
                  message: "notifications.error.message",
                  buttonTitle: "action.retry")
        {
          await fetchRequests()
        }
        #if !os(visionOS)
        .listRowBackground(theme.primaryBackgroundColor)
        #endif
        .listSectionSeparator(.hidden)
      case let .requests(data):
              Text("NotificationsRequestsRowView(request: request)")
      }
    }
    .listStyle(.plain)
    #if !os(visionOS)
      .scrollContentBackground(.hidden)
      .background(theme.primaryBackgroundColor)
    #endif
      .navigationTitle("notifications.content-filter.requests.title")
      .navigationBarTitleDisplayMode(.inline)
      .task {
        await fetchRequests()
      }
      .refreshable {
        await fetchRequests()
      }
  }

  private func fetchRequests() async {
    do {
        viewState = .loading
    } catch {
      viewState = .error
    }
  }
}

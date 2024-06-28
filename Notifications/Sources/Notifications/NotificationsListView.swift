import DesignSystem
import Env
import Models
import Network
import SwiftUI

@MainActor
public struct NotificationsListView: View {
  @Environment(\.scenePhase) private var scenePhase

  @Environment(Theme.self) private var theme
  @Environment(RouterPath.self) private var routerPath

  @State private var viewModel = NotificationsViewModel()
  @State private var isNotificationsPolicyPresented: Bool = false
  @Binding var scrollToTopSignal: Int

  let lockedAccountId: String?

  public init(lockedAccountId: String? = nil,
              scrollToTopSignal: Binding<Int>)
  {
    self.lockedAccountId = lockedAccountId
    _scrollToTopSignal = scrollToTopSignal
  }

  public var body: some View {
    ScrollViewReader { proxy in
      List {
        scrollToTopView
        topPaddingView
        notificationsView
      }
      .environment(\.defaultMinListRowHeight, 1)
      .listStyle(.plain)
      .onChange(of: scrollToTopSignal) {
        withAnimation {
          proxy.scrollTo(ScrollToView.Constants.scrollToTop, anchor: .top)
        }
      }
    }
    .toolbar {
      ToolbarItem(placement: .principal) {
          let title = "Notifications"
          Text(title)
            .font(.headline)
            .accessibilityRepresentation {
              Menu(title) {}
            }
            .accessibilityAddTraits(.isHeader)
            .accessibilityRemoveTraits(.isButton)
            .accessibilityRespondsToUserInteraction(true)
        
      }
    }
    .navigationBarTitleDisplayMode(.large)
    #if !os(visionOS)
      .scrollContentBackground(.hidden)
      .background(theme.primaryBackgroundColor)
    #endif
      .onAppear {
   
        Task {
          await viewModel.fetchNotifications()
        }
      }
      .refreshable {
        SoundEffectManager.shared.playSound(.pull)
        HapticManager.shared.fireHaptic(.dataRefresh(intensity: 0.3))
        await viewModel.fetchNotifications()
        HapticManager.shared.fireHaptic(.dataRefresh(intensity: 0.7))
        SoundEffectManager.shared.playSound(.refresh)
      }
      .onChange(of: scenePhase) { _, newValue in
        switch newValue {
        case .active:
          Task {
            await viewModel.fetchNotifications()
          }
        default:
          break
        }
      }
  }

  @ViewBuilder
  private var notificationsView: some View {
    switch viewModel.state {
    case .loading:
      ForEach(ConsolidatedNotification.placeholders()) { notification in
        NotificationRowView(notification: notification,
                            routerPath: routerPath
        )
          .listRowInsets(.init(top: 12,
                               leading: .layoutPadding + 4,
                               bottom: 0,
                               trailing: .layoutPadding))
        #if os(visionOS)
          .listRowBackground(RoundedRectangle(cornerRadius: 8)
            .foregroundStyle(.background))
        #else
            .listRowBackground(theme.primaryBackgroundColor)
        #endif
            .redacted(reason: .placeholder)
            .allowsHitTesting(false)
      }

    case let .display(notifications, nextPageState):
      if notifications.isEmpty {
        PlaceholderView(iconName: "bell.slash",
                        title: "notifications.empty.title",
                        message: "notifications.empty.message")
        #if !os(visionOS)
          .listRowBackground(theme.primaryBackgroundColor)
        #endif
          .listSectionSeparator(.hidden)
      } else {
        ForEach(notifications) { notification in
          NotificationRowView(
            notification: notification,
            routerPath: routerPath
          )
            .listRowInsets(.init(top: 12,
                                 leading: .layoutPadding + 4,
                                 bottom: 6,
                                 trailing: .layoutPadding))
          #if os(visionOS)
            .listRowBackground(RoundedRectangle(cornerRadius: 8)
              .foregroundStyle(Material.regular).hoverEffect())
            .listRowHoverEffectDisabled()
          #else
            .listRowBackground(theme.primaryBackgroundColor)
          #endif
            .id(notification.id)
        }

        switch nextPageState {
        case .none:
          EmptyView()
        case .hasNextPage:
          NextPageView {
//            try await viewModel.fetchNextPage()
          }
          .listRowInsets(.init(top: .layoutPadding,
                               leading: .layoutPadding + 4,
                               bottom: .layoutPadding,
                               trailing: .layoutPadding))
          #if !os(visionOS)
            .listRowBackground(theme.primaryBackgroundColor)
          #endif
        }
      }

    case .error:
      ErrorView(title: "notifications.error.title",
                message: "notifications.error.message",
                buttonTitle: "action.retry")
      {
        await viewModel.fetchNotifications()
      }
      #if !os(visionOS)
      .listRowBackground(theme.primaryBackgroundColor)
      #endif
      .listSectionSeparator(.hidden)
    }
  }

  private var topPaddingView: some View {
    HStack {}
      .listRowBackground(Color.clear)
      .listRowSeparator(.hidden)
      .listRowInsets(.init())
      .frame(height: .layoutPadding)
      .accessibilityHidden(true)
  }

  private var scrollToTopView: some View {
    ScrollToView()
      .frame(height: .scrollToViewHeight)
      .onAppear {
        viewModel.scrollToTopVisible = true
      }
      .onDisappear {
        viewModel.scrollToTopVisible = false
      }
  }
}

import Env
import Foundation
import Models
import Network
import Observation
import SwiftUI

@MainActor
@Observable class NotificationsViewModel {
  public enum State {
    public enum PagingState {
      case none, hasNextPage
    }

    case loading
    case display(notifications: [ConsolidatedNotification], nextPageState: State.PagingState)
    case error(error: Error)
  }

  enum Constants {
    static let notificationLimit: Int = 30
  }

  public enum Tab: LocalizedStringKey, CaseIterable {
    case all = "notifications.tab.all"
    case mentions = "notifications.tab.mentions"
  }

  private let filterKey = "notification-filter"
  var state: State = .loading
  var isLockedType: Bool = false
  var lockedAccountId: String?
  var selectedType: Models.Notification.NotificationType? {
    didSet {
      guard oldValue != selectedType
      else { return }

      if !isLockedType {
        UserDefaults.standard.set(selectedType?.rawValue ?? "", forKey: filterKey)
      }

      consolidatedNotifications = []
    }
  }

  func loadSelectedType() {
    guard let value = UserDefaults.standard.string(forKey: filterKey)
    else {
      selectedType = nil
      return
    }

    selectedType = .init(rawValue: value)
  }

  var scrollToTopVisible: Bool = false

  private var queryTypes: [String]? {
    if let selectedType {
      var excludedTypes = Models.Notification.NotificationType.allCases
      excludedTypes.removeAll(where: { $0 == selectedType })
      return excludedTypes.map(\.rawValue)
    }
    return nil
  }

  private var consolidatedNotifications: [String] = []

  func fetchNotifications() async {
   
    do {
      var nextPageState: State.PagingState = .hasNextPage
        state = .display(notifications: [], nextPageState: .none)
    } catch {
      state = .error(error: error)
    }
  }

}

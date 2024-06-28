//
//  NotificationExt.swift
//
//
//  Created by Jérôme Danthinne on 31/01/2023.
//

import Models

extension Notification {
  func consolidationId(selectedType: Models.Notification.NotificationType?) -> String? {
    guard let supportedType else { return nil }
      return nil
  }

  func isConsolidable(selectedType: Models.Notification.NotificationType?) -> Bool {
    // Notification is consolidable onlt if the consolidation id is not the notication id (unique) itself
    consolidationId(selectedType: selectedType) != id
  }
}

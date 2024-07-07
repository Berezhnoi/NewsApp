//
//  Notifications.swift
//  NewsApp
//
//  Created by rendi on 06.07.2024.
//

import Foundation

extension Notification.Name {
    /// Notification posted when favorites are updated, indicating that the list of favorite articles has changed.
    static let favoritesUpdated = Notification.Name("favoritesUpdated")
      
    /// Notification posted when articles are updated, indicating that the list of articles has changed.
    static let articlesUpdated = Notification.Name("articlesUpdated")
    
    /// Notification posted when the country is changed.
    static let countryChanged = Notification.Name("countryChanged")
}

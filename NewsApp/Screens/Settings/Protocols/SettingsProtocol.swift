//
//  SettingsProtocol.swift
//  NewsApp
//
//  Created by rendi on 06.07.2024.
//

import Foundation

enum Theme: String {
    case light = "light"
    case dark = "dark"
}

protocol SettingsModelProtocol {
    var currentTheme: Theme { get set }
    var currentLanguage: String { get set }
    
    func saveSettings()
    func getLanguages() -> [String]
}

protocol SettingsViewDelegate: AnyObject {
    func numberOfLanguages() -> Int
    func language(at index: Int) -> String
    func didSelectLanguage(at index: Int)
    func themeSwitchChanged(to theme: Theme)
}

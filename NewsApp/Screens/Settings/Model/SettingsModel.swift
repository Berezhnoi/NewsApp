//
//  SettingsModel.swift
//  NewsApp
//
//  Created by rendi on 06.07.2024.
//

import Foundation

class SettingsModel: SettingsModelProtocol {
    let languages = ["en", "uk"] // List of supported languages
    
    var currentTheme: Theme = .light
    var currentLanguage: String = "en"
    
    init() {
         loadSettings()
     }
    
    func saveSettings() {
        UserDefaults.standard.set(currentTheme.rawValue, forKey: "theme")
        UserDefaults.standard.set(currentLanguage, forKey: "language")
    }
    
    func getLanguages() -> [String] {
        return languages
    }
    
    private func loadSettings() {
        if let themeString = UserDefaults.standard.string(forKey: "theme"), let theme = Theme(rawValue: themeString) {
            currentTheme = theme
        }
        
        if let language = UserDefaults.standard.string(forKey: "language"), languages.contains(language) {
            currentLanguage = language
        }
    }
}

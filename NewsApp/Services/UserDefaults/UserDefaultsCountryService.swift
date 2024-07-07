//
//  UserDefaultsCountryService.swift
//  NewsApp
//
//  Created by rendi on 07.07.2024.
//
import Foundation

class UserDefaultsCountryService {
    
    static private let userDefaults = UserDefaults.standard
    static private let countryCodeKey = "SelectedCountryCode"
    
    static func saveCountryCode(_ code: String) {
        userDefaults.set(code, forKey: countryCodeKey)
        NotificationCenter.default.post(name: .countryChanged, object: nil)
    }
    
    static func getCountryCode() -> String? {
        return userDefaults.string(forKey: countryCodeKey)
    }
}


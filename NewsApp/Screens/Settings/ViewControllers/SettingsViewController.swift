//
//  SettingsViewController.swift
//  NewsApp
//
//  Created by rendi on 06.07.2024.
//

import UIKit

class SettingsViewController: UIViewController {
    private var settingsView: SettingsView!
    private var settingsModel: SettingsModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.backgroundColor = .systemBackground
        
        settingsModel = SettingsModel()
        
        settingsView = SettingsView(frame: view.bounds)
        settingsView.delegate = self
        view.addSubview(settingsView)
    }
}

// MARK: - SettingsViewDelegate
extension SettingsViewController: SettingsViewDelegate {
    func numberOfLanguages() -> Int {
        return settingsModel.getLanguages().count
    }
    
    func language(at index: Int) -> String {
        return settingsModel.getLanguages()[index]
    }
    
    func didSelectLanguage(at index: Int) {
        let selectedLanguage = settingsModel.getLanguages()[index]
        settingsModel.currentLanguage = selectedLanguage
        settingsModel.saveSettings()
    }
    
    func themeSwitchChanged(to theme: Theme) {
        settingsModel.currentTheme = theme
        settingsModel.saveSettings()
    }
}

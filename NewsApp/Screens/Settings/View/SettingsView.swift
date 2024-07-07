//
//  SettingsView.swift
//  NewsApp
//
//  Created by rendi on 06.07.2024.
//

import UIKit

class SettingsView: UIView {
    weak var delegate: SettingsViewDelegate?
    
    let themeSwitch: UISwitch = {
        let themeSwitch = UISwitch()
        themeSwitch.translatesAutoresizingMaskIntoConstraints = false
        return themeSwitch
    }()
    
    let languagePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(themeSwitch)
        addSubview(languagePicker)
        
        NSLayoutConstraint.activate([
            themeSwitch.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            themeSwitch.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            languagePicker.topAnchor.constraint(equalTo: themeSwitch.bottomAnchor, constant: 20),
            languagePicker.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            languagePicker.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            languagePicker.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        // Add targets/actions for controls
        themeSwitch.addTarget(self, action: #selector(themeSwitchChanged(_:)), for: .valueChanged)
        languagePicker.dataSource = self
        languagePicker.delegate = self
    }
    
    @objc private func themeSwitchChanged(_ sender: UISwitch) {
        let theme: Theme = sender.isOn ? .dark : .light
        delegate?.themeSwitchChanged(to: theme)
    }
}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate
extension SettingsView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return delegate?.numberOfLanguages() ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return delegate?.language(at: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.didSelectLanguage(at: row)
    }
}

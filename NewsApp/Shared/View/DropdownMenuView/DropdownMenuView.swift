//
//  DropdownMenuView.swift
//  NewsApp
//
//  Created by rendi on 07.07.2024.
//

import UIKit

protocol DropdownMenuDelegate: AnyObject {
    func didSelectCountry(_ countryCode: String?)
}

class DropdownMenuView: UIView {
    
    weak var delegate: DropdownMenuDelegate?
    
    private let countries: [String: String?] = [
        "USA": "us",
        "Ukraine": "ua",
        "England": "gb",
        "Germany": "de",
        "Default": nil
    ]
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(tableView)
    }
}

extension DropdownMenuView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let countryNames = Array(countries.keys)
        cell.textLabel?.text = countryNames[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let countryNames = Array(countries.keys)
        let selectedCountryName = countryNames[indexPath.row]
        guard let selectedCountryCode = countries[selectedCountryName] else {
            delegate?.didSelectCountry(nil)
            return
        }
        
        delegate?.didSelectCountry(selectedCountryCode)
    }
}



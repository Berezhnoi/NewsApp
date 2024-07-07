import UIKit

protocol DropdownMenuDelegate: AnyObject {
    func didSelectOption(_ option: String?)
}

class DropdownMenuView: UIView {

    weak var delegate: DropdownMenuDelegate?

    private let options: [String: String?]
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 8
        tableView.backgroundColor = .white
        tableView.layer.shadowColor = UIColor.black.cgColor
        tableView.layer.shadowOpacity = 0.5
        tableView.layer.shadowOffset = CGSize(width: 0, height: 2)
        tableView.layer.shadowRadius = 4
        return tableView
    }()

    private let overlayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.isHidden = true
        return view
    }()

    init(options: [String: String?]) {
        self.options = options
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(overlayView)
        addSubview(tableView)

        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: bottomAnchor),

            tableView.centerXAnchor.constraint(equalTo: centerXAnchor),
            tableView.centerYAnchor.constraint(equalTo: centerYAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
        
        // Calculate the height based on the number of rows
        let numberOfRows = options.count
        let rowHeight: CGFloat = 44

        let tableViewHeight = CGFloat(numberOfRows) * rowHeight
        tableView.heightAnchor.constraint(equalToConstant: tableViewHeight).isActive = true

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // Add gesture recognizer to overlayView to hide dropdown
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideDropdown))
        overlayView.addGestureRecognizer(tapGesture)
    }

    @objc private func hideDropdown() {
        overlayView.isHidden = true
        removeFromSuperview()
    }

    func showDropdown(in superview: UIView) {
        superview.addSubview(self)
        tableView.reloadData()
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])

        overlayView.isHidden = false
    }
    
    static func generateCountriesDropdownMenu() -> DropdownMenuView {
        let options: [String: String?] = [
            "USA": "us",
            "Ukraine": "ua",
            "England": "gb",
            "Germany": "de",
        ]
        let countriesDropdownMenu = DropdownMenuView(options: options)
        countriesDropdownMenu.translatesAutoresizingMaskIntoConstraints = false
        return countriesDropdownMenu
    }
}

extension DropdownMenuView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let optionName = Array(options.keys)[indexPath.row]
        cell.textLabel?.text = optionName
        
        // Set cell color based on interface style
        if traitCollection.userInterfaceStyle == .dark {
            cell.backgroundColor = .darkGray
            cell.textLabel?.textColor = .white
        } else {
            cell.backgroundColor = .white
            cell.textLabel?.textColor = .black
        }
        
        let selectedOption = UserDefaultsCountryService.getCountryCode()
        
        // Highlight the selected cell based on the selectedOption
        if let selectedOption = selectedOption, let value = options[optionName], value == selectedOption {
            cell.textLabel?.textColor = .red
         }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let optionName = Array(options.keys)[indexPath.row]
        
        // Extract the value from the dictionary
        if let selectedOption = options[optionName] {
            delegate?.didSelectOption(selectedOption)
        } else {
            delegate?.didSelectOption(nil)
        }
        
        hideDropdown()
    }
}

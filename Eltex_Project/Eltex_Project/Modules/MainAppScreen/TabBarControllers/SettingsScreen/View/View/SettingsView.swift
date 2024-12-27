//
//  SettingsView.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 25.12.2024.
//

import UIKit

protocol SettingsViewDelegate: AnyObject {
    func logoutButtonTapped()
}

final class SettingsView: UIView {
    
    private lazy var settingsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.register(SettingsTableViewCell.self,
                           forCellReuseIdentifier: SettingsTableViewCell.identifier)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var logOutButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(named: "logoutImage")
        configuration.title = "Log Out"
        
        configuration.baseBackgroundColor = .white
        configuration.baseForegroundColor = .red
        
        configuration.cornerStyle = .medium
        
        configuration.imagePadding = 8
        configuration.imagePlacement = .leading
        
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self,
                         action: #selector(logOutAction),
                         for: .touchUpInside)
        
        return button
    }()
    
    private var settingsModel: [Settings]?
    private let viewModel: SettingsViewModel
    
    weak var delegate: SettingsViewDelegate?
    
    init(frame: CGRect, viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSettingsData(_ data: [Settings]) {
        settingsModel = data
        settingsTableView.reloadData()
    }
}


extension SettingsView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = settingsModel else { return 0 }
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as? SettingsTableViewCell,
              let model = settingsModel else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .default
        let cellData = model[indexPath.row]
        cell.configureCell(with: cellData)
        
        return cell
    }
}

private extension SettingsView {
    
    @objc
    func logOutAction() {
        delegate?.logoutButtonTapped()
    }
    
    func setupView() {
        addSubview(settingsTableView)
        addSubview(logOutButton)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            settingsTableView.topAnchor.constraint(equalTo: self.topAnchor),
            settingsTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            settingsTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            settingsTableView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        NSLayoutConstraint.activate([
            logOutButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logOutButton.topAnchor.constraint(equalTo: settingsTableView.bottomAnchor, constant: 36),
            logOutButton.widthAnchor.constraint(equalToConstant: 226),
            logOutButton.heightAnchor.constraint(equalToConstant: 42)
        ])
    }
}

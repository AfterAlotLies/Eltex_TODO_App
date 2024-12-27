//
//  SettingsViewController.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 25.12.2024.
//

import UIKit
import Combine

// MARK: - SettingsViewController
final class SettingsViewController: UIViewController {
    
    private enum Constants {
        static let alertMessage = "Are you sure wanna quit?"
        static let alertTitle = "Quit?"
        static let yesActionTitle = "Yes, i'm sure"
        static let noActionTitle = "No, i'm not"
        static let controllerTitle = "Settings"
    }
    
    private lazy var settingsView: SettingsView = {
        let view = SettingsView(frame: .zero,
                                viewModel: viewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    private let viewModel: SettingsViewModel
    private var subscriptions: Set<AnyCancellable> = []
    
    // MARK: - Lifecycle
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        setupBindings()
    }
}

// MARK: - SettingsViewController + SettingsViewDelegate
extension SettingsViewController: SettingsViewDelegate {
    
    func logoutButtonTapped() {
        showAlert(message: Constants.alertMessage)
    }
}

// MARK: - Private Methods
private extension SettingsViewController {
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: Constants.alertTitle,
                                      message: message,
                                      preferredStyle: .alert)
        let yesAction = UIAlertAction(title: Constants.yesActionTitle,
                                      style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.logOut()
        }
        let noAction = UIAlertAction(title: Constants.noActionTitle,
                                     style: .cancel,
                                     handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true)
    }
    
    func setupBindings() {
        viewModel.$settingsData
            .sink { [weak self] settings in
                guard let self = self else { return }
                self.settingsView.setSettingsData(settings)
            }
            .store(in: &subscriptions)
    }
    
    func setupController() {
        view.addSubview(settingsView)
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let titleLabel = UILabel()
        titleLabel.text = Constants.controllerTitle
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        
        navigationItem.titleView = titleLabel
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            settingsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            settingsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            settingsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            settingsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

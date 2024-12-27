//
//  SettingsViewController.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 25.12.2024.
//

import UIKit
import Combine

final class SettingsViewController: UIViewController {
    
    private lazy var settingsView: SettingsView = {
        let view = SettingsView(frame: .zero, viewModel: viewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    private let viewModel: SettingsViewModel
    private var subscriptions: Set<AnyCancellable> = []
    
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

extension SettingsViewController: SettingsViewDelegate {
    
    func logoutButtonTapped() {
        showAlert(message: "Are you sure wanna quit?")
    }
}

private extension SettingsViewController {
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Wait", message: message, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes, i'm sure", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.logOut()
        }
        let noAction = UIAlertAction(title: "No, i'm not done", style: .cancel, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true)
    }
}

private extension SettingsViewController {
    
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
        titleLabel.text = "Settings"
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

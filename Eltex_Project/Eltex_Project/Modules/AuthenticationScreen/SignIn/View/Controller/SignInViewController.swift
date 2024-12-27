//
//  SignInViewController.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 19.12.2024.
//

import UIKit
import Combine

// MARK: - SignInViewController
final class SignInViewController: UIViewController {
    
    private lazy var signInView: SignInView = {
        let view = SignInView(frame: .zero, viewModel: viewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let viewModel: SignInViewModel
    private var subscriptions: Set<AnyCancellable> = []
    
    // MARK: - Lifecycle
    init(viewModel: SignInViewModel) {
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

// MARK: - Private methods
private extension SignInViewController {
    
    func setupBindings() {
        viewModel.$errorMessage
            .sink { [weak self] errorMessage in
                guard let self = self else { return }
                if errorMessage != "" {
                    self.showAlert(title: "Error", message: errorMessage)
                }
            }
            .store(in: &subscriptions)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
}

// MARK: - Setup Controller + Setup Constraints
private extension SignInViewController {
    
    func setupController() {
        view.addSubview(signInView)
        view.backgroundColor = .clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        setupConstraints()
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            signInView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            signInView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            signInView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            signInView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

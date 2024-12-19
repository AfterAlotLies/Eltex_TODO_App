//
//  SignUpViewController.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 20.12.2024.
//

import UIKit

final class SignUpViewController: UIViewController {
    
    private lazy var signUpView: SignUpView = {
        let view = SignUpView(frame: .zero, viewModel: viewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let viewModel: SignUpViewModel
    
    init(viewModel: SignUpViewModel) {
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
    }
}

private extension SignUpViewController {
    
    func setupController() {
        view.addSubview(signUpView)
        view.backgroundColor = .clear
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            signUpView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            signUpView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            signUpView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            signUpView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

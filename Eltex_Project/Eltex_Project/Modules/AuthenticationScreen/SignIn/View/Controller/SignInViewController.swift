//
//  SignInViewController.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 19.12.2024.
//

import UIKit

final class SignInViewController: UIViewController {
    
    private lazy var signInView: SignInView = {
        let view = SignInView(frame: .zero, viewModel: viewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let viewModel: SignInViewModel
    
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
    }
}

private extension SignInViewController {
    
    func setupController() {
        view.addSubview(signInView)
        view.backgroundColor = .clear
        
        setupConstraints()
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

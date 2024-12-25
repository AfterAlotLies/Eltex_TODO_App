//
//  HomeViewController.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 23.12.2024.
//

import UIKit
import Combine

// MARK: - HomeViewController
final class HomeViewController: UIViewController {
    
    private lazy var homeView: HomeView = {
        let view = HomeView(frame: .zero, viewModel: viewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let viewModel: HomeViewModel
    private var subscriptions: Set<AnyCancellable> = []
    
    // MARK: - Lifecycle
    init(viewModel: HomeViewModel) {
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
private extension HomeViewController {
    
    func setupBindings() {
        viewModel.$userInfo
            .sink { [weak self] userInfo in
                guard let self = self else { return }
                self.homeView.setupUserInfo(userInfo.email, userInfo.name)
            }
            .store(in: &subscriptions)
        
        viewModel.$noteSections
            .sink { [weak self] notes in
                guard let self = self else { return }
                self.homeView.setupNoteData(notes)
            }
            .store(in: &subscriptions)
    }
}

// MARK: - Setup Controller + Setup Constraints
private extension HomeViewController {
    
    func setupController() {
        view.addSubview(homeView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            homeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            homeView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            homeView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            homeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

//
//  OnboardingViewController.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 19.12.2024.
//

import UIKit
import Combine

// MARK: - OnboardingViewController
final class OnboardingViewController: UIViewController {
    
    private lazy var onboardingView: OnboardingView = {
        let view = OnboardingView(frame: .zero,
                                  viewModel: viewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let viewModel: OnboardingViewModel
    private var subscriptions: Set<AnyCancellable> = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        setupBindings()
    }
    
    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods
private extension OnboardingViewController {
    
    func setupBindings() {
        viewModel.$pageData
            .sink { [weak self] pagitationData in
                guard let self = self else { return }
                if let data = pagitationData {
                    self.onboardingView.setPagitaionData(data)
                }
            }
            .store(in: &subscriptions)
    }
    
    func setupController() {
        view.backgroundColor = .clear
        
        view.addSubview(onboardingView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            onboardingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            onboardingView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            onboardingView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            onboardingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

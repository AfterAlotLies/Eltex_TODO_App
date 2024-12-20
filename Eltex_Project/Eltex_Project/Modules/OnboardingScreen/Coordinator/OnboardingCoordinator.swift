//
//  OnboardingCoordinator.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 19.12.2024.
//

import UIKit
import Combine

protocol OnboardingCoordinatorProtocol {
    func showOnboarding()
}

final class OnboardingCoordinator: Coordinator {
    
    private var subscriptions: Set<AnyCancellable> = []
    
    var childrenCoordinator: [Coordinator] = []
    var navigationController: UINavigationController
    var type: CoordinatorType { .onboarding }
    
    let coordinatorDidFinished = PassthroughSubject<Void, Never>()
    
    func start() {
        showOnboarding()
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        print("inited OnboardingCoordinator")
    }
    
    deinit {
        print("deinit OnboardingCoordinator")
    }
    
}

extension OnboardingCoordinator: OnboardingCoordinatorProtocol {
    
    func showOnboarding() {
        let viewModel = OnboardingViewModel()
        
        viewModel.isFinished
            .sink { [weak self] in
                guard let self = self else { return }
                self.coordinatorDidFinished.send()
                self.subscriptions.removeAll()
            }
            .store(in: &subscriptions)
        
        let viewController = OnboardingViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
}

//
//  SettingsCoordinator.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 22.12.2024.
//

import UIKit
import Combine

// MARK: - SettingsCoordinatorProtocol
protocol SettingsCoordinatorProtocol {
    func showSettings()
}

// MARK: - SettingsCoordinator + Coordinator
final class SettingsCoordinator: Coordinator {
    
    var childrenCoordinator: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    var type: CoordinatorType { .settings }
    
    private var subscriptions: Set<AnyCancellable> = []
    let coordinatorDidFinished = PassthroughSubject<Void, Never>()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Start
    func start() {
        showSettings()
    }
}

// MARK: - SettingsCoordinator + SettingsCoordinatorProtocol
extension SettingsCoordinator: SettingsCoordinatorProtocol {
    
    func showSettings() {
        let viewModel = SettingsViewModel()
        
        viewModel.logOutAction
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.coordinatorDidFinished.send()
                self.cancelSubscriptions()
            }
            .store(in: &subscriptions)
        
        let settingsVC = SettingsViewController(viewModel: viewModel)
        navigationController.isNavigationBarHidden = false
        navigationController.pushViewController(settingsVC, animated: true)
    }
}

// MARK: - Private Methods
private extension SettingsCoordinator {
    
    func cancelSubscriptions() {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }
}

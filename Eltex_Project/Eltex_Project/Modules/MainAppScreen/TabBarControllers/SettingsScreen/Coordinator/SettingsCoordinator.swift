//
//  SettingsCoordinator.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 22.12.2024.
//

import UIKit
import Combine

protocol SettingsCoordinatorProtocol {
    func showSettings()
}

final class SettingsCoordinator: Coordinator {
    
    var childrenCoordinator: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    var type: CoordinatorType { .settings }
    
    private var subscriptions: Set<AnyCancellable> = []
    let coordinatorDidFinished = PassthroughSubject<Void, Never>()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showSettings()
    }
    
    deinit {
        print("settings deinited coorditanor")
    }
}

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
        navigationController.pushViewController(settingsVC, animated: true)
    }
}

private extension SettingsCoordinator {
    
    func cancelSubscriptions() {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }
}

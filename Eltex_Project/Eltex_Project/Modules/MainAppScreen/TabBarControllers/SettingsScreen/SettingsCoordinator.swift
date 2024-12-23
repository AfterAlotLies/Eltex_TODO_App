//
//  SettingsCoordinator.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 22.12.2024.
//

import UIKit

final class SettingsCoordinator: Coordinator {
    var childrenCoordinator: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    var type: CoordinatorType {.app}
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        print("SettingsCoordinator coordinator started")
    }
    
    
}

//
//  MainAppTabBarCoordinator.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 20.12.2024.
//

import UIKit

final class MainAppTabBarCoordinator: Coordinator {
    
    var type: CoordinatorType { .mainApp }
    
    var childrenCoordinator: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    

    func start() {
//        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
    }
}

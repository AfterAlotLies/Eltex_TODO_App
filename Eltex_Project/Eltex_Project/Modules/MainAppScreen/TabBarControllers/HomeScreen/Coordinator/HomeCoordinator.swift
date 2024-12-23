//
//  HomeCoordinator.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 22.12.2024.
//

import UIKit

// MARK: - HomeCoordinatorProtocol
protocol HomeCoordinatorProtocol {
    func setupHomeViewController()
}

// MARK: - HomeCoordinator + Coordinator
final class HomeCoordinator: Coordinator {
    
    var childrenCoordinator: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    var type: CoordinatorType { .home }
    
    private let homeUserInfo: UserInfo
    private let notesRepository: NotesRepository
    
    init(navigationController: UINavigationController, userInfo: UserInfo, notesRepository: NotesRepository) {
        self.homeUserInfo = userInfo
        self.navigationController = navigationController
        self.notesRepository = notesRepository
    }
    
    // MARK: - Start
    func start() {
        setupHomeViewController()
    }
    
}

// MARK: - HomeCoordinator + HomeCoordinatorProtocol
extension HomeCoordinator: HomeCoordinatorProtocol {
    
    func setupHomeViewController() {
        let viewModel = HomeViewModel(userInfo: homeUserInfo, notesRepository: notesRepository)
        let viewController = HomeViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: false)
    }
}

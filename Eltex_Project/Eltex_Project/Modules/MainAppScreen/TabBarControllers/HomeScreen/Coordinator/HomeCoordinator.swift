//
//  HomeCoordinator.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 22.12.2024.
//

import UIKit
import Combine

// MARK: - HomeCoordinatorProtocol
protocol HomeCoordinatorProtocol {
    func setupHomeViewController()
    func showDetailNote(with note: Note)
}

// MARK: - HomeCoordinator + Coordinator
final class HomeCoordinator: Coordinator {
    
    var childrenCoordinator: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    var type: CoordinatorType { .home }
    
    private let homeUserInfo: UserInfo
    private let notesRepository: NotesRepository
    private var subscriptions: Set<AnyCancellable> = []
    
    init(navigationController: UINavigationController, userInfo: UserInfo, notesRepository: NotesRepository) {
        self.homeUserInfo = userInfo
        self.navigationController = navigationController
        self.notesRepository = notesRepository
    }
    
    // MARK: - Start
    func start() {
        setupHomeViewController()
    }
    
    deinit {
        print("home deinited coorditanor")
    }
}

// MARK: - HomeCoordinator + HomeCoordinatorProtocol
extension HomeCoordinator: HomeCoordinatorProtocol {
    
    func setupHomeViewController() {
        let viewModel = HomeViewModel(userInfo: homeUserInfo, notesRepository: notesRepository)
        
        viewModel.detailNotePublisher
            .sink { [weak self] note in
                guard let self = self else { return }
                self.showDetailNote(with: note)
            }
            .store(in: &subscriptions)
        
        let viewController = HomeViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func showDetailNote(with note: Note) {
        let coordinator = DetailNoteCoordinator(navigationController: navigationController, notesRepository: notesRepository, note: note)
        coordinator.delegate = self
        childrenCoordinator.append(coordinator)
        coordinator.start()
    }
}

extension HomeCoordinator: DetailNoteCoordinatorDelegate {
    func detailNoteCoordinatorDidFinish(_ coordinator: DetailNoteCoordinator) {
        childrenCoordinator.removeAll { $0.type == .detail }
    }
}

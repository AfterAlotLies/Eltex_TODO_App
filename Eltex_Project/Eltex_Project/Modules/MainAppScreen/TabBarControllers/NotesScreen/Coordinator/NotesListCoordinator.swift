//
//  NotesListCoordinator.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 22.12.2024.
//

import UIKit
import Combine

protocol NotesListCoordinatorProtocol {
    func showNoteList()
    func showAddNote()
}

// MARK: - NotesListCoordinator + Coordinator
final class NotesListCoordinator: Coordinator {
    var childrenCoordinator: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    var type: CoordinatorType {.app}
    
    private var subscriptions: Set<AnyCancellable> = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        print("noteList coordinator started")
        showNoteList()
    }
    
}

extension NotesListCoordinator: NotesListCoordinatorProtocol {
    
    func showNoteList() {
        let viewModel = NoteListViewModel()
        
        viewModel.addNewNoteShowAction
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.showAddNote()
            }
            .store(in: &subscriptions)
        
        let noteListVC = NotesListViewController(viewModel: viewModel)
        navigationController.pushViewController(noteListVC, animated: false)
    }
    
    func showAddNote() {
        let controller = AddNewNoteViewController()
        if let sheetController = controller.sheetPresentationController {
            sheetController.detents = [.medium(), .large()]
            sheetController.prefersScrollingExpandsWhenScrolledToEdge = false
            sheetController.prefersEdgeAttachedInCompactHeight = true
        }
        controller.modalPresentationStyle = .pageSheet

        navigationController.present(controller, animated: true)
    }
}

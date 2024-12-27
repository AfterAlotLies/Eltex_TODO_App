//
//  CalendarCoordinator.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 22.12.2024.
//

import UIKit
import Combine

protocol CalendarCoordinatorProtocol {
    func showCalendar()
    func showDetails(for note: Note)
}

final class CalendarCoordinator: Coordinator {
    var childrenCoordinator: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    var type: CoordinatorType {.calendar}
    
    private let notesRepository: NotesRepository
    private var subscriptions: Set<AnyCancellable> = []
    
    init(navigationController: UINavigationController, notesRepository: NotesRepository) {
        self.navigationController = navigationController
        self.notesRepository = notesRepository
    }
    
    func start() {
        showCalendar()
    }
    
    deinit {
        print("calendar deinited coorditanor")
    }
}

extension CalendarCoordinator: CalendarCoordinatorProtocol {
    
    func showCalendar() {
        let viewModel = CalendarViewModel(notesRepository: notesRepository)
        
        viewModel.showDetailNoteAction
            .sink { [weak self] note in
                guard let self = self else { return }
                self.showDetails(for: note)
            }
            .store(in: &subscriptions)
        
        let controller = CalendarViewController(viewModel: viewModel)
        navigationController.isNavigationBarHidden = false
        navigationController.pushViewController(controller, animated: true)
    }
    
    func showDetails(for note: Note) {
        let coordinator = DetailNoteCoordinator(navigationController: navigationController, notesRepository: notesRepository, note: note)
        coordinator.delegate = self
        childrenCoordinator.append(coordinator)
        coordinator.start()
    }
}

extension CalendarCoordinator: DetailNoteCoordinatorDelegate {
    func detailNoteCoordinatorDidFinish(_ coordinator: DetailNoteCoordinator) {
        childrenCoordinator.removeAll { $0.type == .detail }
    }
}

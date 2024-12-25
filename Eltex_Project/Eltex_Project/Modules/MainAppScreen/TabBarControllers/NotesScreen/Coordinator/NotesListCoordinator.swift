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
    func showDetails(for note: Note)
}

// MARK: - NotesListCoordinator + Coordinator
final class NotesListCoordinator: Coordinator {
    var childrenCoordinator: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    var type: CoordinatorType {.notes}
    
    private let notesRepository: NotesRepository
    private var subscriptions: Set<AnyCancellable> = []
    
    init(navigationController: UINavigationController, notesRepository: NotesRepository) {
        self.navigationController = navigationController
        self.notesRepository = notesRepository
    }
    
    func start() {
        showNoteList()
    }
    
    deinit {
        print("noteslist deinited coorditanor")
    }
    
}

extension NotesListCoordinator: NotesListCoordinatorProtocol {
    
    func showNoteList() {
        let viewModel = NoteListViewModel(notesRepository: notesRepository)
        
        viewModel.addNewNoteShowAction
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.showAddNote()
            }
            .store(in: &subscriptions)
        
        viewModel.showNoteDetailsAction
            .sink { [weak self] note in
                guard let self = self else { return }
                self.showDetails(for: note)
            }
            .store(in: &subscriptions)
        
        let noteListVC = NotesListViewController(viewModel: viewModel)
        navigationController.pushViewController(noteListVC, animated: false)
    }
    
    func showAddNote() {
        let viewModel = NewNoteViewModel(notesRepository: notesRepository, choosenNote: nil)
        
        viewModel.noteCreatedPublisher
            .sink { [weak self]  in
                guard let self = self else { return }
                self.navigationController.dismiss(animated: true)
            }
            .store(in: &subscriptions)
        
        let newNoteVC = NewNoteViewController(viewModel: viewModel)
        newNoteVC.modalPresentationStyle = .overFullScreen
        navigationController.present(newNoteVC, animated: true)
    }
    
    func showDetails(for note: Note) {
        let coordinator = DetailNoteCoordinator(navigationController: navigationController, notesRepository: notesRepository, note: note)
        coordinator.delegate = self
        childrenCoordinator.append(coordinator)
        coordinator.start()
    }
}

extension NotesListCoordinator: DetailNoteCoordinatorDelegate {
    func detailNoteCoordinatorDidFinish(_ coordinator: DetailNoteCoordinator) {
        childrenCoordinator.removeAll { $0.type == .detail }
    }
}

private extension NotesListCoordinator {
    
    func setupNavigationBar(for vc: UIViewController) {
        vc.navigationItem.hidesBackButton = true
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "backButtonImage"),
                            for: .normal)
        backButton.tintColor =  UIColor(red: 99.0 / 255.0,
                                        green: 217.0 / 255.0,
                                        blue: 243.0 / 255.0,
                                        alpha: 1)
        backButton.addTarget(self,
                             action: #selector(backButtonTapped),
                             for: .touchUpInside)
        
        let titleLabel = UILabel()
        titleLabel.text = "Task Details"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 17,
                                            weight: .semibold)
        
        let stackView = UIStackView(arrangedSubviews: [backButton, titleLabel])
        stackView.axis = .horizontal
        stackView.spacing = 15
        stackView.alignment = .center
        
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: stackView)
    }
    
    @objc
    func backButtonTapped() {
        navigationController.popViewController(animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
}

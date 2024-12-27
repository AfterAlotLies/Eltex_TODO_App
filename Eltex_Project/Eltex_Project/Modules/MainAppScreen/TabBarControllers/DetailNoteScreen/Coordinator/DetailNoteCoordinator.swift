//
//  DetailNoteCoordinator.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 26.12.2024.
//

import UIKit
import Combine

// MARK: - DetailNoteCoordinatorDelegate
protocol DetailNoteCoordinatorDelegate: AnyObject {
    func detailNoteCoordinatorDidFinish(_ coordinator: DetailNoteCoordinator)
}

// MARK: - DetailNoteCoordinatorProtocol
protocol DetailNoteCoordinatorProtocol {
    func showDetailtNote(note: Note)
    func showEditingNote(note: Note, detailVM: DetailNoteViewModel)
}

// MARK: - DetailNoteCoordinator + Coordinator
final class DetailNoteCoordinator: Coordinator {
    
    private enum Constants {
        static let backButtonImage = UIImage(named: "backButtonImage")
        static let backButtonTintColor: UIColor = UIColor(red: 99.0 / 255.0,
                                                          green: 217.0 / 255.0,
                                                          blue: 243.0 / 255.0,
                                                          alpha: 1)
        static let titleLabelText = "Task Details"
    }
    
    var childrenCoordinator: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    var type: CoordinatorType { .detail }
    
    private let notesRepository: NotesRepository
    private let note: Note
    private var subscriptions: Set<AnyCancellable> = []
    
    weak var delegate: DetailNoteCoordinatorDelegate?
    
    init(navigationController: UINavigationController, notesRepository: NotesRepository, note: Note) {
        self.navigationController = navigationController
        self.notesRepository = notesRepository
        self.note = note
    }
    
    // MARK: - Start
    func start() {
        showDetailtNote(note: note)
    }
}

// MARK: - DetailNoteCoordinator + DetailNoteCoordinatorProtocol
extension DetailNoteCoordinator: DetailNoteCoordinatorProtocol {
    
    func showDetailtNote(note: Note) {
        let notesRepository = notesRepository
        let viewModel = DetailNoteViewModel(notesRepository: notesRepository)
        
        viewModel.editNoteAction
            .sink { [weak self] noteData in
                guard let self = self else { return }
                self.showEditingNote(note: noteData, detailVM: viewModel)
            }
            .store(in: &subscriptions)
        
        viewModel.closeDetailViewAction
            .sink { [weak self] in
                guard let self = self else { return }
                self.navigationController.popViewController(animated: true)
                self.cancelSubscriptions()
                self.delegate?.detailNoteCoordinatorDidFinish(self)
            }
            .store(in: &subscriptions)
        
        let detailVC = DetailNoteViewController(choosenNote: note, viewModel: viewModel)
        
        navigationController.setNavigationBarHidden(false, animated: false)
        setupNavigationBar(for: detailVC)
        navigationController.pushViewController(detailVC, animated: true)
    }
    
    func showEditingNote(note: Note, detailVM: DetailNoteViewModel) {
        let viewModel = NewNoteViewModel(notesRepository: notesRepository, choosenNote: note)
        
        viewModel.noteEditedPublisher
            .sink { [weak self] newNote in
                guard let self = self else { return }
                if let newNote = newNote {
                    detailVM.setNewNoteAction.send(newNote)
                    self.navigationController.dismiss(animated: true)
                } else {
                    self.navigationController.dismiss(animated: true)
                }
            }
            .store(in: &subscriptions)
        
        let controller = NewNoteViewController(viewModel: viewModel)
        controller.setupControllerForEditing(note: note)
        controller.modalPresentationStyle = .overFullScreen

        navigationController.present(controller, animated: true)
    }
}

// MARK: - Private Methods
private extension DetailNoteCoordinator {
    
    func cancelSubscriptions() {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }
    
    func setupNavigationBar(for vc: UIViewController) {
        vc.navigationItem.hidesBackButton = true
        
        let backButton = UIButton(type: .system)
        backButton.setImage(Constants.backButtonImage,
                            for: .normal)
        backButton.tintColor = Constants.backButtonTintColor
        backButton.addTarget(self,
                             action: #selector(backButtonTapped),
                             for: .touchUpInside)
        
        let titleLabel = UILabel()
        titleLabel.text = Constants.titleLabelText
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        
        let stackView = UIStackView(arrangedSubviews: [backButton, titleLabel])
        stackView.axis = .horizontal
        stackView.spacing = 15
        stackView.alignment = .center
        
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: stackView)
    }
    
    @objc
    func backButtonTapped() {
        navigationController.popViewController(animated: true)
        delegate?.detailNoteCoordinatorDidFinish(self)
    }
}

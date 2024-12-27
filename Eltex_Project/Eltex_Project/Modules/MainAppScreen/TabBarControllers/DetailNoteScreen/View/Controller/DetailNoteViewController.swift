//
//  DetailNoteViewController.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 24.12.2024.
//

import UIKit
import Combine

// MARK: - DetailNoteViewController
final class DetailNoteViewController: UIViewController {
    
    private lazy var detailNoteView: DetailNoteView = {
        let view = DetailNoteView(frame: .zero,
                                  viewModel: viewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setUserNoteData(choosenNote)
        return view
    }()
    
    private let choosenNote: Note
    private let viewModel: DetailNoteViewModel
    private var subscriptions: Set<AnyCancellable> = []
    
    // MARK: - Lifecycle
    init(choosenNote: Note, viewModel: DetailNoteViewModel) {
        self.choosenNote = choosenNote
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        setupBindings()
    }
}

// MARK: - Private Methods
private extension DetailNoteViewController {
    
    func setupBindings() {
        viewModel.setNewNoteAction
            .sink { [weak self] note in
                guard let self = self else { return }
                self.detailNoteView.setUserNoteData(note)
            }
            .store(in: &subscriptions)
    }
    
    func setupController() {
        view.addSubview(detailNoteView)
        
        view.applyGradientBackground(colors: [AppBackgroundColors.topColor,
                                              AppBackgroundColors.bottomColor])
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            detailNoteView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            detailNoteView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            detailNoteView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            detailNoteView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

//
//  NotesListViewController.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 23.12.2024.
//

import UIKit
import Combine

final class NotesListViewController: UIViewController {
    
    private lazy var notesListView: NotesListView = {
        let view = NotesListView(frame: .zero, viewModel: viewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let viewModel: NoteListViewModel
    
    init(viewModel: NoteListViewModel) {
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
    }
}

private extension NotesListViewController {
    
    func setupController() {
        view.addSubview(notesListView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            notesListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            notesListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            notesListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            notesListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

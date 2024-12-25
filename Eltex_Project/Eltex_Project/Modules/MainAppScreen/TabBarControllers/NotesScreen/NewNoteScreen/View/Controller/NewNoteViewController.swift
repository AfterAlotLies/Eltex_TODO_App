//
//  NewNoteViewController.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 24.12.2024.
//

import UIKit
import Combine

final class NewNoteViewController: UIViewController {
    
    private lazy var newNoteView: NewNoteView = {
        let view = NewNoteView(frame: .zero, viewModel: viewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let viewModel: NewNoteViewModel
    private var subscriptions: Set<AnyCancellable> = []
    
    init(viewModel: NewNoteViewModel) {
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
    
    func setupControllerForEditing(note: Note) {
        newNoteView.setEditingNoteData(note)
    }
}

private extension NewNoteViewController {
    
    func setupBindings() {
        viewModel.$errorMessage
            .sink { [weak self] errorMessage in
                guard let self = self else { return }
                if errorMessage != "" {
                    self.showAlert(message: errorMessage)
                }
            }
            .store(in: &subscriptions)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
    func setupController() {
        view.addSubview(newNoteView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        setupConstraints()
        
        view.backgroundColor = UIColor.white.withAlphaComponent(0.6)
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            newNoteView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            newNoteView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newNoteView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            newNoteView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}



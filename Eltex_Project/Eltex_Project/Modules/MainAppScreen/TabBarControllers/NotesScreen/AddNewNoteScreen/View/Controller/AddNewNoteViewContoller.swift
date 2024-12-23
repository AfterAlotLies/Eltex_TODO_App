//
//  AddNewNoteViewContoller.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 23.12.2024.
//

import UIKit
import Combine

final class AddNewNoteViewController: UIViewController {
    
    private lazy var addNewNoteView: AddNewNoteView = {
        let view = AddNewNoteView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }
}

private extension AddNewNoteViewController {
    
    func setupController() {
        view.addSubview(addNewNoteView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        setupConstraints()
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            addNewNoteView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            addNewNoteView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            addNewNoteView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            addNewNoteView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

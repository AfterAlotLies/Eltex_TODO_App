//
//  NotesListView.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 23.12.2024.
//

import UIKit

final class NotesListView: UIView {
    
    private enum Constants {
        static let searchBarBackgroundColor: UIColor = UIColor(red: 16.0 / 255.0, green: 45.0 / 255.0, blue: 83.0 / 255.0, alpha: 0.8)
        static let addNoteBackgroundColor: UIColor = UIColor(red: 99.0 / 255.0, green: 217.0 / 255.0 , blue: 243.0 / 255.0, alpha: 1)
    }
    
    private lazy var searchBar: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Search by task title"
        
        let placeholderColor = UIColor.lightGray
        if let placeholder = textField.placeholder {
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: placeholderColor
            ]
            textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
        }
        
        let imageView = UIImageView(image: UIImage(named: "searchImage"))
        imageView.contentMode = .scaleAspectFit
        
        let imageContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        imageView.frame = CGRect(x: 10, y: 0, width: 20, height: 20)
        imageContainer.addSubview(imageView)
        
        textField.rightView = imageContainer
        textField.rightViewMode = .always
        
        textField.backgroundColor = Constants.searchBarBackgroundColor
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.cornerRadius = 10
        
        textField.leftViewMode = .always
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        textField.leftView = paddingView
        
        return textField
    }()
    
    private lazy var listTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate  = self
        tableView.register(NotesTableViewCell.self, forCellReuseIdentifier: NotesTableViewCell.identifier)
        return tableView
    }()
    
    private lazy var addNoteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "addNoteImage"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = Constants.addNoteBackgroundColor
        button.addTarget(self, action: #selector(addNewNoteButtonAction), for: .touchUpInside)
        return button
    }()
    
    private let viewModel: NoteListViewModel
    
    init(frame: CGRect, viewModel: NoteListViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addNoteButton.layer.cornerRadius = addNoteButton.bounds.size.height / 2

    }
}

extension NotesListView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotesTableViewCell.identifier, for: indexPath) as? NotesTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configureCell("Client meeting", "Tomorrow | 10:30pm", isCompleted: false)
        
        return cell
    }
}

extension NotesListView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        let titleLabel = UILabel()
        titleLabel.text = "Tasks List"
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
        ])
        
        return headerView
    }
}

private extension NotesListView {
    
    @objc
    func addNewNoteButtonAction() {
        viewModel.showAddNewNote()
    }
}

private extension NotesListView {
    
    func setupView() {
        backgroundColor = .clear
        
        addSubview(searchBar)
        addSubview(listTableView)
        addSubview(addNoteButton)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 42)
        ])
        
        NSLayoutConstraint.activate([
            listTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            listTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            listTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
        ])
        
        NSLayoutConstraint.activate([
            addNoteButton.topAnchor.constraint(equalTo: listTableView.bottomAnchor, constant: 16),
            addNoteButton.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 16),
            addNoteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            addNoteButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            addNoteButton.heightAnchor.constraint(equalToConstant: 50),
            addNoteButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
}

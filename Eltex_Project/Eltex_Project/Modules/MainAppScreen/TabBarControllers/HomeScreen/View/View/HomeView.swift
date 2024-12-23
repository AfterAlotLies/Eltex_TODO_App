//
//  HomeView.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 23.12.2024.
//

import UIKit

// MARK: - HomeView
final class HomeView: UIView {
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private lazy var userEmailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private lazy var userNotesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(NotesTableViewCell.self, forCellReuseIdentifier: NotesTableViewCell.identifier)
        return tableView
    }()
    
    private var noteSections: [NoteSection]?
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUserInfo(_ email: String, _ name: String) {
        userNameLabel.text = name
        userEmailLabel.text = email
    }
    
    func setupNoteData(_ noteData: [NoteSection]) {
        noteSections = noteData
        userNotesTableView.reloadData()
    }
    
}

// MARK: - HomeView + UITableViewDataSource
extension HomeView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let noteSectionsModel = noteSections else { return 0 }
        return noteSectionsModel.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let noteSectionsModel = noteSections else { return 0 }
        return noteSectionsModel[section].notes.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotesTableViewCell.identifier, for: indexPath) as? NotesTableViewCell,
              let noteSectionsModel = noteSections  else {
            return UITableViewCell()
        }
        
        let section = noteSectionsModel[indexPath.section]
        let noteData = section.notes[indexPath.row]
        
        cell.configureCell(noteData.noteName,
                           noteData.noteDate,
                           isCompleted: noteData.isCompleted)
        
        return cell
    }
}

// MARK: - HomeView + UITableViewDelegate
extension HomeView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let noteSectionsModel = noteSections else { return UIView() }
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        let titleLabel = UILabel()
        titleLabel.text = noteSectionsModel[section].title
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

// MARK: - Setup View + Setup Constraints()
private extension HomeView {
    
    func setupView() {
        backgroundColor = .clear
        
        addSubview(userNameLabel)
        addSubview(userEmailLabel)
        addSubview(userNotesTableView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            userNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            userNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            userEmailLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8),
            userEmailLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            userEmailLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            userNotesTableView.topAnchor.constraint(equalTo: userEmailLabel.bottomAnchor, constant: 16),
            userNotesTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            userNotesTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            userNotesTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

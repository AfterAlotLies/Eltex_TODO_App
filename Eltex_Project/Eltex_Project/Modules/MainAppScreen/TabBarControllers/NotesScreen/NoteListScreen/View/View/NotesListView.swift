//
//  NotesListView.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 23.12.2024.
//

import UIKit

// MARK: - NotesListView
final class NotesListView: UIView {
    
    private enum Constants {
        static let searchBarBackgroundColor: UIColor = UIColor(red: 16/255,
                                                               green: 45/255,
                                                               blue: 83/255,
                                                               alpha: 0.8)
        static let addNoteBackgroundColor: UIColor = UIColor(red: 99/255,
                                                             green: 217/255,
                                                             blue: 243/255,
                                                             alpha: 1)
        static let searchBarPlaceholder = "Search by task title"
        static let searchBarImage = UIImageView(image: UIImage(named: "searchImage"))
        static let addNoteButtonImage = UIImage(named: "addNoteImage")
        static let viewForHeaderTitle = "Tasks List"
    }
    
    private lazy var searchBar: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = Constants.searchBarPlaceholder
        
        let placeholderColor = UIColor.lightGray
        if let placeholder = textField.placeholder {
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: placeholderColor
            ]
            textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
        }
        
        let imageView = Constants.searchBarImage
        imageView.contentMode = .scaleAspectFit
        
        let imageContainer = UIView(frame: CGRect(x: 0, y: 0,
                                                  width: 40, height: 20))
        imageView.frame = CGRect(x: 10, y: 0,
                                 width: 20, height: 20)
        imageContainer.addSubview(imageView)
        
        textField.rightView = imageContainer
        textField.rightViewMode = .always
        
        textField.backgroundColor = Constants.searchBarBackgroundColor
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.cornerRadius = 10
        
        textField.leftViewMode = .always
        let paddingView = UIView(frame: CGRect(x: 0, y: 0,
                                               width: 20, height: 20))
        textField.leftView = paddingView
        
        return textField
    }()
    
    private lazy var listTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate  = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(NotesTableViewCell.self,
                           forCellReuseIdentifier: NotesTableViewCell.identifier)
        return tableView
    }()
    
    private lazy var addNoteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Constants.addNoteButtonImage, for: .normal)
        button.tintColor = .white
        button.backgroundColor = Constants.addNoteBackgroundColor
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 10
        button.addTarget(self,
                         action: #selector(addNewNoteButtonAction),
                         for: .touchUpInside)
        return button
    }()
    
    private let viewModel: NoteListViewModel
    private var noteModel: [Note]?
    
    // MARK: - Lifecycle
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
    
    // MARK: - Public Methods
    func setNoteModel(_ note: [Note]) {
        noteModel = note
        listTableView.reloadData()
    }
}

// MARK: - NotesListView + UITableViewDataSource
extension NotesListView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = noteModel else { return 0 }
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotesTableViewCell.identifier, for: indexPath) as? NotesTableViewCell,
              let model = noteModel else {
            return UITableViewCell()
        }
        
        let cellData = model[indexPath.row]
        
        cell.configureCell(cellData.noteName,
                           cellData.noteDate,
                           cellData.noteTime,
                           isCompleted: cellData.isCompleted)
        
        return cell
    }
}

// MARK: - NotesListView + UITableViewDelegate
extension NotesListView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        let titleLabel = UILabel()
        titleLabel.text = Constants.viewForHeaderTitle
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = noteModel else { return }
        let cellData = model[indexPath.row]
        viewModel.showNoteDetails(cellData)
    }
}

// MARK: - Private Methods
private extension NotesListView {
    
    @objc
    func addNewNoteButtonAction() {
        viewModel.showAddNewNote()
    }
    
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

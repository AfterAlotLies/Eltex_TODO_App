//
//  NotesTableViewCell.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 23.12.2024.
//

import UIKit

// MARK: - NotesTableViewCell
final class NotesTableViewCell: UITableViewCell {
    
    private lazy var contentViewCell: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.clear.cgColor
        view.layer.cornerRadius = 5
        return view
    }()
    
    private lazy var taskNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var dateTaskLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .black
        label.font = .systemFont(ofSize: 10)
        return label
    }()
    
    private lazy var completedTaskImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var moreInformationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "cellInfoImage")
        return imageView
    }()
    
    private lazy var taskContentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [taskNameLabel,
                                                       dateTaskLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.backgroundColor = .clear
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [completedTaskImageView,
                                                       taskContentStackView,
                                                       moreInformationImageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.backgroundColor = .clear
        stackView.spacing = 10
        stackView.alignment = .center
        return stackView
    }()
    
    static let identifier: String = String(describing: NotesTableViewCell.self)
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        setupCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        taskNameLabel.text = nil
        dateTaskLabel.text = nil
        completedTaskImageView.image = nil
    }
    
    func configureCell(_ taskName: String, _ taskDate: String, _ taskTime: String, isCompleted: Bool) {
        taskNameLabel.text = taskName
        dateTaskLabel.text = "\(taskDate) | \(taskTime)"
        if isCompleted {
            completedTaskImageView.isHidden = false
            contentStackView.insertArrangedSubview(completedTaskImageView, at: 0)
            completedTaskImageView.image = UIImage(named: "completedTask")
        } else {
            completedTaskImageView.isHidden = true
            contentStackView.removeArrangedSubview(completedTaskImageView)
        }
    }
}

// MARK: - Setup Cell + Setup Constraints
private extension NotesTableViewCell {
    
    func setupCell() {
        contentView.addSubview(contentViewCell)
        contentViewCell.addSubview(contentStackView)
    
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            contentViewCell.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            contentViewCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentViewCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            contentViewCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            completedTaskImageView.heightAnchor.constraint(equalToConstant: 20),
            completedTaskImageView.widthAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            moreInformationImageView.widthAnchor.constraint(equalToConstant: 11),
            moreInformationImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentViewCell.topAnchor, constant: 8),
            contentStackView.leadingAnchor.constraint(equalTo: contentViewCell.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: contentViewCell.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: contentViewCell.bottomAnchor, constant: -8)
        ])
    }
}

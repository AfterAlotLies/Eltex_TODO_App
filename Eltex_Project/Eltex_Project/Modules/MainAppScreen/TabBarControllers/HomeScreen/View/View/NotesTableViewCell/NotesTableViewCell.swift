//
//  NotesTableViewCell.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 23.12.2024.
//

import UIKit
import Combine

// MARK: - NotesTableViewCell
final class NotesTableViewCell: UITableViewCell {
    
    static let identifier: String = String(describing: NotesTableViewCell.self)
    
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
    
    private var subscriptions: Set<AnyCancellable> = []

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
        dateTaskLabel.text = formatNoteDate(taskDate, taskTime)
        taskNameLabel.text = taskName
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

private extension NotesTableViewCell {
    
    func formatNoteDate(_ taskDate: String, _ taskTime: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let today = Calendar.current.startOfDay(for: Date())
        
        guard let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today) else {
            return "\(taskDate) | \(taskTime)"
        }
        
        guard let noteDate = dateFormatter.date(from: taskDate) else {
            return "\(taskDate) | \(taskTime)"
        }
        
        if Calendar.current.isDate(noteDate, inSameDayAs: today) {
            return "Today | \(taskTime)"
        } else if Calendar.current.isDate(noteDate, inSameDayAs: tomorrow) {
            return "Tomorrow | \(taskTime)"
        } else {
            return "\(taskDate) | \(taskTime)"
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

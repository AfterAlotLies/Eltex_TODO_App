//
//  DetailNoteView.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 24.12.2024.
//

import UIKit

// MARK: - DetailNoteView
final class DetailNoteView: UIView {
    
    private enum Constants {
        static let buttonsBackgroundColor: UIColor = UIColor(red: 5/255,
                                                             green: 36/255,
                                                             blue: 62/255,
                                                             alpha: 1)
        
        static let completedButtonImageTask = UIImage(named: "completedTask")
        static let doneButtonTitle = "Done"
        static let deleteButtonImage = UIImage(named: "deleteNoteImage")
        static let deleteButtonTitle = "Delete"
        static let widthAnchor: CGFloat = 88
        static let heightAnchor: CGFloat = 71
        static let topAnchor26: CGFloat = 26
        static let topAnchor16: CGFloat = 16
        static let leadingAnchor: CGFloat = 16
        static let trailingAnchor: CGFloat = -16
    }
    
    private lazy var noteNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    private lazy var noteNameImageView: UIImageView = createImageView("noteNameImage")
    private lazy var calendarImageView: UIImageView = createImageView("calendarImage")
    private lazy var clockImageView: UIImageView = createImageView("clockImage")
    
    private lazy var noteDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    private lazy var noteTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    private lazy var dividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white.withAlphaComponent(0.3)
        return view
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 14, weight: .regular)
        textView.textColor = .white
        textView.backgroundColor = .clear
        return textView
    }()
    
    private lazy var doneNoteButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        
        configuration.baseBackgroundColor = Constants.buttonsBackgroundColor
        configuration.cornerStyle = .medium
        
        configuration.image = Constants.completedButtonImageTask
        configuration.imagePadding = 10
        configuration.imagePlacement = .top
        
        configuration.title = Constants.doneButtonTitle
        configuration.baseForegroundColor = .white
        configuration.attributedTitle?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.layer.shadowColor = UIColor.white.withAlphaComponent(0.7).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowOpacity = 0.6
        button.layer.shadowRadius = 5
        
        button.addTarget(self,
                         action: #selector(markNoteAsDone),
                         for: .touchUpInside)
        
        return button
    }()
    
    private lazy var deleteNoteButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        
        configuration.baseBackgroundColor = Constants.buttonsBackgroundColor
        configuration.cornerStyle = .medium
        
        configuration.image = Constants.deleteButtonImage
        configuration.imagePadding = 10
        configuration.imagePlacement = .top
        
        configuration.title = Constants.deleteButtonTitle
        configuration.baseForegroundColor = .white
        configuration.attributedTitle?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.layer.shadowColor = UIColor.white.withAlphaComponent(0.7).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowOpacity = 0.6
        button.layer.shadowRadius = 5
        
        button.addTarget(self,
                         action: #selector(deleteNote),
                         for: .touchUpInside)
        
        return button
    }()
    
    private let viewModel: DetailNoteViewModel
    private var noteData: Note?
    
    // MARK: - Lifecycle
    init(frame: CGRect, viewModel: DetailNoteViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func setUserNoteData(_ userNoteData: Note) {
        noteData = userNoteData
        noteNameLabel.text = userNoteData.noteName
        noteDateLabel.text = "\(userNoteData.noteDate) |"
        noteTimeLabel.text = userNoteData.noteTime
        descriptionTextView.text = userNoteData.noteDescription
        
        setupDoneAndCancelButtonAnchors(userNoteData.isCompleted)
    }
}

// MARK: - Private Methods
private extension DetailNoteView {
    
    @objc
    func editNote() {
        guard let note = noteData else { return }
        viewModel.editnote(note: note)
    }
    
    @objc
    func markNoteAsDone() {
        guard let noteId = noteData?.noteId else { return }
        viewModel.markNoteCompleted(noteId: noteId)
    }
    
    @objc
    func deleteNote() {
        guard let noteId = noteData?.noteId else { return }
        viewModel.deleteNote(noteId: noteId)
    }
    
    func createImageView(_ imageName: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: imageName)
        return imageView
    }
    
    func setupDoneAndCancelButtonAnchors(_ isCompleted: Bool) {
        if isCompleted {
            addSubview(deleteNoteButton)
            NSLayoutConstraint.activate([
                deleteNoteButton.widthAnchor.constraint(equalToConstant: Constants.widthAnchor),
                deleteNoteButton.heightAnchor.constraint(equalToConstant: Constants.heightAnchor),
                deleteNoteButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: Constants.topAnchor26),
                deleteNoteButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ])
        } else {
            addSubview(doneNoteButton)
            addSubview(deleteNoteButton)
            
            NSLayoutConstraint.activate([
                doneNoteButton.widthAnchor.constraint(equalToConstant: Constants.widthAnchor),
                doneNoteButton.heightAnchor.constraint(equalToConstant: Constants.heightAnchor),
                doneNoteButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: Constants.topAnchor26),
                doneNoteButton.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: Constants.trailingAnchor)
            ])
            
            NSLayoutConstraint.activate([
                deleteNoteButton.widthAnchor.constraint(equalToConstant: Constants.widthAnchor),
                deleteNoteButton.heightAnchor.constraint(equalToConstant: Constants.heightAnchor),
                deleteNoteButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: Constants.topAnchor26),
                deleteNoteButton.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: Constants.leadingAnchor)
            ])
        }
    }
    
    func setupView() {
        addSubview(noteNameLabel)
        addSubview(noteNameImageView)
        addSubview(calendarImageView)
        addSubview(noteDateLabel)
        addSubview(clockImageView)
        addSubview(noteTimeLabel)
        addSubview(dividerView)
        addSubview(descriptionTextView)
        
        setupImageInteractionEnabledTrue()
        
        setupConstraints()
    }
    
    func setupImageInteractionEnabledTrue() {
        noteNameImageView.isUserInteractionEnabled = true
        let editNote = UITapGestureRecognizer(target: self,
                                              action: #selector(editNote))
        noteNameImageView.addGestureRecognizer(editNote)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            noteNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.topAnchor16),
            noteNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.leadingAnchor),
            noteNameLabel.trailingAnchor.constraint(equalTo: noteNameImageView.leadingAnchor, constant: -4)
        ])
        
        NSLayoutConstraint.activate([
            noteNameImageView.heightAnchor.constraint(equalToConstant: 16),
            noteNameImageView.widthAnchor.constraint(equalToConstant: 16),
            noteNameImageView.centerYAnchor.constraint(equalTo: noteNameLabel.centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            calendarImageView.heightAnchor.constraint(equalToConstant: 11),
            calendarImageView.widthAnchor.constraint(equalToConstant: 11),
            calendarImageView.topAnchor.constraint(equalTo: noteNameLabel.bottomAnchor, constant: 8),
            calendarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            noteDateLabel.centerYAnchor.constraint(equalTo: calendarImageView.centerYAnchor),
            noteDateLabel.leadingAnchor.constraint(equalTo: calendarImageView.trailingAnchor, constant: 4)
        ])
        
        NSLayoutConstraint.activate([
            clockImageView.heightAnchor.constraint(equalToConstant: 11),
            clockImageView.widthAnchor.constraint(equalToConstant: 11),
            clockImageView.centerYAnchor.constraint(equalTo: noteDateLabel.centerYAnchor),
            clockImageView.leadingAnchor.constraint(equalTo: noteDateLabel.trailingAnchor, constant: 6)
        ])
        
        NSLayoutConstraint.activate([
            noteTimeLabel.centerYAnchor.constraint(equalTo: clockImageView.centerYAnchor),
            noteTimeLabel.leadingAnchor.constraint(equalTo: clockImageView.trailingAnchor, constant: 4),
        ])
        
        NSLayoutConstraint.activate([
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            dividerView.topAnchor.constraint(equalTo: noteTimeLabel.bottomAnchor, constant: Constants.topAnchor16),
            dividerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Constants.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            descriptionTextView.heightAnchor.constraint(equalToConstant: 157),
            descriptionTextView.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: Constants.topAnchor16),
            descriptionTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Constants.trailingAnchor)
        ])
    }
}

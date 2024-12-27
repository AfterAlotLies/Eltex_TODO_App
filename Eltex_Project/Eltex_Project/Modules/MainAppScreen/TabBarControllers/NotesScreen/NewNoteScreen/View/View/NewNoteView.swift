//
//  NewNoteView.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 24.12.2024.
//

import UIKit

// MARK: - NewNoteView
final class NewNoteView: UIView {
    
    private enum Constants {
        static let uiBackgroundColor: UIColor = UIColor(red: 5/255,
                                                        green: 36/255,
                                                        blue: 62/255,
                                                        alpha: 1.0)
        static let buttonBorderColor: UIColor = UIColor(red: 14/255,
                                                        green: 165/255,
                                                        blue: 233/255,
                                                        alpha: 1)
        
        static let taskTextFieldPlaceholder = "task"
        static let taskTextFieldImage = UIImageView(image: UIImage(named: "taskCheckImage"))
        static let descriptionTextFieldImage = UIImageView(image: UIImage(named: "descriptionTaskImage"))
        static let dateTextFieldPlaceholder = "Date"
        static let dateTextFieldImage = UIImageView(image: UIImage(named: "dateTaskImage"))
        static let timeTextFieldPlaceholder = "Time"
        static let timeTextFieldImage = UIImageView(image: UIImage(named: "timeTaskImage"))
        static let cancelButtonTitle = "cancel"
        static let createButtonTitle = "create"
        static let saveButtonTitle = "save"
        
        static let topAnchor: CGFloat = 16
        static let leadingAnchor: CGFloat = 16
        static let trailingAnchor: CGFloat = -16
    }
    
    private lazy var taskTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = Constants.taskTextFieldPlaceholder
        textField.textColor = .lightGray
        
        let placeholderColor = UIColor.lightGray
        if let placeholder = textField.placeholder {
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: placeholderColor
            ]
            textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
        }
        
        let imageView = Constants.taskTextFieldImage
        imageView.contentMode = .scaleAspectFit
        
        let imageContainer = UIView(frame: CGRect(x: 0, y: 0,
                                                  width: 40, height: 20))
        imageView.frame = CGRect(x: 10, y: 0,
                                 width: 20, height: 20)
        imageContainer.addSubview(imageView)
        
        textField.leftView = imageContainer
        textField.leftViewMode = .always
        
        textField.backgroundColor = Constants.uiBackgroundColor
        textField.layer.cornerRadius = 5
        
        return textField
    }()
    
    private lazy var descriptionTaskTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = Constants.uiBackgroundColor
        
        let imageView = Constants.descriptionTextFieldImage
        imageView.contentMode = .scaleAspectFit
        
        imageView.frame = CGRect(x: 10, y: 10,
                                 width: 20, height: 20)
        textView.addSubview(imageView)
        
        textView.layer.cornerRadius = 5
        textView.textColor = .lightGray
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 50,
                                                   bottom: 10, right: 10)
        
        return textView
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        }
        picker.addTarget(self,
                         action: #selector(dateChanged),
                         for: .valueChanged)
        return picker
    }()
    
    private lazy var timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        }
        picker.addTarget(self,
                         action: #selector(timeChanged),
                         for: .valueChanged)
        return picker
    }()
    
    private lazy var dateTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = Constants.dateTextFieldPlaceholder
        textField.textColor = .lightGray
        
        let placeholderColor = UIColor.lightGray
        if let placeholder = textField.placeholder {
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: placeholderColor
            ]
            textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
        }
        
        textField.borderStyle = .roundedRect
        textField.backgroundColor = Constants.uiBackgroundColor
        textField.layer.cornerRadius = 5
        
        textField.inputView = datePicker
        
        let imageView = Constants.dateTextFieldImage
        imageView.contentMode = .scaleAspectFit
        let imageContainer = UIView(frame: CGRect(x: 0, y: 0,
                                                  width: 40, height: 20))
        imageView.frame = CGRect(x: 10, y: 0,
                                 width: 20, height: 20)
        imageContainer.addSubview(imageView)
        textField.leftView = imageContainer
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private lazy var timeTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = Constants.timeTextFieldPlaceholder
        textField.textColor = .lightGray
        
        let placeholderColor = UIColor.lightGray
        if let placeholder = textField.placeholder {
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: placeholderColor
            ]
            textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
        }
        
        textField.borderStyle = .roundedRect
        textField.backgroundColor = Constants.uiBackgroundColor
        textField.layer.cornerRadius = 5
        
        textField.inputView = timePicker
        
        let imageView = Constants.timeTextFieldImage
        imageView.contentMode = .scaleAspectFit
        let imageContainer = UIView(frame: CGRect(x: 0, y: 0,
                                                  width: 40, height: 20))
        imageView.frame = CGRect(x: 10, y: 0,
                                 width: 20, height: 20)
        imageContainer.addSubview(imageView)
        textField.leftView = imageContainer
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constants.cancelButtonTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = Constants.buttonBorderColor.cgColor
        
        button.addTarget(self,
                         action: #selector(cancelCreatingNewNote),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constants.createButtonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Constants.buttonBorderColor
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = Constants.buttonBorderColor.cgColor
        button.addTarget(self,
                         action: #selector(createNewNote),
                         for: .touchUpInside)
        return button
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -4)
        view.layer.shadowRadius = 1
        view.layer.shadowOpacity = 0.4
        return view
    }()
    
    private let viewModel: NewNoteViewModel
    private var bottomConstraint: NSLayoutConstraint!
    private var editingNote: Note?
    
    // MARK: - Lifecycle
    init(frame: CGRect, viewModel: NewNoteViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupView()
        setupKeyboardObservers()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func setEditingNoteData(_ data: Note) {
        editingNote = data
        setupFields()
    }
}

// MARK: - Private Methods
private extension NewNoteView {
    
    func setupDefaultDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        dateTextField.text = formatter.string(from: Date())
        datePicker.date = Date()
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        timeTextField.text = timeFormatter.string(from: Date())
        timePicker.date = Date()
    }
    
    func setupFields() {
        guard let note = editingNote else { return }
        taskTextField.text = note.noteName
        descriptionTaskTextView.text = note.noteDescription
        dateTextField.text = note.noteDate
        timeTextField.text = note.noteTime
        createButton.setTitle(Constants.saveButtonTitle, for: .normal)
    }
    
    func setupKeyboardObservers() {
       NotificationCenter.default.addObserver(
           self,
           selector: #selector(keyboardWillShow),
           name: UIResponder.keyboardWillShowNotification,
           object: nil
       )
       NotificationCenter.default.addObserver(
           self,
           selector: #selector(keyboardWillHide),
           name: UIResponder.keyboardWillHideNotification,
           object: nil
       )
   }
    
    @objc
    func cancelCreatingNewNote() {
        guard let _ = editingNote else {
            viewModel.closeScreen()
            return
        }
        viewModel.cancelEditing()
    }
    
    @objc
    func createNewNote() {
        guard let editingNote = editingNote else  {
            let newNoteData = Note(noteId: UUID(),
                                   noteName: taskTextField.text ?? "",
                                   noteDate: dateTextField.text ?? "",
                                   noteTime: timeTextField.text ?? "",
                                   noteDescription: descriptionTaskTextView.text ?? "",
                                   isCompleted: false)
            viewModel.addNewNote(note: newNoteData)
            return
        }
        let editedNoteData = Note(noteId: editingNote.noteId,
                               noteName: taskTextField.text ?? "",
                               noteDate: dateTextField.text ?? "",
                               noteTime: timeTextField.text ?? "",
                               noteDescription: descriptionTaskTextView.text ?? "",
                               isCompleted: false)
        viewModel.saveEditing(for: editedNoteData)
    }
    
    @objc
    func keyboardWillShow(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            return
        }
        
        let keyboardHeight = keyboardFrame.height
        bottomConstraint.constant = -(keyboardHeight)
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    @objc
    func keyboardWillHide(_ notification: Notification) {
        bottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    @objc
    func dateChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        dateTextField.text = formatter.string(from: sender.date)
    }
    
    @objc
    func timeChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        timeTextField.text = formatter.string(from: sender.date)
    }
    
    func setupView() {
        addSubview(containerView)
        
        containerView.addSubview(taskTextField)
        containerView.addSubview(descriptionTaskTextView)
        containerView.addSubview(dateTextField)
        containerView.addSubview(timeTextField)
        
        containerView.addSubview(cancelButton)
        containerView.addSubview(createButton)
        
        setupConstraints()
        setupDefaultDate()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -0),
            containerView.topAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.topAnchor, constant: Constants.topAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 444)
        ])
        
        bottomConstraint = containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        bottomConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            taskTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.topAnchor),
            taskTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.leadingAnchor),
            taskTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: Constants.trailingAnchor),
            taskTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        NSLayoutConstraint.activate([
            descriptionTaskTextView.topAnchor.constraint(equalTo: taskTextField.bottomAnchor, constant: Constants.topAnchor),
            descriptionTaskTextView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.leadingAnchor),
            descriptionTaskTextView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: Constants.trailingAnchor),
            descriptionTaskTextView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            dateTextField.topAnchor.constraint(equalTo: descriptionTaskTextView.bottomAnchor, constant: Constants.topAnchor),
            dateTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.leadingAnchor),
            dateTextField.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: Constants.trailingAnchor),
            dateTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        NSLayoutConstraint.activate([
            timeTextField.topAnchor.constraint(equalTo: descriptionTaskTextView.bottomAnchor, constant: Constants.topAnchor),
            timeTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Constants.trailingAnchor),
            timeTextField.heightAnchor.constraint(equalToConstant: 44),
            timeTextField.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: Constants.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.leadingAnchor),
            cancelButton.topAnchor.constraint(equalTo: dateTextField.bottomAnchor, constant: Constants.topAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: Constants.trailingAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            createButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: Constants.trailingAnchor),
            createButton.topAnchor.constraint(equalTo: timeTextField.bottomAnchor, constant: Constants.topAnchor),
            createButton.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: Constants.leadingAnchor),
            createButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

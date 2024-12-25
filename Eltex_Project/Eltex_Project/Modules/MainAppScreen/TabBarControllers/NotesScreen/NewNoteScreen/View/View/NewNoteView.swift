//
//  NewNoteView.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 24.12.2024.
//

import UIKit

final class NewNoteView: UIView {
    
    private enum Constants {
        static let uiBackgroundColor: UIColor = UIColor(red: 5.0 / 255.0, green: 36.0 / 255.0, blue: 62.0 / 255.0, alpha: 1.0)
        static let buttonBorderColor: UIColor = UIColor(red: 14.0 / 255.0, green: 165.0 / 255.0, blue: 233.0 / 255.0, alpha: 1)
    }
    
    private lazy var taskTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "task"
        textField.textColor = .lightGray
        
        let placeholderColor = UIColor.lightGray
        if let placeholder = textField.placeholder {
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: placeholderColor
            ]
            textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
        }
        
        let imageView = UIImageView(image: UIImage(named: "taskCheckImage"))
        imageView.contentMode = .scaleAspectFit
        
        let imageContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        imageView.frame = CGRect(x: 10, y: 0, width: 20, height: 20)
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
        
        let imageView = UIImageView(image: UIImage(named: "descriptionTaskImage"))
        imageView.contentMode = .scaleAspectFit
        
        imageView.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        textView.addSubview(imageView)
        
        textView.layer.cornerRadius = 5
        textView.textColor = .lightGray
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 50, bottom: 10, right: 10)
        
        return textView
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        }
        picker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        return picker
    }()
    
    private lazy var timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        }
        picker.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
        return picker
    }()
    
    private lazy var dateTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Date"
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
        
        let imageView = UIImageView(image: UIImage(named: "dateTaskImage"))
        imageView.contentMode = .scaleAspectFit
        let imageContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        imageView.frame = CGRect(x: 10, y: 0, width: 20, height: 20)
        imageContainer.addSubview(imageView)
        textField.leftView = imageContainer
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private lazy var timeTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Time"
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
        
        let imageView = UIImageView(image: UIImage(named: "timeTaskImage"))
        imageView.contentMode = .scaleAspectFit
        let imageContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        imageView.frame = CGRect(x: 10, y: 0, width: 20, height: 20)
        imageContainer.addSubview(imageView)
        textField.leftView = imageContainer
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("cancel", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = Constants.buttonBorderColor.cgColor
        button.addTarget(self, action: #selector(cancelCreatingNewNote), for: .touchUpInside)
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("create", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Constants.buttonBorderColor
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = Constants.buttonBorderColor.cgColor
        button.addTarget(self, action: #selector(createNewNote), for: .touchUpInside)
        return button
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        return view
    }()
    
    private let viewModel: NewNoteViewModel
    private var bottomConstraint: NSLayoutConstraint!
    private var editingNote: Note?
    
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
    
    func setEditingNoteData(_ data: Note) {
        editingNote = data
        setupFields()
    }
    
}

private extension NewNoteView {
    
    func setupFields() {
        guard let note = editingNote else { return }
        taskTextField.text = note.noteName
        descriptionTaskTextView.text = note.noteDescription
        dateTextField.text = note.noteDate
        timeTextField.text = note.noteTime
        createButton.setTitle("save", for: .normal)
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
    
}

private extension NewNoteView {
    
    func setupView() {
        addSubview(containerView)
        
        containerView.addSubview(taskTextField)
        containerView.addSubview(descriptionTaskTextView)
        containerView.addSubview(dateTextField)
        containerView.addSubview(timeTextField)
        
        containerView.addSubview(cancelButton)
        containerView.addSubview(createButton)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -0),
            containerView.topAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            containerView.heightAnchor.constraint(equalToConstant: 444)
        ])
        
        bottomConstraint = containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        bottomConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            taskTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            taskTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            taskTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            taskTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        NSLayoutConstraint.activate([
            descriptionTaskTextView.topAnchor.constraint(equalTo: taskTextField.bottomAnchor, constant: 16),
            descriptionTaskTextView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            descriptionTaskTextView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            descriptionTaskTextView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            dateTextField.topAnchor.constraint(equalTo: descriptionTaskTextView.bottomAnchor, constant: 16),
            dateTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            dateTextField.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: -16),
            dateTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        NSLayoutConstraint.activate([
            timeTextField.topAnchor.constraint(equalTo: descriptionTaskTextView.bottomAnchor, constant: 16),
            timeTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            timeTextField.heightAnchor.constraint(equalToConstant: 44),
            timeTextField.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            cancelButton.topAnchor.constraint(equalTo: dateTextField.bottomAnchor, constant: 16),
            cancelButton.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: -16),
            cancelButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            createButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            createButton.topAnchor.constraint(equalTo: timeTextField.bottomAnchor, constant: 16),
            createButton.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: 16),
            createButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

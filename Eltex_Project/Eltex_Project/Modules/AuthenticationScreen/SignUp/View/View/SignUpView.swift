//
//  SignUpView.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 20.12.2024.
//

import UIKit

// MARK: - SignUpView
final class SignUpView: UIView {
    
    private enum Constants {
        static let signInButtonColor: UIColor = UIColor(red: 14/255,
                                                        green: 165/255,
                                                        blue: 233/255,
                                                        alpha: 1)
        static let signUpButtonTextColor: UIColor = UIColor(red: 99/255,
                                                            green: 217/255,
                                                            blue: 243/255,
                                                            alpha: 1)
        static let topImageName = "authTopImage"
        static let welcomeLabelText = "Welcome to DO IT"
        static let titleLabelText = "Create an account and Join us now!"
        static let signUpButtonTitle = "Sign Up"
        static let messageLabelText = "Already have an account?"
        static let signInButtonTitle = "Sign In"
        static let topAnchor16: CGFloat = 16
        static let topAnchor36: CGFloat = 36
        static let leadingAnchor: CGFloat = 16
        static let trailingAnchor: CGFloat = -16
        static let heightAnchor: CGFloat = 42
    }
    
    private lazy var topImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: Constants.topImageName)
        return imageView
    }()
    
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.welcomeLabelText
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = Constants.titleLabelText
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    
    private lazy var userInputTextField: UITextField = createInputTextField(placeholder: "Full name",
                                                                            leftImage: "userImage")
    
    private lazy var emailInputTextField: UITextField = createInputTextField(placeholder: "E-mail",
                                                                             leftImage: "emailImage")
    
    private lazy var passwordInputTextField: UITextField = createInputTextField(placeholder: "Password",
                                                                                leftImage: "passwordImage")
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle(Constants.signUpButtonTitle,
                        for: .normal)
        button.setTitleColor(.white,
                             for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.cornerRadius = 10
        
        button.backgroundColor = Constants.signInButtonColor
        
        button.addTarget(self,
                         action: #selector(signUpButtonTapped),
                         for: .touchUpInside)
        
        return button
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.text = Constants.messageLabelText
        return label
    }()
    
    private lazy var signInMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constants.signInButtonTitle, for: .normal)
        button.setTitleColor(Constants.signUpButtonTextColor, for: .normal)
        
        button.addTarget(self,
                         action: #selector(signInHandler),
                         for: .touchUpInside)
        return button
    }()
    
    private let viewModel: SignUpViewModel
    
    // MARK: - Lifecycle
    init(frame: CGRect, viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods
private extension SignUpView {
    
    @objc
    func signUpButtonTapped() {
        guard
            let user = userInputTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !user.isEmpty,
            let email = emailInputTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !email.isEmpty,
            let password = passwordInputTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !password.isEmpty
        else {
            return
        }
        
        viewModel.signUpUser(user, email, password)
    }
    
    @objc
    func signInHandler() {
        viewModel.didTapSignIn()
    }
    
    func createInputTextField(placeholder: String, leftImage: String) -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = placeholder
        
        let imageView = UIImageView(image: UIImage(named: leftImage))
        imageView.contentMode = .scaleAspectFit
        
        let imageContainer = UIView(frame: CGRect(x: 0, y: 0,
                                                  width: 40, height: 20))
        imageView.frame = CGRect(x: 10, y: 0,
                                 width: 20, height: 20)
        
        imageContainer.addSubview(imageView)
        
        textField.leftView = imageContainer
        textField.leftViewMode = .always
        
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 10
        textField.backgroundColor = .white
        
        return textField
    }
}

// MARK: - Setup View + Setup Constraints
private extension SignUpView {
    
    func setupView() {
        addSubview(topImageView)
        addSubview(welcomeLabel)
        addSubview(titleLabel)
        addSubview(userInputTextField)
        addSubview(emailInputTextField)
        addSubview(passwordInputTextField)
        addSubview(signUpButton)
        addSubview(messageLabel)
        addSubview(signInMessageButton)
        
        passwordInputTextField.isSecureTextEntry = true
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            topImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            topImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.topAnchor16),
            topImageView.heightAnchor.constraint(equalToConstant: 83),
            topImageView.widthAnchor.constraint(equalToConstant: 83)
        ])
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: topImageView.bottomAnchor, constant: Constants.topAnchor16),
            welcomeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.leadingAnchor),
            welcomeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Constants.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 6),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Constants.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            userInputTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 26),
            userInputTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.leadingAnchor),
            userInputTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Constants.trailingAnchor),
            userInputTextField.heightAnchor.constraint(equalToConstant: Constants.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            emailInputTextField.topAnchor.constraint(equalTo: userInputTextField.bottomAnchor, constant: Constants.topAnchor36),
            emailInputTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.leadingAnchor),
            emailInputTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Constants.trailingAnchor),
            emailInputTextField.heightAnchor.constraint(equalToConstant: Constants.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            passwordInputTextField.topAnchor.constraint(equalTo: emailInputTextField.bottomAnchor, constant: Constants.topAnchor36),
            passwordInputTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.leadingAnchor),
            passwordInputTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Constants.trailingAnchor),
            passwordInputTextField.heightAnchor.constraint(equalToConstant: Constants.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            signUpButton.topAnchor.constraint(equalTo: passwordInputTextField.bottomAnchor, constant: Constants.topAnchor36),
            signUpButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.leadingAnchor),
            signUpButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Constants.trailingAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: Constants.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -20),
            messageLabel.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: Constants.topAnchor16),
            messageLabel.trailingAnchor.constraint(equalTo: signInMessageButton.leadingAnchor, constant: -4)
        ])
        
        NSLayoutConstraint.activate([
            signInMessageButton.centerYAnchor.constraint(equalTo: messageLabel.centerYAnchor),
        ])
    }
}

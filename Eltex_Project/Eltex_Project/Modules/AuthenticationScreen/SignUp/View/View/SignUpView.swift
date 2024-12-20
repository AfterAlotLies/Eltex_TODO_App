//
//  SignUpView.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 20.12.2024.
//

import UIKit

final class SignUpView: UIView {
    
    private enum Constants {
        static let signInButtonColor: UIColor = UIColor(red: 14.0 / 255.0,
                                                        green: 165.0 / 255.0,
                                                        blue: 233.0 / 255.0,
                                                        alpha: 1)
        static let signUpButtonTextColor: UIColor = UIColor(red: 99.0 / 255.0,
                                                            green: 217.0 / 255.0,
                                                            blue: 243.0 / 255.0,
                                                            alpha: 1)
    }
    
    private lazy var topImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "authTopImage")
        return imageView
    }()
    
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Welcome to DO IT"
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = "Create an account and Join us now!"
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
        
        button.setTitle("Sign up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.cornerRadius = 10
        
        button.backgroundColor = Constants.signInButtonColor
        
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Already have an account?"
        return label
    }()
    
    private lazy var signInMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign in", for: .normal)
        button.setTitleColor(Constants.signUpButtonTextColor, for: .normal)
        button.addTarget(self, action: #selector(signInHandler), for: .touchUpInside)
        return button
    }()
    
    private let viewModel: SignUpViewModel
    
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

private extension SignUpView {
    
    @objc
    func signUpButtonTapped() {
        guard
            let user = userInputTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !user.isEmpty,
            let email = emailInputTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !email.isEmpty,
            let password = passwordInputTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !password.isEmpty
        else {
            print("Email or password is invalid")
            return
        }
        
        // Действия, если проверка пройдена
        print("Email: \(email), Password: \(password)")
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
        
        let imageContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        imageView.frame = CGRect(x: 10, y: 0, width: 20, height: 20)
        imageContainer.addSubview(imageView)
        
        textField.leftView = imageContainer
        textField.leftViewMode = .always
        
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 10
        textField.backgroundColor = .white
        
        return textField
    }
    
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
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            topImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            topImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            topImageView.heightAnchor.constraint(equalToConstant: 83),
            topImageView.widthAnchor.constraint(equalToConstant: 83)
        ])
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: topImageView.bottomAnchor, constant: 16),
            welcomeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            welcomeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 6),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            userInputTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 26),
            userInputTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            userInputTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            userInputTextField.heightAnchor.constraint(equalToConstant: 42)
        ])
        
        NSLayoutConstraint.activate([
            emailInputTextField.topAnchor.constraint(equalTo: userInputTextField.bottomAnchor, constant: 36),
            emailInputTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            emailInputTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            emailInputTextField.heightAnchor.constraint(equalToConstant: 42)
        ])
        
        NSLayoutConstraint.activate([
            passwordInputTextField.topAnchor.constraint(equalTo: emailInputTextField.bottomAnchor, constant: 36),
            passwordInputTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            passwordInputTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            passwordInputTextField.heightAnchor.constraint(equalToConstant: 42)
        ])
        
        NSLayoutConstraint.activate([
            signUpButton.topAnchor.constraint(equalTo: passwordInputTextField.bottomAnchor, constant: 36),
            signUpButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            signUpButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            signUpButton.heightAnchor.constraint(equalToConstant: 42)
        ])
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -20),
            messageLabel.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: signInMessageButton.leadingAnchor, constant: -4)
        ])
        
        NSLayoutConstraint.activate([
            signInMessageButton.centerYAnchor.constraint(equalTo: messageLabel.centerYAnchor),
        ])
    }
}

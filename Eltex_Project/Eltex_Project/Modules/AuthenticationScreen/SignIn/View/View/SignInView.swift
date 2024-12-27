//
//  SignInView.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 19.12.2024.
//

import UIKit

// MARK: - SignInView
final class SignInView: UIView {
    
    private enum Constants {
        static let signInButtonColor: UIColor = UIColor(red: 14/255,
                                                        green: 165/255,
                                                        blue: 233/255,
                                                        alpha: 1)
        static let signUpButtonTextColor: UIColor = UIColor(red: 99/255,
                                                            green: 217/255,
                                                            blue: 243/255,
                                                            alpha: 1)
        static let topImage = UIImage(named: "authTopImage")
        static let welcomeBackTitle = "Welcome back to DO IT"
        static let titleLabelText = "Have an other productive day !"
        static let signInButtonTitle = "Sign In"
        static let signUpButtonTitle = "Sign Up"
        static let messageLabelText = "Don't have an account?"
        static let leadingAnchor: CGFloat = 16
        static let trailingAnchor: CGFloat = -16
        static let heightAnchor: CGFloat = 42
        static let topAnchor: CGFloat = 16
    }
    
    private lazy var topImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Constants.topImage
        return imageView
    }()
    
    private lazy var welcomeBackLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.welcomeBackTitle
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
    
    private lazy var emailInputTextField: UITextField = createInputTextField(placeholder: "E-mail",
                                                                             leftImage: "emailImage")
    private lazy var passwordInputTextField: UITextField = createInputTextField(placeholder: "Password",
                                                                                leftImage: "passwordImage")
    
    private lazy var signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle(Constants.signInButtonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.cornerRadius = 10
        
        button.addTarget(self,
                         action: #selector(signInButtonTapped),
                         for: .touchUpInside)
        
        button.backgroundColor = Constants.signInButtonColor
        
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
    
    private lazy var signUpMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constants.signUpButtonTitle, for: .normal)
        button.setTitleColor(Constants.signUpButtonTextColor, for: .normal)
        
        button.addTarget(self,
                         action: #selector(signUpHandler),
                         for: .touchUpInside)
        return button
    }()
    
    private let viewModel: SignInViewModel
    
    // MARK: - Lifecycle
    init(frame: CGRect, viewModel: SignInViewModel) {
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
private extension SignInView {
    
    @objc
    func signInButtonTapped() {
        guard
            let email = emailInputTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !email.isEmpty,
            let password = passwordInputTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !password.isEmpty
        else {
            return
        }
        
        viewModel.signInUser(email: email, password: password)
    }
    
    @objc
    func signUpHandler() {
        viewModel.didTapSignUp()
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
private extension SignInView {
    
    func setupView() {
        addSubview(topImageView)
        addSubview(welcomeBackLabel)
        addSubview(titleLabel)
        addSubview(emailInputTextField)
        addSubview(passwordInputTextField)
        addSubview(signInButton)
        addSubview(messageLabel)
        addSubview(signUpMessageButton)
        
        passwordInputTextField.isSecureTextEntry = true
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            topImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            topImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.topAnchor),
            topImageView.heightAnchor.constraint(equalToConstant: 83),
            topImageView.widthAnchor.constraint(equalToConstant: 83)
        ])
        
        NSLayoutConstraint.activate([
            welcomeBackLabel.topAnchor.constraint(equalTo: topImageView.bottomAnchor, constant: Constants.topAnchor),
            welcomeBackLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.leadingAnchor),
            welcomeBackLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Constants.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: welcomeBackLabel.bottomAnchor, constant: 6),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Constants.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            emailInputTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 26),
            emailInputTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.leadingAnchor),
            emailInputTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Constants.trailingAnchor),
            emailInputTextField.heightAnchor.constraint(equalToConstant: Constants.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            passwordInputTextField.topAnchor.constraint(equalTo: emailInputTextField.bottomAnchor, constant: 36),
            passwordInputTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.leadingAnchor),
            passwordInputTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Constants.trailingAnchor),
            passwordInputTextField.heightAnchor.constraint(equalToConstant: Constants.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            signInButton.topAnchor.constraint(equalTo: passwordInputTextField.bottomAnchor, constant: 36),
            signInButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.leadingAnchor),
            signInButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Constants.trailingAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: Constants.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -20),
            messageLabel.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: Constants.topAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: signUpMessageButton.leadingAnchor, constant: -4)
        ])
        
        NSLayoutConstraint.activate([
            signUpMessageButton.centerYAnchor.constraint(equalTo: messageLabel.centerYAnchor),
        ])
    }
}

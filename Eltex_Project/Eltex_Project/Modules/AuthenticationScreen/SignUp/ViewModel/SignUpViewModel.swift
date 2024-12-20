//
//  SignUpViewModel.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 20.12.2024.
//

import Combine

final class SignUpViewModel {
    
    @Published private(set) var errorMessage = ""
    
    private let userService: RegistrationProtocol
    private var subscriptions: Set<AnyCancellable> = []
    
    let signInAction = PassthroughSubject<Void, Never>()
    
    init(userService: RegistrationProtocol) {
        self.userService = userService
        setupBindings()
    }
    
    func didTapSignIn() {
        signInAction.send()
    }
    
    func signUpUser(_ userName: String, _ email: String, _ password: String) {
        guard UserInputValidator.validateName(userName) else {
            errorMessage = "User name is not valid"
            return
        }
        
        guard UserInputValidator.validateEmail(email) else {
            errorMessage = "Email is not valid"
            return
        }
        
        guard UserInputValidator.validatePassword(password) else {
            errorMessage = "Password is not valid"
            return
        }
        
        userService.addUserToDataBase(userName: userName, userEmail: email, userPassword: password)
    }
    
}

private extension SignUpViewModel {
    
    func setupBindings() {
        userService.addUserStatePublisher
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .success:
                    print("User added successfully move to main screen")
                case .userAlreadyExists:
                    self.errorMessage = "User already exists"
                case .failure:
                    self.errorMessage = "Something went wrong"
                case .none:
                    break
                }
            }
            .store(in: &subscriptions)
    }
}

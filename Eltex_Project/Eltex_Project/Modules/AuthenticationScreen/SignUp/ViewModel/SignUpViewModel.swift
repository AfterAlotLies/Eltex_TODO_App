//
//  SignUpViewModel.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 20.12.2024.
//

import Combine
import Foundation

final class SignUpViewModel {
    
    @Published private(set) var errorMessage = ""
    
    private let userService: RegistrationProtocol
    private var subscriptions: Set<AnyCancellable> = []
    private var cancellables: AnyCancellable?
    
    let showSignInScreenAction = PassthroughSubject<Void, Never>()
    let signUpSucceededAction = PassthroughSubject<UserInfo, Never>()
    
    init(userService: RegistrationProtocol) {
        self.userService = userService
    }
    
    func didTapSignIn() {
        showSignInScreenAction.send()
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
        
        cancellables = userService.addUserToDataBase(userName: userName, userEmail: email, userPassword: password)
            .sink(receiveCompletion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .finished:
                    print()
                case .failure(let error):
                    if let error = error as? UserRegistrationResult {
                        switch error {
                        case .userAlreadyExists:
                            self.errorMessage = "User already exists"
                        }
                    } else {
                        self.errorMessage = error.localizedDescription
                    }
                }
            }, receiveValue: { [weak self] userInfo in
                guard let self = self else { return }
                self.signUpSucceededAction.send(userInfo)
            })
    }
    
}

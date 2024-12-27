//
//  SignInViewModel.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 19.12.2024.
//

import Combine
import Foundation

final class SignInViewModel {
    
    @Published private(set) var errorMessage: String = ""
    
    private let userService: LoginProtocol
    private var cancellable: AnyCancellable?
    
    let showSignUpScreenAction = PassthroughSubject<Void, Never>()
    let signInSucceededAction = PassthroughSubject<UserInfo, Never>()

    
    init(userService: LoginProtocol) {
        self.userService = userService
    }
    
    func didTapSignUp() {
        showSignUpScreenAction.send()
    }
    
    func signInUser(email: String, password: String) {
        cancellable = userService.authenticateUser(email: email, password: password)
            .sink { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    if let error = error as? UserAuthorizationResult {
                        switch error {
                        case .invalidPassword:
                            self.errorMessage = "Incorrect password"
                        case .invalidUser:
                            self.errorMessage = "User doesn't exist"
                        }
                    } else {
                        self.errorMessage = error.localizedDescription
                    }
                }
            } receiveValue: { [weak self] userInfo in
                guard let self = self else { return }
                self.signInSucceededAction.send(userInfo)
            }
    }
    
}

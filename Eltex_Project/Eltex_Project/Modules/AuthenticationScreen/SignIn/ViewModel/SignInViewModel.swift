//
//  SignInViewModel.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 19.12.2024.
//

import Combine

final class SignInViewModel {
    
    @Published private(set) var errorMessage: String = ""
    
    private let userService: LoginProtocol
    private var cancellable: AnyCancellable?
    
    let signUpAction = PassthroughSubject<Void, Never>()

    
    init(userService: LoginProtocol) {
        self.userService = userService
    }
    
    func didTapSignUp() {
        signUpAction.send()
    }
    
    func signInUser(email: String, password: String) {
        cancellable = userService.authenticateUser(email: email, password: password)
            .sink { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .finished:
                    print("successed")
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
            } receiveValue: { (email, name, id) in
                print("email: \(email), name: \(name), id: \(id)")
            }

    }
    
}

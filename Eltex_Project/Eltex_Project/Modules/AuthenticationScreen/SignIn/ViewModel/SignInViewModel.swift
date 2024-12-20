//
//  SignInViewModel.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 19.12.2024.
//

import Combine

final class SignInViewModel {
    let signUpAction = PassthroughSubject<Void, Never>()
    
    func didTapSignUp() {
        signUpAction.send()
    }
    
    func signInUser() {
        
    }
    
}

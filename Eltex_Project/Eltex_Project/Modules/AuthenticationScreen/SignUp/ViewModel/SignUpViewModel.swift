//
//  SignUpViewModel.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 20.12.2024.
//

import Combine

final class SignUpViewModel {
    let signInAction = PassthroughSubject<Void, Never>()
    
    func didTapSignIn() {
        signInAction.send()
    }
    
    func signUpUser(_ userName: String, _ email: String, _ password: String) {
        
    }
}

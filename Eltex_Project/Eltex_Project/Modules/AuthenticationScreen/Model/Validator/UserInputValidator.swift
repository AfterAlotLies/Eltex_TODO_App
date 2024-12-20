//
//  UserInputValidator.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 21.12.2024.
//

import Foundation

struct UserInputValidator {
    static func validateName(_ name: String) -> Bool {
        let nameRegex = "^[a-zA-Zа-яА-Я ]+$"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        return namePredicate.evaluate(with: name)
    }

    static func validateEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    static func validatePassword(_ password: String) -> Bool {
        return password.count >= 6
    }
}

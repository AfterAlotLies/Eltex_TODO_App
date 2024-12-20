//
//  RegistrationProtocol.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 21.12.2024.
//

import Combine

protocol RegistrationProtocol {
    var addUserStatePublisher: Published<UserRegistrationResult>.Publisher { get }
    func addUserToDataBase(userName: String, userEmail: String, userPassword: String)
    func fetchAllUsers()
    func deleteAllUsers() 
}

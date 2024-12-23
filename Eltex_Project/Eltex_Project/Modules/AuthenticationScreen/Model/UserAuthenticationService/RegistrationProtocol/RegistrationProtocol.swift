//
//  RegistrationProtocol.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 21.12.2024.
//

import Combine
import Foundation

protocol RegistrationProtocol {
    func addUserToDataBase(userName: String, userEmail: String, userPassword: String) -> AnyPublisher<UserInfo, Error>
    func deleteAllUsers()
    func fetchAllUsers()
}

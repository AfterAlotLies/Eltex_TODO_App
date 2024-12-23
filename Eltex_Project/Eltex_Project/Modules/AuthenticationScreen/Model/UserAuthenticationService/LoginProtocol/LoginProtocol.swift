//
//  LoginProtocol.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 21.12.2024.
//

import Combine
import Foundation

protocol LoginProtocol {
    func authenticateUser(email: String, password: String) -> AnyPublisher<UserInfo, Error>
}

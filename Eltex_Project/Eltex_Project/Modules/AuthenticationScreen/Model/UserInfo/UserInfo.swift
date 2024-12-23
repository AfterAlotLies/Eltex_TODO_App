//
//  UserInfo.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 23.12.2024.
//

import Foundation

struct UserInfo: Codable {
    let name: String
    let email: String
    let id: UUID?
}

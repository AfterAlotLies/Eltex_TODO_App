//
//  UserAuthenticationService.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 20.12.2024.
//

import CoreData
import Foundation
import Combine

enum UserRegistrationResult {
    case success
    case userAlreadyExists
    case failure
    case none
}

enum UserAuthorizationResult: Error {
    case invalidPassword 
    case invalidUser
    
    var description: String? {
        switch self {
        case .invalidPassword: 
            return "Invalid password"
        case .invalidUser: 
            return "Invalid user"
        }
    }
}

// MARK: - UserAuthenticationService class
final class UserAuthenticationService {
    
    @Published private var registrationUserResult: UserRegistrationResult = .none
    
    private let entityName: String = "UserEntity"
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Eltex_Project")
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    func fetchAllUsers() {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        
        do {
            let users = try context.fetch(fetchRequest)
            for user in users {
                print("User ID: \(user.id?.uuidString ?? "No ID")")
                print("Name: \(user.name ?? "No Name")")
                print("Email: \(user.email ?? "No Email")")
            }
        } catch {
            print("Failed to fetch users: \(error)")
        }
    }
    
    func deleteAllUsers() {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = UserEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            print("All users deleted successfully")
        } catch {
            print("Failed to delete all users: \(error)")
        }
    }
    
}

// MARK: - UserAuthenticationService + RegistrationProtocol
extension UserAuthenticationService: RegistrationProtocol {
    
    var addUserStatePublisher: Published<UserRegistrationResult>.Publisher {
        $registrationUserResult
    }
    
    func addUserToDataBase(userName: String, userEmail: String, userPassword: String) {
        let context = persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", userEmail)
        
        do {
            let existingUsers = try context.fetch(fetchRequest)
            
            if !existingUsers.isEmpty {
                print("User with this email already exists")
                registrationUserResult = .userAlreadyExists
                return
            }
        } catch {
            print("Failed to check for existing user: \(error)")
            registrationUserResult = .failure
            return
        }
        
        let userEntity = UserEntity(context: context)
        userEntity.id = UUID()
        userEntity.name = userName
        userEntity.email = userEmail
        userEntity.password = userPassword
        
        if context.hasChanges {
            do {
                try context.save()
                print("saved success")
                registrationUserResult = .success
            } catch {
                print("failed to save: \(error)")
                registrationUserResult = .failure
            }
        }
    }
    
}

// MARK: - UserAuthenticationService + LoginProtocol
extension UserAuthenticationService: LoginProtocol {
    
    func authenticateUser(email: String, password: String) -> AnyPublisher<(String, String, UUID?), Error> {
        let context = persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        
        return Future<(String, String, UUID?), Error> { promise in
            do {
                let users = try context.fetch(fetchRequest)
                
                if let user = users.first {
                    if user.password == password {
                        promise(.success((user.email ?? "No email", user.name ?? "No name", user.id)))
                    } else {
                        print("invalid password")
                        promise(.failure(UserAuthorizationResult.invalidPassword))
                    }
                } else {
                    print("invalid user")
                    promise(.failure(UserAuthorizationResult.invalidUser))
                }
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}

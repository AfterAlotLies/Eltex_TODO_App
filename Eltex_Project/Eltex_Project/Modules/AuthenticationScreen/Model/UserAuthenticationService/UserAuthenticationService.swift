//
//  UserAuthenticationService.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 20.12.2024.
//

import CoreData
import Combine

// MARK: - Error Enums
enum UserRegistrationResult: Error {
    case userAlreadyExists
}

enum UserAuthorizationResult: Error {
    case invalidPassword 
    case invalidUser
}

// MARK: - UserAuthenticationService class
final class UserAuthenticationService {
    
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
    
    func addUserToDataBase(userName: String, userEmail: String, userPassword: String) -> AnyPublisher<UserInfo, Error> {
        let context = persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", userEmail)
        
        return Future<UserInfo, Error> { promise in
            do {
                let existingUsers = try context.fetch(fetchRequest)
                
                if let _ = existingUsers.first {
                    print("User with this email already exists")
                    promise(.failure(UserRegistrationResult.userAlreadyExists))
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
                        print("User saved successfully")
                        promise(.success(UserInfo(name: userEntity.name ?? "No name",
                                                  email: userEntity.email ?? "No email",
                                                  id: userEntity.id)))
                    } catch {
                        print("Failed to save user: \(error)")
                        promise(.failure(error))
                    }
                }
            } catch {
                print("Failed to check for existing user: \(error)")
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
}

// MARK: - UserAuthenticationService + LoginProtocol
extension UserAuthenticationService: LoginProtocol {
    
    func authenticateUser(email: String, password: String) -> AnyPublisher<UserInfo, Error> {
        let context = persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        
        return Future<UserInfo, Error> { promise in
            do {
                let users = try context.fetch(fetchRequest)
                
                if let user = users.first {
                    if user.password == password {
                        promise(.success(UserInfo(name: user.name ?? "No name",
                                                  email: user.email ?? "No email",
                                                  id: user.id)))
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

//
//  UserCacheService.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 23.12.2024.
//

import Foundation

final class UserCacheService {
    static let shared = UserCacheService()
    
    private let cache = NSCache<NSString, UserInfoWrapper>()
    private let fileManager = FileManager.default
    private let fileName = "authenticatedUser.json"
    
    private lazy var filePath: URL = {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
    }()
    
    private init() {
        loadUserFromDisk()
    }
    
    func saveUser(_ user: UserInfo) {
        let wrapper = UserInfoWrapper(userInfo: user)
        cache.setObject(wrapper, forKey: "authenticatedUser")
        saveUserToDisk(user)
    }
    
    func getUser() -> UserInfo? {
        if let wrapper = cache.object(forKey: "authenticatedUser") {
            return wrapper.userInfo
        }
        return nil
    }
    
    func clearUser() {
        cache.removeObject(forKey: "authenticatedUser")
        try? fileManager.removeItem(at: filePath)
    }
    
}

private extension UserCacheService {
    
    func loadUserFromDisk() {
        guard fileManager.fileExists(atPath: filePath.path) else { return }
        
        do {
            let data = try Data(contentsOf: filePath)
            let user = try JSONDecoder().decode(UserInfo.self, from: data)
            let wrapper = UserInfoWrapper(userInfo: user)
            cache.setObject(wrapper, forKey: "authenticatedUser")
        } catch {
            fatalError("Failed to load user from disk: \(error)")
        }
    }
    
    func saveUserToDisk(_ user: UserInfo) {
        do {
            let data = try JSONEncoder().encode(user)
            try data.write(to: filePath, options: .atomic)
        } catch {
            fatalError("Failed to save user to disk: \(error)")
        }
    }
}

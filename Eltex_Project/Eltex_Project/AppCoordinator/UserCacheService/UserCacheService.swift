//
//  UserCacheService.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 23.12.2024.
//

import Foundation

// MARK: - UserCacheService
final class UserCacheService {
    
    private enum Constants {
        static let fileName = "authenticatedUser.json"
        static let cacheKey: NSString = "authenticatedUser"
    }
    
    static let shared = UserCacheService()
    
    private let cache = NSCache<NSString, UserInfoWrapper>()
    private let fileManager = FileManager.default
    private let fileName = Constants.fileName
    
    private lazy var filePath: URL = {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
    }()
    
    private init() {
        loadUserFromDisk()
    }
    
    func saveUser(_ user: UserInfo) {
        let wrapper = UserInfoWrapper(userInfo: user)
        cache.setObject(wrapper, forKey: Constants.cacheKey)
        saveUserToDisk(user)
    }
    
    func getUser() -> UserInfo? {
        if let wrapper = cache.object(forKey: Constants.cacheKey) {
            return wrapper.userInfo
        }
        return nil
    }
    
    func clearUser() {
        cache.removeObject(forKey: Constants.cacheKey)
        try? fileManager.removeItem(at: filePath)
    }
    
}

// MARK: - Private methods
private extension UserCacheService {
    
    func loadUserFromDisk() {
        guard fileManager.fileExists(atPath: filePath.path) else { return }
        
        do {
            let data = try Data(contentsOf: filePath)
            let user = try JSONDecoder().decode(UserInfo.self, from: data)
            let wrapper = UserInfoWrapper(userInfo: user)
            cache.setObject(wrapper, forKey: Constants.cacheKey)
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

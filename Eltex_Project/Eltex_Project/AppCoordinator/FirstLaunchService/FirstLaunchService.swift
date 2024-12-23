//
//  FirstLaunchService.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 20.12.2024.
//

import Foundation

final class FirstLaunchService {
    static let shared = FirstLaunchService()
    
    private init() {}
    
    private var isFirstTimeLaunch: Bool {
        if UserDefaults.standard.object(forKey: "firstLaunch") == nil {
            return true
        }
        return UserDefaults.standard.bool(forKey: "firstLaunch")
    }
    
    func setFirstLaunch() {
        UserDefaults.standard.setValue(false, forKey: "firstLaunch")
        UserDefaults.standard.synchronize()
    }
    
    func getIsFirstTimeLaunch() -> Bool {
        return isFirstTimeLaunch
    }
}

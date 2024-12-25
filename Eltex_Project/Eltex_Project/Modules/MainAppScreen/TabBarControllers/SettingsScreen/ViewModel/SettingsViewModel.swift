//
//  SettingsViewModel.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 25.12.2024.
//

import Combine

final class SettingsViewModel {
    @Published private(set) var settingsData: [Settings] = []
    
    let logOutAction = PassthroughSubject<Void, Never>()
    
    init() {
        setSettingsData()
    }
    
    func logOut() {
        logOutAction.send()
    }
}

private extension SettingsViewModel {
    
    func setSettingsData() {
        settingsData = [
            Settings(image: "profileImage",
                     title: "Profile"),
            Settings(image: "conversationImage",
                     title: "Conversations"),
            Settings(image: "projectImage",
                     title: "Projects"),
            Settings(image: "termsImage",
                     title: "Terms and Policies")
        ]
    }
}

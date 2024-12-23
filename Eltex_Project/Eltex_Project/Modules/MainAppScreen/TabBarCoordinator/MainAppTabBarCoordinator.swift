//
//  MainAppTabBarCoordinator.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 20.12.2024.
//

import UIKit

enum TabBarPages: CaseIterable {
    case home
    case notesList
    case calendar
    case settings
    
    var itemIcon: UIImage? {
        switch self {
        case .home:
            return UIImage(named: "homeScreen")
        case .notesList:
            return UIImage(named: "notesListScreen")
        case .calendar:
            return UIImage(named: "calendarScreen")
        case .settings:
            return UIImage(named: "settingsScreen")
        }
    }
}

protocol MainAppTabBarCoordinatorProtocol {
    func setupScreenCoordinator(_ page: TabBarPages) -> UINavigationController
}

final class MainAppTabBarCoordinator: Coordinator {
    
    var type: CoordinatorType { .tabbar }
    
    var childrenCoordinator: [Coordinator] = []
    var navigationController: UINavigationController
    var tabBarController: UITabBarController
    
    var userInfo: UserInfo
    
    init(navigationController: UINavigationController, userInfo: UserInfo) {
        self.navigationController = navigationController
        self.userInfo = userInfo
        self.tabBarController = UITabBarController()
    }
    
    func start() {
        print("tab bar started")
        let pages: [TabBarPages] = TabBarPages.allCases
        let viewController = pages.map { setupScreenCoordinator($0) }
        
        tabBarController.viewControllers = viewController
        tabBarController.selectedIndex = 0

        navigationController.setViewControllers([tabBarController], animated: false)
    }
}

extension MainAppTabBarCoordinator: MainAppTabBarCoordinatorProtocol {
    
    func setupScreenCoordinator(_ page: TabBarPages) -> UINavigationController {
        let childNavigationController = UINavigationController()
        childNavigationController.isNavigationBarHidden = true
        
        switch page {
        case .home:
            let homeCoordinator = HomeCoordinator(navigationController: childNavigationController, userInfo: userInfo)
            childrenCoordinator.append(homeCoordinator)
            homeCoordinator.start()
            
        case .notesList:
            let notesListCoordinator = NotesListCoordinator(navigationController: childNavigationController)
            childrenCoordinator.append(notesListCoordinator)
            notesListCoordinator.start()
            
        case .calendar:
            let calendarCoordinator = CalendarCoordinator(navigationController: childNavigationController)
            childrenCoordinator.append(calendarCoordinator)
            calendarCoordinator.start()
            
        case .settings:
            let settingsCoordinator = SettingsCoordinator(navigationController: childNavigationController)
            childrenCoordinator.append(settingsCoordinator)
            settingsCoordinator.start()
        }
        
        childNavigationController.tabBarItem = UITabBarItem(
            title: "",
            image: page.itemIcon,
            selectedImage: page.itemIcon
        )
        
        return childNavigationController
    }
}

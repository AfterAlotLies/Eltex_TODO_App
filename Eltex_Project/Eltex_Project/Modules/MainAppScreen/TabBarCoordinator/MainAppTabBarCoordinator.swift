//
//  MainAppTabBarCoordinator.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 20.12.2024.
//

import UIKit
import Combine

// MARK: - TabBarPages
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

// MARK: - MainAppTabBarCoordinatorProtocol
protocol MainAppTabBarCoordinatorProtocol {
    func setupScreenCoordinator(_ page: TabBarPages) -> UINavigationController
}

// MARK: - MainAppTabBarCoordinator + Coordinator
final class MainAppTabBarCoordinator: Coordinator {
    
    var type: CoordinatorType { .tabbar }
    
    var childrenCoordinator: [Coordinator] = []
    var navigationController: UINavigationController
    
    private var tabBarController: UITabBarController
    private var subscriptions: Set<AnyCancellable> = []
    private let userInfo: UserInfo
    private let notesRepository: NotesRepository
    
    let coordinatorDidFinish = PassthroughSubject<Void, Never>()
    
    init(navigationController: UINavigationController, userInfo: UserInfo) {
        self.navigationController = navigationController
        self.userInfo = userInfo
        self.tabBarController = UITabBarController()
        self.notesRepository = NotesRepository(userInfo: self.userInfo)
    }
    
    // MARK: - Start
    func start() {
        let pages: [TabBarPages] = TabBarPages.allCases
        
        let viewController = pages.map { setupScreenCoordinator($0) }
        
        tabBarController.viewControllers = viewController
        tabBarController.selectedIndex = 0
        tabBarController.view.backgroundColor = .clear
        tabBarController.tabBar.isTranslucent = false
        
        navigationController.isNavigationBarHidden = true
        navigationController.setViewControllers([tabBarController], animated: true)
    }
    
    deinit {
        print("tabbar deinited coorditanor")
    }
}

// MARK: - MainAppTabBarCoordinator + MainAppTabBarCoordinatorProtocol
extension MainAppTabBarCoordinator: MainAppTabBarCoordinatorProtocol {
    
    func setupScreenCoordinator(_ page: TabBarPages) -> UINavigationController {
        let childNavigationController = UINavigationController()
        childNavigationController.isNavigationBarHidden = true
        childNavigationController.view.applyGradientBackground(colors: [AppBackgroundColors.topColor, AppBackgroundColors.bottomColor])
        
        childNavigationController.tabBarItem = UITabBarItem(
            title: "",
            image: page.itemIcon,
            selectedImage: page.itemIcon
        )
        
        switch page {
        case .home:
            let homeCoordinator = HomeCoordinator(navigationController: childNavigationController,
                                                  userInfo: userInfo,
                                                  notesRepository: notesRepository)
            childrenCoordinator.append(homeCoordinator)
            homeCoordinator.start()
            return homeCoordinator.navigationController
            
        case .notesList:
            let notesListCoordinator = NotesListCoordinator(navigationController: childNavigationController,
                                                            notesRepository: notesRepository)
            childrenCoordinator.append(notesListCoordinator)
            notesListCoordinator.start()
            return notesListCoordinator.navigationController
            
        case .calendar:
            let calendarCoordinator = CalendarCoordinator(navigationController: childNavigationController)
            childrenCoordinator.append(calendarCoordinator)
            calendarCoordinator.start()
            return calendarCoordinator.navigationController
            
        case .settings:
            let settingsCoordinator = SettingsCoordinator(navigationController: childNavigationController)
            
            settingsCoordinator.coordinatorDidFinished
                .sink { [weak self] _ in
                    guard let self = self else { return }
                    self.coordinatorDidFinish.send()
                    self.childrenCoordinator.removeAll()
                    self.cancelSubscriptions()
                }
                .store(in: &subscriptions)
            
            childrenCoordinator.append(settingsCoordinator)
            settingsCoordinator.start()
            return settingsCoordinator.navigationController
        }
    }
    
}

private extension MainAppTabBarCoordinator {
    
    func cancelSubscriptions() {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }
}

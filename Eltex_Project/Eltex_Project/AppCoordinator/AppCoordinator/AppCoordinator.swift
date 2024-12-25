//
//  AppCoordinator.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 19.12.2024.
//

import UIKit
import Combine

// MARK: - AppCoordinatorProtocol
protocol AppCoordinatorProtocol {
    func showOnBoardingScreen()
    func showAuthScreen()
    func setupTabBarCoordinator(_ userInfo: UserInfo)
}

// MARK: - AppCoordinatorFinishProtocol
protocol AppCoordinatorFinishProtocol {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}

// MARK: - AppCoordinator + Coordinator
final class AppCoordinator: Coordinator {
    
    var childrenCoordinator: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    var type: CoordinatorType { .app }
    
    private var firstLaunchService: FirstLaunchService?
    
    private var subscriptions: Set<AnyCancellable> = []
    
    // MARK: - Start
    func start() {
        firstLaunchService = FirstLaunchService()
        setBackgroundColor()
        if firstLaunchService?.getIsFirstTimeLaunch() == true {
            showOnBoardingScreen()
        } else {
            firstLaunchService = nil
            if let userInfo = UserCacheService.shared.getUser() {
                setupTabBarCoordinator(userInfo)
            } else {
                showAuthScreen()
            }
        }
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
}

// MARK: - AppCoordinator + AppCoordinatorProtocol
extension AppCoordinator: AppCoordinatorProtocol {
    
    func showOnBoardingScreen() {
        guard let service = firstLaunchService else { return }
        let onboardingCoordinator = OnboardingCoordinator(navigationController: navigationController, firstLaunchService: service)
        
        onboardingCoordinator.coordinatorDidFinished
                .sink { [weak self, weak onboardingCoordinator] in
                    guard let self = self, let onboardingCoordinator = onboardingCoordinator else { return }
                    self.coordinatorDidFinish(childCoordinator: onboardingCoordinator)
                    self.showAuthScreen()
                }
                .store(in: &subscriptions)
        
        childrenCoordinator.append(onboardingCoordinator)
        onboardingCoordinator.start()
    }
    
    func showAuthScreen() {
        let authCoordinator = AuthCoordinator(navigationController: navigationController)
        
        authCoordinator.coordinatorDidFinished
            .sink { [weak self, weak authCoordinator] userInfo in
                guard let self = self, let authCoordinator = authCoordinator else { return }
                self.coordinatorDidFinish(childCoordinator: authCoordinator)
                UserCacheService.shared.saveUser(userInfo)
                self.setupTabBarCoordinator(userInfo)
            }
            .store(in: &subscriptions)
        
        childrenCoordinator.append(authCoordinator)
        navigationController.setViewControllers([], animated: false)
        authCoordinator.start()
    }
    
    func setupTabBarCoordinator(_ userInfo: UserInfo) {
        let coordinator = MainAppTabBarCoordinator(navigationController: navigationController, userInfo: userInfo)
        
        coordinator.coordinatorDidFinish
            .sink { [weak self, weak coordinator] _ in
                guard let self = self,
                      let coordinator = coordinator else { return }
                UserCacheService.shared.clearUser()
                self.coordinatorDidFinish(childCoordinator: coordinator)
                self.showAuthScreen()
            }
            .store(in: &subscriptions)
        
        childrenCoordinator.append(coordinator)
        navigationController.setViewControllers([], animated: false)
        coordinator.start()
    }
}

// MARK: - AppCoordinator + AppCoordinatorFinishProtocol
extension AppCoordinator: AppCoordinatorFinishProtocol {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childrenCoordinator = childrenCoordinator.filter { $0.type != childCoordinator.type }
    }
}

// MARK: - AppCoordinator + Private methods
private extension AppCoordinator {
    
    func setBackgroundColor() {
        guard let rootView = navigationController.view else { return }
        rootView.applyGradientBackground(colors: [AppBackgroundColors.topColor, AppBackgroundColors.bottomColor])
    }
}

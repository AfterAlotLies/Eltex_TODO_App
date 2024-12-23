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
    
    private var isFirstTime: Bool = FirstLaunchService.shared.getIsFirstTimeLaunch()
    private var isUserAuthenticated: Bool = false // Заглушка - построить сервис
    private var subscriptions: Set<AnyCancellable> = []
    
    func start() {
        setBackgroundColor()
        if isFirstTime {
            showOnBoardingScreen()
        } else {
            if isUserAuthenticated {
                setupTabBarCoordinator(<#T##userInfo: UserInfo##UserInfo#>)
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
        let onboardingCoordinator = OnboardingCoordinator(navigationController: navigationController)
        
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
                self.setupTabBarCoordinator(userInfo)
            }
            .store(in: &subscriptions)
        
        childrenCoordinator.append(authCoordinator)
        navigationController.setViewControllers([], animated: false)
        authCoordinator.start()
    }
    
    func setupTabBarCoordinator(_ userInfo: UserInfo) {
        let coordinator = MainAppTabBarCoordinator(navigationController: navigationController, userInfo: userInfo)
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

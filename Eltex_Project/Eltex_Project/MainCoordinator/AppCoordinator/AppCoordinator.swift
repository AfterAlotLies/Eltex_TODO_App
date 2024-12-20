//
//  AppCoordinator.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 19.12.2024.
//

import UIKit
import Combine

protocol AppCoordinatorProtocol {
    func showOnBoardingScreen()
    func showAuthScreen()
}

protocol AppCoordinatorFinishProtocol {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}

final class AppCoordinator: Coordinator {
    
    private enum Constants {
        static let topColor: UIColor = UIColor(red: 18.0 / 255.0, green: 83.0 / 255.0, blue: 170.0 / 255.0, alpha: 1)
        static let bottomColor: UIColor = UIColor(red: 5.0 / 255.0, green: 36.0 / 255.0, blue: 62.0 / 255.0, alpha: 1)
    }
    
    var childrenCoordinator: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    var type: CoordinatorType { .app }
    
    private var isFirstTime: Bool = FirstLaunchService.shared.getIsFirstTimeLaunch()
    private var subscriptions: Set<AnyCancellable> = []
    
    func start() {
        setBackgroundColor()
        if isFirstTime {
            showOnBoardingScreen()
        } else {
            showAuthScreen()
        }
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
}

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
        let authCoordinator: Coordinator = AuthCoordinator(navigationController: navigationController)
        
        childrenCoordinator.append(authCoordinator)
        navigationController.setViewControllers([], animated: false)
        authCoordinator.start()
    }
}

extension AppCoordinator: AppCoordinatorFinishProtocol {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childrenCoordinator = childrenCoordinator.filter { $0.type != childCoordinator.type }
    }
}

private extension AppCoordinator {
    
    func setBackgroundColor() {
        guard let rootView = navigationController.view else { return }
        rootView.applyGradientBackground(colors: [Constants.topColor, Constants.bottomColor])
    }
}

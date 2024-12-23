//
//  AuthCoordinator.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 19.12.2024.
//

import UIKit
import Combine

// MARK: - AuthCoordinatorProtocol
protocol AuthCoordinatorProtocol {
    func showSignIn()
    func showSignUp()
}

// MARK: - AuthCoordinator + Coordinator
final class AuthCoordinator: Coordinator {
    
    private var subscriptions: Set<AnyCancellable> = []
    
    let coordinatorDidFinished = PassthroughSubject<UserInfo, Never>()
    
    var childrenCoordinator: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    var type: CoordinatorType { .authentication }
    
    func start() {
        showSignIn()
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
}

// MARK: - AuthCoordinator + AuthCoordinatorProtocol
extension AuthCoordinator: AuthCoordinatorProtocol {
    
    func showSignIn() {
        let authenticationService = UserAuthenticationService()
        let viewModel = SignInViewModel(userService: authenticationService)
        
        viewModel.showSignUpScreenAction
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.showSignUp()
            }
            .store(in: &subscriptions)
        
        viewModel.signInSucceededAction
            .sink { [weak self] userInfo in
                guard let self = self else { return }
                self.coordinatorDidFinished.send(userInfo)
            }
            .store(in: &subscriptions)
        
        
        let viewController = SignInViewController(viewModel: viewModel)
        UIView.transition(with: navigationController.view, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.navigationController.setViewControllers([viewController], animated: false)
        })
    }
    
    func showSignUp() {
        let authenticationService = UserAuthenticationService()
        let viewModel = SignUpViewModel(userService: authenticationService)
        
        viewModel.showSignInScreenAction
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.showSignIn()
            }
            .store(in: &subscriptions)
        
        viewModel.signUpSucceededAction
            .sink { [weak self] userInfo in
                guard let self = self else { return }
                self.coordinatorDidFinished.send(userInfo)
            }
            .store(in: &subscriptions)
        
        let viewController = SignUpViewController(viewModel: viewModel)
        UIView.transition(with: navigationController.view, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.navigationController.setViewControllers([viewController], animated: false)
        })
    }
}

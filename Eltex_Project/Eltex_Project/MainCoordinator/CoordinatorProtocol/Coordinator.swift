//
//  Coordinator.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 18.12.2024.
//

import UIKit

protocol Coordinator {
    var childrenCoordinator: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    var type: CoordinatorType { get }
    
    func start()
}

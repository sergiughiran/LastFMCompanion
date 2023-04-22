//
//  Coordinator.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 03.06.2021.
//

import UIKit

protocol Coordinator: AnyObject {
    var presenter: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    var rootViewController: UIViewController? { get }

    func start()
    func childDidFinnish(_ child: Coordinator)
}

extension Coordinator {
    func childDidFinnish(_ child: Coordinator) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}

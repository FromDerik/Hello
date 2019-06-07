//
//  AppCoordinator.swift
//  Hello
//
//  Created by Derik Malcolm on 5/29/19.
//  Copyright © 2019 Derik Malcolm. All rights reserved.
//

import UIKit

class AuthCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    
    var navigationController: UIViewController
    
    init(navigationController: UIViewController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
    }
    
    
}

class AppCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UIViewController
    
    init(navigationController: UIViewController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
    }
    
    
}

//
//  Coordinator.swift
//  Hello
//
//  Created by Derik Malcolm on 5/29/19.
//  Copyright © 2019 Derik Malcolm. All rights reserved.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UIViewController { get set }
    
    func start()
}

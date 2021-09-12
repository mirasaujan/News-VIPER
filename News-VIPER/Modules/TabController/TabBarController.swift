//
//  TabBarController.swift
//  News-VIPER
//
//  Created by Miras Karazhigitov on 11.09.2021.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        viewControllers = [NewsListRouter.createModule(),
                           FavoritesRouter.createModule()]
    }
}

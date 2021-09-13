//
//  FavoritesRouter.swift
//  News-VIPER
//
//  Created by Miras Karazhigitov on 11.09.2021.
//

import UIKit

class FavoritesRouter: NewsListRouterProtocol {
    static func createModule() -> UIViewController {
        let vc = NewsListViewController()
        let presenter = FavoritesPresenter()
        presenter.view = vc
        let interactor = FavoritesInteractor()
        interactor.observer = presenter
        presenter.interactor = interactor
        presenter.configureView()
        
        let nc = UINavigationController(rootViewController: vc)
        nc.tabBarItem = UITabBarItem(title: "Favorites",
                                     image: UIImage(systemName: "suit.heart"),
                                     selectedImage: UIImage(systemName: "suit.heart.fill"))
        nc.restorationIdentifier = NewsListViewController.typeName
        
        presenter.router = FavoritesRouter(navigationController: nc)
        
        return nc
    }
    
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

//
//  NewsListRouter.swift
//  News-VIPER
//
//  Created by Miras Karazhigitov on 11.09.2021.
//

import UIKit

protocol NewsListRouterProtocol {
    static func createModule()-> UIViewController
    
    var navigationController: UINavigationController? { get set }
    func pushToAdDetail(_ news: News)
    func showErrorAlert(for error: Error)
}

extension NewsListRouterProtocol {
    func pushToAdDetail(_ news: News) {
        let vc = NewsDetailViewController()
        let presenter = NewsDetailPresenter()
        presenter.news = news
        presenter.view = vc
        presenter.intractor = NewsDetailInteractor()
        vc.presenter = presenter
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showErrorAlert(for error: Error) {
        let vc = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        vc.addAction(okAction)
        
        navigationController?.present(vc, animated: true, completion: nil)
    }
}

class NewsListRouter: NewsListRouterProtocol {
    static func createModule() -> UIViewController {
        let vc = NewsListViewController()
        let presenter = NewsListPresenter()
        let interactor = NewsListInteractor()
        presenter.view = vc
        presenter.configureView()
        presenter.interactor = interactor
        
        let nc = UINavigationController(rootViewController: vc)
        nc.tabBarItem = UITabBarItem(title: "News",
                                     image: UIImage(systemName: "newspaper"),
                                     selectedImage: UIImage(systemName: "newspaper.fill"))
        nc.restorationIdentifier = NewsListViewController.typeName
        
        presenter.router = NewsListRouter(navigationController: nc)
        
        return nc
    }
    
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

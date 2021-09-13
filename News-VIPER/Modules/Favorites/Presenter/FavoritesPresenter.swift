//
//  FavoritesPresenter.swift
//  News-VIPER
//
//  Created by Miras Karazhigitov on 11.09.2021.
//

import Foundation

protocol FavoritesPresenterProtocol {
    func configureView()
    func selectNews(at index: Int)
}

class FavoritesPresenter: FavoritesPresenterProtocol {
    var router: NewsListRouterProtocol!
    weak var view: NewsListViewProtocol!
    var interactor: FavoritesInteractorProtocol!
    
    func configureView() {
        view.onViewDidLoad = {
            self.view.setupTableView()
            self.loadViewModels()
        }
        
        view.onCellSelect = { [unowned self] index in
            self.selectNews(at: index)
        }
    }
    
    func loadViewModels() {
        let news = interactor.fetchNews().reversed()
        let viewModels = news.map { NewsListViewController.CellViewModel(title: $0.title,
                                                                              description: $0.description) }
        view.show(viewModels: viewModels, animated: false)
    }
    
    func selectNews(at index: Int) {
        router.pushToAdDetail(interactor.news[index])
    }
}

extension FavoritesPresenter: FavoritesInteractorObserver {
    func favoritesInteractor(_ interactor: FavoritesInteractor, changed newsList: [News]) {
        let viewModels = newsList.reversed().map { NewsListViewController.CellViewModel(title: $0.title,
                                                                             description: $0.description) }
        view.show(viewModels: viewModels, animated: false)
    }
}

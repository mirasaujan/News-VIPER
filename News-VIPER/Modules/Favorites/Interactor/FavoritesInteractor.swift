//
//  FavoritesInteractor.swift
//  News-VIPER
//
//  Created by Miras Karazhigitov on 11.09.2021.
//

import Foundation

protocol FavoritesInteractorProtocol {
    var news: [News] { get }
    
    func fetchNews(completion: @escaping ([NewsListViewController.CellViewModel]) -> Void)
}

class FavoritesInteractor: FavoritesInteractorProtocol {
    var news = [News]()
    
    private let storage = NewsListStorage()
    
    func fetchNews(completion: @escaping ([NewsListViewController.CellViewModel]) -> Void) {
        self.news = storage.fetch()
        
        completion(self.news.map { NewsListViewController.CellViewModel(title: $0.title,
                                                                        description: $0.description) })
    }
}

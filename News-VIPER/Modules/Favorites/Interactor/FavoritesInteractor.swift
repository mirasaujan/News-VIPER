//
//  FavoritesInteractor.swift
//  News-VIPER
//
//  Created by Miras Karazhigitov on 11.09.2021.
//

import Foundation

protocol FavoritesInteractorProtocol {
    var news: [News] { get }
    
    func fetchNews() -> [News]
}

protocol FavoritesInteractorObserver: AnyObject {
    func favoritesInteractor(_ interactor: FavoritesInteractor, changed newsList: [News])
}

class FavoritesInteractor: FavoritesInteractorProtocol {
    weak var observer: FavoritesInteractorObserver?
    var news = [News]()
    
    private let storage = NewsListStorage()
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateList), name: NewsListStorage.newsListChangedNotificationName, object: storage)
    }
    
    @objc private func updateList(_ notification: Notification) {
        observer?.favoritesInteractor(self, changed: fetchNews())
    }
    
    func fetchNews() -> [News] {
        self.news = storage.fetch()
        
        return self.news
    }
}

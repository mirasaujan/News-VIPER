//
//  NewsDetailInteractor.swift
//  News-VIPER
//
//  Created by Miras Karazhigitov on 12.09.2021.
//

import Foundation

protocol NewsDetailInteractorProtocol {
    func save(_ news: News)
}

class NewsDetailInteractor: NewsDetailInteractorProtocol {
    let storage = NewsListStorage()
    
    func save(_ news: News) {
        storage.add(news: news)
    }
}

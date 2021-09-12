//
//  NewsListInteractor.swift
//  News-VIPER
//
//  Created by Miras Karazhigitov on 11.09.2021.
//

import Foundation

protocol NewsListInteractorProtocol {
    var news: [News] { get }
    func fetchTopHeadlinesNews(page: Int, completion: @escaping ([NewsListViewController.CellViewModel], Error?) -> Void)
    func fetchEverythingNews(page: Int, completion: @escaping ([NewsListViewController.CellViewModel], Error?) -> Void)
}

class NewsListInteractor: NewsListInteractorProtocol {
    var news = [News]()
    
    private let service = NewsService()
    
    func fetchTopHeadlinesNews(page: Int, completion: @escaping ([NewsListViewController.CellViewModel], Error?) -> Void) {
        service.fetchNews(type: .topHeadlines(page)) { news, error in
            if page > 1 {
                self.news.append(contentsOf: news)
            } else {
                self.news = news
            }

            completion(self.news.map { NewsListViewController.CellViewModel(title: $0.title,
                                                                            description: $0.description) },
                       error)
        }
    }
    
    func fetchEverythingNews(page: Int, completion: @escaping ([NewsListViewController.CellViewModel], Error?) -> Void) {
        service.fetchNews(type: .everything(page)) { news, error in
            if page > 1 {
                self.news.append(contentsOf: news)
            } else {
                self.news = news
            }

            completion(self.news.map { NewsListViewController.CellViewModel(title: $0.title,
                                                                            description: $0.description) },
                       error)
        }
    }
}

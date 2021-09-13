//
//  NewsListInteractor.swift
//  News-VIPER
//
//  Created by Miras Karazhigitov on 11.09.2021.
//

import Foundation

protocol NewsListInteractorProtocol {
    var news: [News] { get }
    
    func set(currentSegment: Segment)
    func loadViewModels()
    func loadMoreViewModels()
    func refresh()
    
    func startTimer()
    func stopTimer()
}

protocol NewsListInteractorObserver: AnyObject {
    func newsListInteractor(_ interactor: NewsListInteractor, didFinishLoading news: [News])
    func newsListInteractor(_ interactor: NewsListInteractor, didReceive error: Error)
}

class NewsListInteractor: NewsListInteractorProtocol {
    weak var observer: NewsListInteractorObserver?
    var news = [News]()
    
    private var timer: Timer?
    var currentSegment: Segment!
    private var currentPage = 1
    private var isLoading = false
    
    private let service = NewsService()
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            if self.currentSegment == .topHeadlines {
                self.fetch()
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    func loadViewModels() {
        currentPage = 1
        fetch()
    }
    
    func refresh() {
        fetch()
    }
    
    func loadMoreViewModels() {
        guard !isLoading else { return }
        
        currentPage += 1
        fetch()
    }
    
    func fetch() {
        isLoading = true
        switch currentSegment {
        case .topHeadlines:
            fetchTopHeadlinesNews(page: currentPage) { [weak self] models, error in
                guard let self = self else { return }
                if let error = error {
                    self.observer?.newsListInteractor(self, didReceive: error)
                    self.isLoading = false
                    
                    return
                }
                
                self.observer?.newsListInteractor(self, didFinishLoading: models)
                self.isLoading = false
            }
        case .everything:
            fetchEverythingNews(page: currentPage) { [weak self] models, error in
                guard let self = self else { return }
                if let error = error {
                    self.observer?.newsListInteractor(self, didReceive: error)
                    self.isLoading = false
                    
                    return
                }
                
                self.observer?.newsListInteractor(self, didFinishLoading: models)
                self.isLoading = false
            }
        default:
            break
        }
    }
    
    func fetchTopHeadlinesNews(page: Int, completion: @escaping ([News], Error?) -> Void) {
        service.fetchNews(type: .topHeadlines(page)) { news, error in
            if page > 1 {
                self.news.append(contentsOf: news)
            } else {
                self.news = news
            }

            completion(self.news, error)
        }
    }
    
    func fetchEverythingNews(page: Int, completion: @escaping ([News], Error?) -> Void) {
        service.fetchNews(type: .everything(page)) { news, error in
            if page > 1 {
                self.news.append(contentsOf: news)
            } else {
                self.news = news
            }

            completion(self.news, error)
        }
    }
    
    func set(currentSegment: Segment) {
        self.currentSegment = currentSegment
    }
}

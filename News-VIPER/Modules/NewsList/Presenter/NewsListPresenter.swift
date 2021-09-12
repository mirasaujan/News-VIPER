//
//  NewsListPresenter.swift
//  News-VIPER
//
//  Created by Miras Karazhigitov on 11.09.2021.
//

import Foundation

protocol NewsListPresenterProtocol {
    func configureView()
    func segmentedControlSelected(index: Int)
    func loadViewModels()
    func loadMoreViewModels()
    func refresh()
    
    func selectNews(at index: Int)
    
    func startTimer()
    func stopTimer()
}

class NewsListPresenter: NewsListPresenterProtocol {
    weak var view: NewsListViewProtocol!
    var interactor: NewsListInteractorProtocol!
    var router: NewsListRouter!
    
    private var currentPage = 1
    private var currentSegment: Segment!
    private var isLoading = false
    var timer: Timer?
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            if self.currentSegment == .topHeadlines {
                self.fetch(page: self.currentPage)
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    func configureView() {
        view.onViewDidLoad = {
            let currentSegmentIndex = 0
            self.currentSegment = Segment(rawValue: currentSegmentIndex)!
            self.view.setupSegmentedControl(items: Segment.allCases.map { $0.title }, selectedIndex: currentSegmentIndex)
            self.view.setupTableView()
            self.view.setupPullToRefresh()
            
            self.loadViewModels()
        }
        
        view.onViewDidAppear = { [unowned self] in
            self.startTimer()
        }
        
        view.onViewDidDisappear = { [unowned self] in
            self.stopTimer()
        }
        
        view.onSegmentSelect = { [unowned self] index in
            self.segmentedControlSelected(index: index)
        }
        
        view.onPullToRefresh = { [unowned self] in
            self.refresh()
        }
        
        view.onCellSelect = { [unowned self] index in
            self.selectNews(at: index)
        }
        
        view.onDisplayOfLastCell = { [unowned self] in
            loadMoreViewModels()
        }
    }
    
    func loadViewModels() {
        currentPage = 1
        fetch(page: currentPage)
    }
    
    func refresh() {
        fetch(page: currentPage)
    }
    
    func selectNews(at index: Int) {
        router.pushToAdDetail(interactor.news[index])
    }
    
    func segmentedControlSelected(index: Int) {
        guard let segment = Segment(rawValue: index) else { return }
        currentSegment = segment
        currentPage = 1
        
        fetch(page: currentPage)
    }
    
    func loadMoreViewModels() {
        guard !isLoading else { return }
        
        currentPage += 1
        fetch(page: currentPage)
    }
    
    func fetch(page: Int) {
        isLoading = true
        switch currentSegment {
        case .topHeadlines:
            interactor.fetchTopHeadlinesNews(page: page) { [weak self] models, error in
                DispatchQueue.main.async {
                    self?.view.stopRefreshControl()
                }
                
                if let error = error {
                    self?.router.showErrorAlert(for: error)
                    self?.isLoading = false
                    
                    return
                }
                
                DispatchQueue.main.async {
                    self?.view.show(viewModels: models, animated: false)
                    self?.isLoading = false
                }
            }
        case .everything:
            interactor.fetchEverythingNews(page: page) { [weak self] models, error in
                DispatchQueue.main.async {
                    self?.view.stopRefreshControl()
                }
                
                if let error = error {
                    self?.router.showErrorAlert(for: error)
                    self?.isLoading = false
                    
                    return
                }
                
                DispatchQueue.main.async {
                    self?.view.show(viewModels: models, animated: false)
                    self?.isLoading = false
                }
            }
        default:
            break
        }
    }
}

enum Segment: Int, CaseIterable {
    case topHeadlines, everything
    
    var title: String {
        switch self {
        case .topHeadlines:
            return "Top headlines"
        case .everything:
            return "Everything"
        }
    }
}

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
    
    func selectNews(at index: Int)
}

class NewsListPresenter: NewsListPresenterProtocol {
    weak var view: NewsListViewProtocol!
    var interactor: NewsListInteractorProtocol!
    var router: NewsListRouter!
    
    func configureView() {
        view.onViewDidLoad = {
            let currentSegmentIndex = 0
            self.interactor.set(currentSegment: Segment(rawValue: currentSegmentIndex)!)
            self.view.setupSegmentedControl(items: Segment.allCases.map { $0.title }, selectedIndex: currentSegmentIndex)
            self.view.setupTableView()
            self.view.setupPullToRefresh()
            
            self.interactor.loadViewModels()
        }
        
        view.onViewDidAppear = { [unowned self] in
            self.interactor.startTimer()
        }
        
        view.onViewDidDisappear = { [unowned self] in
            self.interactor.stopTimer()
        }
        
        view.onSegmentSelect = { [unowned self] index in
            self.segmentedControlSelected(index: index)
        }
        
        view.onPullToRefresh = { [unowned self] in
            self.interactor.refresh()
        }
        
        view.onCellSelect = { [unowned self] index in
            self.selectNews(at: index)
        }
        
        view.onDisplayOfLastCell = { [unowned self] in
            self.interactor.loadMoreViewModels()
        }
    }
    
    func selectNews(at index: Int) {
        router.pushToAdDetail(interactor.news[index])
    }
    
    func segmentedControlSelected(index: Int) {
        guard let segment = Segment(rawValue: index) else { return }
        
        interactor.set(currentSegment: segment)
        interactor.loadViewModels()
    }
}

extension NewsListPresenter: NewsListInteractorObserver {
    func newsListInteractor(_ interactor: NewsListInteractor, didFinishLoading viewModels: [NewsListViewController.CellViewModel]) {
        DispatchQueue.main.async {
            self.view.stopRefreshControl()
            self.view.show(viewModels: viewModels, animated: false)
        }
    }
    
    func newsListInteractor(_ interactor: NewsListInteractor, didReceive error: Error) {
        DispatchQueue.main.async {
            self.view.stopRefreshControl()
            self.router.showErrorAlert(for: error)
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

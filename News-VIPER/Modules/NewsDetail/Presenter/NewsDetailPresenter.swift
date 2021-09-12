//
//  NewsDetailPresenter.swift
//  News-VIPER
//
//  Created by Miras Karazhigitov on 11.09.2021.
//

import Foundation

protocol NewsDetailPresenterProtocol {
    func configureView()
    func save()
}

class NewsDetailPresenter: NewsDetailPresenterProtocol {
    weak var view: NewsDetailViewProtocol!
    var intractor: NewsDetailInteractorProtocol!
    
    var news: News!
    
    func configureView() {
        view.show(NewsViewModel(imageUrl: news.urlToImage,
                                title: news.title,
                                content: news.content))
    }
    
    func save() {
        intractor.save(news)
    }
}

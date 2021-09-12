//
//  NewsDetailViewController.swift
//  News-VIPER
//
//  Created by Miras Karazhigitov on 11.09.2021.
//

import UIKit
import SnapKit
import SDWebImage

protocol NewsDetailViewProtocol: AnyObject {
    func show(_ news: NewsViewModel)
}

class NewsDetailViewController: UIViewController, NewsDetailViewProtocol {
    var presenter: NewsDetailPresenterProtocol!
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let contentLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInterface()
        presenter.configureView()
    }
    
    private func setupInterface() {
        view.backgroundColor = .white
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.height.equalTo(300)
        }
        
        titleLabel.numberOfLines = 0
        titleLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
        }
        
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        contentLabel.numberOfLines = 0
        view.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.bottom.equalTo(view.snp.bottom).offset(-20)
        }
        
        setupNavigationItem()
    }
    
    func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(heartButtonPressed))
    }
    
    @objc private func heartButtonPressed() {
        presenter.save()
    }
    
    func show(_ news: NewsViewModel) {
        imageView.sd_setImage(with: news.imageUrl, completed: nil)
        titleLabel.text = news.title
        contentLabel.text = news.content
    }
}

struct NewsViewModel {
    let imageUrl: URL
    let title: String
    let content: String
}

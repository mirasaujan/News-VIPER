//
//  NewsCell.swift
//  News-VIPER
//
//  Created by Miras Karazhigitov on 11.09.2021.
//

import SnapKit
import UIKit

class NewsCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let posterImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [titleLabel, descriptionLabel, posterImageView].forEach {
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(5)
            make.leading.equalTo(self).offset(16)
            make.trailing.equalTo(self).offset(-16)
        }
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.numberOfLines = 2
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalTo(self).offset(16)
            make.trailing.equalTo(self).offset(-16)
            make.bottom.equalTo(self.snp.bottom).offset(-5)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: NewsListViewController.CellViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
    }
}

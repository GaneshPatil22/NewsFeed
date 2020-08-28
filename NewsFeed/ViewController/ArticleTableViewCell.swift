//
//  ArticleTableViewCell.swift
//  NewsFeed
//
//  Created by MacMini 20 on 8/27/20.
//  Copyright © 2020 MacMini 20. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    let logoImageView: CusomImageView = {
        let iv = CusomImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 8
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let articleTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.font = UIFont.boldSystemFont(ofSize: 16.0)
        return lbl
    }()
    
    let detailLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.font = UIFont.boldSystemFont(ofSize: 16.0)
        lbl.alpha = 0.5
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
    }
    
    private func setUpView() {
        addSubview(articleTitleLabel)
        addSubview(logoImageView)
        addSubview(detailLabel)
        
        articleTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        articleTitleLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        articleTitleLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true

        logoImageView.topAnchor.constraint(equalTo: articleTitleLabel.bottomAnchor, constant: 5).isActive = true
        logoImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        logoImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        detailLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 5).isActive = true
        detailLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        detailLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        detailLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        
    }

    func setUpData(model: Article) {
        articleTitleLabel.text = model.title
        if let imageURL = model.urlToImage {
            logoImageView.setUpImage(using: imageURL)
        }
        detailLabel.text = model.articleDescription
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

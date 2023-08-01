//
//  NewsTableViewCell.swift
//  News
//
//  Created by Abdelrahman on 30/07/2023.
//

import UIKit
import Kingfisher


class NewsTableViewCell: UITableViewCell {
    
    ///Properties
    static let identifier = "NewsTableViewCell"
    var exist = false
    var bindDeleteToFavoritesView:(() -> ())?
    var bindAddToFavoritesView:(() -> ())?
    
    ///View elements
    let title:UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 20,weight: .medium)
        label.numberOfLines = 3
        return label
    }()
    
    let articleDesription:UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 18,weight: .regular)
        return label
    }()
    
    let source:UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 16,weight: .regular)
        return label
    }()
    
    let publishDate:UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 14,weight: .regular)
        return label
    }()
    
    let newsImageView:UIImageView = {
       let image = UIImageView()
        image.backgroundColor = .systemBackground
        image.contentMode = .scaleToFill
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 20
        return image
    }()
    
    let likeButton:UIButton = {
       let button = UIButton()
        //button.setImage(UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)), for: .normal)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .label
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        return button
    }()
    
    
    ///Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(title)
        contentView.addSubview(articleDesription)
        contentView.addSubview(source)
        contentView.addSubview(publishDate)
        contentView.addSubview(newsImageView)
        contentView.addSubview(likeButton)
        likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    ///Load subViews
    override func layoutSubviews() {
        super.layoutSubviews()
        newsImageView.frame = CGRect(x: 10, y: 15, width: contentView.frame.width - 20, height: 200)
        title.frame = CGRect(x: 10, y: 220, width: contentView.frame.size.width - 20, height: 80)
        //articleDesription.frame = CGRect(x: 10, y: contentView.frame.height - title.bounds.height, width: 200, height: 50)
        source.frame = CGRect(x: 10, y: 290, width: 150, height: 50)
        publishDate.frame = CGRect(x: 160, y: 290, width: 200, height: 50)
        likeButton.frame = CGRect(x: contentView.frame.width - 60, y: 290, width: 50, height: 50)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    ///Configure with data
    public func configure(model:Article,Source:String?){
        title.text = model.title
        articleDesription.text = model.description
        source.text = Source ?? ""
        publishDate.text = model.publishedAt
        let imageUrl = URL(string: model.urlToImage ?? "" )
        newsImageView.kf.setImage(with: imageUrl,placeholder: UIImage(named: "noImage"))
    }
    
    ///Like Button Functionality
    @objc func didTapLikeButton(){
        if exist{
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            likeButton.tintColor = .label
            bindDeleteToFavoritesView!()
        }else{
           likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
           likeButton.tintColor = .systemRed
           bindAddToFavoritesView!()
           
       }
        exist = !exist
    }
    
}

//
//  NewsDetailsView.swift
//  News
//
//  Created by Abdelrahman on 31/07/2023.
//

import UIKit
import Kingfisher
import SafariServices


protocol NewsDetailsViewDelegate:AnyObject{
    func didTapContinueReading(_ NewsDetailsView:NewsDetailsView)
}

class NewsDetailsView: UIView {
    ///Properties
    weak var delegate:NewsDetailsViewDelegate?

    ///View elements
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemBackground
        imageView.contentMode = .scaleToFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    
    private let sourceLabel: UILabel = {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           label.font = UIFont.systemFont(ofSize: 14)
           label.textColor = .gray
           return label
       }()
       
       private let publishedAtLabel: UILabel = {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           label.font = UIFont.systemFont(ofSize: 14)
           label.textColor = .gray
           return label
       }()
    
    private let lineSeparator1: UIView = {
           let view = UIView()
           view.translatesAutoresizingMaskIntoConstraints = false
           view.backgroundColor = .gray
           return view
       }()
       
       private let lineSeparator2: UIView = {
           let view = UIView()
           view.translatesAutoresizingMaskIntoConstraints = false
           view.backgroundColor = .gray
           return view
       }()
    
    private let continueReadingButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Continue Reading", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(continueReadingButtonTapped), for: .touchUpInside)
      
        return button
       }()
    
    ///Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    
    ///Add subViews
    private func setupUI() {
        backgroundColor = .systemBackground
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(imageView)
        contentView.addSubview(authorLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(sourceLabel)
        contentView.addSubview(publishedAtLabel)
        contentView.addSubview(continueReadingButton)
        contentView.addSubview(lineSeparator1)
        contentView.addSubview(lineSeparator2)
        
        // Set up constraints for each UI component
        NSLayoutConstraint.activate([
                    scrollView.topAnchor.constraint(equalTo: topAnchor),
                    scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
                    scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
                    scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
                    
                    contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                    contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                    contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                    contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                    contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                    
                    titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -30),
                    titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
                    titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
                    
                    imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
                    imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant:  15),
                    imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant:  -15),
                    imageView.heightAnchor.constraint(equalToConstant: 200),
                    
                    authorLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
                    authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
                    authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
                    
                    sourceLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 8),
                    sourceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
                    sourceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
                    
                    publishedAtLabel.topAnchor.constraint(equalTo: sourceLabel.bottomAnchor, constant: 8),
                    publishedAtLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
                    publishedAtLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
                    
                    lineSeparator1.topAnchor.constraint(equalTo: publishedAtLabel.bottomAnchor, constant: 20),
                    lineSeparator1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                    lineSeparator1.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                    lineSeparator1.heightAnchor.constraint(equalToConstant: 1),
                    
                    descriptionLabel.topAnchor.constraint(equalTo: lineSeparator1.bottomAnchor, constant: 8),
                    descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                    descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                    
                    lineSeparator2.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
                    lineSeparator2.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                    lineSeparator2.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                    lineSeparator2.heightAnchor.constraint(equalToConstant: 1),
                    
                    contentLabel.topAnchor.constraint(equalTo: lineSeparator2.bottomAnchor, constant: 16),
                    contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                    contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                    
                    continueReadingButton.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 16),
                    continueReadingButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                    continueReadingButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
                ])
    }
    
    
    /// Public method to set the data for the news details view
    func configure(with article: Article, source:String) {
        titleLabel.text = article.title
        authorLabel.text = "By \(article.author ?? "Unknown")"
        descriptionLabel.text = article.description
        contentLabel.text = article.content
        let imageUrl = URL(string: article.urlToImage ?? "" )
        imageView.kf.setImage(with: imageUrl,placeholder: UIImage(named: "noImage"))
        
        sourceLabel.text = "Source: \(source)"
        publishedAtLabel.text = "Published at: \(article.publishedAt ?? "")"
    }
    
    ///Continue reading button functionality
    @objc private func continueReadingButtonTapped() {
        delegate?.didTapContinueReading(self)
    }
}


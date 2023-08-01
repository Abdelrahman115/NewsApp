//
//  FavoritesViewController.swift
//  News
//
//  Created by Abdelrahman on 31/07/2023.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    ///Outlets
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    ///Properties
    var favArticlesArray:[ArticleToRealmFavorites] = []
    
    
    ///View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadDatafromRealm()
        tableView.reloadData()
    }

    
    ///setupUI of the function
    private func setupUI(){
        view.backgroundColor = .systemBackground
        title = "Favorites"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
    }
    
    ///Get saved favorites from realm
    func loadDatafromRealm(){
        let articles = RealmManager.shared.getAllObjects(ArticleToRealmFavorites.self)
        favArticlesArray.removeAll()
        for each in articles{
            favArticlesArray.append(each)
        }
        if favArticlesArray.isEmpty{
            tableView.isHidden = true
            placeHolderLabel.text = "No Favorites"
            placeHolderLabel.textColor = .systemGray
            placeHolderLabel.isHidden = false
        }else{
            tableView.isHidden = false
            placeHolderLabel.isHidden = true
        }
    }
}


///TableView delegate and datasource
extension FavoritesViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favArticlesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Create cell
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as! NewsTableViewCell
        
        //Configure cell with data
        let savedArticle = favArticlesArray[indexPath.row]
        let article = Article(author: savedArticle.author, content: savedArticle.content, description: savedArticle.description, publishedAt: savedArticle.publishedAt, source: nil, title: savedArticle.title, url: savedArticle.url, urlToImage: savedArticle.urlToImage)
        
        cell.configure(model: article,Source: savedArticle.source)
        cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        cell.likeButton.tintColor = .systemRed
        cell.exist = true
        
        //Delete from realm when clicking on favorite button and update tableview
        cell.bindDeleteToFavoritesView = { [weak self] in
            guard let self = self else {return}
            RealmManager.shared.deleteDatafromFavorites(title: article.title ?? "")
            self.favArticlesArray.removeAll()
            self.loadDatafromRealm()
            self.tableView.reloadData()
            print("Object deleted from realm")
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 340
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //create Article object
        let savedArticle = favArticlesArray[indexPath.row]
        let article = Article(author: savedArticle.author, content: savedArticle.content, description: savedArticle.articleDescription, publishedAt: savedArticle.publishedAt, source: nil, title: savedArticle.title, url: savedArticle.url, urlToImage: savedArticle.urlToImage)
        
        //Navigate to NewsDetailsView
        let vc = NewsDetailsViewController(article: article,source: savedArticle.source)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

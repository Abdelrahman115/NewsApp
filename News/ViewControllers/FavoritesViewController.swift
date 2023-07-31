//
//  FavoritesViewController.swift
//  News
//
//  Created by Abdelrahman on 31/07/2023.
//

import UIKit

class FavoritesViewController: UIViewController {

    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var favArticlesArray:[ArticleToRealm] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        //RealmManager.shared.deleteAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadDatafromRealm()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

    
    private func setupUI(){
        view.backgroundColor = .systemBackground
        title = "Favorites"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
    }
    
    
    func loadDatafromRealm(){
        let articles = RealmManager.shared.getAllObjects(ArticleToRealm.self)
        favArticlesArray.removeAll()
        for each in articles{
            favArticlesArray.append(each)
        }
        if favArticlesArray.isEmpty{
            tableView.isHidden = true
            placeHolderLabel.text = "No Articles To Read"
            placeHolderLabel.isHidden = false
        }else{
            tableView.isHidden = false
            placeHolderLabel.isHidden = true
        }
    }
    

}


extension FavoritesViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favArticlesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as! NewsTableViewCell
        
        let savedArticle = favArticlesArray[indexPath.row]
        
        let article = Article(author: savedArticle.author, content: savedArticle.content, description: savedArticle.description, publishedAt: savedArticle.publishedAt, source: nil, title: savedArticle.title, url: savedArticle.url, urlToImage: savedArticle.urlToImage)
        
        cell.configure(model: article,Source: savedArticle.source)
        cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        cell.exist = true
        
        cell.bindDeleteToFavoritesView = { [weak self] in
            guard let self = self else {return}
            RealmManager.shared.deleteDatafromFavorites(title: article.title ?? "")
            self.favArticlesArray.removeAll()
            self.loadDatafromRealm()
            self.tableView.reloadData()
            //tableView.reloadData()
            print("Object deleted from realm")
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 340
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
}

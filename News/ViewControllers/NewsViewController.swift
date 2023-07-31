//
//  ViewController.swift
//  News
//
//  Created by Abdelrahman on 30/07/2023.
//

import UIKit
import SafariServices

class NewsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel:FetchNews!
    var articles:[Article] = []
    var savedTitle:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    private func setupUI(){
        view.backgroundColor = .systemBackground
        title = "News"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
    }

    
    private func fetchData(){
        viewModel = FetchNews()
        viewModel.fetchNewHeadLines()
        viewModel.bindNews = {[weak self] in
            guard let self = self else {return}
            DispatchQueue.main.async {
                guard let news = self.viewModel.newHeadlines?.articles else{return}
                self.articles.append(contentsOf: news)
                self.tableView.reloadData()
            }
        }
    }
}



extension NewsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as! NewsTableViewCell
        
        let article = articles[indexPath.row]
        cell.configure(model: article,Source: article.source?["name"] as? String ?? "")
        
        
        let savedArticles = RealmManager.shared.getObject(title: article.title ?? "")
        for each in savedArticles{
            savedTitle = each.title ?? ""
        }
        if savedTitle == article.title{
            cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            cell.exist = true
        }else{
            cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            cell.exist = false
        }
        self.savedTitle = ""
        
        let obj = RealmManager.shared.createObject(article: article)
        
        cell.bindAddToFavoritesView = { [weak self] in
            guard let _ = self else {return}
            RealmManager.shared.add(object: obj)
            print("Object saved to realm")
        }
        
        cell.bindDeleteToFavoritesView = { [weak self] in
            guard let _ = self else {return}
            RealmManager.shared.deleteDatafromFavorites(title: article.title ?? "")
            print("Object deleted from realm")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        
        
        guard let url = URL(string: article.url ?? "") else {return}
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 340
    }
}





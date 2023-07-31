//
//  ViewController.swift
//  News
//
//  Created by Abdelrahman on 30/07/2023.
//

import UIKit
import SafariServices

class NewsViewController: UIViewController {
    
    @IBOutlet weak var themeSelector: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var viewModel:FetchNews!
    var articles:[Article] = []
    var savedTitle:String = ""
    //let refreshControl = UIRefreshControl()
    
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
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        
        themeSelector.selectedSegmentIndex = MTUserDefaults.shared.theme.rawValue

        
    }
    
    
    @IBAction func themeSelector(_ sender: UISegmentedControl) {
        MTUserDefaults.shared.theme = Theme(rawValue: sender.selectedSegmentIndex) ?? .device
        self.view.window?.overrideUserInterfaceStyle = MTUserDefaults.shared.theme.getUserInterfaceStyle()
    }
    
    private func fetchData(){
        articles.removeAll()
        viewModel = FetchNews()
        viewModel.fetchNewHeadLines()
        viewModel.bindNews = {[weak self] in
            guard let self = self else {return}
            DispatchQueue.main.async {
                guard let news = self.viewModel.newHeadlines?.articles else{return}
                self.articles.append(contentsOf: news)
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
                print("Updated")
            }
        }
    }
    
    @objc func refreshTable() {
        fetchData()
    }
    
    @objc func didTapSetting() {
            
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
        
        let vc = NewsDetailsViewController(article: article,source: article.source?["name"] as? String ?? "")
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 340
    }
}





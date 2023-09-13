//
//  ViewController.swift
//  News
//
//  Created by Abdelrahman on 30/07/2023.
//

import UIKit
import SafariServices
import Reachability

class NewsViewController: UIViewController {
    ///Outlets
    @IBOutlet weak var themeSelector: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    ///Properties
    let reachability = try! Reachability()
    private let searchVC = UISearchController(searchResultsController: nil)
    
    
    var viewModel:FetchNews!
    var articles:[Article] = []
    var savedTitle:String = ""
    var isUpdated:Bool = false
    var sources:[String] = []
    
    
    ///View functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        checkConnection()
        createSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    ///SetupUI of View
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
    
    ///Fetch data from news API
    private func fetchData(){
        
        viewModel = FetchNews()
        viewModel.fetchNewHeadLines()
        viewModel.bindNews = {[weak self] in
            guard let self = self else {return}
            DispatchQueue.main.async {
                guard let news = self.viewModel.newHeadlines?.articles else{return}
                
                self.articles.removeAll()
                self.articles.append(contentsOf: news)
                
                //Cash the fetched data to realm
                self.casheItemsToRealm()
                
                //relod data in table
                self.tableView.refreshControl?.endRefreshing()
                self.isUpdated = true
                self.tableView.reloadData()
            }
        }
        viewModel.bindErrors = {[weak self] in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.alertUser(title: "Error", message: "Internet connection error, Please check your connection.")
                self.getCashedItems()
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    ///Fetch search results
    private func fetchSearchResults(query:String){
        
        viewModel = FetchNews()
        viewModel.fetchSearchResults(query: query)
        viewModel.bindNews = {[weak self] in
            guard let self = self else {return}
            DispatchQueue.main.async {
                guard let news = self.viewModel.newHeadlines?.articles else{return}
                self.articles.removeAll()
                self.articles.append(contentsOf: news)
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
                self.isUpdated = true
            }
        }
        viewModel.bindErrors = {[weak self] in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.alertUser(title: "Error", message: "Internet connection failed, Please check your connection.")
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    ///Check Connection
    func checkConnection(){
        reachability.whenReachable = {[weak self] reachability in
            self?.fetchData()
        }
        reachability.whenUnreachable = {[weak self] _ in
            self?.alertUser(title: "Error", message: "Internet connection failed, Please check your connection.")
            
            //get cached data from realm in case (no internet connetion)
            self?.tableView.refreshControl?.endRefreshing()
            self?.getCashedItems()
        }
        do{
            try reachability.startNotifier()
        }catch{
            
        }
    }
    
    ///Cash Items to realm
    private func casheItemsToRealm(){
        RealmManager.shared.deleteDatafromCashed()
        for each in self.articles{
            let source = each.source?["name"] as? String ?? "Unknown"
            let obj = RealmManager.shared.createArticleToRealmCashedObject(article: each,source: source)
            RealmManager.shared.add(object: obj)
        }
    }
    
    ///Get Chashed items
    private func getCashedItems(){
        let cashedArticles = RealmManager.shared.getAllObjects(ArticleToRealmCashed.self)
        self.articles.removeAll()
        self.sources.removeAll()
        for each in cashedArticles{
            let article = Article(author: each.author, content: each.content, description: each.articleDescription, publishedAt: each.publishedAt, source: nil, title: each.title, url: each.url, urlToImage: each.urlToImage)
            self.articles.append(article)
            self.sources.append(each.source)
        }
        self.tableView.reloadData()
    }
    
    ///Create searchBar
    private func createSearchBar(){
        navigationItem.searchController = searchVC
        searchVC.searchBar.delegate = self
    }
    
    ///Display Alert
    func alertUser(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        
        present(alert,animated: true)
    }
    
    ///Pull down to reload data
    @objc func refreshTable() {
        fetchData()
        if isUpdated{
            self.alertUser(title: "Alert", message: "Your newsfeed is updated successfully.")
        }else{
            self.alertUser(title: "Error", message: "Internet connection failed, Please check your connection.")
        }
    }
    
    ///Theme Segemnted Controller
    @IBAction func themeSelector(_ sender: UISegmentedControl) {
        MTUserDefaults.shared.theme = Theme(rawValue: sender.selectedSegmentIndex) ?? .device
        self.view.window?.overrideUserInterfaceStyle = MTUserDefaults.shared.theme.getUserInterfaceStyle()
    }
}



///TableView delgate and data source

extension NewsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Create cell
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as! NewsTableViewCell
        
        //Configure the cell
        let article = articles[indexPath.row]
        if sources.isEmpty{
            let source = article.source?["name"] as? String ?? "Unknown"
            cell.configure(model: article,Source: source)
        }else{
            let source = sources[indexPath.row]
            cell.configure(model: article,Source: source)
        }
        
        
        
        //Get saved Articles in Realm to fill like button
        let savedArticles = RealmManager.shared.getObject(title: article.title ?? "")
        for each in savedArticles{
            savedTitle = each.title ?? ""
        }
        if savedTitle == article.title{
            cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            cell.likeButton.tintColor = .systemRed
            cell.exist = true
        }else{
            cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            cell.likeButton.tintColor = .label
            cell.exist = false
        }
        self.savedTitle = ""
        
        //save object or delete it when clicking like button
        cell.bindAddToFavoritesView = { [weak self] in
            guard let _ = self else {return}
            let obj = RealmManager.shared.createArticleToRealmFavoritesObject(article: article)
            RealmManager.shared.add(object: obj)
            print("Object saved to realm")
        }
        
        //Remove Favorites
        cell.bindDeleteToFavoritesView = { [weak self] in
            guard let _ = self else {return}
            //let obj = RealmManager.shared.createArticleToRealmFavoritesObject(article: article)
            RealmManager.shared.deleteDatafromFavorites(title: article.title ?? "")
            print("Object deleted from realm")
        }
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        if sources.isEmpty{
            let source = article.source?["name"] as? String ?? "Unknown"
            let vc = NewsDetailsViewController(article: article,source: source)
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }else{
            let source = sources[indexPath.row]
            let vc = NewsDetailsViewController(article: article,source: source)
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
        

    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 340
    }
}


///SearchBar delegate
extension NewsViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {return}
        fetchSearchResults(query: text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if isUpdated{
            fetchData()
        }
        
    }
}





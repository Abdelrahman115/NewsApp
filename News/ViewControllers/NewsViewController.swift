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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
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
        cell.configure(model: article)
        cell.delegate = self
        
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


extension NewsViewController:NewsTableViewCellDelegate{
    func playerControlsViewDidTabLikeButton(_ newsTableViewCell: NewsTableViewCell, exist: Bool) {
        print("Like")
    }
}


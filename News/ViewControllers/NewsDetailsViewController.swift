//
//  NewsDetailsViewController.swift
//  News
//
//  Created by Abdelrahman on 31/07/2023.
//

import UIKit
import SafariServices

class NewsDetailsViewController: UIViewController {

    ///Properties
    private let article:Article
    private var source:String = ""
    private var newsDetailsView: NewsDetailsView!
    
    ///Initializer
    init(article:Article,source:String){
        self.article = article
        self.source = source
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
    ///View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setuoUI()
        configureWithData()
    }
    
    ///SetupUI of the view
    private func setuoUI(){
        // Instantiate the custom NewsDetailsView
        navigationItem.leftBarButtonItem?.tintColor = UIColor.red
        newsDetailsView = NewsDetailsView()
        newsDetailsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newsDetailsView)

        // Set constraints for the NewsDetailsView
        NSLayoutConstraint.activate([
            newsDetailsView.topAnchor.constraint(equalTo: view.topAnchor),
            newsDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newsDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            newsDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        newsDetailsView.delegate = self
    }
    
    
    ///Configure data with article object
    private func configureWithData(){
        newsDetailsView.configure(with: article,source: source)
    }
    
    
}


///Delegate of continue reading button
extension NewsDetailsViewController:NewsDetailsViewDelegate{
    func didTapContinueReading(_ NewsDetailsView: NewsDetailsView) {
        
        guard let url = URL(string: article.url ?? "") else {return}
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
}

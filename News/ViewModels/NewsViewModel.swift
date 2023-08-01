//
//  NewsViewModel.swift
//  News
//
//  Created by Abdelrahman on 30/07/2023.
//

import Foundation

class FetchNews{
    
    var bindNews:(() -> ()) = {}
    var bindErrors:(() -> ()) = {}
    
    var newHeadlines:NewsResponse?{
        didSet{
            bindNews()
        }
    }
    
    var error:Error?{
        didSet{
            bindErrors()
        }
    }
    
    func fetchNewHeadLines(){
        NetworkManager.shared.getTopNews { [weak self] result in
            guard let self = self else {return}
            switch result{
            case.success(let model):
                self.newHeadlines = model
            case .failure(let error):
                self.error = error
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchSearchResults(query:String){
        NetworkManager.shared.search(q: query) { [weak self] result in
            guard let self = self else {return}
            switch result{
            case.success(let model):
                self.newHeadlines = model
            case .failure(let error):
                self.error = error
                print(error.localizedDescription)
            }
        }
    }
}

//
//  NewsViewModel.swift
//  News
//
//  Created by Abdelrahman on 30/07/2023.
//

import Foundation

class FetchNews{
    //static var news:[NewsResponse] = []
    var bindNews:(() -> ()) = {}
    
    var newHeadlines:NewsResponse?{
        didSet{
            bindNews()
        }
    }
    
    func fetchNewHeadLines(){
        NetworkManager.shared.getTopNews { [weak self] result in
            guard let self = self else {return}
            switch result{
            case.success(let model):
                self.newHeadlines = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
}

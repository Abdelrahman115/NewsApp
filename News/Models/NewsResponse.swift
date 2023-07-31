//
//  NewsResponse.swift
//  News
//
//  Created by Abdelrahman on 30/07/2023.
//

import Foundation


struct NewsResponse:Codable{
    let status:String
    let totalResults:Int
    let articles:[Article]
}


struct Article:Codable{
    let author:String?
    let content:String?
    let description:String?
    let publishedAt:String?
    let source:[String:String?]?
    let title:String?
    let url:String?
    let urlToImage:String?
}

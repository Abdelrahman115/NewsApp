//
//  Article(RealmObject).swift
//  News
//
//  Created by Abdelrahman on 30/07/2023.
//

import Foundation


import Foundation
import RealmSwift

class ArticleToRealm:Object{
    @objc dynamic var author:String?
    @objc dynamic var content:String?
    @objc dynamic var articleDescription:String?
    @objc dynamic var publishedAt:String?
    @objc dynamic var source:String = ""
    @objc dynamic var title:String?
    @objc dynamic var url:String?
    @objc dynamic var urlToImage:String?
    
    
    /*init(author: String? = nil, content: String? = nil, articleDescription: String? = nil, publishedAt: String? = nil, source: String? = nil, title: String? = nil, url: String? = nil, urlToImage: String? = nil) {
        self.author = author
        self.content = content
        self.articleDescription = articleDescription
        self.publishedAt = publishedAt
        self.source = source ?? ""
        self.title = title
        self.url = url
        self.urlToImage = urlToImage
    }*/
}

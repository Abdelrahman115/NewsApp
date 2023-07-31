//
//  Article(RealmObject).swift
//  News
//
//  Created by Abdelrahman on 30/07/2023.
//

import Foundation


import Foundation
import RealmSwift

class ArticleToRealmFavorites:Object{
    @objc dynamic var author:String?
    @objc dynamic var content:String?
    @objc dynamic var articleDescription:String?
    @objc dynamic var publishedAt:String?
    @objc dynamic var source:String = ""
    @objc dynamic var title:String?
    @objc dynamic var url:String?
    @objc dynamic var urlToImage:String?
    
}

class ArticleToRealmCashed:Object{
    @objc dynamic var author:String?
    @objc dynamic var content:String?
    @objc dynamic var articleDescription:String?
    @objc dynamic var publishedAt:String?
    @objc dynamic var source:String = ""
    @objc dynamic var title:String?
    @objc dynamic var url:String?
    @objc dynamic var urlToImage:String?
}

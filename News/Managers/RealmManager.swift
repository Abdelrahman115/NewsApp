//
//  RealmManager.swift
//  News
//
//  Created by Abdelrahman on 30/07/2023.
//

import Foundation
import RealmSwift


import RealmSwift

class RealmManager {
    static let shared = RealmManager()
    private let realm: Realm
    
    private init() {
        do {
            self.realm = try Realm()
        } catch {
            fatalError("Failed to initialize Realm: \(error.localizedDescription)")
        }
    }
    
    
    func createArticleToRealmFavoritesObject(article:Article) -> ArticleToRealmFavorites{
        let obj = ArticleToRealmFavorites()
        obj.author = article.author
        obj.content = article.content
        obj.articleDescription = article.description
        obj.publishedAt = article.publishedAt
        obj.source = article.source?["name"] as? String ?? ""
        obj.title = article.title
        obj.url = article.url
        obj.urlToImage = article.urlToImage
        return obj
    }
    
    func createArticleToRealmCashedObject(article:Article,source:String) -> ArticleToRealmCashed{
        let obj = ArticleToRealmCashed()
        obj.author = article.author
        obj.content = article.content
        obj.articleDescription = article.description
        obj.publishedAt = article.publishedAt
        obj.source = source
        obj.title = article.title
        obj.url = article.url
        obj.urlToImage = article.urlToImage
        return obj
    }
    
    
    func add(object: Object) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            print("Failed to add object to Realm: \(error.localizedDescription)")
        }
    }
    
    
    func delete(object: Object) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            print("Failed to delete object from Realm: \(error.localizedDescription)")
        }
    }
    

    
    func deleteDatafromFavorites(title:String){
        let delProduct = try! Realm().objects(ArticleToRealmFavorites.self).filter("title == %@",title)
         try! Realm().write({
             try! Realm().delete(delProduct)
         })
    }
    
    
    func deleteDatafromCashed(){
        let delProduct = try! Realm().objects(ArticleToRealmCashed.self)
         try! Realm().write({
             try! Realm().delete(delProduct)
         })
    }
    
    func getObject(title:String) -> Results<ArticleToRealmFavorites>{
        let object = try! Realm().objects(ArticleToRealmFavorites.self).filter("title == %@",title)
        return object
    }
    
    func getAllObjects<T: Object>(_ type: T.Type) -> Results<T> {
        return realm.objects(type)
    }
    
    
    func deleteAll() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
}

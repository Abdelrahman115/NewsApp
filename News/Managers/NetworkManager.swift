//
//  NetworkManager.swift
//  News
//
//  Created by Abdelrahman on 30/07/2023.
//

import Foundation


final class NetworkManager{
    static let shared = NetworkManager()
    
    let baseURL = "https://newsapi.org/v2/top-headlines?"
    let country = Locale.current.regionCode?.lowercased()
    let apiKey = "101ac9e39bea48e887c26e2592877769"
    
    enum APIError:Error{
        case failedToGetData
    }
    
    private init() {}
    
    
    
    
    public func getTopNews(completion:@escaping(Result<NewsResponse, Error>) -> Void){
        guard let country = country else {return}
        let urlString = baseURL+"country=\(String(describing: country))"+"&apikey=\(apiKey)"
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data ,  error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            do{
                let result = try JSONDecoder().decode(NewsResponse.self, from: data)
                completion(.success(result))
            }catch{
                print(error.localizedDescription)
                completion(.failure(error))
            }
            
        }
        task.resume()
    }
    
    
}

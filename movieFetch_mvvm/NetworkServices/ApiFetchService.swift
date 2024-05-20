//
//  ApiFetchService.swift
//  movieFetch_mvvm
//
//  Created by shanmuga srinivas on 14/05/24.
//

import Foundation

enum NetworkError: Error {
    case urlError
    case networkError
    case dataCannotParse
}

class ApiFetchService {
    
    let cache = NSCache<AnyObject, AnyObject>()
    
    // static var shared = ApiFetchService()
    func fetchMoviesData(page: Int, completion: @escaping(_ result: Result<[PhotoModel], NetworkError>) -> Void) {
        
        let urlString = "https://jsonplaceholder.typicode.com/photos?query="
        
        fetchData(urlS: urlString, completion: completion)
    }
    
    func fetchSearchPhotos(query: String, completion: @escaping(_ result: Result<[PhotoModel], NetworkError>) -> Void) {
        
        let urlString = "https://jsonplaceholder.typicode.com/photos?query=\(query)"
        
        fetchData(urlS: urlString, completion: completion)
    }
    
    
    func fetchData(urlS: String, completion: @escaping(_ result: Result<[PhotoModel], NetworkError>) -> Void) {
        
        guard let url = URL(string: urlS) else {
            completion(.failure(.urlError))
            return
        }
        
        if let cacheData = cache.object(forKey: urlS as NSString) {
            do {
                print("cache triggered")
                let result = try JSONDecoder().decode([PhotoModel].self, from: cacheData as! Data)
                completion(.success(result))
                return
            } catch {
                completion(.failure(.dataCannotParse))
                return
            }
        }
        
        URLSession.shared.dataTask(with: url) { Data, response, error in
            
            if let error = error {
                print("erorr: \(error)")
                completion(.failure(.networkError))
                return
            }
            
            guard let data = Data else {
                completion(.failure(.dataCannotParse))
                return
            }
            
            self.cache.setObject(data as NSData, forKey: urlS as NSString)
            
            do {
                let result = try JSONDecoder().decode([PhotoModel].self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.dataCannotParse))
            }
            
        }.resume()
        
    }
}

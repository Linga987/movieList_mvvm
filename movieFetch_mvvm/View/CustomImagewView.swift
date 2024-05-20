//
//  customImagewView.swift
//  movieFetch_mvvm
//
//  Created by shanmuga srinivas on 15/05/24.
//

import Foundation
import UIKit

class CustomImagewView: UIImageView {
    
    var task:URLSessionDataTask!
    
    func loadImage(url: URL) {
        image = nil
        
        if let task = task {
            task.cancel()
        }
        task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self.image = image
            }
            
        }
        
        task.resume()
    }
}

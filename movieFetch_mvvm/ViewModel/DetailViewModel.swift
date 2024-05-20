//
//  DetailViewModel.swift
//  movieFetch_mvvm
//
//  Created by shanmuga srinivas on 15/05/24.
//

import Foundation

class DetailViewModel {
    
    var photoModel: PhotoModel
    
    var imageView: URL?
    var labelText: String
    
    init(photoModel: PhotoModel) {
        self.photoModel = photoModel
        self.labelText = photoModel.title
        self.imageView = imageViewURL(photoModel.url)
    }
    
    func imageViewURL(_ imageData: String) -> URL? {
        return URL(string: "\(imageData)")
    }
    
    
}

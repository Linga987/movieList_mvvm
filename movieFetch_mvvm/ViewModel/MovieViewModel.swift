//
//  MovieViewModel.swift
//  movieFetch_mvvm
//
//  Created by shanmuga srinivas on 14/05/24.
//

import Foundation

class MovieViewModel {
    
    var isLoading:Observable<Bool> = Observable(value: false)
    var refresh:Observable<Bool> = Observable(value: false)
    var photoArray = [PhotoModel]()
    var searchNameArray: [PhotoModel] = []
    var total_pages = 1
    var curretnPage = 1
    func getMoviesData(isRefresh: Bool, page: Int, completion: @escaping () -> Void) {
        if isLoading.value ?? true {
            return
        }
        if isRefresh {
            refresh.value = true
        }
        isLoading.value = true
        ApiFetchService().fetchMoviesData(page: page) { [weak self] result in
            //  self?.isLoading.value = false
            if isRefresh {
                self?.refresh.value = false
            }
            switch result {
            case .success(let data):
                self?.photoArray = data
                //   self?.total_pages = data.totalPages
            case .failure(let error):
                print(error)
            }
            completion()
        }
    }
    
    func getSearchedPhotosData(query: String, completion: @escaping()-> Void) {
        
        ApiFetchService().fetchSearchPhotos(query: query) { [weak self] result in
            switch result {
            case .success(let data):
                self?.photoArray = data
            case .failure(let error):
                print(error)
            }
            completion()
        }
    }
    
    func numberOfSection()-> Int {
        return 1
    }
    
    func numberOfRowa(section: Int) -> Int {
        return photoArray.count
    }
    
    func retrieveId(photoId: Int) -> PhotoModel? {
        let photo = photoArray.first(where: {$0.id == photoId})
        return photo
    }
    
    func retrieveSearchedName(searchText: String) {
        searchNameArray = photoArray.filter({$0.title.lowercased().prefix(searchText.count) == searchText.lowercased()})
    }
}

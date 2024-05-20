//
//  Observable.swift
//  movieFetch_mvvm
//
//  Created by shanmuga srinivas on 15/05/24.
//

import Foundation

class Observable<T> {
    
    var value: T? {
        didSet {
            DispatchQueue.main.async {
                self.listener?(self.value)
            }
        }
    }
    
    init(value: T?) {
        self.value = value
    }
    
    private var listener: ((T?) -> Void)?
    func bind(_ listener: @escaping((T?) -> Void)) {
        listener(value)
        self.listener = listener
    }
}

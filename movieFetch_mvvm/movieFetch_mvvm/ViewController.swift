//
//  ViewController.swift
//  movieFetch_mvvm
//
//  Created by shanmuga srinivas on 14/05/24.
//

import UIKit

class ViewController: UIViewController{
   
    var movieViewModel: MovieViewModel = MovieViewModel()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var ActivityIndicaterView: UIActivityIndicatorView!
    let refreshControll = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUPUI()
        fetchPhotoData(page: 1, isRefresh: false)
        bindViewModel()
    }
    
    func setUPUI() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.searchBar.delegate = self
        tableView.register(UINib(nibName: "customPhotoCellTableViewCell" , bundle: nil),
                           forCellReuseIdentifier: "cell")
        tableView.refreshControl = UIRefreshControl()
        refreshControll.addTarget(self, action: #selector(refreshData), for: .valueChanged)
      //  self.refreshData()
    }
    
    @objc func refreshData() {
        self.movieViewModel.photoArray.removeAll()
        movieViewModel.curretnPage = 1
        fetchPhotoData(page: 1, isRefresh: true)
    }
    
    func fetchPhotoData(page: Int, isRefresh: Bool) {
        movieViewModel.getMoviesData(isRefresh: isRefresh, page: page) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func bindViewModel() {
        movieViewModel.isLoading.bind {  [weak self] isLoading  in
            guard let self = self, let isLoading = isLoading else {return}
            
            DispatchQueue.main.async {
                if isLoading {
                    self.ActivityIndicaterView.startAnimating()
                } else {
                    self.ActivityIndicaterView.stopAnimating()
                }
            }
        }
        
        movieViewModel.refresh.bind { [weak self]  isRresh in
            guard let self = self, let isRefresh = isRresh else { return }
            DispatchQueue.main.async {
                if isRefresh {
                    self.refreshControll.beginRefreshing()
                } else {
                    self.refreshControll.endRefreshing()
                }
            }
        }
    }
    
    func openDetail(id: Int) {
        guard let cellId = movieViewModel.retrieveId(photoId: id) else { return }
        let detailViewModel = DetailViewModel(photoModel: cellId)
        let detailViewController = DetailsViewController(detailViewModel: detailViewModel)
        self.navigationController?.pushViewController(detailViewController, animated: true)
        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return movieViewModel.numberOfSection()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieViewModel.numberOfRowa(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if movieViewModel.curretnPage < movieViewModel.total_pages && indexPath.row == movieViewModel.photoArray.count - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loading", for: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! customPhotoCellTableViewCell
            let photos = movieViewModel.photoArray[indexPath.row]
            cell.photoArray = photos
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photoID = movieViewModel.photoArray[indexPath.row].id
        self.openDetail(id: photoID)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if movieViewModel.curretnPage < movieViewModel.total_pages && indexPath.row == movieViewModel.photoArray.count - 1 {
            movieViewModel.curretnPage += 1
            fetchPhotoData(page: movieViewModel.curretnPage, isRefresh: false)
        }
    }
    
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else {
            return
        }
        movieViewModel.getSearchedPhotosData(query: query) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
}


//
//  DetailsViewController.swift
//  movieFetch_mvvm
//
//  Created by shanmuga srinivas on 14/05/24.
//

import UIKit
import SDWebImage

class DetailsViewController: UIViewController {
    
    var detailViewModel: DetailViewModel
    
    @IBOutlet weak var ImageView: CustomImagewView!
    @IBOutlet weak var labelView: UILabel!
    
    
    init(detailViewModel: DetailViewModel) {
        self.detailViewModel = detailViewModel
        super.init(nibName: "DetailsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configui()
    }
    
    func configui() {
        labelView.text = detailViewModel.labelText
        ImageView.loadImage(url: detailViewModel.imageView!)
    }
    
}

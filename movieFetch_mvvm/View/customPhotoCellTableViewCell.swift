//
//  customPhotoCellTableViewCell.swift
//  movieFetch_mvvm
//
//  Created by shanmuga srinivas on 14/05/24.
//

import UIKit
import SDWebImage

class customPhotoCellTableViewCell: UITableViewCell {

    var photoArray: PhotoModel? {
        didSet {
            updateUI()
        }
    }
  
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var labelText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateUI() {
        labelText.text = photoArray?.title
        ImageView.sd_setImage(with: URL(string: photoArray?.thumbnailUrl ?? ""))
    }
    
}

//
//  FeedImageCell.swift
//  Acharya Prashant Foundation
//
//  Created by Ashok Singh on 16/04/24.
//

import UIKit

class FeedImageCell: UICollectionViewCell {

    @IBOutlet weak var feedImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        feedImgView.image = UIImage.init(named: "AcharyaPrashant")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        feedImgView.image = UIImage.init(named: "AcharyaPrashant")
    }
}

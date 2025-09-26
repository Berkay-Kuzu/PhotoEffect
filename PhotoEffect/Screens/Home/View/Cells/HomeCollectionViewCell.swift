//
//  HomeCollectionViewCell.swift
//  PhotoEffect
//
//  Created by Berkay on 26.09.2025.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var overlayTitleLabel: UILabel!
    @IBOutlet weak var overlayImageView: UIImageView!
    @IBOutlet weak var overlayContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCellUI()
    }
    
    func setupCellUI(){
        overlayContainerView.clipsToBounds = true
        overlayContainerView.layer.cornerRadius = 10
    }

    func prepareCell(item: Overlay, model: HomeUserModel){
        overlayTitleLabel.text = item.overlayName
        overlayContainerView.layer.borderWidth = item.overlayName == model.name ? 2 : 0
        overlayContainerView.layer.borderColor = item.overlayName == model.name ? UIColor.systemBlue.cgColor : UIColor.clear.cgColor
        
        if let image = item.downloadedImage {
            overlayImageView.image = image
        } else {
            overlayImageView.image = AppImages.placeholder_image.image
        }
    }
}

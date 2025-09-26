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

    func prepareCell(item: Overlay){
        overlayTitleLabel.text = item.overlayName
    }
    
}

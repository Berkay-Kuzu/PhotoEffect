//
//  Extension+UICollectionView.swift
//  PhotoEffect
//
//  Created by Berkay on 26.09.2025.
//

import UIKit

extension UICollectionViewCell {
    var cellName: String {
        return String(describing: self)
    }
}

extension UICollectionView {
    func registerCell<Cell: UICollectionViewCell>(with cellType: Cell.Type) {
        let cellName = String(describing: cellType)
        let nib = UINib(nibName: cellName, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: cellName)
    }
}

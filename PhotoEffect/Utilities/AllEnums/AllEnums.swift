//
//  AllEnums.swift
//  PhotoEffect
//
//  Created by Berkay on 26.09.2025.
//

import UIKit

enum AppImages: String {
    case placeholder_image
    
    var image: UIImage {
        UIImage(named: self.rawValue) ?? UIImage()
    }
}

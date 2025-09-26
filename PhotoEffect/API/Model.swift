//
//  Model.swift
//  PhotoEffect
//
//  Created by Berkay on 26.09.2025.
//

import UIKit

struct Overlay: Codable {
    let overlayId: Int
    let overlayName: String
    let overlayPreviewIconUrl: String
    let overlayUrl: String
    
    var downloadedImage: UIImage? = nil
    
    enum CodingKeys: String, CodingKey {
        case overlayId, overlayName, overlayPreviewIconUrl, overlayUrl
    }
}

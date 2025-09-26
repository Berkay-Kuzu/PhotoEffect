//
//  ImageDownloaderManager.swift
//  PhotoEffect
//
//  Created by Berkay on 26.09.2025.
//

import UIKit

class ImageDownloaderManager {
    
    static let shared = ImageDownloaderManager()
    
    private let cache = NSCache<NSString, UIImage>()
    
    func downloadImage(from urlString: String) async -> UIImage? {
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            return image
        }
        
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let image = UIImage(data: data) {
                cache.setObject(image, forKey: cacheKey)
                return image
            } else {
                return nil
            }
            
        } catch {
            print("Image download error: \(error)")
            return nil
        }
    }
}

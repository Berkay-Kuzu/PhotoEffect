//
//  PhotoManager.swift
//  PhotoEffect
//
//  Created by Berkay on 27.09.2025.
//

import UIKit
import Photos

class PhotoManager {
    
    static let shared = PhotoManager()
    
    func combine(bottomImage: UIImage, topImage: UIImage, frame: CGRect) -> UIImage? {
        let size = UIScreen.main.bounds
        UIGraphicsBeginImageContextWithOptions(size.size, false, 0.0)
        
        bottomImage.draw(in: CGRect(origin: .zero, size: size.size))
        topImage.draw(in: frame, blendMode: .normal, alpha: 1.0)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func saveImageToCache(_ image: UIImage, asPNG: Bool = false) -> URL? {
        let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let fileName = "combined_\(UUID().uuidString)." + (asPNG ? "png" : "jpg")
        let fileURL = cacheDirectory.appendingPathComponent(fileName)
        
        let imageData = asPNG ? image.pngData() : image.jpegData(compressionQuality: 0.8)
        
        guard let data = imageData else { return nil }
        
        do {
            try data.write(to: fileURL, options: .atomic)
            return fileURL
        } catch {
            print("❌ Save error: \(error.localizedDescription)")
            return nil
        }
    }
}

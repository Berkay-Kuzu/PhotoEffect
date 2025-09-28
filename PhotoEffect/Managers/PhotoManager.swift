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
    
    func calculateHistogram(for image: UIImage) -> (red: [Int], green: [Int], blue: [Int]) {
        guard let cgImage = image.cgImage else {
            print("❌ Histogram: CGImage cannot be created")
            return (red: Array(repeating: 0, count: 256),
                   green: Array(repeating: 0, count: 256), 
                   blue: Array(repeating: 0, count: 256))
        }
        
        let width = cgImage.width
        let height = cgImage.height
        
        guard width > 0 && height > 0 else {
            print("❌ Histogram: Invalid image size")
            return (red: Array(repeating: 0, count: 256),
                   green: Array(repeating: 0, count: 256), 
                   blue: Array(repeating: 0, count: 256))
        }
        
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        
        var pixelData = [UInt8](repeating: 0, count: width * height * bytesPerPixel)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(data: &pixelData,
                                     width: width,
                                     height: height,
                                     bitsPerComponent: bitsPerComponent,
                                     bytesPerRow: bytesPerRow,
                                     space: colorSpace,
                                     bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            print("❌ Histogram: Context cannot be created")
            return (red: Array(repeating: 0, count: 256),
                   green: Array(repeating: 0, count: 256), 
                   blue: Array(repeating: 0, count: 256))
        }
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        var redHistogram = Array(repeating: 0, count: 256)
        var greenHistogram = Array(repeating: 0, count: 256)
        var blueHistogram = Array(repeating: 0, count: 256)
        
        for i in stride(from: 0, to: pixelData.count - 3, by: 4) {
            let red = Int(pixelData[i])
            let green = Int(pixelData[i + 1])
            let blue = Int(pixelData[i + 2])
            
            if red >= 0 && red < 256 {
                redHistogram[red] += 1
            }
            if green >= 0 && green < 256 {
                greenHistogram[green] += 1
            }
            if blue >= 0 && blue < 256 {
                blueHistogram[blue] += 1
            }
        }
        
        print("✅ Histogram calculation is completed - Red: \(redHistogram.prefix(5)), Green: \(greenHistogram.prefix(5)), Blue: \(blueHistogram.prefix(5))")
        return (red: redHistogram, green: greenHistogram, blue: blueHistogram)
    }
}

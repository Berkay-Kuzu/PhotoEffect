//
//  HomeViewModel.swift
//  PhotoEffect
//
//  Created by Berkay on 26.09.2025.
//

import UIKit

class HomeViewModel {
    
    weak var delegate: HomeViewModelDelegate?
    
    var userModel = HomeUserModel(name: nil)
    
    var selectedOverlayItem: Overlay?
    
    var downloadedImage: UIImage? {
        selectedOverlayItem?.downloadedImage
    }
    
    var isLoading = false {
        didSet {
            self.delegate?.handleHomeViewModelOutput(output: .showLoader(status: isLoading))
        }
    }
    
    var overlayItems: [Overlay] = [] {
        didSet {
            self.delegate?.handleHomeViewModelOutput(output: .reloadData)
        }
    }
    
    init(){
        fetchOverlayItems()
    }
    
    func fetchOverlayItems() {
        Task {
            isLoading = true
            let result = try await PhotoEffectNetworkService().fetchOverlayItems()
            isLoading = false
            switch result {
            case .success(let success):
                self.overlayItems = success
                self.fetchPreviewImagesConcurrently()
                self.fetchImagesConcurrently()
                print("overlay items: \(success)")
            case .failure(let failure):
                self.delegate?.handleHomeViewModelOutput(output: .showAlert(title: failure.errorDescription))
            }
        }
    }
    
    func fetchPreviewImagesConcurrently() {
        Task {
            await withTaskGroup(of: (Int, UIImage?).self) { group in
                for (index, item) in overlayItems.enumerated() {
                    group.addTask {
                        let image = await ImageDownloaderManager.shared.downloadImage(from: item.overlayPreviewIconUrl)
                        return (index, image)
                    }
                }
                
                for await (index, image) in group {
                    if let image {
                        var updatedItem = overlayItems[index]
                        updatedItem.downloadedPreviewImage = image
                        overlayItems[index] = updatedItem
                        
                        await MainActor.run {
                            self.delegate?.handleHomeViewModelOutput(output: .reloadItem(index: index))
                        }
                    }
                }
            }
        }
    }

    func fetchImagesConcurrently() {
        Task {
            await withTaskGroup(of: (Int, UIImage?).self) { group in
                for (index, item) in overlayItems.enumerated() {
                    group.addTask {
                        let image = await ImageDownloaderManager.shared.downloadImage(from: item.overlayUrl)
                        return (index, image)
                    }
                }
                
                for await (index, image) in group {
                    if let image {
                        var updatedItem = overlayItems[index]
                        updatedItem.downloadedImage = image
                        overlayItems[index] = updatedItem
                        
                        await MainActor.run {
                            self.delegate?.handleHomeViewModelOutput(output: .reloadItem(index: index))
                        }
                    }
                }
            }
        }
    }
    
    func handleSave(bottom: UIImage, top: UIImage, frame: CGRect, asPNG: Bool = false) -> URL? {
        guard let combined = PhotoManager.shared.combine(bottomImage: bottom, topImage: top, frame: frame) else {
            return nil
        }
        return PhotoManager.shared.saveImageToCache(combined, asPNG: asPNG)
    }
    
    func numberOfItemsInSection() ->Int {
        overlayItems.count
    }
    
    func cellForItemAt(indexPath: IndexPath) -> Overlay {
        overlayItems[indexPath.row]
    }
    
    func didSelectItemAt (indexPath: IndexPath) {
        let selectedItem = cellForItemAt(indexPath: indexPath)
        selectedOverlayItem = selectedItem
        userModel.name = selectedItem.overlayName
        self.delegate?.handleHomeViewModelOutput(output: .selectedItem(item: selectedItem))
    }
    
    func sizeForItemAt(collectionView: UICollectionView) -> CGSize {
        let width = (collectionView.frame.size.width - 50) / 5
        return CGSize(width: width, height: width + 30)
    }
    
    func insetForSectionAt() -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
}

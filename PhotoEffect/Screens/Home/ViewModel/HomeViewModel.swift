//
//  HomeViewModel.swift
//  PhotoEffect
//
//  Created by Berkay on 26.09.2025.
//

import UIKit

class HomeViewModel {
    
    weak var delegate: HomeViewModelDelegate?
    
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
            case .failure(let failure):
                self.delegate?.handleHomeViewModelOutput(output: .showAlert(title: failure.localizedDescription))
            }
        }
    }
    
    func numberOfItemsInSection() ->Int {
        overlayItems.count
    }
    
    func cellForItemAt(indexPath: IndexPath) -> Overlay {
        overlayItems[indexPath.row]
    }
    
    func sizeForItemAt(collectionView: UICollectionView) -> CGSize {
        let width = (collectionView.frame.size.width - 50) / 5
        return CGSize(width: width, height: width + 30)
    }
    
    func insetForSectionAt() -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
}

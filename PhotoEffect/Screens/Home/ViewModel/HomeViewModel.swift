//
//  HomeViewModel.swift
//  PhotoEffect
//
//  Created by Berkay on 26.09.2025.
//

import Foundation

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
}

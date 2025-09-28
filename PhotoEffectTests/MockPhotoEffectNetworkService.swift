//
//  MockPhotoEffectNetworkService.swift
//  PhotoEffectTests
//
//  Created by Berkay on 28.09.2025.
//

import Foundation
@testable import PhotoEffect

final class MockPhotoEffectNetworkService: PhotoEffectNetworkServiceProtocol {
    
    var mockOverlays: [Overlay] = []
    var shouldReturnError = false
    var errorToReturn: NetworkError = .invalidResponse
    
    func fetchOverlayItems() async throws -> Result<[Overlay], NetworkError> {
        if shouldReturnError {
            return .failure(errorToReturn)
        } else {
            return .success(mockOverlays)
        }
    }
}

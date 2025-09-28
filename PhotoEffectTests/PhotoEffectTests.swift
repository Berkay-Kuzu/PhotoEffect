//
//  PhotoEffectTests.swift
//  PhotoEffectTests
//
//  Created by Berkay on 26.09.2025.
//

import XCTest
@testable import PhotoEffect

final class PhotoEffectNetworkServiceTests: XCTestCase {
    
    var mockService: MockPhotoEffectNetworkService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockService = MockPhotoEffectNetworkService()
    }
    
    override func tearDownWithError() throws {
        mockService = nil
        try super.tearDownWithError()
    }
    
    @MainActor
    func testFetchOverlayItemsSuccess() async throws {
        // Given
        let expectedOverlays = [
            Overlay(
                overlayId: 1,
                overlayName: "Test Overlay 1",
                overlayPreviewIconUrl: "https://example.com/icon1.png",
                overlayUrl: "https://example.com/file1.png"
            ),
            Overlay(
                overlayId: 2,
                overlayName: "Test Overlay 2",
                overlayPreviewIconUrl: "https://example.com/icon2.png",
                overlayUrl: "https://example.com/file2.png"
            )
        ]
        mockService.mockOverlays = expectedOverlays
        
        // When
        let result = try await mockService.fetchOverlayItems()
        
        // Then
        switch result {
        case .success(let overlays):
            XCTAssertEqual(overlays.count, 2)
            XCTAssertEqual(overlays.first?.overlayName, "Test Overlay 1")
            XCTAssertEqual(overlays.last?.overlayId, 2)
        case .failure:
            XCTFail("Beklenen başarı ama hata geldi")
        }
    }
    
    @MainActor
    func testFetchOverlayItemsFailure() async throws {
        // Given
        mockService.shouldReturnError = true
        mockService.errorToReturn = .invalidResponse
        
        // When
        let result = try await mockService.fetchOverlayItems()
        
        // Then
        switch result {
        case .success:
            XCTFail("Beklenen hata ama başarı geldi")
        case .failure(let error):
            XCTAssertEqual(error, .invalidResponse)
            XCTAssertEqual(error.errorDescription, "Invalid Response")
        }
    }
}

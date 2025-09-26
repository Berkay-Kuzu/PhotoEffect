//
//  PhotoEffectNetworkService.swift
//  PhotoEffect
//
//  Created by Berkay on 26.09.2025.
//

import Foundation

class PhotoEffectNetworkService: BaseNetworkService<PokemonRouter> {
    
    func fetchOverlayItems() async throws -> Result<[Overlay], NetworkError> {
        do {
            let result = try await request([Overlay].self, router: .getAllOverlayItems)
            return .success(result)
        } catch let error as NetworkError{
            return .failure(error)
        } catch {
            return .failure(.dataConversionFailure)
        }
    }
}

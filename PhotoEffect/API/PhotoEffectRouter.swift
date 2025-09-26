//
//  PhotoEffectRouter.swift
//  PhotoEffect
//
//  Created by Berkay on 26.09.2025.
//

import Foundation

protocol URLRequestConvertible {
    func makeURLRequest() throws -> URLRequest
}

struct APIConfig {
    static let baseURL = "https://lyrebirdstudio.s3-us-west-2.amazonaws.com/candidates/overlay.json"
}

enum NetworkError: Error {
    case invalidURL
    case requestFailed(statusCode: Int)
    case invalidResponse
    case dataConversionFailure
}

enum PokemonRouter: URLRequestConvertible {
    
    case getAllOverlayItems
    
    var method: String {
        switch self {
        case .getAllOverlayItems:
            return "GET"
        }
    }
    
    func makeURLRequest() throws -> URLRequest {
        guard let url = URL(string: APIConfig.baseURL) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}

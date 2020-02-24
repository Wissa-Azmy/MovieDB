//
//  MoviesDBAPIService.swift
//  WMDB
//
//  Created by Wissa Azmy on 2/14/20.
//  Copyright © 2020 Wissa Azmy. All rights reserved.
//

import Foundation

protocol MovieDBAPIService {
    func request(_ endpoint: MovieDBEndpoint, page: Int, query: String, completion: @escaping (Result<MoviesResponse, ResponseError>) -> ())
}

public enum ResponseError: Error {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
    
    var description: String {
        switch self {
        case .apiError:
            return "The request has failed."
        case .invalidEndpoint:
            return "The Endpoint is not valid."
        case .invalidResponse:
          return "Invalid server response."
        case .noData:
          return "The server returned empty data."
        case .serializationError:
          return "An error occurred while decoding data."
        }
    }
}

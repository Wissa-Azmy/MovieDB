//
//  APIService.swift
//  WMDB
//
//  Created by Wissa Azmy on 2/16/20.
//  Copyright © 2020 Wissa Azmy. All rights reserved.
//

import Foundation

public class APIService: MovieDBAPIService {
    let urlSession: URLSession
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
    
    init(session: URLSession = URLSession.shared) {
      self.urlSession = session
    }
    // NOTE: - I Usualy use Moya to construct my network layer, but I going native for the task sake.
    func request(_ endpoint: MovieDBEndpoint, page: Int, completion: @escaping (Result<MoviesResponse, ResponseError>) -> ()) {
        
        guard let urlRequest = MovieDBUrlManager.urlRequest(of: endpoint, page) else {
            completion(Result.failure(.invalidEndpoint))
            return
        }
        
        urlSession.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                completion(Result.failure(.apiError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.hasSuccessStatusCode else {
                completion(Result.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(Result.failure(.noData))
                return
            }
            
            do {
                let moviesResponse = try self.jsonDecoder.decode(MoviesResponse.self, from: data)
                completion(Result.success(moviesResponse))
            } catch {
                completion(Result.failure(.serializationError))
            }
        }.resume()
    }
}


extension HTTPURLResponse {
  var hasSuccessStatusCode: Bool {
    return 200...299 ~= statusCode
  }
}

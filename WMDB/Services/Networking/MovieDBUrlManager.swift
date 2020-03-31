//
//  MovieDBUrlManager.swift
//  WMDB
//
//  Created by Wissa Azmy on 2/18/20.
//  Copyright © 2020 Wissa Azmy. All rights reserved.
//

import Foundation

struct MovieDBUrlManager {
    static let scheme = "https"
    static let mainHost = "api.themoviedb.org"
    static let imagesHost = "image.tmdb.org"
    static let nowPlayingPath = "/3/movie/now_playing"
    static let searchPath = "/3/search/movie"
    static let imagesPath = "/t/p/"
    static let imgSize = "w300"
    static let token = TOKEN
    
    static func urlRequest(of endpoint: MovieDBEndpoint, _ page: Int) -> URLRequest? {
        var queryItems = [URLQueryItem(name: "page", value: "\(page)")]
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = mainHost
        
        switch  endpoint{
        case .nowPlaying:
            urlComponents.path = nowPlayingPath
        case .search(let query):
            urlComponents.path = searchPath
            queryItems.append(URLQueryItem(name: "query", value: "\(query)"))
        }
        
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
        
        return urlRequest
    }
    
    static func imgUrl(for imgPath: String) -> URL? {
        var urlComponents = URLComponents()
        
        urlComponents.scheme = scheme
        urlComponents.host = imagesHost
        urlComponents.path = imagesPath + imgSize + imgPath
        
        guard let url = urlComponents.url else {
            return nil
        }
        
        return url
    }
}

enum MovieDBEndpoint {
    case nowPlaying, search(_ query: String)
}

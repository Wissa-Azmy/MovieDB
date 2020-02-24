//
//  Movie.swift
//  WMDB
//
//  Created by Wissa Azmy on 2/14/20.
//  Copyright © 2020 Wissa Azmy. All rights reserved.
//

import Foundation

struct MoviesResponse: Decodable {
    let results: [Movie]
    let page, totalResults, totalPages: Int
    
    enum codingKeys: String, CodingKey {
        case results, page
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
}

struct Movie: Decodable {
    let title, overview: String
    let backdropPath, posterPath: String?
    let voteAverage: Double
    
    enum codingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case rating = "vote_average"
        case backdropPath = "backdrop_path"
        case title, overview
    }
    
    var ratingText: String {
        var ratingText = ""
        let rating = Int(voteAverage)
        if rating >= 1 {
            ratingText = (0..<rating).reduce("") { accumulated, _ in accumulated + "⭐️" }
            ratingText += " (\(voteAverage))"
        } else {
            ratingText = "No rating"
        }
        
        return "Rating: " + ratingText
    }
    
    var overviewText: String {
        guard !overview.isEmpty, overview.trimmingCharacters(in: .whitespaces).count > 0 else {
            return "No Overview Available."
        }
        
        return overview
    }
    
    var backdropUrl: URL? {
        if let path = backdropPath {
            return MovieDBUrlManager.imgUrl(for: path)
        }
        return nil
    }
    
    var posterUrl: URL? {
        if let path = posterPath {
            return MovieDBUrlManager.imgUrl(for: path)
        }
        return nil
    }
}



extension Array where Element == Movie {
    func matching(_ text: String?) -> [Movie] {
        if let text = text, text.count > 0 {
            return self.filter {
                $0.title.lowercased().contains(text.lowercased())
            }
        } else {
            return self
        }
    }
}

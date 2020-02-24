//
//  MovieStructTests.swift
//  WMDBTests
//
//  Created by Wissa Azmy on 2/21/20.
//  Copyright © 2020 Wissa Azmy. All rights reserved.
//

import XCTest

@testable import WMDB
class MovieStructTests: XCTestCase {
    var movie: Movie!
    var minimalMovie: Movie!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        movie = Movie(title: "Wissa", overview: "Wissa is a passionate iOS Engineer", backdropPath: "/1.jpg", posterPath: "/2.jpg", voteAverage: 9.9)
        minimalMovie = Movie(title: "Wissa", overview: "", backdropPath: nil, posterPath: nil, voteAverage: 0.0)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInit_MovieNotNil() {
        XCTAssertNotNil(minimalMovie)
    }
    
    func testRatingText() {
        XCTAssertEqual("Rating: ⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️ (9.9)", movie.ratingText)
        XCTAssertEqual("Rating: No rating", minimalMovie.ratingText)
    }
    
    func testOverviewText() {
        XCTAssertEqual("Wissa is a passionate iOS Engineer", movie.overviewText)
        XCTAssertEqual("No Overview Available.", minimalMovie.overviewText)
    }

    func testBackdropUrl() {
        XCTAssertEqual("https://image.tmdb.org/t/p/w300/1.jpg", movie.backdropUrl?.absoluteString)
        XCTAssertNil(minimalMovie?.backdropUrl)
    }
    
    func testPosterUrl() {
        XCTAssertEqual("https://image.tmdb.org/t/p/w300/2.jpg", movie.posterUrl?.absoluteString)
        XCTAssertNil(minimalMovie?.posterUrl)
    }
}

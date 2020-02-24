//
//  MovieDBUrlManagerTests.swift
//  WMDBTests
//
//  Created by Wissa Azmy on 2/18/20.
//  Copyright © 2020 Wissa Azmy. All rights reserved.
//

import XCTest

@testable import WMDB
class MovieDBUrlManagerTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class. /cjTQSwcsfVdirSFSHNBXRGkxmWa.jpg
    }

    func testUrlRequestUrl() {
        let url = MovieDBUrlManager.urlRequest(of: .nowPlaying, page: 1)?.url?.absoluteString
        XCTAssertEqual(url, "https://api.themoviedb.org/3/movie/now_playing?page=1")
    }

    func testImgUrl() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let url = MovieDBUrlManager.imgUrl(for: "/cjTQSwcsfVdirSFSHNBXRGkxmWa.jpg")?.absoluteString
        XCTAssertEqual(url, "https://image.tmdb.org/t/p/w300/cjTQSwcsfVdirSFSHNBXRGkxmWa.jpg")
    }

}

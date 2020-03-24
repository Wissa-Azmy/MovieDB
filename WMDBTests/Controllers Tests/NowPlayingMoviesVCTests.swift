//
//  NowPlayingMoviesVCTests.swift
//  WMDBTests
//
//  Created by Wissa Azmy on 2/14/20.
//  Copyright © 2020 Wissa Azmy. All rights reserved.
//

import XCTest

@testable import WMDB
class NowPlayingMoviesVCTests: XCTestCase {
    var sut: NowPlayingMoviesVC!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = NowPlayingMoviesVC()
        _ = sut.view
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInit_tableViewNotNil() {
        XCTAssertNotNil(sut.tableView)
    }

    func testDataSource_isSet() {
        XCTAssertNotNil(sut.tableView.dataSource)
    }
    
    func testDelegate_isSet() {
        XCTAssertNotNil(sut.tableView.delegate)
    }

}

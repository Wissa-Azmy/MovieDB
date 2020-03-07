//
//  MoviesDataServiceTests.swift
//  WMDBTests
//
//  Created by Wissa Azmy on 2/14/20.
//  Copyright © 2020 Wissa Azmy. All rights reserved.
//

import XCTest

@testable import WMDB
class MoviesDataServiceTests: XCTestCase {
    var apiService: MovieDBAPIServiceMock!
    var sut: MoviesDataService!
    var moviesTableView: UITableView!
    var moviesTVDelegate: NowPlayingMoviesVC!
    var moviesList: [Movie]!

    override func setUp() {
        apiService = ApiServiceMock()
        sut = MoviesDataService(api: apiService)
        moviesTVDelegate = NowPlayingMoviesVC()
        sut.delegate = moviesTVDelegate
        moviesTableView = TableViewMock(dataSource: sut, delegate: moviesTVDelegate)
        
        // Setup data
        let movie = Movie(title: "Movie", overview: "", backdropPath: nil, posterPath: nil, voteAverage: 0.0)
        moviesList = Array(repeating: movie, count: 5)
        sut.movies = moviesList
        sut.totalNumberOfMovies = 5
        sut.filteredMoviesTotalNumber = 6
        moviesTableView.reloadData()
    }

    override func tearDown() {
        moviesTVDelegate.isSearching = false
    }
    
    // MARK: - Test tableview data source methods
    func testTableView_NumberOfSections() {
        XCTAssertEqual(moviesTableView.numberOfSections, 1)
    }
    
    func testTableView_NumberOfRows_forNowPlayingMovies() {
        let numberOfRows = moviesTableView.numberOfRows(inSection: 0)
        XCTAssertEqual(numberOfRows, 5)
    }
    
    func testTableView_NumberOfRows_forFilteredMovies() {
        moviesTVDelegate.isSearching = true
        moviesTableView.reloadData()
        
        let numberOfRows = moviesTableView.numberOfRows(inSection: 0)
        XCTAssertEqual(numberOfRows, 6)
    }
    
    // MARK: - Test Cell
    func testCell_IsMovieCell() {
        let cell = moviesTableView.cellForRow(at: IndexPath(row: 0, section: 0))
        
        XCTAssertNotNil(cell)
        XCTAssertTrue(cell is MovieCell)
    }
    
    func testCell_TitleLabelText() {
        let cell = moviesTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! MovieCell
        
        XCTAssertEqual(cell.titleLbl.text, "Movie")
    }
    
    // MARK: - Test Data Manipulation
    func testUpdateNowPlayingMoviesData() {
        sut.movies.removeAll()
        let queue = DispatchQueue(label: "FileLoaderTests")
        sut.fetch(endpoint: .nowPlaying, on: queue)
        queue.sync {}

        XCTAssertEqual(sut.pageNumber, 2)
        XCTAssertEqual(sut.totalPages, 50)
        XCTAssertEqual(sut.totalNumberOfMovies, 500)
        XCTAssertEqual(sut.movies.count, 7)
    }
    
    func testUpdateFilteredMoviesData() {
        let queue = DispatchQueue(label: "FileLoaderTests")
        sut.fetch(endpoint: .search(""), on: queue)
        queue.sync {}

        XCTAssertEqual(sut.searchPageNumber, 2)
        XCTAssertEqual(sut.filteredTotalPages, 50)
        XCTAssertEqual(sut.filteredMoviesTotalNumber, 500)
        XCTAssertEqual(sut.filteredMovies.count, 7)
    }
    
    func testResetSearchData() {
        sut.searchPageNumber = 5
        sut.filteredTotalPages = 7
        sut.filteredMovies = moviesList
        sut.filteredMoviesTotalNumber = 443
        
        sut.resetSearchData()
        
        XCTAssertEqual(sut.searchPageNumber, 1)
        XCTAssertEqual(sut.filteredTotalPages, 2)
        XCTAssertEqual(sut.filteredMoviesTotalNumber, 0)
        XCTAssertEqual(sut.filteredMovies.count, 0)
    }
    
}


class TableViewMock: UITableView {
    init(dataSource: MoviesDataService, delegate: NowPlayingMoviesVC) {
        super.init(frame: CGRect(x: 0, y: 0, width: 300, height: 500), style: .plain)
        self.dataSource = dataSource
        self.delegate = delegate
        self.register(MovieCell.self, forCellReuseIdentifier: "Cell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class ApiServiceMock: MovieDBAPIServiceMock {
    var page = 1
    let movie = Movie(title: "Movie", overview: "", backdropPath: nil, posterPath: nil, voteAverage: 0.0)
    
    func request(_ endpoint: MovieDBEndpoint, page: Int, completion: @escaping (Result<MoviesResponse, ResponseError>) -> ()) {
        let moviesList = Array(repeating: movie, count: 7)
        let moviesResponse = MoviesResponse(results: moviesList, page: page, totalResults: 500, totalPages: 50)
        
        completion(Result.success(moviesResponse))
    }
}

protocol MovieDBAPIServiceMock: MovieDBAPIService {
    var page: Int { get set }
}

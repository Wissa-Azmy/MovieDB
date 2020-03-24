//
//  MoviesDataService.swift
//  WMDB
//
//  Created by Wissa Azmy on 2/14/20.
//  Copyright © 2020 Wissa Azmy. All rights reserved.
//

import UIKit

protocol MoviesDataServiceDelegate: class {
    func onFetchSuccess(with newIndexPathsToReload: [IndexPath]?)
    func onFetchError(with description: String)
}

protocol Searchable: class {
    var isSearching: Bool { get }
}

class MoviesDataService: NSObject {
    let moviesDBApi: MovieDBAPIService
    weak var delegate: (MoviesDataServiceDelegate & Searchable)?
    private var isFetchInProgress = false
    
    var pageNumber = 1
    var totalPages = 2
    var allMoviesCount = 0
    var searchPageNumber = 1
    var filteredTotalPages = 2
    var filteredMoviesCount = 0
    
    var movies = [Movie]()
    var filteredMovies = [Movie]()
    
    var moviesCount: Int {
        return delegate!.isSearching ? filteredMoviesCount : allMoviesCount
    }
    
    private var loadedMoviesCount: Int {
        return delegate!.isSearching ? filteredMovies.count : movies.count
    }
    
    private var requestPage: Int {
        return delegate!.isSearching ? searchPageNumber : pageNumber
    }
    
    init(api: MovieDBAPIService = APIService()) {
        moviesDBApi = api
    }
}


// MARK: - Networking
extension MoviesDataService {
    func fetch(endpoint: MovieDBEndpoint = .nowPlaying, on queue: DispatchQueue = DispatchQueue.main) {
        guard !isFetchInProgress else { return }
        
        isFetchInProgress = true
        moviesDBApi.request(endpoint, page: requestPage) {  [weak self] (result) in
            guard let self = self else { return }
            queue.async {
                switch result {
                case .failure(let error):
                    self.delegate?.onFetchError(with: error.description)
                case .success(let moviesResponse):
                    switch endpoint {
                    case .nowPlaying:
                        self.updateNowPlayingMoviesData(with: moviesResponse)
                    case .search:
                        self.updateFilteredMoviesData(with: moviesResponse)
                    }
                    DispatchQueue.main.async { // In case a background thread is used
                        self.updateTableView(with: moviesResponse)
                    }
                }
                self.isFetchInProgress = false
            }
        }
    }
}


// MARK: - Private Methods
extension MoviesDataService {
    private func updateNowPlayingMoviesData(with moviesResponse: MoviesResponse) {
        if pageNumber < totalPages {
            pageNumber += 1
        }
        totalPages = moviesResponse.totalPages
        allMoviesCount = moviesResponse.totalResults
        movies.append(contentsOf: moviesResponse.results)
    }
    
    private func updateFilteredMoviesData(with moviesResponse: MoviesResponse) {
        if searchPageNumber < filteredTotalPages {
            searchPageNumber += 1
        }

        filteredTotalPages = moviesResponse.totalPages
        filteredMoviesCount = moviesResponse.totalResults
        filteredMovies.append(contentsOf: moviesResponse.results)
    }
    
    private func updateTableView(with moviesResponse: MoviesResponse) {
        if moviesResponse.page > 1 {
            let indexPathsToReload = self.calculateIndexPathsToReload(from: moviesResponse.results)
            self.delegate?.onFetchSuccess(with: indexPathsToReload)
        } else {
            self.delegate?.onFetchSuccess(with: .none)
        }
    }
    
    /// Calculates the tableView cells index paths to reload for the new movies patch appended to the movies array
    /// - Parameter newMovies: new movies patch added to the movies array from the last fetch
    private func calculateIndexPathsToReload(from newMovies: [Movie]) -> [IndexPath] {
        let startIndex = loadedMoviesCount - newMovies.count
        let endIndex = startIndex + newMovies.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}


// MARK: - Internal Methods
extension MoviesDataService {
    func resetSearchData() {
        searchPageNumber = 1
        filteredTotalPages = 2
        filteredMovies.removeAll()
        filteredMoviesCount = 0
    }
    
    func movie(at index: Int) -> Movie {
        return delegate!.isSearching ? filteredMovies[index] : movies[index]
    }
    
    /// Checks if a cell has its movie data finished downloading by making sure its indexPath is not beyond the downloaded moviesCount.
    /// - Parameter indexPath: The indexPath of the cell to check
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= loadedMoviesCount
    }
}

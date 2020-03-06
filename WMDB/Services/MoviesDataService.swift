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
    var searchPageNumber = 1
    var totalPages = 2
    var filteredTotalPages = 2
    var totalNumberOfMovies = 0
    var filteredMoviesTotalNumber = 0
    var movies = [Movie]()
    var filteredMovies = [Movie]()
    
    private var moviesCount: Int {
        return delegate!.isSearching ? filteredMovies.count : movies.count
    }
    
    private var requestPage: Int {
        return delegate!.isSearching ? searchPageNumber : pageNumber
    }
    
    var queryText: String? {
        didSet {
            if let query = queryText {
                resetSearchData()
                fetch(moviesMatching: query, endpoint: .search)
            }
        }
    }
    
    init(api: MovieDBAPIService = APIService()) {
        moviesDBApi = api
    }
    
    func fetch(moviesMatching query: String = "", endpoint: MovieDBEndpoint = .nowPlaying, on queue: DispatchQueue = DispatchQueue.main) {
        guard !isFetchInProgress else {
            return
        }
        
        isFetchInProgress = true
        moviesDBApi.request(endpoint, page: requestPage, query: query) {  [weak self] (result) in
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
                    self.updateTableView(with: moviesResponse)
                }
                self.isFetchInProgress = false
            }
        }
    }
    
    private func updateNowPlayingMoviesData(with moviesResponse: MoviesResponse) {
        if pageNumber < totalPages {
            pageNumber += 1
        }
        totalPages = moviesResponse.totalPages
        totalNumberOfMovies = moviesResponse.totalResults
        movies.append(contentsOf: moviesResponse.results)
    }
    
    private func updateFilteredMoviesData(with moviesResponse: MoviesResponse) {
        if searchPageNumber < filteredTotalPages {
            searchPageNumber += 1
        }

        filteredTotalPages = moviesResponse.totalPages
        filteredMoviesTotalNumber = moviesResponse.totalResults
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
    
    private func calculateIndexPathsToReload(from newMovies: [Movie]) -> [IndexPath] {
        let startIndex = moviesCount - newMovies.count
        let endIndex = startIndex + newMovies.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    func resetSearchData() {
        searchPageNumber = 1
        filteredTotalPages = 2
        filteredMovies.removeAll()
        filteredMoviesTotalNumber = 0
    }
    
    func selectItem(At index: Int, navigationController: UINavigationController) {
        let vc = MovieDetailsVC()
        // index check is to avoid 'index out of range' if selected cell movie data was not fetched yet.
        if delegate!.isSearching, index < filteredMovies.count {
            vc.movie = filteredMovies[index]
            navigationController.pushViewController(vc, animated: true)
        } else if index < movies.count {
            vc.movie = movies[index]
            navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= moviesCount
    }
}


extension MoviesDataService: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate!.isSearching ? filteredMoviesTotalNumber : totalNumberOfMovies
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MovieCell
        // if the cell at that index path is beyond the count of the movies received so far.
        if isLoadingCell(for: indexPath) {
            cell.configCell(withDataOf: .none)
        } else {
            let movie = delegate!.isSearching ? filteredMovies[indexPath.row] : movies[indexPath.row]
            cell.configCell(withDataOf: movie)
        }
        
        return cell
    }
}


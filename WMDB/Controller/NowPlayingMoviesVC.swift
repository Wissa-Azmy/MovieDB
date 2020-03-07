//
//  ViewController.swift
//  WMDB
//
//  Created by Wissa Azmy on 2/14/20.
//  Copyright © 2020 Wissa Azmy. All rights reserved.
//

import UIKit

class NowPlayingMoviesVC: UITableViewController {
    private let moviesDataService = MoviesDataService()
    private let searchController = UISearchController(searchResultsController: nil)
    private var queryString = ""
    var isSearching = false
    private let activityIndicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.hidesWhenStopped = true
        indicatorView.style = .large
        indicatorView.color = ColorPalette.titleStrip
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        return indicatorView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        moviesDataService.delegate = self
        moviesDataService.fetch()

        setupSearchController()
        setupTableView()
        activityIndicatorView.centerAnchor(in: view)
        activityIndicatorView.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        title = "Now Playing"

        let navBar = navigationController?.navigationBar
        navBar?.barTintColor = .white
        navBar?.prefersLargeTitles = true
        navBar?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: Fonts.title]
        navBar?.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: Fonts.largeTitle]
    }
    

    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Now Playing Movies"
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .white
        tableView.register(MovieCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = moviesDataService
        tableView.prefetchDataSource = self
        tableView.separatorColor = UIColor.clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.clipsToBounds = false
        tableView.addSubview(activityIndicatorView)
    }
}


// MARK: - TableView Delegate Methods
extension NowPlayingMoviesVC {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        moviesDataService.selectItem(At: indexPath.row, navigationController: navigationController!)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
}


// MARK: - Movies DataSource delegate Methods
extension NowPlayingMoviesVC: MoviesDataServiceDelegate {
    func onFetchSuccess(with newIndexPathsToReload: [IndexPath]?) {
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }
            return
        }
        
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        guard !indexPathsToReload.isEmpty else {
            tableView.reloadData()
            return
        }
        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }
    
    private func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
    
    func onFetchError(with description: String) {
        activityIndicatorView.stopAnimating()
        
        let title = "Error"
        let action = UIAlertAction(title: "OK", style: .default)
        let APIFailureAlert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        APIFailureAlert.addAction(action)
        present(APIFailureAlert, animated: true)
    }
}


// MARK: - DataSource prefetching Methods
extension NowPlayingMoviesVC: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    if indexPaths.contains(where: moviesDataService.isLoadingCell) {
        if isSearching {
            moviesDataService.fetch(endpoint: .search(queryString))
        } else {
            moviesDataService.fetch()
        }
    }
  }
}


// MARK: - UISearch Controller Methods
extension NowPlayingMoviesVC: UISearchResultsUpdating, UISearchBarDelegate, Searchable {
    func updateSearchResults(for searchController: UISearchController) {
        queryString = searchController.searchBar.text ?? ""
        if !queryString.trimmingCharacters(in: .whitespaces).isEmpty {
            isSearching = true
            moviesDataService.queryText = queryString
        } else {
            isSearching = false
            moviesDataService.fetch()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        queryString = ""
        isSearching = false
        moviesDataService.resetSearchData()
        moviesDataService.fetch()
    }
}



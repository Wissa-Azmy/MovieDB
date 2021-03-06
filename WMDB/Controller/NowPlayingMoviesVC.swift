//
//  ViewController.swift
//  WMDB
//
//  Created by Wissa Azmy on 2/14/20.
//  Copyright © 2020 Wissa Azmy. All rights reserved.
//

import UIKit

class NowPlayingMoviesVC: UIViewController {
    let moviesDataService = MoviesDataService()
    var tableView: MoviesTableView!
    private var queryString = ""
    var isSearching = false
    private var isError = false
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.hidesWhenStopped = true
        indicatorView.style = .large
        indicatorView.color = ColorPalette.titleStrip
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        return indicatorView
    }()
    
    override func loadView() {
        super.loadView()
        view = UIView()
        view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        setupSearchController()
        setupTableView()
        moviesDataService.delegate = self
        moviesDataService.fetch()
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
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Now Playing Movies"
        self.navigationItem.searchController = searchController
    }
    
    private func setupTableView() {
        tableView = MoviesTableView(dataService: moviesDataService, navigationDelegate: self)
        tableView.prefetchDataSource = self
        tableView.addSubview(activityIndicatorView)
        view.addSubview(tableView)
        tableView.anchors(to: view)
    }
}


// MARK: - Movies Data Service delegate Methods
extension NowPlayingMoviesVC: MoviesDataServiceDelegate {
    func onFetchSuccess(with newIndexPathsToReload: [IndexPath]?) {
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            self.activityIndicatorView.stopAnimating()
            self.tableView.reloadData()
            
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
        if !isError { // To avoid warning while trying to show multiple alerts in the same time
            isError = true
            let APIFailureAlert = UIAlertController(title: "Error", message: description, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default) { (_) in self.isError = false }
            APIFailureAlert.addAction(action)
            present(APIFailureAlert, animated: true)
        }
    }
}


// MARK: - UISearch Controller Methods
extension NowPlayingMoviesVC: UISearchResultsUpdating, UISearchBarDelegate, Searchable {
    func updateSearchResults(for searchController: UISearchController) {
        queryString = searchController.searchBar.text ?? ""
        if !queryString.trimmingCharacters(in: .whitespaces).isEmpty {
            isSearching = true
            moviesDataService.resetSearchData()
            moviesDataService.fetch(endpoint: .search(queryString))
        } else {
            isSearching = false
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        queryString = ""
        isSearching = false
        moviesDataService.resetSearchData()
        moviesDataService.fetch()
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

extension NowPlayingMoviesVC: TableViewNavigationDelegate {
    func navigate(to vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
}



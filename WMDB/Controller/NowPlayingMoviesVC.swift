//
//  ViewController.swift
//  WMDB
//
//  Created by Wissa Azmy on 2/14/20.
//  Copyright © 2020 Wissa Azmy. All rights reserved.
//

import UIKit

class NowPlayingMoviesVC: UITableViewController {
    let moviesDataService = MoviesDataService()
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
        tableView = MoviesTableView(dataService: moviesDataService)
        tableView.addSubview(activityIndicatorView)
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
        
        let title = "Error"
        let action = UIAlertAction(title: "OK", style: .default)
        let APIFailureAlert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        APIFailureAlert.addAction(action)
        present(APIFailureAlert, animated: true)
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



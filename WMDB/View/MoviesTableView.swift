//
//  MoviesTableView.swift
//  WMDB
//
//  Created by Wissa Azmy on 3/24/20.
//  Copyright © 2020 Wissa Azmy. All rights reserved.
//

import UIKit

protocol TableViewNavigationDelegate: class {
    func navigate(to vc: UIViewController)
}

class MoviesTableView: UITableView {
    private var moviesDataService: MoviesDataService!
    private weak var navigationDelegate: TableViewNavigationDelegate!
    var isSearching = false
    
    convenience init(dataService: MoviesDataService, navigationDelegate: TableViewNavigationDelegate? = nil) {
        self.init()
        self.moviesDataService = dataService
        self.backgroundColor = .white
        self.translatesAutoresizingMaskIntoConstraints = false
        self.register(MovieCell.self, forCellReuseIdentifier: "Cell")
        self.dataSource = self
        self.delegate = self
        self.navigationDelegate = navigationDelegate
        self.separatorColor = UIColor.clear
        self.clipsToBounds = false
    }

}

// MARK: - TableView Data Source Methods
extension MoviesTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesDataService.moviesCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MovieCell
        
        if moviesDataService.isLoadingCell(for: indexPath) {
            cell.configCell(withDataOf: .none)
        } else {
            cell.configCell(withDataOf: moviesDataService.movie(at: indexPath.row))
        }
        
        return cell
    }
}

// MARK: - TableView Delegate Methods
extension MoviesTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard !moviesDataService.isLoadingCell(for: indexPath) else { return }
               
        let vc = MovieDetailsVC()
        vc.movie = moviesDataService?.movie(at: indexPath.row)
        navigationDelegate?.navigate(to: vc)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
}


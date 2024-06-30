//
//  MDMoviesListViewController+TableView.swift
//  MovieDirectory
//
//  Created by IndianRenters on 30/06/24.
//

import Foundation
import UIKit

extension MDMoviesListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(identifier: MDHomeListMovieCell.identifier, type: MDHomeListMovieCell.self)
        cell.configure(list[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MDMovieDetailViewController") as? MDMovieDetailViewController {
            vc.movie = list[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
}

//
//  MDHomeViewController+TableView.swift
//  MovieDirectory
//
//  Created by IndianRenters on 30/06/24.
//

import Foundation
import UIKit

extension MDHomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isSearching ? 1 : sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return viewModel.filteredMoviesCount
        }
        if collapsedSections.contains(section) {
            return 0
        } else {
            switch sections[section] {
            case .year:
                return viewModel.yearCount
            case .genre:
                return viewModel.genreCount
            case .directors:
                return viewModel.directorCount
            case .actors:
                return viewModel.actorCount
            case .movies:
                return viewModel.moviesCount
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isSearching {
            let cell = tableView.dequeueCell(identifier: MDHomeListMovieCell.identifier, type: MDHomeListMovieCell.self)
            cell.configure(viewModel.filteredMovies[indexPath.row])
            
            return cell
        } else {
            if sections[indexPath.section] == .movies {
                let cell = tableView.dequeueCell(identifier: MDHomeListMovieCell.identifier, type: MDHomeListMovieCell.self)
                cell.configure(viewModel.movies[indexPath.row])
                
                return cell
            } else {
                
                let cell = tableView.dequeueCell(identifier: MDHomeListViewCell.identifier, type: MDHomeListViewCell.self)
                switch sections[indexPath.section] {
                    
                case .year:
                    cell.configure(with: viewModel.yearList[indexPath.row])
                case .genre:
                    cell.configure(with: viewModel.genreList[indexPath.row])
                case .directors:
                    cell.configure(with: viewModel.directorList[indexPath.row])
                case .actors:
                    cell.configure(with: viewModel.actorList[indexPath.row])
                case .movies:
                    cell.configure(with: viewModel.movies[indexPath.row].title)
                }
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return isSearching ? 0 : 45
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! ExpandableHeaderView
        header.titleLabel.text = sections[section].description()
        header.section = section
        header.delegate = self
        header.setCollapsed(collapsed: collapsedSections.contains(section))
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isSearching {
            var list: [MovieElement] = []
            var header: String  = ""
            switch sections[indexPath.section] {
            case .year:
                list = viewModel.getListFor(item: viewModel.yearList[indexPath.row], element: .year)
                header = viewModel.yearList[indexPath.row]
            case .genre:
                list = viewModel.getListFor(item: viewModel.genreList[indexPath.row], element: .genre)
                header = viewModel.genreList[indexPath.row]
            case .directors:
                list = viewModel.getListFor(item: viewModel.directorList[indexPath.row], element: .directors)
                header = viewModel.directorList[indexPath.row]
            case .actors:
                list = viewModel.getListFor(item: viewModel.actorList[indexPath.row], element: .actors)
                header = viewModel.actorList[indexPath.row]
            case .movies:
                if let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MDMovieDetailViewController") as? MDMovieDetailViewController {
                    vc.movie = viewModel.movies[indexPath.row]
                    self.navigationController?.pushViewController(vc, animated: true)
                    return
                }
            }
            
            if let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MDMoviesListViewController") as? MDMoviesListViewController {
                vc.list = list
                vc.titleValue = header
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            if let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MDMovieDetailViewController") as? MDMovieDetailViewController {
                vc.movie = viewModel.filteredMovies[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }
        }
    }
    
    
}

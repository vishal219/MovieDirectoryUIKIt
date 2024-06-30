//
//  MDHomeViewController+Search.swift
//  MovieDirectory
//
//  Created by IndianRenters on 30/06/24.
//

import Foundation
import UIKit

extension MDHomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard self.predictiveText == nil else { return true}
        searchTask?.cancel()
        
        //if search button tapped
        if text == "\n" {
            searchBar.resignFirstResponder()
            return false
        }
        guard let newText = (searchBar.text as NSString?)?.replacingCharacters(in: range, with: text),newText.count > 0 else {
            self.isSearching = false
            
            self.tableView.reloadData()
            return true
        }
        
        let task = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.isSearching = true
            self.viewModel.filterLists(newText)
           // self.tableView.reloadData()
        }

        searchTask = task
        //Debouncing
        searchQueue.asyncAfter(deadline: .now() + .milliseconds(300), execute: task)
       
        return true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let text = searchBar.text,text.count > 0 {
            self.isSearching = true
            
        } else {
            self.isSearching = false
            
        }
        
    }
    
    
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.isSearching = true
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //Reset data on empty search query
        if searchText == "" {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.isSearching = false
                self.tableView.reloadData()
            }
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text,text.count > 0 {
            self.isSearching = true
        } else {
            self.isSearching = false
        }
        
    }

    
}

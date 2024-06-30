//
//  ViewController.swift
//  MovieDirectory
//
//  Created by IndianRenters on 29/06/24.
//

import UIKit

class MDHomeViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - Properties
    ///sections in list
    var sections : [FilterCategory] = [.year, .genre, .directors, .actors, .movies]
    ///collapsed sections index list
    var collapsedSections : Set<Int> = [0,1,2,3,4]
    ///queue for searching
    var searchQueue: DispatchQueue = DispatchQueue(label: "com.example.searchQueue", qos: .userInitiated, attributes: .concurrent)
    ///task for searching users
    var searchTask: DispatchWorkItem?
    ///bool value stating whether the user is searching or not
    var isSearching: Bool = false
    ///predictive text to disable hit for auto correction
    var predictiveText: String?
    ///view model
    var viewModel = MDHomeListViewModel()
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        setupTableView()
        customizeSearchBarPlaceholder()
        setupVieWModel()
    }
    
    //MARK: - Methods
    func setupUI() {
        view.backgroundColor = .white
        tableView.backgroundColor = .clear
        titleTextLabel.textColor = .black
        titleTextLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        searchBar.barTintColor = .white
        searchBar.delegate = self
        searchBar.searchTextField.textColor = .black
    }
    
    func setupTableView() {
        tableView.register(ExpandableHeaderView.self, forHeaderFooterViewReuseIdentifier: "header")
        tableView.registerCell(nibName: MDHomeListViewCell.identifier)
        tableView.registerCell(nibName: MDHomeListMovieCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = .black
    }
    
    func customizeSearchBarPlaceholder() {
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            let placeholderText = "Search movies by Title/Actor/Genre/Director"
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.gray 
            ]
            textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        }
        
        // Customize search icon
        if let leftView = searchBar.searchTextField.leftView as? UIImageView {
            leftView.tintColor = UIColor.gray // Optionally set the tint color
        }
    }
    
    func setupVieWModel() {
        viewModel.loadJSONData()
        
        viewModel.dataLoaded = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                tableView.reloadData()
            }
        }
    }
    
}




extension MDHomeViewController: ExpandableHeaderViewDelegate {
    func toggleSection(header: ExpandableHeaderView, section: Int) {
        let collapsed = !collapsedSections.contains(section)
        
        if collapsed {
            collapsedSections.insert(section)
        } else {
            collapsedSections.remove(section)
        }
        
        header.setCollapsed(collapsed: collapsed)
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
    
    
}

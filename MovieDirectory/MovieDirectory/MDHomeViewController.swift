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
    
    
    var sections : [FilterCategory] = [.year, .genre, .directors, .actors, .movies]
    var collapsedSections : Set<Int> = [0,1,2,3,4]
    ///queue for searching
    private var searchQueue: DispatchQueue = DispatchQueue(label: "com.example.searchQueue", qos: .userInitiated, attributes: .concurrent)
    ///task for searching users
    private var searchTask: DispatchWorkItem?
    ///bool value stating whether the user is searching or not
    private var isSearching: Bool = false
    ///predictive text to disable hit for auto correction
    private var predictiveText: String?
    
    var viewModel = MDHomeListViewModel()
    
    //MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        setupTableView()
        customizeSearchBarPlaceholder()
        setupVieWModel()
    }
    
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


extension UITableView {
    
    func assignDelegate(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        self.delegate = delegate
        self.dataSource = dataSource
    }
    
    func setContentInset(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
        self.contentInset = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    
    func registerCell(nibName: String) {
        self.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
    }
    
    func dequeueCell<T>(identifier: String, type: T.Type) -> T {
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}



//MARK: - Search bar delegates and data source

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

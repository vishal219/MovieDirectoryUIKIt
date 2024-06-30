//
//  MDMoviesListViewController.swift
//  MovieDirectory
//
//  Created by IndianRenters on 29/06/24.
//

import UIKit

class MDMoviesListViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Properties
    ///movies list
    var list: [MovieElement] = []
    ///title of the filter
    var titleValue: String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        titleLabel.text = titleValue
        tableView.reloadData()
    }
    
    ///setup User Interface
    func setupUI() {
        titleLabel.textColor = .black
        view.backgroundColor = .white
        tableView.backgroundColor = .clear
        tableView.registerCell(nibName: MDHomeListMovieCell.identifier)
        tableView.assignDelegate(delegate: self, dataSource: self)
    }

}



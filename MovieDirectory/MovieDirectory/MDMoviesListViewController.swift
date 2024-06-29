//
//  MDMoviesListViewController.swift
//  MovieDirectory
//
//  Created by IndianRenters on 29/06/24.
//

import UIKit

class MDMoviesListViewController: UIViewController {
    
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var list: [MovieElement] = []
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
    
    
    func setupUI() {
        titleLabel.textColor = .black
        view.backgroundColor = .white
        tableView.backgroundColor = .clear
        tableView.registerCell(nibName: MDHomeListMovieCell.identifier)
        tableView.assignDelegate(delegate: self, dataSource: self)
    }

    

}


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

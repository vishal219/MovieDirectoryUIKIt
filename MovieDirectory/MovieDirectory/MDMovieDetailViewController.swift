//
//  MDMovieDetailViewController.swift
//  MovieDirectory
//
//  Created by IndianRenters on 30/06/24.
//

import UIKit

class MDMovieDetailViewController: UIViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var plotView: UIView!
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var plotValueLabel: UILabel!
    @IBOutlet weak var castView: UIView!
    @IBOutlet weak var castLabel: UILabel!
    @IBOutlet weak var castValueLabel: UILabel!
    @IBOutlet weak var genreView: UIView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var genreValueLabel: UILabel!
    @IBOutlet weak var releasedView: UIView!
    @IBOutlet weak var releasedLabel: UILabel!
    @IBOutlet weak var releasedValueLabel: UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingValueLabel: UILabel!
    @IBOutlet weak var ratingButton: UIButton!

    //MARK: Properties
    var movie: MovieElement? = nil
    
    //MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        guard let movie = movie else {
            return
        }
        
        movieImageView.sd_setImage(with: URL(string: movie.poster))
        titlelabel.text = movie.title
        plotValueLabel.text = movie.plot
        castValueLabel.text = movie.actors
        releasedValueLabel.text = movie.released
        genreValueLabel.text = movie.genre
        
    }
    
    
    func setupUI() {
        view.backgroundColor = .white
        [plotView,castView,releasedView,genreView,ratingView].forEach({ view in
            view?.backgroundColor = .clear
        })
        
        [titlelabel,plotValueLabel,castValueLabel,releasedValueLabel,genreValueLabel].forEach({ view in
            view?.numberOfLines = 0
            view?.textColor = .black
            //view?.font = UIFont().withSize(14.0)
        })
        
      //  titlelabel.font = UIFont().withSize(18.0)
        
        [plotLabel,castLabel,releasedLabel,genreLabel].forEach({ view in
            view?.numberOfLines = 0
           // view?.font = UIFont().withSize(16.0)
        })
        
        plotLabel.text = "Plot"
        castLabel.text = "Cast"
        releasedLabel.text = "Released"
        genreLabel.text = "Genre"
        ratingLabel.text = "Rating"
        
    }

}

//
//  MDHomeListMovieCell.swift
//  MovieDirectory
//
//  Created by IndianRenters on 29/06/24.
//

import UIKit
import SDWebImage

class MDHomeListMovieCell: UITableViewCell {
    
    //MARK: Outlets
    @IBOutlet weak var moviesImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieLanguageTextLabel: UILabel!
    @IBOutlet weak var movieLanguageContentLabel: UILabel!
    @IBOutlet weak var movieYearLabel: UILabel!
    @IBOutlet weak var movieYearContentLabel: UILabel!
    
    ///identifier
    static let identifier = "MDHomeListMovieCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setupUI()
        // Configure the view for the selected state
    }
    
    ///setup user interface
    func setupUI() {
        contentView.backgroundColor = .white
        
        [movieTitleLabel,movieYearLabel,movieYearContentLabel,movieLanguageTextLabel, movieLanguageContentLabel].forEach({view in
            view?.textColor = .black
        })
    }
    
    
    /// configure cell for given movie
    /// - Parameter movie: Object describing movie details
    func configure(_ movie: MovieElement) {
        moviesImageView.sd_setImage(with: URL(string: movie.poster))
        
        movieLanguageTextLabel.text = AppTexts.language
        movieYearLabel.text  = AppTexts.year
        
        movieTitleLabel.text = movie.title
        movieLanguageContentLabel.text = movie.language
        if let last = movie.year.last, last == "–" {
            movieYearContentLabel.text = movie.year + AppTexts.present
        } else {
            movieYearContentLabel.text = movie.year
        }
        
    }
}

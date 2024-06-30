//
//  MDHomeListViewCell.swift
//  MovieDirectory
//
//  Created by IndianRenters on 29/06/24.
//

import UIKit

class MDHomeListViewCell: UITableViewCell {
    
    //MARK: Outlets
    @IBOutlet weak var titleLabel: UILabel!
    
    ///identifier
    static let identifier = "MDHomeListViewCell"


    //MARK: Lifecycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setupUI()
        // Configure the view for the selected state
    }
    
    ///setup user interface
    func setupUI() {
        contentView.backgroundColor = .white
        titleLabel.textColor = .black
    }
    
    /// configure cell for given string
    /// - Parameter value: list value to be shown
    func configure(with value: String) {
        if value.last == "–" {
            titleLabel.text = value + " \(AppTexts.present)"
        } else {
            titleLabel.text = value
        }
    }
    
}

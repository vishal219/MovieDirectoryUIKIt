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
    
    func setupUI() {
        contentView.backgroundColor = .white
        titleLabel.textColor = .black
    }
    
    func configure(with value: String) {
        if value.last == "–" {
            titleLabel.text = value + " Present"
        } else {
            titleLabel.text = value
        }
    }
    
}

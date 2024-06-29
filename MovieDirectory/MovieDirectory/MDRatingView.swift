//
//  MDRatingView.swift
//  MovieDirectory
//
//  Created by IndianRenters on 30/06/24.
//

import UIKit




class MDRatingView: UIView {

    private let sourceLabel = UILabel()
    private let valueLabel = UILabel()
    private let progressBar = UIProgressView(progressViewStyle: .default)
    private let starStackView = UIStackView()

    init(rating: Rating) {
        super.init(frame: .zero)
        setupView(rating: rating)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func configure(_ rating: Rating) {
        setupView(rating: rating)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView(rating: Rating) {
        sourceLabel.text = rating.source.rawValue
        sourceLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        valueLabel.font = UIFont.systemFont(ofSize: 16)
        valueLabel.textAlignment = .right

        let stackView = UIStackView(arrangedSubviews: [sourceLabel, valueLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8.0
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
        ])

        if rating.source.rawValue == "Internet Movie Database" {
            setupStarRating(rating.value)
        } else if rating.value.contains("%") {
            setupProgressBar(value: rating.value, maxValue: 100)
        } else if rating.value.contains("/100") {
            setupProgressBar(value: rating.value, maxValue: 100)
        }

        valueLabel.text = rating.value
    }

    private func setupStarRating(_ value: String) {
        let rating = Double(value.split(separator: "/")[0]) ?? 0
        let starCount = Int(rating.rounded())

        starStackView.axis = .horizontal
        starStackView.spacing = 4.0
        addSubview(starStackView)

        for _ in 1...starCount {
            let starImageView = UIImageView(image: UIImage(systemName: "star.fill"))
            starImageView.tintColor = .yellow
            starStackView.addArrangedSubview(starImageView)
        }

        starStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            starStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            starStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            starStackView.topAnchor.constraint(equalTo: sourceLabel.bottomAnchor, constant: 8),
            starStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    private func setupProgressBar(value: String, maxValue: Int) {
        guard let numericValue = value.split(separator: "/").first ?? value.split(separator: "%").first,
              let rating = Float(numericValue) else { return }

        progressBar.progress = rating / Float(maxValue)
        addSubview(progressBar)

        progressBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            progressBar.topAnchor.constraint(equalTo: sourceLabel.bottomAnchor, constant: 8),
            progressBar.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}


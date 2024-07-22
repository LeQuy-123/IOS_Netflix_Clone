//
//  UppcommingTableViewCell.swift
//  Netflix clone
//
//  Created by mac on 14/7/24.
//

import UIKit


protocol MovieTableViewCellDelegate: AnyObject {
    func MovieTableViewCellDelegate(_ cell: MovieTableViewCell, viewModel: TitlePreviewModel)
}

class MovieTableViewCell: UITableViewCell {
    static let identifier = "UppcommingTableViewCell"
    
    private let playButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        return button
    }()
    private let titleDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 5// Allow multiple lines
        label.lineBreakMode = .byTruncatingTail // Wrap text at word boundaries
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2 // Allow multiple lines
        label.lineBreakMode = .byTruncatingTail // Wrap text at word boundaries
        return label
    }()
    private let posterImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(titleDescription)

        contentView.addSubview(playButton)
        
        applyContrains()
        
    }
 
    private func applyContrains() {
        let contraints = [
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            posterImageView.widthAnchor.constraint(equalToConstant: 100),
            
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            
            titleDescription.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10),
            titleDescription.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            titleDescription.trailingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: -10),

            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 50),  // Set a fixed width for the button
            playButton.heightAnchor.constraint(equalToConstant: 30)  // Set a fixed height for the button
             
        ]
        NSLayoutConstraint.activate(contraints)
    }
    
    public func configure(with model: TitleViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterUrl)") else {return}
        posterImageView.sd_setImage(with: url, completed: nil)
        titleLabel.text =  model.titleName
        titleDescription.text = model.description
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
 
}

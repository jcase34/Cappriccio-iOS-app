//
//  PracticeSessionTableViewCell.swift
//  Lento
//
//  Created by Jacob Case on 1/13/23.
//

import UIKit

class PracticeSessionTableViewCell: UITableViewCell {
    
    //Cell Properties
    static let identifier = "PracticeSessionCell"
    
    //Outlets
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "helvetica", size: 16)
        label.textColor = .systemGray
        return label
    }()
    
    let MinutesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "helvetica", size: 14)
        label.textColor = .systemGray
        return label
    }()
    
    let majorScaleDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "helvetica", size: 14)
        label.text = "♯Major Scale:"
        label.textColor = .systemGray
        return label
    }()
    
    let majorScaleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "helvetica", size: 14)
        return label
    }()
    
    let minorScaleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "helvetica", size: 14)
        return label
    }()
    
    let minorScaleDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "helvetica", size: 14)
        label.text = "♭Minor Scale:"
        label.textColor = .systemGray
        return label
    }()
    
    let mainPieceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "helvetica", size: 14)
        return label
    }()
    
    let mainPieceDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "helvetica", size: 14)
        label.text = "🎼Main Piece:"
        label.textColor = .systemGray
        return label
    }()
    
    let sightReadingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "helvetica", size: 14)
        return label
    }()
    
    let sightReadingDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "helvetica", size: 14)
        label.text = "📝Sight Reading:"
        label.textColor = .systemGray
        return label
    }()
    
    let improvLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "helvetica", size: 14)
        return label
    }()
    
    let improvDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "helvetica", size: 14)
        label.text = "🎶Improvisation:"
        label.textColor = .systemGray
        return label
    }()
    
    let repertoireLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "helvetica", size: 14)
        return label
    }()
    
    let repertoireDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "helvetica", size: 14)
        label.text = "🗄️Repertoire:"
        label.textColor = .systemGray
        return label
    }()
    
    let sessionImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(systemName: "pianokeys")
        imageView.tintColor = .black
        return imageView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        MinutesLabel.translatesAutoresizingMaskIntoConstraints = false
        majorScaleLabel.translatesAutoresizingMaskIntoConstraints = false
        majorScaleDescription.translatesAutoresizingMaskIntoConstraints = false
        minorScaleLabel.translatesAutoresizingMaskIntoConstraints = false
        minorScaleDescription.translatesAutoresizingMaskIntoConstraints = false
        mainPieceLabel.translatesAutoresizingMaskIntoConstraints = false
        mainPieceDescription.translatesAutoresizingMaskIntoConstraints = false
        sightReadingLabel.translatesAutoresizingMaskIntoConstraints = false
        sightReadingDescription.translatesAutoresizingMaskIntoConstraints = false
        improvLabel.translatesAutoresizingMaskIntoConstraints = false
        improvDescription.translatesAutoresizingMaskIntoConstraints = false
        repertoireLabel.translatesAutoresizingMaskIntoConstraints = false
        repertoireDescription.translatesAutoresizingMaskIntoConstraints = false
        sessionImageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(MinutesLabel)
        contentView.addSubview(majorScaleLabel)
        contentView.addSubview(majorScaleDescription)
        contentView.addSubview(minorScaleLabel)
        contentView.addSubview(minorScaleDescription)
        contentView.addSubview(mainPieceLabel)
        contentView.addSubview(mainPieceDescription)
        contentView.addSubview(sightReadingLabel)
        contentView.addSubview(sightReadingDescription)
        contentView.addSubview(improvLabel)
        contentView.addSubview(improvDescription)
        contentView.addSubview(repertoireLabel)
        contentView.addSubview(repertoireDescription)
        contentView.addSubview(sessionImageView)
        
        configureImageView()
        configureDateLabel()
        configureMinutesLabel()
        configureMajorScale()
        configureMinorScale()
        configureMainPiece()
        configureSightReading()
        configureImprovsiation()
        configureRepertoire()
        
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 2
        
        
    }
    
    func configureImageView() {
        NSLayoutConstraint.activate([
            sessionImageView.widthAnchor.constraint(equalToConstant: 60),
            sessionImageView.heightAnchor.constraint(equalToConstant: 60),
            sessionImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            sessionImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20)
            ])
    }
    
    func configureDateLabel() {
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 45),
            dateLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 25)
            ])
    }
    
    func configureMinutesLabel() {
        NSLayoutConstraint.activate([
            MinutesLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor),
            MinutesLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 30)
            ])
    }
    
    func configureMajorScale() {
        NSLayoutConstraint.activate([
            majorScaleDescription.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            majorScaleDescription.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 100),
            
            majorScaleLabel.topAnchor.constraint(equalTo: majorScaleDescription.bottomAnchor),
            majorScaleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 120)
            
            ])
    }
    
    func configureMinorScale() {
        NSLayoutConstraint.activate([
            minorScaleDescription.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            minorScaleDescription.leadingAnchor.constraint(equalTo: majorScaleDescription.leadingAnchor, constant: 120),
            
            minorScaleLabel.topAnchor.constraint(equalTo: minorScaleDescription.bottomAnchor),
            minorScaleLabel.leadingAnchor.constraint(equalTo: majorScaleLabel.leadingAnchor, constant: 120)
            
            ])
    }
    
    func configureMainPiece() {
        NSLayoutConstraint.activate([
            mainPieceDescription.topAnchor.constraint(equalTo: self.majorScaleLabel.topAnchor, constant: 25),
            mainPieceDescription.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 100),
            
            mainPieceLabel.topAnchor.constraint(equalTo: mainPieceDescription.bottomAnchor),
            mainPieceLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 120)
            
            ])
    }
    
    func configureSightReading() {
        NSLayoutConstraint.activate([
            sightReadingDescription.topAnchor.constraint(equalTo: self.mainPieceLabel.topAnchor, constant: 25),
            sightReadingDescription.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 100),

            sightReadingLabel.topAnchor.constraint(equalTo: sightReadingDescription.bottomAnchor),
            sightReadingLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 120)

            ])
    }

    func configureImprovsiation() {
        NSLayoutConstraint.activate([
            improvDescription.topAnchor.constraint(equalTo: self.sightReadingLabel.topAnchor, constant: 25),
            improvDescription.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 100),

            improvLabel.topAnchor.constraint(equalTo: improvDescription.bottomAnchor),
            improvLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 120)

            ])
    }

    func configureRepertoire() {
        NSLayoutConstraint.activate([
            repertoireDescription.topAnchor.constraint(equalTo: self.improvLabel.topAnchor, constant: 25),
            repertoireDescription.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 100),

            repertoireLabel.topAnchor.constraint(equalTo: repertoireDescription.bottomAnchor),
            repertoireLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 120)

            ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    
    
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

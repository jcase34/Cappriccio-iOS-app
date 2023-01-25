//
//  PracticeTableViewCell.swift
//  Lento
//
//  Created by Jacob Case on 1/24/23.
//

import UIKit

class PracticeTableViewCell: UITableViewCell {
    
    //Cell Properties
    static let identifier = "PracticeSessionCell"

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var majorScaleLabel: UILabel!
    @IBOutlet weak var mainPieceLabel: UILabel!
    @IBOutlet weak var sightReadingLabel: UILabel!
    @IBOutlet weak var minorScaleLabel: UILabel!
    @IBOutlet weak var improvisationLabel: UILabel!
    @IBOutlet weak var repertoireLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 2
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }

}

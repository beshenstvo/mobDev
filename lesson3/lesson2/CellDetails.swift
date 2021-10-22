//
//  CellDetails.swift
//  lesson2
//
//  Created by Rufus on 22.10.2021.
//

import UIKit

class CellDetails: UITableViewCell {

    @IBOutlet weak var TrackView: UIView!
    @IBOutlet weak var TrackImage: UIImageView!
    @IBOutlet weak var TrackNameLabel: UILabel!
    @IBOutlet weak var TrackArtistNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  DetailTableViewCell.swift
//  lesson4
//
//  Created by Rufus on 26.10.2021.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    @IBOutlet weak var TableViewDetail: UIView!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var labelView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

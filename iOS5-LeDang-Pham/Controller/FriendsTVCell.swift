//
//  FriendsTVCell.swift
//  iOS5-LeDang-Pham
//
//  Created by Kim on 15.12.20.
//

import UIKit

class FriendsTVCell: UITableViewCell {

    @IBOutlet weak var friendsText: UITextField!
    
    @IBOutlet weak var friendName: UILabel!
    
    @IBOutlet weak var friendAddress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

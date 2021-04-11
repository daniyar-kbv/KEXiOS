//
//  SuggestCell.swift
//  yandex-map
//
//  Created by Arystan on 4/6/21.
//

import UIKit

class SuggestCell: UITableViewCell {

    @IBOutlet weak var addressTitle: UILabel!
    @IBOutlet weak var subtitleTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

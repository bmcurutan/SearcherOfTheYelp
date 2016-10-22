//
//  DropdownCell.swift
//  Yelp
//
//  Created by Bianca Curutan on 10/21/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

//
//  SwitchCell.swift
//  Yelp
//
//  Created by Bianca Curutan on 10/20/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class DropdownCell: UITableViewCell {
    
    @IBOutlet weak var dropdownLabel: UILabel!
    // TODO @IBOutlet weak var onSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

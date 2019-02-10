//
//  TaskDatePickerTableViewCell.swift
//  KeepYourMind
//
//  Created by Yuki Nagashima on 2019/02/10.
//  Copyright © 2019 yuki-n.inc. All rights reserved.
//

import UIKit

class TaskDatePickerTableViewCell: UITableViewCell {
    
    @IBOutlet var taskIndexLabel: UILabel!
    @IBOutlet var dateTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

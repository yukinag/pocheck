//
//  TaskTitleTableViewCell.swift
//  KeepYourMind
//
//  Created by Yuki Nagashima on 2019/01/01.
//  Copyright © 2019 yuki-n.inc. All rights reserved.
//

import UIKit

class TaskTitleTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet var taskTitle: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

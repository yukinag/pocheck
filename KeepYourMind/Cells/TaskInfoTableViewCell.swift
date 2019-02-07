//
//  TaskInfoTableViewCell.swift
//  KeepYourMind
//
//  Created by Yuki Nagashima on 2019/01/01.
//  Copyright © 2019 yuki-n.inc. All rights reserved.
//

import UIKit

class TaskInfoTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet var taskIndexLabel: UILabel!
    @IBOutlet var taskTextField: UITextField!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }



    
}

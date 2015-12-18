//
//  TextFieldCell.swift
//  ABA
//
//  Created by Edward Suczewski on 12/16/15.
//  Copyright © 2015 Edward Suczewski. All rights reserved.
//

import UIKit

class TextFieldCell: UITableViewCell {

    
    @IBOutlet weak var textField: UITextField!
    
    func updateWithText(text: String) {
        textField.text = text
    }
}

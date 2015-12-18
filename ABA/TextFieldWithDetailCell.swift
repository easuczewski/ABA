//
//  TextFieldWithDetailCell.swift
//  ABA
//
//  Created by Edward Suczewski on 12/16/15.
//  Copyright © 2015 Edward Suczewski. All rights reserved.
//

import UIKit

class TextFieldWithDetailCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var detailLabel: UILabel!

    func updateWithText(text: String, detail: String) {
        textField.text = text
        detailLabel.text = detail
    }
}

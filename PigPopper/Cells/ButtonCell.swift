//
//  ButtonCell.swift
//  PigPopper
//
//  Created by Evan Corriere on 9/10/20.
//  Copyright © 2020 Evan Corriere. All rights reserved.
//

import UIKit

class ButtonCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupWith(label: String, key: String) {
        self.label.text = label
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        print("click")
    }
}

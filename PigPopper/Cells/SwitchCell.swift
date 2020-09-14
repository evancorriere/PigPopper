//
//  TableViewCell.swift
//  PigPopper
//
//  Created by Evan Corriere on 9/10/20.
//  Copyright © 2020 Evan Corriere. All rights reserved.
//

import UIKit

class SwitchCell: UITableViewCell {

    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var selection: UISwitch!
    
    var key: String?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initWithKey(key: String) {
        self.key = key
        selection.addTarget(self, action: #selector(toggle), for: .valueChanged)
        // TODO
        self.selection.setOn(true, animated: false)
        
    }

    @objc func toggle(_ sender: UISwitch) {
        // TODO
        print("")
    }

    

}

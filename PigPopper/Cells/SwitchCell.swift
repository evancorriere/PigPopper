//
//  TableViewCell.swift
//  PigPopper
//
//  Created by Evan Corriere on 9/10/20.
//  Copyright © 2020 Evan Corriere. All rights reserved.
//

import UIKit

enum SettingsSwitch: CaseIterable {
    case music
    case notifications
}


class SwitchCell: UITableViewCell {

    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var selection: UISwitch!
    
    var switchType: SettingsSwitch?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selection.addTarget(self, action: #selector(toggle), for: .valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        // Configure the view for the selected state
    }

    
    func setupWith(switchType: SettingsSwitch) {
        self.switchType = switchType
        
        switch switchType {
        case .music:
            label.text = "Music"
        case .notifications:
            label.text = "Notifications"
            
        }
    
        // TODO
//        self.selection.setOn(true, animated: false)
        
    }

    @objc func toggle(_ sender: UISwitch) {
        // TODO
        print("toggled")
    }

    

}

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
    case soundEffects
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
        var initialSwitchValue: Bool?
        
        switch switchType {
        case .music:
            label.text = "Music"
            initialSwitchValue = DataHelper.getData(type: Bool.self, forKey: .settingsMusic)
        case .notifications:
            label.text = "Notifications"
            initialSwitchValue = DataHelper.getData(type: Bool.self, forKey: .settingsNotification)
        case .soundEffects:
            label.text = "Sound Effects"
            initialSwitchValue = DataHelper.getData(type: Bool.self, forKey: .settingsSoundEffects)
        }
    
        self.selection.setOn(initialSwitchValue ?? true, animated: false)
        
    }

    @objc func toggle(_ sender: UISwitch) {
        switch switchType {
        case .music:
            if sender.isOn {
                playBackgroundMusic()
                DataHelper.setData(value: true, key: .settingsMusic)
            } else {
                pauseBackgroundMusic()
                DataHelper.setData(value: false, key: .settingsMusic)
            }
        case .soundEffects:
            if sender.isOn {
                DataHelper.setData(value: true, key: .settingsSoundEffects)
            } else {
                DataHelper.setData(value: false, key: .settingsSoundEffects)
            }
        case .notifications:
            print("hi")
        case .none:
            print("No case associated with this switch")
        }
    }
    

}

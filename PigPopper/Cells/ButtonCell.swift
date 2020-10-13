//
//  ButtonCell.swift
//  PigPopper
//
//  Created by Evan Corriere on 9/10/20.
//  Copyright © 2020 Evan Corriere. All rights reserved.
//

import UIKit


enum SettingsButton: CaseIterable {
    case about
    case credits
    case changeName
    case support
}


class ButtonCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var buttonType: SettingsButton?
    var viewController: SettingsViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupWith(label: String, button: SettingsButton) {
        self.buttonType = button
        self.label.text = label
        
        if button == .changeName {
            self.button.layer.borderColor = UIColor.red.cgColor
            self.button.setTitleColor(.red, for: .normal)
        } else {
            self.button.layer.borderColor = UIColor.link.cgColor
            self.button.setTitleColor(.link, for: .normal)
        }
        
        if button == .changeName {
            self.button.setTitle("Change", for: .normal)
        } else if button == .support {
            self.button.setTitle("Contact", for: .normal)
        } else {
            self.button.setTitle("View", for: .normal)
        }
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        switch buttonType {
        case .about:
            if let url = URL(string: "http://www.evancorriere.com") {
                UIApplication.shared.open(url)
            }
        case .credits:
            if let url = URL(string: "http://www.evancorriere.com") {
                UIApplication.shared.open(url)
            }
        case .changeName:
            viewController?.promptForNewUsername(isRetry: false)
        case .support:
//            let email = "evancorriere@gmail.com"
//            if let url = URL(string: "mailto:\(email)") {
//                if #available(iOS 10.0, *) {
//                    UIApplication.shared.open(url)
//                } else {
//                    UIApplication.shared.openURL(url)
//                }
//            }
            if let url = URL(string: "https://forms.gle/AWNPYgJeYPHJVZxKA") {
                UIApplication.shared.open(url)
            }
        case .none:
            print("button type is none")
        }
        
    }
}

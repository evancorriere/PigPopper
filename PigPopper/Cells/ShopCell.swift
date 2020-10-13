//
//  ShopCell.swift
//  PigPopper
//
//  Created by Evan Corriere on 8/23/20.
//  Copyright © 2020 Evan Corriere. All rights reserved.
//

import UIKit

class ShopCell: UITableViewCell {

    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    weak var shopViewController: ShopViewController?
    var shopItem: ShopItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func actionTapped(_ sender: Any) {
        guard let item = shopItem else {
            return
        }

        let coins = DataHelper.getBacon()
        
        if item.isOwned() {
            item.select()
            shopViewController?.tableView.reloadData()
        } else if item.isAffordable(totalCoins: coins) {
            item.markOwned()
            DataHelper.setBacon(bacon: coins - item.price!)
            shopViewController?.updateLabels()
            
            // just bought item
            statusLabel.text = "Owned"
            actionButton.setTitle("Equip", for: .normal)
        }
    }
    
    func setupWithItem(item: ShopItem) {
        self.shopItem = item
        itemImageView.image = UIImage(named: item.name)
        
        
        // how did this work
//        imageView?.image = UIImage(named: item.name)
        actionButton.isHidden = false
        actionButton.isEnabled = true
        actionButton.alpha = 1.0
        
        if item.isOwned() {
            if item.isSelected() {
                statusLabel.text = "Selected"
                actionButton.isHidden = true
                actionButton.setTitle("Equipped", for: .normal)
            } else if item.unlockMethod == .bacon {
                statusLabel.text = "Owned"
                actionButton.setTitle("Equip", for: .normal)
            } else {
                statusLabel.text = "Unlocked"
                actionButton.setTitle("Equip", for: .normal)
            }
        } else {
            switch item.unlockMethod {
            case .bacon:
                statusLabel.font = UIFont(name: "AmericanTypeWriter ", size: 17)
                statusLabel.text = "Cost: " + String(item.price!)
                actionButton.setTitle("Buy", for: .normal)
                actionButton.isEnabled = true
                actionButton.alpha = 1.0
                if !item.isAffordable(totalCoins: DataHelper.getBacon()) {
                    actionButton.isEnabled = false
                    actionButton.alpha = 0.4
                }
                // TODO: specify if can afford the item
            case .achievement:
                statusLabel.numberOfLines = 2
                statusLabel.font = UIFont(name: "AmericanTypeWriter ", size: 11)
                statusLabel.text = "Reach a score of \(item.achievement!.requiredScore)"
                actionButton.setTitle("Equip", for: .normal)
                actionButton.isEnabled = false
                actionButton.alpha = 0.4
                
            }
        }
    }
    

}

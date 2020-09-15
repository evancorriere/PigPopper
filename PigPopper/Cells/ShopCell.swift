//
//  ShopCell.swift
//  PigPopper
//
//  Created by Evan Corriere on 8/23/20.
//  Copyright © 2020 Evan Corriere. All rights reserved.
//

import UIKit

class ShopCell: UITableViewCell {

    
    @IBOutlet weak var itemImageView: UIView!
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
            statusLabel.text = "Selected"
            shopViewController?.tableView.reloadData()
        } else if item.isAffordable(totalCoins: coins) {
            item.markOwned()
            DataHelper.setBacon(bacon: coins - item.price)
            statusLabel.text = "Owned"
            shopViewController?.updateLabels()
            actionButton.setTitle("Equip", for: .normal)
        }
    }
    
    func setupWithItem(item: ShopItem) {
        self.shopItem = item
        imageView?.image = UIImage(named: item.name)
        if item.isOwned() {
            if item.isSelected() {
                statusLabel.text = "Selected"
            } else {
                statusLabel.text = "Owned"
            }
            actionButton.setTitle("Equip", for: .normal)
        } else {
            statusLabel.text = "Cost: " + String(item.price)
            actionButton.setTitle("Buy", for: .normal)
        }
    }
    

}

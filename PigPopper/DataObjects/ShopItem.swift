//
//  ShopItem.swift
//  PigPopper
//
//  Created by Evan Corriere on 8/23/20.
//  Copyright © 2020 Evan Corriere. All rights reserved.
//

import Foundation

class ShopItem {
    
    let name: String
    let price: Int
    
    let selectedWeaponKey = "selectedWeapon"
    let ownsKey: String
    
    
    init(name: String, price: Int) {
        self.name = name
        self.price = price
        self.ownsKey = "owns_" + name
    }
    
    func isOwned() -> Bool {
        return DataHelper.getItemOwned(itemName: name)
    }
    
    func markOwned() {
        DataHelper.setItemOwned(itemName: name, bool: true)
    }
    
    func isSelected() -> Bool {
        let selected = DataHelper.getSelectedWeapon()
        return name == selected
    }
    
    func select() {
        DataHelper.setSelectedWeapon(weaponName: name)
    }
    
    func isAffordable(totalCoins: Int) -> Bool {
        return price <= totalCoins
    }
    
}

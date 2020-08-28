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
        return UserDefaults.standard.bool(forKey: ownsKey)
    }
    
    func markOwned() {
        UserDefaults.standard.set(true, forKey: ownsKey)
    }
    
    func isSelected() -> Bool {
        let selected = UserDefaults.standard.string(forKey: selectedWeaponKey)
        return name == selected
    }
    
    func select() {
        UserDefaults.standard.set(name, forKey: selectedWeaponKey)
    }
    
    func isAffordable(totalCoins: Int) -> Bool {
        return price <= totalCoins
    }
    
}

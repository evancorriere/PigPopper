//
//  ShopItem.swift
//  PigPopper
//
//  Created by Evan Corriere on 8/23/20.
//  Copyright © 2020 Evan Corriere. All rights reserved.
//

import Foundation

enum UnlockMethod: CaseIterable {
    case bacon
    case achievement
}

enum ItemType: CaseIterable {
    case weapon
    case hat
}


class ShopItem {
    let name: String
    let price: Int?
    let achievement: Achievement?
    let unlockMethod: UnlockMethod
    let itemType: ItemType
    
    init(name: String, itemType: ItemType, unlockMethod: UnlockMethod, price: Int?, achievement: Achievement?) {
        self.name = name
        self.itemType = itemType
        self.unlockMethod = unlockMethod
        self.price = price
        self.achievement = achievement
    }
    
    convenience init(name: String, price: Int, itemType: ItemType) {
        self.init(name: name, itemType: itemType, unlockMethod: .bacon, price: price, achievement: nil)
    }
    
    convenience init(achievement: Achievement, itemType: ItemType) {
        self.init(name: achievement.reward, itemType: itemType, unlockMethod: .achievement, price: nil, achievement: achievement)
    }
    
    func isOwned() -> Bool {
        switch unlockMethod {
        case .achievement:
            return achievement!.isCompleted()
        case .bacon:
            return DataHelper.getItemOwned(itemName: name)
        }
    }
    
    func markOwned() {
        if unlockMethod == .bacon {
            DataHelper.setItemOwned(itemName: name, bool: true)
        }
    }
    
    func isSelected() -> Bool {
        switch itemType {
        case .weapon:
            return DataHelper.getSelectedWeapon() == name
        case .hat:
            return DataHelper.getSelectedWeapon() == name
        }
    }
    
    func select() {
        switch itemType {
        case .weapon:
            return DataHelper.setSelectedWeapon(weaponName: name)
        case .hat:
            return DataHelper.setSelectedHat(hatName: name)
        }
    }
    
    func isAffordable(totalCoins: Int) -> Bool {
        return unlockMethod == .bacon && totalCoins >= price!
    }
    
}

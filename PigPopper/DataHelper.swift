//
//  DataHelper.swift
//  PigPopper
//
//  Created by Evan Corriere on 9/15/20.
//  Copyright © 2020 Evan Corriere. All rights reserved.
//

import Foundation

enum UserDefaultKeys: String, CaseIterable { // TODO: how does this work
    case highScore
    case coins
    case setupDone
    case selectedWeapon
    case username
}

final class DataHelper {

    static let defaultWeaponName = "dessert_fork"
    
    static func setData<T>(value: T, key: UserDefaultKeys) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key.rawValue)
    }
    
    static func getData<T>(type: T.Type, forKey: UserDefaultKeys) -> T? {
        let defaults = UserDefaults.standard
        let value = defaults.object(forKey: forKey.rawValue) as? T
        return value
    }
    
    static func removeData(key: UserDefaultKeys) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key.rawValue)
    }
    
    
    /*
     * Item ownership. All purchaseable items are named based on the image name
     * stored with key owns_item
     * these keys are NOT in the key enum
     */
    
    static func getItemOwned(itemName: String) -> Bool {
        let ownsItemKey = "" + itemName
        return UserDefaults.standard.bool(forKey: ownsItemKey)
    }
    
    static func setItemOwned(itemName: String, bool: Bool) {
        let ownsItemKey = "owns_" + itemName
        UserDefaults.standard.set(bool, forKey: ownsItemKey)
    }
    
    
    
    
    /*
     * Convenience functions
     */
    
    static func getHighscore() -> Int {
        return getData(type: Int.self, forKey: .highScore) ?? 0
    }
    
    static func setHighscore(highscore: Int) {
        setData(value: highscore, key: .highScore)
    }
    
    static func getBacon() -> Int {
        return getData(type: Int.self, forKey: .coins) ?? 0
    }
    
    static func setBacon(bacon: Int) {
        setData(value: bacon, key: .coins)
    }
    
    static func getSelectedWeapon() -> String {
        return getData(type: String.self, forKey: .selectedWeapon) ?? defaultWeaponName
    }
    
    static func setSelectedWeapon(weaponName: String) {
        setData(value: weaponName, key: .selectedWeapon)
    }
    
    static func getUsername() -> String? {
        return getData(type: String.self, forKey: .username)
    }
    
    
}

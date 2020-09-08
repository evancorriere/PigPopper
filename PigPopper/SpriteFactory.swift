//
//  SpriteFactory.swift
//  PigPopper
//
//  Created by Evan Corriere on 6/30/20.
//  Copyright © 2020 Evan Corriere. All rights reserved.
//

import Foundation
import SpriteKit

class SpriteFactory {
    static let targetHeight = CGFloat(80)
    static let forkSize = CGSize(width: 10, height: 80)
    static let selectedWeaponKey = "selectedWeapon"
    static let priceLabelName = "priceLabelName"
    static let availableWeapons = ["dessert_fork", "cook_fork", "spear", "gold_sword"]
    static let defaultWeapon = "dessert_fork"
    static let prices = [
        "dessert_fork": 0,
        "cook_fork": 30,
        "spear": 60,
        "gold_sword": 90
    ]
    static let homeButtonName = "homeButton"
    
    static func getHomeSprites() -> [SKNode] {
        return [getHomeButton(), getHomeLabel()]
    }
    
    
    
    static func getHomeButton() -> SKSpriteNode {
        let homeButton = SKSpriteNode(color: .white, size: CGSize(width: 50, height: 50))
        homeButton.position = CGPoint(x: 50, y: 40)
        homeButton.isHidden = true
        homeButton.name = homeButtonName
        return homeButton
    }
    
    static func getHomeLabel() -> SKSpriteNode {
        let homeButton = SKSpriteNode(imageNamed: "barn")
        homeButton.position = CGPoint(x: 40, y: 40)
        homeButton.size = CGSize(width: 60, height: 60)
        return homeButton
    }
    
    static func getForkSprite() -> SKSpriteNode {
        let fork = SKSpriteNode(imageNamed: "dessert_fork")
        fork.name = "fork"
        fork.size = forkSize
        return fork
    }
    
    static func getCookForkSprite() -> SKSpriteNode {
        let cookFork = SKSpriteNode(imageNamed: "cook_fork")
        cookFork.name = "fork"
        cookFork.size = forkSize
        return cookFork
    }
    
    static func getWeaponSprite(weaponName: String) -> SKSpriteNode {
        let fork = SKSpriteNode(imageNamed: weaponName)
        fork.name = "fork"
        fork.size = forkSize
        return fork
        
    }
    
    static func getSelectedWeaponSprite() -> SKSpriteNode{
        let weaponName = UserDefaults.standard.string(forKey: selectedWeaponKey)
        let weapon = SKSpriteNode(imageNamed: weaponName ?? defaultWeapon)
        
        let h = weapon.size.height
        let w = weapon.size.width
        
        let ratio = targetHeight / h
        weapon.size = CGSize(width: w * ratio, height: targetHeight)
        weapon.name = "fork"
        
        // setup physics body to be a hitboxSize rect
        weapon.physicsBody = SKPhysicsBody(rectangleOf: forkSize)
        weapon.physicsBody?.categoryBitMask = CollisionTypes.fork.rawValue
        weapon.physicsBody?.collisionBitMask = CollisionTypes.pig.rawValue | CollisionTypes.shield.rawValue
        weapon.physicsBody?.contactTestBitMask = CollisionTypes.pig.rawValue | CollisionTypes.shield.rawValue
        weapon.physicsBody?.affectedByGravity = false
        weapon.physicsBody?.allowsRotation = false
        
        return weapon
    }
    
    static func getPig() -> Pig {
        return Pig()
    }
    
    static func getWeaponSprite(forIndex i: Int) -> SKSpriteNode {
        return getWeaponSprite(weaponName: availableWeapons[i])
    }
    
    static func getPriceBox(forIndex i: Int) -> SKSpriteNode {
        return getPriceBox(weaponName: availableWeapons[i])
    }
    
    static func getShield() -> SKSpriteNode {
        let shield = SKSpriteNode(imageNamed: "shield")
        shield.size = CGSize(width: 100, height: 100)
        shield.physicsBody = SKPhysicsBody(circleOfRadius: 50)
        shield.physicsBody?.isDynamic = false
        shield.physicsBody?.categoryBitMask = CollisionTypes.shield.rawValue
        shield.physicsBody?.collisionBitMask = CollisionTypes.fork.rawValue
        shield.physicsBody?.contactTestBitMask = CollisionTypes.fork.rawValue
        shield.name = "shield"
        shield.zPosition = 10
        return shield
    }
    
    static func getPriceBox(weaponName: String) -> SKSpriteNode {
        if !availableWeapons.contains(weaponName) {
            return SKSpriteNode()
        }
        
        let priceBox = SKSpriteNode(color: .white, size: CGSize(width: 80, height: 40))
        priceBox.name = "buy_" + weaponName
        
        let priceLabel = SKLabelNode()
        
        let ownsWeapon = UserDefaults.standard.bool(forKey: "owns_" + weaponName)
        if ownsWeapon {
            let selected = UserDefaults.standard.string(forKey: selectedWeaponKey) ?? defaultWeapon
            if weaponName == selected {
                priceLabel.text = "selected"
            } else {
                priceLabel.text = "owned"
            }
        } else {
            let weaponPrice = prices[weaponName]!
            priceLabel.text = "Price: \(weaponPrice) 🥓"
        }
        
        priceLabel.verticalAlignmentMode = .center
        priceLabel.horizontalAlignmentMode = .center
        priceLabel.fontColor = .black
        priceLabel.fontSize = 13
        priceLabel.name = priceLabelName
        priceBox.addChild(priceLabel)
        
        return priceBox
    }
    
    static func getBackgroundSprite(size: CGSize) -> SKSpriteNode {
        let backgroundSprite = SKSpriteNode(imageNamed: "background")
        backgroundSprite.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundSprite.size = size
        backgroundSprite.zPosition = -1
        return backgroundSprite
    }
    
}

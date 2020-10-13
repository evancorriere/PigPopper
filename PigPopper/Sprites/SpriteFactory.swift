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
        let weapon = SKSpriteNode(imageNamed: weaponName)
        
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
    
    static func getSelectedWeaponSprite() -> SKSpriteNode{
        let selectedWeaponName = DataHelper.getSelectedWeapon()
        return getWeaponSprite(weaponName: selectedWeaponName)
    }
    
    static func getPig() -> Pig {
        return Pig()
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
    
    static func getBackgroundSprite(size: CGSize) -> SKSpriteNode {
        let backgroundSprite = SKSpriteNode(imageNamed: "background")
        backgroundSprite.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundSprite.size = size
        backgroundSprite.zPosition = -1
        return backgroundSprite
    }
    
    
    // returns an array of bacon sprites that will be
    // exploding out of pig.
    static func getBaconSprites(count: Int) -> [SKSpriteNode] {
        var baconSprites: [SKSpriteNode] = []
        for _ in 0..<count {
            let sprite = SKSpriteNode(imageNamed: "bacon")
            sprite.size = CGSize(width: 15, height: 40)
            sprite.zPosition = 9
            sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
            sprite.physicsBody?.affectedByGravity = true
            sprite.physicsBody?.collisionBitMask = CollisionTypes.none.rawValue
            sprite.physicsBody?.contactTestBitMask = CollisionTypes.none.rawValue
            sprite.physicsBody?.categoryBitMask = CollisionTypes.none.rawValue
            baconSprites.append(sprite)
        }
        
        return baconSprites
    }
    
    
    
    
    /*
     * Hat setup. Each requires a specific size and position
     */
    
    static func getSelectedHat() -> SKSpriteNode? {
        guard let selectedHat = DataHelper.getSelectedHat() else {
            return nil
        }
        
        return getHat(hatName: selectedHat)
    }
    
    static func getHat(hatName: String) -> SKSpriteNode? {
        let hatNode = SKSpriteNode(imageNamed: hatName)

        switch hatName {
        case "antlersHat":
            hatNode.position = CGPoint(x: 25, y: 18)
            hatNode.size = CGSize(width: 40, height: 40)
            hatNode.zRotation = -CGFloat.pi / 4.0
        case "appleHat":
            hatNode.position = CGPoint(x: 22, y: 18)
            hatNode.size = CGSize(width: 28, height: 28)
            hatNode.zRotation = 0.0
        case "armyHat":
            hatNode.position = CGPoint(x: 25, y: 12)
            hatNode.size = CGSize(width: 43, height: 43)
            hatNode.zRotation = -CGFloat.pi / 6.0
        case "beanieHat":
            hatNode.position = CGPoint(x: 10, y: 18)
            hatNode.size = CGSize(width: 45, height: 45)
            hatNode.zRotation = -CGFloat.pi / 5.0
        case "birthdayHat":
            hatNode.position = CGPoint(x: 19, y: 19)
            hatNode.size = CGSize(width: 40, height: 40)
            hatNode.zRotation = -CGFloat.pi / 5.0
        case "bunnyHat":
            hatNode.position = CGPoint(x: 20, y: 17)
            hatNode.size = CGSize(width: 45, height: 45)
            hatNode.zRotation = -CGFloat.pi / 5.0
        case "cowboyHat":
            hatNode.position = CGPoint(x: 22, y: 14)
            hatNode.size = CGSize(width: 50, height: 50)
            hatNode.zRotation = -CGFloat.pi / 8.0
        case "crownHat":
            hatNode.position = CGPoint(x: 20, y: 18)
            hatNode.size = CGSize(width: 45, height: 45)
            hatNode.zRotation = -CGFloat.pi / 8.0
        case "firemanHat":
            hatNode.position = CGPoint(x: 22, y: 14)
            hatNode.size = CGSize(width: 45, height: 45)
            hatNode.zRotation = -CGFloat.pi / 12.0
        case "horseHeadHat":
            hatNode.position = CGPoint(x: 24, y: 0)
            hatNode.size = CGSize(width: 70, height: 70)
            hatNode.zRotation = -CGFloat.pi / 5.0
        case "hotdogHat":
            hatNode.position = CGPoint(x: 26, y: 17)
            hatNode.size = CGSize(width: 50, height: 50)
            hatNode.zRotation = -CGFloat.pi / 4.5
        case "leprechaunHat":
            hatNode.position = CGPoint(x: 18, y: 20)
            hatNode.size = CGSize(width: 50, height: 50)
            hatNode.zRotation = -CGFloat.pi / 12.0
        case "militaryHat":
            hatNode.position = CGPoint(x: 23, y: 14)
            hatNode.size = CGSize(width: 35, height: 35)
            hatNode.zRotation = -CGFloat.pi / 12.0
        case "nurseHat":
            hatNode.position = CGPoint(x: 23, y: 14)
            hatNode.size = CGSize(width: 35, height: 35)
            hatNode.zRotation = -CGFloat.pi / 12.0
        case "pinwheelHat":
            hatNode.position = CGPoint(x: 14, y: 18)
            hatNode.size = CGSize(width: 40, height: 40)
            hatNode.zRotation = -CGFloat.pi / 10.0
        case "pirateHat":
            hatNode.position = CGPoint(x: 18, y: 13)
            hatNode.size = CGSize(width: 60, height: 60)
            hatNode.zRotation = -CGFloat.pi / 6.0
        case "policeHat":
            hatNode.position = CGPoint(x: 32, y: 10)
            hatNode.size = CGSize(width: 40, height: 40)
            hatNode.zRotation = -CGFloat.pi / 8.0
        case "sharkHat":
            hatNode.position = CGPoint(x: 8, y: 28)
            hatNode.size = CGSize(width: 70, height: 70)
            hatNode.zRotation = -CGFloat.pi / 6.0
        case "sunHat":
            hatNode.position = CGPoint(x: 21, y: 13)
            hatNode.size = CGSize(width: 55, height: 40)
            hatNode.zRotation = -CGFloat.pi / 9.0
        case "vikingHat":
            hatNode.position = CGPoint(x: 20, y: 15)
            hatNode.size = CGSize(width: 65, height: 65)
            hatNode.zRotation = -CGFloat.pi / 12.0
        default:
            return nil
        }
        
        return hatNode
    }
    
}

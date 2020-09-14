//
//  GameScene.swift
//  PigPopper
//
//  Created by Evan Corriere on 6/23/20.
//  Copyright © 2020 Evan Corriere. All rights reserved.
//

import Foundation
import SpriteKit

class ShopScene: SKScene {
  
    weak var viewController: MainMenuViewController?
    
    let coinsLabel = SKLabelNode(text: "Coins: 0")
    let whiteStrip = SKSpriteNode(color: .white, size: CGSize(width: 100, height: 20))
    let homeButton = SpriteFactory.getHomeButton()
    
    var coins = 0
    var index = 0
    
    override func didMove(to view: SKView) {
        UserDefaults.standard.set(true, forKey: "owns_dessert_fork")
        
        // setup swipes
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        leftSwipe.direction = .left
        self.view?.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        rightSwipe.direction = .right
        self.view?.addGestureRecognizer(rightSwipe)
        
        
        let labelNode = SKLabelNode()
        labelNode.text = "Welcome to the shop"
        labelNode.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2 + 150)
        labelNode.verticalAlignmentMode = .baseline
        labelNode.horizontalAlignmentMode = .center
        addChild(labelNode)
        
        let swipeLabel = SKLabelNode(text: "Swipe left or right to view more options")
        swipeLabel.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height * 0.3)
        swipeLabel.verticalAlignmentMode = .center
        swipeLabel.horizontalAlignmentMode = .center
        swipeLabel.fontSize = 22
        addChild(swipeLabel)
       
        addChild(homeButton)
        addChild(SpriteFactory.getHomeLabel())
        
        whiteStrip.size = CGSize(width: size.width, height: 150)
        whiteStrip.zPosition = 0
        whiteStrip.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(whiteStrip)
        
        coins = UserDefaults.standard.integer(forKey: "coins")
        updateCoinLabel()
        coinsLabel.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2 + 100)
        coinsLabel.fontSize = 30
        addChild(coinsLabel)
        
        setupItems()
    }
    
    func setupItems() {
        whiteStrip.removeAllChildren()
        
        let itemsPerRow = 3
        let xInitial = -size.width / CGFloat(itemsPerRow)
        let xOffset = size.width / CGFloat(itemsPerRow)
     
        for i in 0 ..< itemsPerRow {
            let adjustedIndex = (index + i) % SpriteFactory.availableWeapons.count
            let weapon = SpriteFactory.getWeaponSprite(forIndex: adjustedIndex)
            let x = xInitial + xOffset * CGFloat(i)
            weapon.position = CGPoint(x: x, y: 0)

            let priceBox = SpriteFactory.getPriceBox(forIndex: adjustedIndex)
            priceBox.position = CGPoint(x: 0, y: -120)
            weapon.addChild(priceBox)
            
            whiteStrip.addChild(weapon)
        }
        
        
    }
    
    func updateCoinLabel() {
        coinsLabel.text = "Coins: \(coins)"
    }
    
    func handleHomeTapped() {
        let menuScene = MainMenuScene(size: size)
        menuScene.viewController = self.viewController
        menuScene.scaleMode = scaleMode
        let transition = SKTransition.push(with: .down, duration: 0.7)
        view?.presentScene(menuScene, transition: transition)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        
        if homeButton.contains(location) {
            handleHomeTapped()
        }
        
        let touchedNodes = nodes(at: location)
        for node in touchedNodes {
            if node.name?.starts(with: "buy_") ?? false {
                let index = node.name!.index(node.name!.startIndex, offsetBy: 4)
                let nameSubstring = node.name![index..<node.name!.endIndex]
                let weaponName = String(nameSubstring)
                let selectedName = UserDefaults.standard.string(forKey: SpriteFactory.selectedWeaponKey) ?? SpriteFactory.defaultWeapon
                if weaponName != selectedName {
                    let ownsWeapon = UserDefaults.standard.bool(forKey: "owns_" + weaponName)
                    if ownsWeapon {
                        UserDefaults.standard.set(weaponName, forKey: SpriteFactory.selectedWeaponKey)
                        setupItems()
                    } else {
                        let price = SpriteFactory.prices[weaponName]!
                        if coins > price {
                            coins -= price
                            UserDefaults.standard.set(true, forKey: "owns_" + weaponName)
                            UserDefaults.standard.set(coins, forKey: "coins")
                            UserDefaults.standard.set(weaponName, forKey: SpriteFactory.selectedWeaponKey)
                            updateCoinLabel()
                            setupItems()
                        }
                    }
                }
            }
        }
    }
    
    @objc func handleSwipeGesture(gesture: UISwipeGestureRecognizer) {
        let weaponCount = SpriteFactory.availableWeapons.count
        switch gesture.direction {
        case .right:
            print("left")
            index = (index + weaponCount - 3) % weaponCount
            setupItems()
        case .left:
            print("right")
            index = (index + 3) % weaponCount
            setupItems()
        default:
            ()
        }
        
    }
    
}

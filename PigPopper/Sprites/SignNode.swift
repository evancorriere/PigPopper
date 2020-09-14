//
//  SignNode.swift
//  PigPopper
//
//  Created by Evan Corriere on 8/17/20.
//  Copyright © 2020 Evan Corriere. All rights reserved.
//

import UIKit
import SpriteKit

class SignNode: SKSpriteNode {
    var score = 0
    var coins = 0
    
    let scoreLabel = SKLabelNode(text: "Score: 0")
    let coinsLabel = SKLabelNode(text: "Bacon: 0")
    
    let defaultFont = "AmericanTypewriter-Bold"
    
    init() {
        let texture = SKTexture(imageNamed: "wood_sign")
        super.init(texture: texture, color: .clear, size: CGSize(width: 150, height: 150))
        self.anchorPoint = CGPoint(x: 0, y: 0)
        
        scoreLabel.position = CGPoint(x: size.width * 0.1, y: self.size.height * 0.72)
        scoreLabel.verticalAlignmentMode = .center
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.zPosition = self.zPosition + 1
        scoreLabel.fontName = defaultFont
        scoreLabel.fontSize = 18
        
        coinsLabel.position = CGPoint(x: size.width * 0.1, y: self.size.height * 0.48)
        coinsLabel.verticalAlignmentMode = .center
        coinsLabel.horizontalAlignmentMode = .left
        coinsLabel.fontSize = 18
        coinsLabel.zPosition = self.zPosition + 1
        coinsLabel.fontName = defaultFont
        
        addChild(scoreLabel)
        addChild(coinsLabel)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateScore(score: Int) {
        self.score = score
        self.scoreLabel.text = "Score: \(self.score)"
    }
    
    func updateCoins(coins: Int) {
        self.coins = coins
        self.coinsLabel.text = "Bacon: \(self.coins)"
    }

}

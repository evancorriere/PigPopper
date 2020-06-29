//
//  MainMenuScene.swift
//  PigPopper
//
//  Created by Evan Corriere on 6/23/20.
//  Copyright © 2020 Evan Corriere. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene {
    
    let startButton = SKSpriteNode(color: .gray, size: CGSize(width: 200, height: 70))
    let startLabel = SKLabelNode()
    
    let shopButton = SKSpriteNode(color: .gray, size: CGSize(width: 200, height: 70))
    let shopButtonLabel = SKLabelNode()
    
    let highScoreLabel = SKLabelNode(text: "High Score: 0")
    
    override func didMove(to view: SKView) {
        backgroundColor = .blue
        
        startButton.position = CGPoint(x: size.width / 2, y: size.height / 2 - 35)
        startButton.name = "start"
        startLabel.text = "Start!"
        startLabel.fontColor = .white
        startLabel.verticalAlignmentMode = .center
        addChild(startButton)
        startButton.addChild(startLabel)
        
        shopButton.position = CGPoint(x: size.width / 2, y: size.height / 2 - 130)
        shopButton.name = "shop"
        shopButtonLabel.text = "Shop"
        shopButtonLabel.fontColor = .white
        shopButtonLabel.verticalAlignmentMode = .center
        addChild(shopButton)
        shopButton.addChild(shopButtonLabel)
        
        highScoreLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 + 100)
        highScoreLabel.fontColor = .white
        highScoreLabel.verticalAlignmentMode = .center
        highScoreLabel.horizontalAlignmentMode = .center
        updateHighScoreLabel()
        addChild(highScoreLabel)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touchLocation = touches.first!.location(in: self)
        let touchedNodes = self.nodes(at: touchLocation)
        print("touch")
        print("Count: \(touchedNodes.count)")
        for touchedNode in touchedNodes {
            if touchedNode.name == startButton.name {
                print("start touched")
                handleStartTapped()
            } else if touchedNode.name == shopButton.name {
                print("shop touched")
                handleShopTapped()
            }
        }
    }
    
    func updateHighScoreLabel() {
        let highScore = UserDefaults.standard.integer(forKey: "highScore")
        highScoreLabel.text = "High Score: \(highScore)"
    }
    
    func handleStartTapped() {
        let gameScene = GameScene(size: size)
        gameScene.scaleMode = scaleMode
        let transition = SKTransition.push(with: .up, duration: 1.5)
        view?.presentScene(gameScene, transition: transition)
    }
    
    func handleShopTapped() {
        let shopScene = ShopScene(size: size)
        shopScene.scaleMode = scaleMode
        let transition = SKTransition.push(with: .up, duration: 1.5)
        view?.presentScene(shopScene, transition: transition)
    }
    
    func sceneTapped() {
        let gameScene = GameScene(size: size)
        gameScene.scaleMode = scaleMode
        let transition = SKTransition.push(with: .up, duration: 1.5)
        view?.presentScene(gameScene, transition: transition)
    }
}

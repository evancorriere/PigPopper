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
    
    let pig = SKSpriteNode(imageNamed: "idle_000")
    let defaultFont = "AmericanTypewriter-Bold"
    let pigWalkAnimation: SKAction
    let pigWalkAnimationKey = "walkAnim"
    let pigIdleAnimation: SKAction
    let pigIdleAnimationKey = "idleAnim"
    
    override init(size: CGSize) {
        var pigWalkTextures:[SKTexture] = []
        var pigIdleTextures:[SKTexture] = []
        
        for i in 0...9 {
            pigWalkTextures.append(SKTexture(imageNamed: "walk_00\(i)"))
            pigIdleTextures.append(SKTexture(imageNamed: "idle_00\(i)"))
        }
        
        pigWalkAnimation = SKAction.animate(with: pigWalkTextures, timePerFrame: 0.1)
        pigIdleAnimation = SKAction.animate(with: pigIdleTextures, timePerFrame: 0.1)
        

        super.init(size: size)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMove(to view: SKView) {
        playBackgroundMusic(filename: "background_music.mp3")
        backgroundColor = .blue
        
        let backgroundSprite = SpriteFactory.getBackgroundSprite(size: size)
        addChild(backgroundSprite)
        
        
        
        startButton.position = CGPoint(x: size.width / 2, y: size.height / 2 - 35)
        startButton.name = "start"
        startLabel.text = "Start!"
        startLabel.fontName = defaultFont
        startLabel.fontColor = .white
        startLabel.verticalAlignmentMode = .center
        addChild(startButton)
        startButton.addChild(startLabel)
        
        shopButton.position = CGPoint(x: size.width / 2, y: size.height / 2 - 130)
        shopButton.name = "shop"
        shopButtonLabel.text = "Shop"
        shopButtonLabel.fontName = defaultFont
        shopButtonLabel.fontColor = .white
        shopButtonLabel.verticalAlignmentMode = .center
        addChild(shopButton)
        shopButton.addChild(shopButtonLabel)
        
        highScoreLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 + 100)
        highScoreLabel.fontColor = .white
        highScoreLabel.fontName = "AmericanTypewriter-Bold"
        highScoreLabel.verticalAlignmentMode = .center
        highScoreLabel.horizontalAlignmentMode = .center
        updateHighScoreLabel()
        addChild(highScoreLabel)
        
        //TODO: add to spriteFactiory (pig factory?)
        pig.size = CGSize(width: 80, height: 80)
        pig.position = CGPoint(x: 30, y: 80)
        addChild(pig)
        startPigAnimation()
        

        addTitleNode()
    }
    
    func startPigAnimation() {
        let walkDistance = size.width - 90
        let walkRepeatCount = 3
        let walkDuration = 3.0
        let idleRepeatCount = 5

        let pigBehavior = SKAction.sequence([
            SKAction.repeat(pigIdleAnimation, count: idleRepeatCount),
            SKAction.group([
                SKAction.repeat(pigWalkAnimation, count: walkRepeatCount),
                SKAction.moveBy(x: walkDistance, y: 0, duration: walkDuration) ]),
            SKAction.scaleX(by: -1, y: 1, duration: 0),
            SKAction.repeat(pigIdleAnimation, count: idleRepeatCount),
            SKAction.group([SKAction.repeat(pigWalkAnimation, count: walkRepeatCount),
                               SKAction.moveBy(x: -walkDistance, y: 0, duration: walkDuration)]),
            SKAction.scaleX(by: -1, y: 1, duration: 0)
        ])
        pig.run(SKAction.repeatForever(pigBehavior))
        
        
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
        let transition = SKTransition.push(with: .left, duration: 1.0)
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
    
    func addTitleNode() {
        let pigLabel = SKLabelNode(text: "Pig")
        let popperLabel = SKLabelNode(text: "Popper!")
        
        pigLabel.fontColor = UIColor(red: 1, green: 0.3294, blue: 1, alpha: 1.0)
        pigLabel.fontName = "ChalkboardSE-Bold"
        pigLabel.fontSize = 80
        pigLabel.horizontalAlignmentMode = .center
        pigLabel.verticalAlignmentMode = .bottom
        pigLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.75)
        pigLabel.zPosition = 5
        
        popperLabel.fontColor = .black
        popperLabel.fontName = defaultFont
        popperLabel.fontSize = 60
        popperLabel.horizontalAlignmentMode = .center
        popperLabel.verticalAlignmentMode = .top
        popperLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.75)
        popperLabel.zPosition = 5
        
        addChild(pigLabel)
        addChild(popperLabel)
        
        
    }
}

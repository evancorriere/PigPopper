//
//  GameScene.swift
//  PigPopper
//
//  Created by Evan Corriere on 6/23/20.
//  Copyright © 2020 Evan Corriere. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
   
    let pig = SKSpriteNode(imageNamed: "Jetpack_000")
    let fork: SKSpriteNode
    
    let explosionSound: SKAction = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
    let shootSound: SKAction = SKAction.playSoundFileNamed("shoot.wav", waitForCompletion: false)
    
    let jetpackAnimation: SKAction
    let explosionAnimation: SKAction
    let flyAnimation: SKAction
    let jetpackAnimationKey = "jetpackAnimation"
    let flyAnimationKey = "flyAnimation"
    let forkMoveAnimationKey = "forkMoveAnimationKey"
    let explosionAnimationKey = "explosionAnimationKey"
    let forkLaunchPosition: CGPoint!
    
    let scoreLabel = SKLabelNode()
    let highScoreLabel = SKLabelNode()
    var score = 0
    var highScore = 0
    
    var initialTouchLocation: CGPoint!
    var initialTouchTime: TimeInterval!
    
    var finalTouchLocation:CGPoint!
    var finalTouchTime: TimeInterval!
    
   
    override init(size: CGSize) {
        var jetpackTextures:[SKTexture] = []
        for i in 0...2 {
            jetpackTextures.append(SKTexture(imageNamed: "Jetpack_00\(i)"))
        }
        jetpackTextures.append(jetpackTextures[1])
        jetpackTextures.append(jetpackTextures[0])
        jetpackAnimation = SKAction.animate(with: jetpackTextures, timePerFrame: 0.1)
        
        var explosionTextures:[SKTexture] = []
        for i in 1...7 {
            explosionTextures.append(SKTexture(imageNamed: "EXPLOSIONS\(i)"))
        }
        explosionAnimation = SKAction.animate(with: explosionTextures, timePerFrame: 0.1)
        
        let right = SKAction.moveTo(x: size.width, duration: 1)
        let flipLeft = SKAction.scaleX(to: -1, duration: 0)
        let left = SKAction.moveTo(x: 0, duration: 2)
        let flipRight = SKAction.scaleX(to: 1, duration: 0)
        let center = SKAction.moveTo(x: size.width / 2, duration: 1)
        flyAnimation = SKAction.sequence([right, flipLeft, left, flipRight, center])
        forkLaunchPosition = CGPoint(x: size.width / 2, y: 100)
        
        fork = SpriteFactory.getSelectedWeaponSprite()
                
        super.init(size: size)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
        
        let backgroundSprite = SpriteFactory.getBackgroundSprite(size: size)
        backgroundSprite.xScale = -1 // flip so the transition looks nice
        addChild(backgroundSprite)
        
        pig.zPosition = 10
        pig.size = CGSize(width: 90, height: 90)
        addChild(pig)
        resetPig()
        
        fork.position = forkLaunchPosition
        fork.zPosition = 5
        fork.zRotation = 0.0
        addChild(fork)
        
        scoreLabel.fontSize = 50
        scoreLabel.zPosition = 3
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.verticalAlignmentMode = .bottom
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        scoreLabel.fontColor = .black
        updateScoreLabel()
        addChild(scoreLabel)
        
        highScoreLabel.fontSize = 50
        highScoreLabel.zPosition = 3
        highScoreLabel.verticalAlignmentMode = .center
        highScoreLabel.horizontalAlignmentMode = .center
        highScoreLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 - 70)
        highScoreLabel.fontColor = .black
        highScore = UserDefaults.standard.integer(forKey: "highScore")
        updateHighScoreLabel()
        addChild(highScoreLabel)
        
        let homeButton = SpriteFactory.getHomeSprite()
        addChild(homeButton)
        
    }
    
    func resetPig() {
        pig.position = CGPoint(x: size.width / 2, y: size.height - 75)
        pig.xScale = 1
        startJetpackAnimation()
        startFlyAnimation()
    }
    
    func updateScoreLabel() {
        scoreLabel.text = "SCORE: \(score)"
    }
    
    func updateHighScoreLabel() {
        highScoreLabel.text = "BEST: \(highScore)"
    }
    
    func startJetpackAnimation() {
        if pig.action(forKey: jetpackAnimationKey) == nil {
            pig.run(SKAction.repeatForever(jetpackAnimation), withKey: jetpackAnimationKey)
        }
    }
    
    func stopJetpackAnimation() {
        pig.removeAction(forKey: jetpackAnimationKey)
    }
    
    
    func startFlyAnimation() {
        if pig.action(forKey: flyAnimationKey) == nil {
            pig.run(SKAction.repeatForever(flyAnimation), withKey: flyAnimationKey)
        }
    }
    
    func stopFlyAnimation() {
        if pig.action(forKey: flyAnimationKey) != nil {
            pig.removeAction(forKey: flyAnimationKey)
        }
    }
    
    func startExplosionAnimation() {
        if pig.action(forKey: explosionAnimationKey) == nil {
            let action = SKAction.sequence([
                explosionAnimation,
                SKAction.run { [weak self] in self?.resetPig() }
            ])
            pig.run(action)
        }
    }
    
    func resetFork() {
        fork.removeAction(forKey: forkMoveAnimationKey)
        fork.position = forkLaunchPosition
        fork.zRotation = 0.0
    }
    
    func handlePigHit() {
        print("hit")
        run(explosionSound)
        stopFlyAnimation()
        stopJetpackAnimation()
        startExplosionAnimation()
        score += 1
        if score > highScore {
            highScore = score
            UserDefaults.standard.set(highScore, forKey: "highScore")
            updateHighScoreLabel()
        }
        updateScoreLabel()
        resetFork()
    }
    
    func handleForkOffScreen() {
        resetFork()
        score = 0
        updateScoreLabel()
    }
    
    func handleHomeTapped() {
        let menuScene = MainMenuScene(size: size)
        menuScene.scaleMode = scaleMode
        let transition = SKTransition.push(with: .right, duration: 1.0)
        view?.presentScene(menuScene, transition: transition)
    }
    
    
    func checkCollisions() {
        if fork.frame.intersects(pig.frame) {
            handlePigHit()
        } else if !intersects(fork) {
            handleForkOffScreen()
        }
    }
    
    func handleSwipe() {
        let touchedNodes = self.nodes(at: initialTouchLocation)
        for touchedNode in touchedNodes {
            if touchedNode.name == "home" {
                handleHomeTapped()
                return
            }
        }
        
        
        if fork.position == forkLaunchPosition {
            handleForkSwiped()
        }
    }
    
    func handleForkSwiped() {
        let dt = finalTouchTime - initialTouchTime
        let swipeVector = CGVector(dx: finalTouchLocation.x - initialTouchLocation.x, dy: finalTouchLocation.y - initialTouchLocation.y)
        let theta = atan2(swipeVector.dy, swipeVector.dx)
        
        if theta >= 0 && theta <= CGFloat.pi {
            fork.zRotation = theta - CGFloat.pi / 2
            print("Theta: \(theta)")
            
            let moveBySwipe = SKAction.move(by: swipeVector, duration: dt)
            run(shootSound)
            fork.run(SKAction.repeatForever(moveBySwipe), withKey: forkMoveAnimationKey)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        initialTouchLocation = touches.first!.location(in: view)
        initialTouchLocation = CGPoint(x: initialTouchLocation.x, y: view!.bounds.height - initialTouchLocation.y)
        initialTouchTime = touches.first!.timestamp
        
        let touchedNodes = self.nodes(at: initialTouchLocation)
        for touchedNode in touchedNodes {
            if touchedNode.name == "home" {
                handleHomeTapped()
                return
            }
        }
        
        print("initial touch location: \(initialTouchLocation!)")
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        finalTouchLocation = touches.first!.location(in: view)
        finalTouchLocation = CGPoint(x: finalTouchLocation.x, y: view!.bounds.height - finalTouchLocation.y)
        finalTouchTime = touches.first!.timestamp
        print("final touch location: \(finalTouchLocation!)")
        handleForkSwiped()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        finalTouchLocation = touches.first!.location(in: view)
        finalTouchLocation = CGPoint(x: finalTouchLocation.x, y: view!.bounds.height - finalTouchLocation.y)
        finalTouchTime = touches.first!.timestamp
        print("canceled touch location: \(finalTouchLocation!)")
        handleForkSwiped()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        
    }
    
    override func didEvaluateActions() {
        checkCollisions()
    }
    
}

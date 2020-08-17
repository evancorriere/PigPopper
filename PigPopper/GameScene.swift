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
    
    let explosionSound: SKAction = SKAction.playSoundFileNamed("explosion2.wav", waitForCompletion: false)
    let shootSound: SKAction = SKAction.playSoundFileNamed("shoot2.wav", waitForCompletion: false)
    
    let jetpackAnimation: SKAction
    let explosionAnimation: SKAction
    let jetpackAnimationKey = "jetpackAnimation"
    let forkMoveAnimationKey = "forkMoveAnimationKey"
    let explosionAnimationKey = "explosionAnimationKey"
    let forkLaunchPosition: CGPoint!
    let homeButton: SKSpriteNode
    
    let scoreLabel = SKLabelNode()
    let coinsLabel = SKLabelNode()
    let highScoreLabel = SKLabelNode()
    let totalCoinsLabel = SKLabelNode()
    var score = 0
    var highScore = 0
    var coins = 0
    var totalCoins = 0
    
    var initialTouchLocation: CGPoint!
    var initialTouchTime: TimeInterval!
    
    var finalTouchLocation:CGPoint!
    var finalTouchTime: TimeInterval!
    
    // Pig movement - update loop
    var dt: TimeInterval = 0
    var lastUpdateTime: TimeInterval = 0
    var velocity = CGPoint.zero
    var velocityMultiplier: CGFloat = 1.0
    let pigBoundingBox: CGRect!
    
   
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
        forkLaunchPosition = CGPoint(x: size.width / 2, y: 100)
        
        fork = SpriteFactory.getSelectedWeaponSprite()
        homeButton = SpriteFactory.getHomeButton()
        
        // setup pig bounding box - full width, ~60 % height
        let minY = size.height * 0.40
        pigBoundingBox = CGRect(x: 0, y: minY, width: size.width, height: size.height * 0.60)
        
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
        
        setupLabels()
        
        addChild(homeButton)
        addChild(SpriteFactory.getHomeLabel())
    }
    
    func setupLabels() {
        scoreLabel.fontSize = 50
        scoreLabel.zPosition = 3
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.verticalAlignmentMode = .bottom
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 + 20)
        scoreLabel.fontColor = .black
        updateScoreLabel()
        addChild(scoreLabel)
        
        coinsLabel.fontSize = 50
        coinsLabel.zPosition = 3
        coinsLabel.horizontalAlignmentMode = .center
        coinsLabel.verticalAlignmentMode = .top
        coinsLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        coinsLabel.fontColor = .black
        updateCoinsLabel()
        addChild(coinsLabel)
        
        highScoreLabel.fontSize = 25
        highScoreLabel.zPosition = 3
        highScoreLabel.verticalAlignmentMode = .center
        highScoreLabel.horizontalAlignmentMode = .left
        print("safe top: \(view!.safeAreaInsets.top)")
        print("safe bottom: \(view!.safeAreaInsets.bottom)")
        print("normal top: \(size.height)")
        highScoreLabel.position = CGPoint(x: view!.safeAreaInsets.left + 10, y: size.height - view!.safeAreaInsets.top - 10)
        highScoreLabel.fontColor = .black
        highScore = UserDefaults.standard.integer(forKey: "highScore")
        updateHighScoreLabel()
        addChild(highScoreLabel)
        
        totalCoinsLabel.fontSize = 25
        totalCoinsLabel.zPosition = 3
        totalCoinsLabel.verticalAlignmentMode = .center
        totalCoinsLabel.horizontalAlignmentMode = .right
        totalCoinsLabel.fontColor = .black
        totalCoinsLabel.position = CGPoint(x: size.width - 20, y: size.height - 30)
        totalCoins = UserDefaults.standard.integer(forKey: "coins")
        updateTotalCoinsLabel()
        addChild(totalCoinsLabel)
        
    }
    
    func resetPig() {
        pig.position = getPigStartPosition()
        velocity = getRandomVelocity()
        startJetpackAnimation()
    }
    
    func updateScoreLabel() {
        scoreLabel.text = "SCORE: \(score)"
    }
    
    func updateHighScoreLabel() {
        highScoreLabel.text = "BEST: \(highScore)"
    }
    
    func updateCoinsLabel() {
        coinsLabel.text = "🥓: \(coins)"
    }
    
    func updateTotalCoinsLabel() {
        totalCoinsLabel.text = "TOTAL 🥓: \(totalCoins)"
    }
    
    func startJetpackAnimation() {
        if pig.action(forKey: jetpackAnimationKey) == nil {
            pig.run(SKAction.repeatForever(jetpackAnimation), withKey: jetpackAnimationKey)
        }
    }
    
    func stopJetpackAnimation() {
        pig.removeAction(forKey: jetpackAnimationKey)
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
    
    func getPigStartPosition() -> CGPoint {
        let validPerimeter = pigBoundingBox.height * 2 + pigBoundingBox.width
        let randomLocation = CGFloat.random(min: 0, max: validPerimeter)
        
        // left side, top, right side
        var position: CGPoint
        if randomLocation < pigBoundingBox.height {
            position = CGPoint(x: 0, y: pigBoundingBox.minY + randomLocation)
        } else if randomLocation < pigBoundingBox.height + pigBoundingBox.width {
            let x = randomLocation - pigBoundingBox.height
            position = CGPoint(x: x, y: pigBoundingBox.maxY)
        } else {
            let y = pigBoundingBox.minY + (validPerimeter - randomLocation)
            position = CGPoint(x: pigBoundingBox.maxX, y: y)
        }
        
        return position
    }
    
    func getRandomVelocity() -> CGPoint {
        let randomAngle = CGFloat.random(min: 0, max: 2 * CGFloat.pi)
        let unitVelocity = vectorFromAngle(angle: randomAngle)
        return unitVelocity * 200
    }
    
    func resetFork() {
        fork.removeAction(forKey: forkMoveAnimationKey)
        fork.position = forkLaunchPosition
        fork.zRotation = 0.0
    }
    
    func handlePigHit() {
        run(explosionSound)
        velocity = CGPoint.zero
        stopJetpackAnimation()
        startExplosionAnimation()
        velocityMultiplier += 0.1
        let coinValue = score / 3 + 1
        score += 1
        coins += coinValue
        if score > highScore {
            highScore = score
            UserDefaults.standard.set(highScore, forKey: "highScore")
            updateHighScoreLabel()
        }
        updateScoreLabel()
        updateCoinsLabel()
        resetFork()
    }
    
    func handleForkOffScreen() {
        resetFork()
        score = 0
        velocityMultiplier = 1.0
        totalCoins += coins
        coins = 0
        
        UserDefaults.standard.set(totalCoins, forKey: "coins")
        
        updateScoreLabel()
        updateCoinsLabel()
        updateTotalCoinsLabel()
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
    
    func validSwipe(swipe: CGVector, time: Double) -> Bool {
        let magnitude = sqrt(pow(swipe.dx, 2) + pow(swipe.dy, 2))
        let scaledMagnitude = Double(magnitude) / time
        return scaledMagnitude > 600
    }
    
    func handleForkSwiped() {
        if fork.position != forkLaunchPosition {
            return
        }
        
        let dt = finalTouchTime - initialTouchTime
        let swipeVector = CGVector(dx: finalTouchLocation.x - initialTouchLocation.x, dy: finalTouchLocation.y - initialTouchLocation.y)
        
        if !validSwipe(swipe: swipeVector, time: dt) { return }
        
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
        
        if homeButton.contains(initialTouchLocation) {
            handleHomeTapped()
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
    
    func movePig() {
        let adjustedVelocity = velocity * velocityMultiplier
        let amountToMove = adjustedVelocity * CGFloat(dt)
        pig.position += amountToMove
    }
    
    func rotatePig() {
        if velocity.x > 0 {
            pig.xScale = 1
        } else {
            pig.xScale = -1
        }
        
    }
    
    func boundsCheckPig() {
        let bottomLeft = CGPoint(x: pigBoundingBox.minX, y: pigBoundingBox.minY)
          let topRight = CGPoint(x: pigBoundingBox.maxX, y: pigBoundingBox.maxY)
          
          if pig.position.x <= bottomLeft.x {
              pig.position.x = bottomLeft.x
              velocity.x = abs(velocity.x)
          }
        
          if pig.position.x >= topRight.x {
              pig.position.x = topRight.x
              velocity.x = -velocity.x
          }
        
          if pig.position.y <= bottomLeft.y {
              pig.position.y = bottomLeft.y
              velocity.y = -velocity.y
          }
          
          if pig.position.y >= topRight.y {
              pig.position.y = topRight.y
              velocity.y = -velocity.y
          }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        
        movePig()
        boundsCheckPig()
        rotatePig()

    }
    
    override func didEvaluateActions() {
        checkCollisions()
    }
    
}

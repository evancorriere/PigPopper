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
   
    weak var viewController: GameViewController?
    let pig: Pig = SpriteFactory.getPig()
    let fork: SKSpriteNode
    let woodSign = SignNode()
    var shields: [SKNode] = []
    
    let explosionSound: SKAction = SKAction.playSoundFileNamed("explosion2.wav", waitForCompletion: false)
    let shootSound: SKAction = SKAction.playSoundFileNamed("shoot2.wav", waitForCompletion: false)
    let jetpackAnimation: SKAction
    let explosionAnimation: SKAction
    let jetpackAnimationKey = "jetpackAnimation"
    let forkMoveAnimationKey = "forkMoveAnimationKey"
    let defaultFont = "AmericanTypewriter"
    let forkLaunchPosition: CGPoint!
    let homeButton: SKSpriteNode
    let hitMessages = ["Great Shot!", "Nice!", "Perfect", "HIT", "BOOM", "Five Stars!"]
    
    let highScoreLabel = SKLabelNode()
    let totalCoinsLabel = SKLabelNode()
    let hitMessageLabel = SKLabelNode()
    let levelUpLabel = SKLabelNode()
    let gameOverLabel = SKLabelNode()
    var score = 0
    var highScore = 0
    var coins = 0
    var totalCoins = 0
    var hitValue = 1
    var shouldResetFork = false
    var shouldResetPig = false
    var forkLaunchable = true
    var forkHitObject = false
    
    var initialTouchLocation: CGPoint!
    var initialTouchTime: TimeInterval!
    
    var finalTouchLocation:CGPoint!
    var finalTouchTime: TimeInterval!
    
    // Pig movement - update loop
    var dt: TimeInterval = 0
    var lastUpdateTime: TimeInterval = 0
    var velocity = CGPoint.zero
    var velocityMultiplier: CGFloat = 1.0
    var pigBoundingBox: CGRect!
    
   
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
            
        super.init(size: size)
        
        let playableHeight = size.height * 0.60
        let minY = size.height - playableHeight - (view?.safeAreaInsets.top ?? 0)
        pigBoundingBox = CGRect(x: 0, y: minY, width: size.width, height: playableHeight)
        
        pig.gameScene = self
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        backgroundColor = .white
        
        
        
        let backgroundSprite = SpriteFactory.getBackgroundSprite(size: size)
        backgroundSprite.xScale = -1 // flip so the transition looks nice
        addChild(backgroundSprite)
        

        addChild(pig)
        resetPig()
        
        fork.position = forkLaunchPosition
        fork.zPosition = 5
        fork.zRotation = 0.0
        addChild(fork)
        
        woodSign.position = CGPoint(x: size.width * 0.05, y: size.height * 0.1)
        woodSign.size = CGSize(width: 150, height: 150)
        addChild(woodSign)
        
        
        
        setupLabels()
        
        addChild(homeButton)
        addChild(SpriteFactory.getHomeLabel())
    }
    
    func viewSafeAreaInsetsDidChange() {
        let playableHeight = size.height * 0.60
        let minY = size.height - playableHeight - (self.view?.safeAreaInsets.top ?? 0) * 0.7
        print("from GS: \(self.view?.safeAreaInsets.left ?? -1)")
        pigBoundingBox = CGRect(x: 0, y: minY, width: size.width, height: playableHeight)
    
    }
    
    
    
    func setupLabels() {
        highScore = DataHelper.getHighscore()
        updateHighScoreLabel()
        
        totalCoins = DataHelper.getBacon()
        updateTotalCoinsLabel()
        
        hitMessageLabel.fontSize = 20
        hitMessageLabel.zPosition = 20
        hitMessageLabel.fontName = defaultFont
        hitMessageLabel.verticalAlignmentMode = .top
        hitMessageLabel.horizontalAlignmentMode = .center
        hitMessageLabel.fontColor = .orange
        hitMessageLabel.setScale(0.0)
        
        levelUpLabel.fontSize = 21
        levelUpLabel.fontName = defaultFont
        levelUpLabel.fontColor = .white
        levelUpLabel.zPosition = 25
        levelUpLabel.verticalAlignmentMode = .center
        levelUpLabel.horizontalAlignmentMode = .left
        levelUpLabel.text = "Level up!"
    }
    
    func resetPig() {
        pig.isHidden = true
        pig.position = getPigStartPosition()
        rotatePig()
        velocity = getRandomVelocity()
        pig.startJetpackAnimation()
        pig.isHidden = false
        forkLaunchable = true
    }
    
    func updateScoreLabel() {
        woodSign.updateScore(score: score)
    }
    
    func updateHighScoreLabel() {
        viewController?.updateHighscore(highscore: highScore)
    }
    
    func updateCoinsLabel() {
        woodSign.updateCoins(coins: coins)
    }
    
    func updateTotalCoinsLabel() {
        viewController?.updateBacon(bacon: totalCoins)
    }
    
    func startExplosionAnimation() {
        pig.explode()
    }
    
    func getPigStartPosition() -> CGPoint {
        let validPerimeter = pigBoundingBox.height * 2 + pigBoundingBox.width
        let randomLocation = CGFloat.random(min: 0, max: validPerimeter)
        
        // left side, top, right side
        var position: CGPoint
        if randomLocation < pigBoundingBox.height { // left side
            position = CGPoint(x: -pig.physicsNode.frame.width, y: pigBoundingBox.minY + randomLocation)
        } else if randomLocation < pigBoundingBox.height + pigBoundingBox.width { // top
            let x = randomLocation - pigBoundingBox.height
            position = CGPoint(x: x, y: pigBoundingBox.maxY + pig.physicsNode.frame.height)
        } else {
            let y = pigBoundingBox.minY + (validPerimeter - randomLocation)
            position = CGPoint(x: pigBoundingBox.maxX + pig.physicsNode.frame.width, y: y)
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
        fork.physicsBody?.velocity = .zero
        fork.zRotation = 0.0
        forkHitObject = false
    }
    
    func handlePigHit() {
        
        runHitMessage()
        
        run(explosionSound)
        self.shouldResetFork = true
        self.shouldResetPig = true
        
        velocity = CGPoint.zero
        pig.stopJetpackAnimation()
        velocityMultiplier += 0.1
        score += 1
        coins += hitValue
        totalCoins += hitValue
        DataHelper.setBacon(bacon: totalCoins)
        if score > highScore {
            highScore = score
            DataHelper.setHighscore(highscore: highScore)
            updateHighScoreLabel()
            let achievements = AchievementManager.updatedAchievements(highscore: highScore)
            if achievements.count > 0 {
                print("Achivements unlocked!")
                for achievement in achievements {
                    print(achievement.rank)
                }
            }
        }
        updateScoreLabel()
        updateCoinsLabel()
        updateTotalCoinsLabel()
        
        if score % 3 == 0 {
            levelUp()
        }
        
        resetFork()
    }
    
    func runHitMessage() {
        hitMessageLabel.text = hitMessages.randomElement()
        hitMessageLabel.position = CGPoint(x: pig.position.x, y: pig.position.y - 50)
        
        
        let displayAction = SKAction.sequence([
            SKAction.scale(to: 1.0, duration: 0.5),
            SKAction.scale(to: 0, duration: 0.5),
            SKAction.removeFromParent()
        ])
        
        addChild(hitMessageLabel)
        hitMessageLabel.run(displayAction)
    }
    
    func runLevelUpMessage() {
        levelUpLabel.position = CGPoint(x: -70, y: size.height * 0.35)
        let acrossAction = SKAction.sequence([
            SKAction.moveTo(x: 10, duration: 0.2),
            SKAction.wait(forDuration: 0.9),
            SKAction.moveTo(x: -70, duration: 0.2),
            SKAction.removeFromParent()
        ])
        addChild(levelUpLabel)
        levelUpLabel.run(acrossAction)
    }
    
    func levelUp() {
        runLevelUpMessage()
        
        hitValue += 1
    
        for shield in shields {
            let newPos = getRandomShieldPosition()
            shield.position = newPos
            shield.run(SKAction.move(to: newPos, duration: 0.5))
        }
    
        if score == 3 || score == 12 || score == 25 {
            addShield()
        }
    }
    
    func addShield() {
        let shield = SpriteFactory.getShield()
        shield.position = getRandomShieldPosition()
        shields.append(shield)
        addChild(shield)
    }
    
    func getRandomShieldPosition() -> CGPoint {
        let x = CGFloat.random(min: pigBoundingBox.minX + 25, max: pigBoundingBox.maxX - 25)
        let y = CGFloat.random(min: pigBoundingBox.minY + 50, max: pigBoundingBox.maxY - 25)
        return CGPoint(x: x, y: y)
    }
    
    func gameOver() {
        self.shouldResetFork = true
        print("game over")
        resetFork()
        score = 0
        velocityMultiplier = 1.0
        hitValue = 1
        coins = 0
        
        for shield in shields {
            shield.removeFromParent()
        }
        
        shields = []
        
        updateScoreLabel()
        updateCoinsLabel()
        updateTotalCoinsLabel()
        updateHighScoreLabel()
        forkLaunchable = true
    }
    
    func handleForkOffScreen() {
        gameOver()
    }
    
    func handleShieldHit() {
        gameOver()
    }
    
    func handleHomeTapped() {
        guard let controller = viewController else {
            return
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    func shieldHit() -> Bool {
        var hit = false
        enumerateChildNodes(withName: "shield") { shield, _ in
            if self.fork.frame.intersects(shield.frame) {
                hit = true
            }
        }
        return hit
    }
    
    func checkNonPhysicsCollisions() {
        if !intersects(fork) {
            handleForkOffScreen()
        }
    }
    
    func validSwipe(swipe: CGVector, time: Double) -> Bool {
        let magnitude = sqrt(pow(swipe.dx, 2) + pow(swipe.dy, 2))
        let scaledMagnitude = Double(magnitude) / time
        return scaledMagnitude > 600
    }
    
    func handleForkSwiped() {
        if !forkLaunchable {
            return
        }
        
        let dt = finalTouchTime - initialTouchTime
        let swipeVector = CGVector(dx: finalTouchLocation.x - initialTouchLocation.x, dy: finalTouchLocation.y - initialTouchLocation.y)
        
        if !validSwipe(swipe: swipeVector, time: dt) {
            return
            
        }
        
        let theta = atan2(swipeVector.dy, swipeVector.dx)
        if theta >= 0 && theta <= CGFloat.pi {
            fork.zRotation = theta - CGFloat.pi / 2
            let moveBySwipe = SKAction.move(by: swipeVector, duration: dt)
            forkLaunchable = false
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
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        finalTouchLocation = touches.first!.location(in: view)
        finalTouchLocation = CGPoint(x: finalTouchLocation.x, y: view!.bounds.height - finalTouchLocation.y)
        finalTouchTime = touches.first!.timestamp
        handleForkSwiped()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        finalTouchLocation = touches.first!.location(in: view)
        finalTouchLocation = CGPoint(x: finalTouchLocation.x, y: view!.bounds.height - finalTouchLocation.y)
        finalTouchTime = touches.first!.timestamp
        handleForkSwiped()
    }
    
    func movePig() {
        let adjustedVelocity = velocity * velocityMultiplier
        let amountToMove = adjustedVelocity * CGFloat(dt)
        pig.position += amountToMove
    }
    
    func rotatePig() {
        if velocity.x > 0 {
            pig.flipRight()
        } else {
            pig.flipLeft()
            
        }
        
    }
    
    func boundsCheckPig() {
        
        let widthOffset = (pig.physicsNode.frame.width / 2) * 0.75
        
        if pig.position.x - widthOffset <= pigBoundingBox.minX && velocity.x < 0 {
            velocity.x = -velocity.x
            rotatePig()
        }
        
        if pig.position.x + widthOffset >= pigBoundingBox.maxX && velocity.x > 0 {
            velocity.x = -velocity.x
            rotatePig()
        }
        
        if pig.position.y + pig.physicsNode.frame.minY <= pigBoundingBox.minY && velocity.y < 0 {
            velocity.y = -velocity.y
        }
        
        if pig.position.y + pig.physicsNode.frame.maxY >= pigBoundingBox.maxY && velocity.y > 0 {
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
        

    }
    
    override func didEvaluateActions() {
        checkNonPhysicsCollisions()
    }
    
    override func didSimulatePhysics() {
        if self.shouldResetFork {
            resetFork()
            self.shouldResetFork = false
        }
        if self.shouldResetPig {
            startExplosionAnimation()
            self.shouldResetPig = false
        }
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node!
        let nodeB = contact.bodyB.node!
        
        if nodeA.name == fork.name || nodeB.name == fork.name {
            if forkHitObject {
                return
            } else {
                forkHitObject = true
            }
            
            
            let otherNode = nodeA.name == fork.name ? nodeB : nodeA
            
            if otherNode.name == "shield" {
                print("hit shield")
                handleShieldHit()
            } else if otherNode.name == pig.name {
                print("hit pig")
                handlePigHit()
            }
        }
    }
}

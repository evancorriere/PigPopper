//
//  TutorialScene.swift
//  PigPopper
//
//  Created by Evan Corriere on 10/8/20.
//  Copyright © 2020 Evan Corriere. All rights reserved.
//

import SpriteKit
import GameplayKit

class TutorialScene: SKScene {
    
    weak var viewController: TutorialViewController?
    let pig: Pig = SpriteFactory.getPig()
    var fork: SKSpriteNode
    var baconSprites: [SKSpriteNode] = []
    
    var shield: SKNode?
    var playSoundEffects = true
    
    let explosionSound: SKAction = SKAction.playSoundFileNamed("explosion2.wav", waitForCompletion: false)
    let shootSound: SKAction = SKAction.playSoundFileNamed("shoot2.wav", waitForCompletion: false)
    let jetpackAnimation: SKAction
    let explosionAnimation: SKAction
    let jetpackAnimationKey = "jetpackAnimation"
    let forkMoveAnimationKey = "forkMoveAnimationKey"
    let defaultFont = "AmericanTypewriter"
    let forkLaunchPosition: CGPoint!
    
    
    var shouldResetFork = false
    var shouldResetPig = false
    var forkLaunchable = true
    var forkHitObject = false
    var ignoreCollisions = false
    
    var initialTouchLocation: CGPoint!
    var initialTouchTime: TimeInterval!
    var finalTouchLocation:CGPoint!
    var finalTouchTime: TimeInterval!
    
    var index = 0
    let instructions = [ "Swipe to launch the fork at the pig.\nRestart if you miss!", "Avoid Shields", "Earn higher scores to earn more bacon.\nSpend bacon on new weapons and hats in the shop!"]
    
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
        
        fork = SpriteFactory.getWeaponSprite(weaponName: SpriteFactory.defaultWeapon)
            
        super.init(size: size)
        
        let playableHeight = size.height * 0.60
        let minY = size.height - playableHeight - (view?.safeAreaInsets.top ?? 0)
        pig.setBoundingBox(boundingBox: CGRect(x: 0, y: minY, width: size.width, height: playableHeight))
        pig.tutorialScene = self
        
        playSoundEffects = DataHelper.getData(type: Bool.self, forKey: .settingsSoundEffects) ?? true
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        backgroundColor = .white
        
        let backgroundSprite = SpriteFactory.getBackgroundSprite(size: size)
        addChild(backgroundSprite)
        
        addChild(pig)
        resetPig()
        
        fork.position = forkLaunchPosition
        fork.zPosition = 5
        fork.zRotation = 0.0
        addChild(fork)
        
        setupIndex()
        
    }
    
    override func didEvaluateActions() {
        if !intersects(fork) {
            resetFork()
            forkLaunchable = true
        }
    }
    
    func resetPig() {
        pig.isHidden = true
        pig.reset()
        pig.startJetpackAnimation()
        pig.flipRight()
    
        
        if index < 2 {
            pig.velocity = CGPoint(x: 150, y: 0)
            let y = view!.bounds.size.height * 0.70
            pig.position = CGPoint(x: -40, y: y)
            forkLaunchable = true
        } else {
            pig.velocity = .zero
            pig.manuallySetHat(hat: "pirateHat")
            pig.position = CGPoint(x: size.width * 0.7, y: size.height * 0.7)
            fork.isHidden = false
        }
        
        pig.isHidden = false
    }
    
    func setupIndex() {
        if index < 0 || index >= instructions.count {
            return
        }
        
        viewController?.infoLabel.text = instructions[index]
        if index == 0 {
            pig.manuallySetHat(hat: nil)
        } else if index == 1 {
            shield = SpriteFactory.getShield()
            shield!.position = CGPoint(x: view!.bounds.width * 0.70, y: view!.bounds.height * 0.40)
            addChild(shield!)
        } else if index >= 2 {
            shield!.removeFromParent()
            shield = nil
            viewController?.button.isHidden = false
        }
    }
    
    func handlePigHit() {
        index += 1
        if index == 2 {
            ignoreCollisions = true
        }
        
        if playSoundEffects {
            run(explosionSound)
        }
        
        self.shouldResetFork = true
        self.shouldResetPig = true
        
        pig.velocity = CGPoint.zero
        pig.stopJetpackAnimation()
        
        addBaconSprites(count: 1, position: pig.position)
        
        
        setupIndex()
    }
    
   
    func addBaconSprites(count: Int, position: CGPoint) {
        let newBaconSprites = SpriteFactory.getBaconSprites(count: count)
        for baconSprite in newBaconSprites {
            
            baconSprite.position = position
            addChild(baconSprite)
            let randX = CGFloat.random(min: -200, max: 200)
            let randY = CGFloat.random(min: 0, max: 120)
            baconSprite.physicsBody?.velocity = CGVector(dx: randX, dy: randY)
        }
        
        baconSprites.append(contentsOf: newBaconSprites)
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
            
            if playSoundEffects {
                run(shootSound)
            }
            
            fork.run(SKAction.repeatForever(moveBySwipe), withKey: forkMoveAnimationKey)
        }
    }
    
    func resetFork() {
        fork.removeAction(forKey: forkMoveAnimationKey)
        fork.physicsBody?.velocity = .zero
        forkHitObject = false
        
        if index >= 2 {
            fork.removeFromParent()
            fork = SpriteFactory.getWeaponSprite(weaponName: "trident")
            fork.position = CGPoint(x: size.width * 0.3, y: size.height * 0.7)
            addChild(fork)
        } else {
            fork.position = forkLaunchPosition
            fork.zRotation = 0.0
        }
    }
    
    func validSwipe(swipe: CGVector, time: Double) -> Bool {
        let magnitude = sqrt(pow(swipe.dx, 2) + pow(swipe.dy, 2))
        let scaledMagnitude = Double(magnitude) / time
        return scaledMagnitude > 600
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        initialTouchLocation = touches.first!.location(in: view)
        initialTouchLocation = CGPoint(x: initialTouchLocation.x, y: view!.bounds.height - initialTouchLocation.y)
        initialTouchTime = touches.first!.timestamp
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
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        pig.update(currentTime)
    }
    
    override func didSimulatePhysics() {
        if self.shouldResetFork {
            resetFork()
            self.shouldResetFork = false
        }
        if self.shouldResetPig {
//            pig.reset()
            self.shouldResetPig = false
            if index >= 2 {
                fork.isHidden = true
            }
            pig.explode()
        }
    }
}

extension TutorialScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if ignoreCollisions {
            return
        }
        
        let nodeA = contact.bodyA.node!
        let nodeB = contact.bodyB.node!
        
        if nodeA.name == fork.name || nodeB.name == fork.name {
            if forkHitObject {
                return
            } else {
                forkHitObject = true
            }
            
            
            let otherNode = nodeA.name == fork.name ? nodeB : nodeA
            
            if otherNode.name == pig.name {
                handlePigHit()
            } else if shield != nil && otherNode.name == shield?.name {
                shouldResetFork = true
                forkLaunchable = true
            }
        }
    }
}

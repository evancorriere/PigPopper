//
//  Pig.swift
//  PigPopper
//
//  Created by Evan Corriere on 8/29/20.
//  Copyright © 2020 Evan Corriere. All rights reserved.
//

import UIKit
import SpriteKit

class Pig: SKNode {

    let imageNode = SKSpriteNode(imageNamed: "Jetpack_000")
    let physicsNode = SKShapeNode(rect: CGRect(x: -20, y: -40, width: 40, height: 80))
    var hatNode: SKSpriteNode?
    
    let jetpackAnimation: SKAction
    let jetpackAnimationKey = "jetpackAnimation"
    
    let explosionAnimation: SKAction
    let explosionAnimationKey = "explosionAnimation"
    
    var boundingBox: CGRect!
    var velocity = CGPoint.zero
    
    var dt: TimeInterval = 0
    var lastUpdateTime: TimeInterval = 0
    var velocityMultiplier: CGFloat = 1.0
    
    weak var gameScene: GameScene?
    
    override init() {
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
        
        super.init()
        
        imageNode.size = CGSize(width: 90, height: 90)
        addChild(imageNode)
        
        physicsNode.zPosition = 8
        physicsNode.name = self.name
        physicsNode.zRotation = -CGFloat.pi / 4.0
        physicsNode.physicsBody = generatePhysicsBody()
        physicsNode.position = CGPoint(x: 0, y: -10)
        physicsNode.alpha = 0.0
        addChild(physicsNode)
        
        
        
        
        hatNode = SpriteFactory.getSelectedHat()
        if hatNode != nil {
            hatNode?.zPosition = imageNode.zPosition + 1
            addChild(hatNode!)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func setBoundingBox(boundingBox: CGRect) {
        self.boundingBox = boundingBox
    }
    
    func reset() {
        setRandomPositionAndVelocity()
        if velocity.x > 0 {
            flipRight()
        } else {
            flipLeft()
        }
    }
    
    func resetSettings() {
        hatNode?.removeFromParent()
        hatNode = SpriteFactory.getSelectedHat()
        if hatNode != nil {
            hatNode?.zPosition = imageNode.zPosition + 1
            addChild(hatNode!)
        }
        
        if velocity.x < 0 {
            flipLeft()
        }
    }
    
    func flipLeft() {
        print("here")
        imageNode.xScale = -1.0
        physicsNode.zRotation = CGFloat.pi / 4.0
        if hatNode != nil {
            hatNode!.xScale = -1.0
            let oldPos = hatNode!.position
            hatNode!.position = CGPoint(x: -abs(oldPos.x), y: oldPos.y)
            hatNode!.zRotation = abs(hatNode!.zRotation)
        }
        
    }
    
    func flipRight() {
        imageNode.xScale = 1.0
        if hatNode != nil {
            hatNode!.xScale = 1.0
            let oldPos = hatNode!.position
            hatNode!.position = CGPoint(x: abs(oldPos.x), y: oldPos.y)
            hatNode!.zRotation = -abs(hatNode!.zRotation)
        }
        physicsNode.zRotation = -CGFloat.pi / 4.0
    }
    
    func startJetpackAnimation() {
        if imageNode.action(forKey: jetpackAnimationKey) == nil {
            imageNode.run(SKAction.repeatForever(jetpackAnimation), withKey: jetpackAnimationKey)
        }
    }
    
    func stopJetpackAnimation() {
           imageNode.removeAction(forKey: jetpackAnimationKey)
       }
    
    func explode() {
        if gameScene == nil {
            print("explode should not be called when gameScene is nil")
            return
        }
        
        if imageNode.action(forKey: explosionAnimationKey) == nil {
            let action = SKAction.sequence([
                explosionAnimation,
                SKAction.run {
                    [weak self] in self?.gameScene?.resetPig()
                },
                SKAction.run {
                    [weak self] in self?.hatNode?.isHidden = false
                }
            
            ])
            hatNode?.isHidden = true
            imageNode.run(action)
        }
    }
    
    func update(_ currentTime: TimeInterval) {
        // Called by GS update
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        
        move()
        boundsCheck()
    }
   
    private func generatePhysicsBody() -> SKPhysicsBody {
        let physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 40, height: 80))
        physicsBody.isDynamic = false
        physicsBody.categoryBitMask = CollisionTypes.pig.rawValue
        physicsBody.collisionBitMask = CollisionTypes.fork.rawValue
        physicsBody.contactTestBitMask = CollisionTypes.fork.rawValue
        return physicsBody
    }
    
    func move() {
        let adjustedVelocity = velocity * velocityMultiplier
        let amountToMove = adjustedVelocity * CGFloat(dt)
        position += amountToMove
    }
    
    
    func boundsCheck() {
        
        let widthOffset = (physicsNode.frame.width / 2) * 0.75
        
        if position.x - widthOffset <= boundingBox.minX && velocity.x < 0 {
            velocity.x = -velocity.x
            flipRight()
        }
        
        if position.x + widthOffset >= boundingBox.maxX && velocity.x > 0 {
            velocity.x = -velocity.x
            flipLeft()
        }
        
        if position.y + physicsNode.frame.minY <= boundingBox.minY && velocity.y < 0 {
            velocity.y = -velocity.y
        }
        
        if position.y + physicsNode.frame.maxY >= boundingBox.maxY && velocity.y > 0 {
            velocity.y = -velocity.y
        }
    }
    
    private func setRandomPositionAndVelocity() {
        // Goal: make it so top -> not very horizontal velocity.
        // left and right -> not super veritcal
        // Pi / 8 deadzones (so pi/8 missing from two spots)
        
        var spawningOnSides = false
        let validPerimeter = boundingBox.height * 2 + boundingBox.width
        let randomLocation = CGFloat.random(min: 0, max: validPerimeter)
        
        // left side, top, right side
        var position: CGPoint
        if randomLocation < boundingBox.height { // left side
            position = CGPoint(x: -physicsNode.frame.width, y: boundingBox.minY + randomLocation)
            spawningOnSides = true
        } else if randomLocation < boundingBox.height + boundingBox.width { // top
            let x = randomLocation - boundingBox.height
            position = CGPoint(x: x, y: boundingBox.maxY + physicsNode.frame.height)
            spawningOnSides = false
        } else {
            let y = boundingBox.minY + (validPerimeter - randomLocation)
            position = CGPoint(x: boundingBox.maxX + physicsNode.frame.width, y: y)
            spawningOnSides = true
        }
        
        // based on spawn location, find velocity angle and set velocity
        let deadzoneSize = CGFloat.pi / 8.0
        var randomAngle = CGFloat.random(min: 0, max: 2 * CGFloat.pi - 2 * deadzoneSize)
        
        // shift angle out of deadzones
        if spawningOnSides {
            // deadzoneas are at pi / 2 and 3pi / 2
            if randomAngle > (CGFloat.pi / 2) - deadzoneSize / 2 {
                randomAngle += deadzoneSize
            }
            
            if randomAngle > 3.0 * CGFloat.pi / 2.0 - deadzoneSize / 2.0 {
                randomAngle += deadzoneSize
            }
        } else {
            // spawning on top, deadzones are around 0 and pi
            randomAngle += deadzoneSize / 2.0
            if randomAngle > CGFloat.pi  - deadzoneSize / 2 {
                randomAngle += deadzoneSize
            }
            
        }
        
        let unitVelocity = vectorFromAngle(angle: randomAngle)
        self.velocity = unitVelocity * 200
        self.position = position
    }
}

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
    
    let jetpackAnimation: SKAction
    let jetpackAnimationKey = "jetpackAnimation"
    
    let explosionAnimation: SKAction
    let explosionAnimationKey = "explosionAnimation"
    
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func flipLeft() {
        imageNode.xScale = -1.0
        physicsNode.zRotation = CGFloat.pi / 4.0
        
    }
    
    func flipRight() {
        imageNode.xScale = 1.0
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
        if imageNode.action(forKey: explosionAnimationKey) == nil {
            let action = SKAction.sequence([
                explosionAnimation,
                SKAction.run {
                    [weak self] in self?.gameScene?.resetPig()
                    
                }])
            imageNode.run(action)
        }
    }
   
    private func generatePhysicsBody() -> SKPhysicsBody {
        let physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 40, height: 80))
        physicsBody.isDynamic = false
        physicsBody.categoryBitMask = CollisionTypes.pig.rawValue
        physicsBody.collisionBitMask = CollisionTypes.fork.rawValue
        physicsBody.contactTestBitMask = CollisionTypes.fork.rawValue
        return physicsBody
    }
}

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
  
    override func didMove(to view: SKView) {
        let labelNode = SKLabelNode()
        labelNode.text = "Welcome to the shop"
        labelNode.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        labelNode.verticalAlignmentMode = .center
        labelNode.horizontalAlignmentMode = .center
        addChild(labelNode)
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//    
//    }
}

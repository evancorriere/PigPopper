//
//  MainMenuScene.swift
//  PigPopper
//
//  Created by Evan Corriere on 6/23/20.
//  Copyright © 2020 Evan Corriere. All rights reserved.
//

import Foundation
import SpriteKit
import DynamoDB

class MainMenuScene: SKScene {
    
    
    weak var viewController: MainMenuViewController?
    
    let flyingPig = SpriteFactory.getPig()
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMove(to view: SKView) {
        let backgroundSprite = SpriteFactory.getBackgroundSprite(size: size)
        addChild(backgroundSprite)
        
    
        let playableHeight = size.height * 0.90
        let minY = size.height - playableHeight - view.safeAreaInsets.top
        flyingPig.setBoundingBox(boundingBox: CGRect(x: 0, y: minY, width: size.width, height: playableHeight))
        flyingPig.reset()
        flyingPig.velocityMultiplier = 0.6
        flyingPig.startJetpackAnimation()
        addChild(flyingPig)
    }
    
    func viewSafeAreaInsetsDidChange() {
        let playableHeight = size.height * 0.90
        let minY = size.height - playableHeight - (self.view?.safeAreaInsets.top ?? 0) * 0.7
        flyingPig.setBoundingBox(boundingBox: CGRect(x: 0, y: minY, width: size.width, height: playableHeight))
    }
    
    override func update(_ currentTime: TimeInterval) {
        flyingPig.update(currentTime)
    }
}

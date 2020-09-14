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
    
    let highScoreLabel = SKLabelNode(text: "High Score: 0")
    
    let pig = SKSpriteNode(imageNamed: "idle_000")
    
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
//        backgroundColor = .blue
//        
        let backgroundSprite = SpriteFactory.getBackgroundSprite(size: size)
        addChild(backgroundSprite)
//        
//
        print("CHECK")
        
        if !UserDefaults.standard.bool(forKey: "setupDone") {
            UserDefaults.standard.set(true, forKey: "owns_\(SpriteFactory.defaultWeapon)")
            UserDefaults.standard.set(SpriteFactory.defaultWeapon, forKey: SpriteFactory.selectedWeaponKey)
            UserDefaults.standard.set(true, forKey: "setupDone")
        }
        
       
        //TODO: add to spriteFactiory (pig factory?)
        pig.size = CGSize(width: 80, height: 80)
        pig.position = CGPoint(x: 30, y: 80)
        pig.zPosition = 25
        addChild(pig)
        startPigAnimation()
        
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
    
    func handleStartTapped() {
        let gameScene = GameScene(size: size)
        gameScene.scaleMode = scaleMode
        gameScene.viewController = self.viewController
        let transition = SKTransition.push(with: .left, duration: 1.0)
        view?.presentScene(gameScene, transition: transition)
    }
    
    func handleLeaderboardTapped() {
        let username = UserDefaults.standard.string(forKey: "username")
        if username != nil {
            viewController?.performSegue(withIdentifier: "leaderboardSegue", sender: nil)
        } else {
            showUsernamePrompt(isRetry: false)
        }
    }
    
    func showUsernamePrompt(isRetry: Bool) {
        let message = isRetry ? "Invalid username. Please try again" : "Select a unique username to be used in the global leaderboard"
        
        let alertController = UIAlertController(title: "Create a username", message: message, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.text = "Username..."
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (action) in
            guard let text = alertController.textFields?.first else { return }
            if self.validateUsername(username: text.text) {
                self.handleLeaderboardTapped()
            } else {
                self.showUsernamePrompt(isRetry: true)
            }
        }))
        self.viewController?.present(alertController, animated: true)
    }
    
    func validateUsername(username: String?) -> Bool {
        guard let username = username else {
            return false
        }
        
        let highscore = UserDefaults.standard.integer(forKey: "highScore")
        let leaderboardItem = LeaderboardItem(username: username, highscore: highscore).dynamoDBItem()
        
        let accessKey = "AKIAZDPKIW43E5RR3A7S" // TODO: remove
        let secretKey = "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"
        let tableName = "leaderboard"
        let dynamoDB = DynamoDB(accessKeyId: accessKey, secretAccessKey: secretKey, region: .uswest1)
        
        let putInput = DynamoDB.PutItemInput(conditionExpression: "attribute_not_exists(username)", item: leaderboardItem, tableName: tableName)
        do {
            let _ = try dynamoDB.putItem(putInput).wait()
            UserDefaults.standard.set(username, forKey: "username")
        } catch {
            print("error with db")
            return false
        }
        return true
    }
}

//
//  GameViewController.swift
//  PigPopper
//
//  Created by Evan Corriere on 9/13/20.
//  Copyright © 2020 Evan Corriere. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    
    @IBOutlet weak var highscoreLabel: UILabel!
    @IBOutlet weak var highscoreLabelView: UIView!
    @IBOutlet weak var baconLabel: UILabel!
    @IBOutlet weak var baconLabelView: UIView!
    
    var gameScene: GameScene?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
  
        

        gameScene = GameScene(size: view.bounds.size)
        gameScene?.viewController = self
        
        gameScene?.scaleMode = .aspectFill
      
        let skView = self.view as! SKView
        skView.showsPhysics = true
        skView.presentScene(gameScene!)
        
        
        highscoreLabelView.layer.masksToBounds = true
        highscoreLabelView.layer.cornerRadius = 10
        highscoreLabelView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.80)
        baconLabelView.layer.masksToBounds = true
        baconLabelView.layer.cornerRadius = 10
        baconLabelView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.80)
        
    }
    
    func updateBacon(bacon: Int) {
        baconLabel.text = "Bacon: \(bacon)"
    }
    
    func updateHighscore(highscore: Int) {
        highscoreLabel.text = "Highscore: \(highscore)"
    }
    
    override func viewSafeAreaInsetsDidChange() {
        gameScene?.viewSafeAreaInsetsDidChange()
    }
    
    override var shouldAutorotate: Bool {
        return false
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    

}

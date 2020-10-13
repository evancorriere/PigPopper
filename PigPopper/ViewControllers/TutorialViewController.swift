//
//  NewTutorialViewController.swift
//  PigPopper
//
//  Created by Evan Corriere on 10/8/20.
//  Copyright © 2020 Evan Corriere. All rights reserved.
//

import UIKit
import SpriteKit

class TutorialViewController: UIViewController {
  
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var button: MenuButton!
    
    var tutorialScene: TutorialScene?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tutorialScene = TutorialScene(size: view.bounds.size)
        tutorialScene?.viewController = self
        tutorialScene?.scaleMode = .aspectFill
        
        infoLabel.textColor = .white
        infoLabel.layer.cornerRadius = 10
        infoLabel.clipsToBounds = true
        
        let skView = self.view as! SKView
        skView.showsPhysics = false
        skView.presentScene(tutorialScene!)
        
    }
    
    
    
    @IBAction func buttonTapped(_ sender: Any) {
        DataHelper.setData(value: true, key: .tutorialCompleted)
        dismiss(animated: false)
    }
    
}

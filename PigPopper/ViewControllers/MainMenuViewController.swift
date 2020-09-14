//
//  GameViewController.swift
//  PigPopper
//
//  Created by Evan Corriere on 6/23/20.
//  Copyright © 2020 Evan Corriere. All rights reserved.
//

import UIKit
import SpriteKit

class MainMenuViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = MainMenuScene(size: view.bounds.size)
        let skView = self.view as! SKView
        scene.viewController = self
        
//        skView.showsNodeCount = true
//        skView.showsFPS = true
//        skView.showsPhysics = true
        
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pageView" {
            if let view = segue.destination as? LeaderboardViewController {
                view.preferredContentSize = CGSize(width: self.view.bounds.width * 0.80, height: self.view.bounds.width * 0.80)
                view.modalPresentationStyle = .overCurrentContext
            }
        }
    }
    
    
    @IBAction func muteTapped(_ sender: Any) {
        print("mute")
    }
    
    
}

extension MainMenuViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}


//
//  GameViewController.swift
//  PigPopper
//
//  Created by Evan Corriere on 6/23/20.
//  Copyright © 2020 Evan Corriere. All rights reserved.
//

import UIKit
import SpriteKit
import DynamoDB

class MainMenuViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var highscoreLabel: MenuLabel!
    @IBOutlet weak var baconLabel: MenuLabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        updateData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = MainMenuScene(size: view.bounds.size)
        let skView = self.view as! SKView
        scene.viewController = self
 
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
    
    private func updateData() {
        highscoreLabel.text = "Highscore: \(DataHelper.getHighscore())"
        baconLabel.text = "Bacon: \(DataHelper.getBacon())"
        imageView.image = UIImage(named: DataHelper.getSelectedWeapon())
    }
    
    func displayLeaderboard() {
        let leaderboardViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "leaderboardViewController") as LeaderboardViewController
        leaderboardViewController.preferredContentSize = CGSize(width: self.view.bounds.width * 0.80, height: self.view.bounds.width * 0.80)
        leaderboardViewController.modalPresentationStyle = .overCurrentContext
        present(leaderboardViewController, animated: true, completion: nil)
    }
    
      @IBAction func muteTapped(_ sender: Any) {
          print("mute")
      }
      
    
    @IBAction func leaderboardTapped(_ sender: Any) {
        let username = UserDefaults.standard.string(forKey: "username")
        if username != nil {
            displayLeaderboard()
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
                self.leaderboardTapped(self)
            } else {
                self.showUsernamePrompt(isRetry: true)
            }
        }))
        
        present(alertController, animated: true)
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

extension MainMenuViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}


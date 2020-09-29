//
//  AchievementView.swift
//  PigPopper
//
//  Created by Evan Corriere on 9/28/20.
//  Copyright © 2020 Evan Corriere. All rights reserved.
//

import UIKit

class AchievementView: UIView {

    static let instance = AchievementView()
    
    // UI
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var rewardLbl: UILabel!
    @IBOutlet weak var rewardImg: UIImageView!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var equipBtn: UIButton!
    
    // Data
    var achievements: [Achievement] = []
    var index = 0
    var callback: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("AchievementView", owner: self, options: nil)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func initialSetup() {
        titleLbl.layer.masksToBounds = true
        titleLbl.layer.cornerRadius = 15.0
        
        continueBtn.layer.masksToBounds = true
        continueBtn.layer.cornerRadius = 5.0
        
        equipBtn.layer.masksToBounds = true
        equipBtn.layer.cornerRadius = 5.0
        
        parentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        parentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

    }
    
    func displayAchievements(achievements: [Achievement], callback: (() -> Void)?) {
        if achievements.count == 0 {
            return
        }
        
        self.achievements = achievements
        self.index = 0
        self.callback = callback
        
        setupAchievementData()
        
        UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.addSubview(parentView)
    }
    
    private func setupAchievementData() {
        equipBtn.isHidden = false
        rewardImg.image = UIImage(named: achievements[index].reward)
        
        if let itemType = achievements[index].itemType {
            switch itemType {
            case .hat:
                rewardLbl.text = "Reward: New Hat!"
            case .weapon:
                rewardLbl.text = "Reward: New Weapon!"
            }
        } else {
            // bacon reward
            rewardLbl.text = "Reward: \(achievements[index].baconAmount!) Bacon!"
            equipBtn.isHidden = true
        }
    }
    
    @IBAction func continueTapped(_ sender: Any) {
        doneDisplayingAchievement()
    }
    
    @IBAction func equipTapped(_ sender: Any) {
        if let itemType = achievements[index].itemType {
            switch itemType {
            case .hat:
                DataHelper.setSelectedHat(hatName: achievements[index].reward)
            case .weapon:
                DataHelper.setSelectedWeapon(weaponName: achievements[index].reward)
            }
        }
        
        doneDisplayingAchievement()
    }
    
    private func doneDisplayingAchievement() {
        index += 1
        if index >= achievements.count {
            
            if self.callback != nil {
                self.callback!()
                print("going to call callback")
            }
            parentView.removeFromSuperview()
        } else {
            setupAchievementData()
        }
    }
    
}

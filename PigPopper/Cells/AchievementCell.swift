//
//  AchievementCell.swift
//  PigPopper
//
//  Created by Evan Corriere on 9/10/20.
//  Copyright © 2020 Evan Corriere. All rights reserved.
//

import UIKit

class AchievementCell: UITableViewCell {

    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var requirementLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var rewardImage: UIImageView!
    
    var achievement: Achievement?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setupWith(achievement: Achievement) {
        self.achievement = achievement
        rankLabel.text = achievement.rank
        requirementLabel.text = "Goal: \(achievement.requiredScore)"
        // TODO : setup progress bar
    }
    

}

//
//  ShopViewController.swift
//  PigPopper
//
//  Created by Evan Corriere on 8/23/20.
//  Copyright © 2020 Evan Corriere. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController {

    let weapons = [
        // the first weapons are earned via currency
        ShopItem(achievement: AchievementManager.achievements[1], itemType: .weapon),
        ShopItem(achievement: AchievementManager.achievements[4], itemType: .weapon),
        ShopItem(achievement: AchievementManager.achievements[7], itemType: .weapon),
        
        // the rest via bacon
        ShopItem(name: "dessert_fork", price: 0, itemType: .weapon),
        ShopItem(name: "cook_fork", price: 50, itemType: .weapon),
        ShopItem(name: "bread_knife", price: 100, itemType: .weapon),
        ShopItem(name: "whisk", price: 150, itemType: .weapon),
        ShopItem(name: "rolling_pin", price: 200, itemType: .weapon),
        ShopItem(name: "utility_knife", price: 250, itemType: .weapon),
        
        ShopItem(name: "screwdriver", price: 500, itemType: .weapon),
        ShopItem(name: "shovel", price: 550, itemType: .weapon),
        ShopItem(name: "chainsaw", price: 600, itemType: .weapon),
        
        ShopItem(name: "arrow", price: 750, itemType: .weapon),
        ShopItem(name: "sniper", price: 800, itemType: .weapon),
        ShopItem(name: "bullet", price: 850, itemType: .weapon),
        
        ShopItem(name: "spear", price: 1000, itemType: .weapon),
        ShopItem(name: "axe", price: 1500, itemType: .weapon),
        ShopItem(name: "axe_gold", price: 2000, itemType: .weapon),
        ShopItem(name: "gold_sword", price: 3000, itemType: .weapon),
        ShopItem(name: "dagger", price: 4000, itemType: .weapon),
        ShopItem(name: "trident", price: 5000, itemType: .weapon),
    ]
    
    let hats = [
        // the first hats are earned via achievement
        ShopItem(achievement: AchievementManager.achievements[0], itemType: .hat),
        ShopItem(achievement: AchievementManager.achievements[3], itemType: .hat),
        ShopItem(achievement: AchievementManager.achievements[6], itemType: .hat),
        
        // the rest via bacon
        ShopItem(name: "nurseHat", price: 30, itemType: .hat),
        ShopItem(name: "sunHat", price: 50, itemType: .hat),
        ShopItem(name: "militaryHat", price: 75, itemType: .hat),
        ShopItem(name: "beanieHat", price: 100, itemType: .hat),
        ShopItem(name: "antlersHat", price: 150, itemType: .hat),
        
        ShopItem(name: "policeHat", price: 200, itemType: .hat),
        ShopItem(name: "birthdayHat", price: 250, itemType: .hat),
        ShopItem(name: "pirateHat", price: 300, itemType: .hat),
        ShopItem(name: "armyHat", price: 400, itemType: .hat),
        ShopItem(name: "cowboyHat", price: 500, itemType: .hat),
        ShopItem(name: "firemanHat", price: 600, itemType: .hat),
       
        ShopItem(name: "pinwheelHat", price: 800, itemType: .hat),
        ShopItem(name: "hotdogHat", price: 1000, itemType: .hat),
        ShopItem(name: "leprechaunHat", price: 1500, itemType: .hat),
        ShopItem(name: "vikingHat", price: 2000, itemType: .hat),
        ShopItem(name: "sharkHat", price: 2500, itemType: .hat),
        ShopItem(name: "horseHeadHat", price: 3000, itemType: .hat)
    ]
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var coinsLabel: UILabel!
    @IBOutlet weak var itemTypeController: UISegmentedControl!
    
    var coins = 0
    var selectedItemType: ItemType = .weapon
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup
        coins = DataHelper.getBacon()
        updateLabels()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
    }
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func itemTypeChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 { // weapons
            selectedItemType = .weapon
            tableView.reloadData()
        } else if sender.selectedSegmentIndex == 1 { // hats
            selectedItemType = .hat
            tableView.reloadData()
        }
    }
    
    func updateLabels() {
        coins = DataHelper.getBacon()
        coinsLabel.text = "Bacon: \(self.coins)"
    }
    
}

extension ShopViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
    
}

extension ShopViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedItemType {
        case .weapon:
            return weapons.count
        case .hat:
            return hats.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shopCell", for: indexPath) as! ShopCell
        
        if selectedItemType == .hat {
            cell.setupWithItem(item: hats[indexPath.row])
        } else {
            cell.setupWithItem(item: weapons[indexPath.row])
        }
        
        cell.shopViewController = self
        cell.selectionStyle = .none
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
    
    
}

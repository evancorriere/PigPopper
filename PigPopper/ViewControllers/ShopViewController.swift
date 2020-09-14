//
//  ShopViewController.swift
//  PigPopper
//
//  Created by Evan Corriere on 8/23/20.
//  Copyright © 2020 Evan Corriere. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController {

    let items = [ ShopItem(name: "dessert_fork", price: 0),
                  ShopItem(name: "cook_fork", price: 50),
                  ShopItem(name: "bread_knife", price: 100),
                  ShopItem(name: "whisk", price: 150),
                  ShopItem(name: "rolling_pin", price: 200),
                  ShopItem(name: "utility_knife", price: 250),
                  
                  
                  ShopItem(name: "screwdriver", price: 500),
                  ShopItem(name: "shovel", price: 550),
                  ShopItem(name: "chainsaw", price: 600),
                  
                  
                  ShopItem(name: "arrow", price: 750),
                  ShopItem(name: "sniper", price: 800),
                  ShopItem(name: "bullet", price: 850),
                  
                  
                  ShopItem(name: "spear", price: 1000),
                  ShopItem(name: "axe", price: 1500),
                  ShopItem(name: "axe_gold", price: 2000),
                  ShopItem(name: "gold_sword", price: 3000),
                  ShopItem(name: "dagger", price: 4000),
                  ShopItem(name: "trident", price: 5000),
                  
    ]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var coinsLabel: UILabel!
    
    var coins = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coins = UserDefaults.standard.integer(forKey: "coins")
        updateLabels()
        
        
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
    }
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateLabels() {
        coins = UserDefaults.standard.integer(forKey: "coins")
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
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shopCell", for: indexPath) as! ShopCell
        let item = items[indexPath.row]
        cell.setupWithItem(item: item)
        cell.shopViewController = self
        cell.selectionStyle = .none
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
    
    
}

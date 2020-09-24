//
//  SettingsViewController.swift
//  PigPopper
//
//  Created by Evan Corriere on 9/10/20.
//  Copyright © 2020 Evan Corriere. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        print("tapp")
        dismiss(animated: true, completion: nil)
    }
    

}

extension SettingsViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(50)
    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        <#code#>
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerFrame = tableView.frame
        
        let title = UILabel()
        title.font = UIFont(name: "AmericanTypewriter", size: 20)
        title.text = self.tableView(self.tableView, titleForHeaderInSection: section)
        title.textColor = UIColor.white
        title.baselineAdjustment = .alignCenters
  
        
        title.frame = CGRect(x: 10, y: 0, width: headerFrame.size.width - 10, height: 30)

        let headerView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: headerFrame.size.width, height: headerFrame.size.height))
        headerView.backgroundColor = .darkGray
        headerView.addSubview(title)
        return headerView
    }
//
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "General"
        } else {
            return "Leaderboard"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
}

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        } else if section == 1 {
            return 2
        } else {
            return 0
        }
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 { // Music
                let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
                cell.setupWith(switchType: .music)
                return cell
            } else if indexPath.row == 1 { // Sound Effects
                let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
                cell.setupWith(switchType: .soundEffects)
                return cell
            } else if indexPath.row == 2 { // About
                let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonCell
                cell.setupWith(label: "About Pig Popper! ", button: .about)
                cell.selectionStyle = .none
                return cell
            } else if indexPath.row == 3 { // Credits
                let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonCell
                cell.setupWith(label: "Credits: ", button: .credits)
                cell.selectionStyle = .none
                return cell
            } else if indexPath.row == 4 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonCell
                cell.setupWith(label: "Support / report a bug!", button: .support)
                cell.selectionStyle = .none
                return cell
            } else {
                return UITableViewCell()
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 { // change username
                let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonCell
                let username = DataHelper.getUsername()
                let labelText = username == nil ? "Set name" : "Username: \(username!)"
                cell.setupWith(label: labelText, button: .changeName)
                cell.selectionStyle = .none
                return cell
            } else if indexPath.row == 1 { // remove from leaderboard
                let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonCell
                cell.setupWith(label: "Delete score", button: .deleteData)
                cell.selectionStyle = .none
                return cell
            } else if indexPath.row == 2 {
                
            }
        }
        return UITableViewCell()
    }
    

    
    
}


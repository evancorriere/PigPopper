//
//  TutorialViewController.swift
//  PigPopper
//
//  Created by Evan Corriere on 10/8/20.
//  Copyright © 2020 Evan Corriere. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var pageViewController: TutorialPageViewController?
    
    var data: TutorialViewData?
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("here43")
    
        // Do any additional setup after loading the view.
        if data != nil {
            loadData()
        }
        
        
        
    }
    
    func setupWith(data: TutorialViewData) {
        self.data = data
        if isViewLoaded {
            loadData()
        }
        index = data.index!
    }
    
    func loadData() {
        label.text = data?.label
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        pageViewController?.incrementPage(currentIndex: data?.index ?? -1)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

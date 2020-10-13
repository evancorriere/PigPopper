//
//  tutorialPageViewController.swift
//  PigPopper
//
//  Created by Evan Corriere on 10/8/20.
//  Copyright © 2020 Evan Corriere. All rights reserved.
//

import UIKit

struct TutorialViewData {
    var label: String
    var image: String
    var index: Int?
}

let tutorialData: [TutorialViewData] = [ TutorialViewData(label: "Screen 1", image: "background"), TutorialViewData(label: "Screen 2", image: "background"), TutorialViewData(label: "Screen 3", image: "background"), TutorialViewData(label: "Screen 4", image: "background") ]


class TutorialPageViewController: UIPageViewController {
    
    
    override func viewDidLoad() {
        print("View will load")
        super.viewDidLoad()
        print("view did load")
        
        // Do any additional setup after loading the view.
        delegate = self
        dataSource = self
        
        guard let initialVC = tutorialViewController(index: 0) else {
            print("nil initial")
            return
        }
        
        setViewControllers([initialVC], direction: .forward, animated: false)
    }
    
    
    func tutorialViewController(index: Int) -> TutorialViewController? {
        if index < 0 || index >= tutorialData.count || tutorialData.count == 0 {
            return nil
        }
        
        guard let tutorialViewController = storyboard?.instantiateViewController(identifier: String(describing: TutorialViewController.self)) as? TutorialViewController else {
            print("nil VC")
            return nil
        }
        
        var data = tutorialData[index]
        data.index = index
        tutorialViewController.pageViewController = self
        tutorialViewController.setupWith(data: data)
        
        return tutorialViewController
    }
    
    func incrementPage(currentIndex: Int) {
        let nextIndex = currentIndex + 1
        if currentIndex >= tutorialData.count {
            dismiss(animated: true)
        }
        
        guard let nextVC = tutorialViewController(index: nextIndex) else {
            return
        }
        
        setViewControllers([nextVC], direction: .forward, animated: false)
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
extension TutorialPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let tutorialView = viewController as? TutorialViewController
        guard let index = tutorialView?.index else {
            return nil
        }
        
        
        return tutorialViewController(index: index - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let tutorialView = viewController as? TutorialViewController
        guard let index = tutorialView?.index else {
            return nil
        }
        
        return tutorialViewController(index: index + 1)
    }
    
    
}

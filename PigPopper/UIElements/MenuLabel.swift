//
//  MenuLabel.swift
//  PigPopper
//
//  Created by Evan Corriere on 9/12/20.
//  Copyright © 2020 Evan Corriere. All rights reserved.
//

import UIKit

class MenuLabel: UILabel {
    
    let defaultFont = "AmericanTypewriter-Bold"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    private func setup() {
        font = UIFont(name: defaultFont, size: 30)
        textColor = .white
    }

}

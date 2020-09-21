//
//  MenuButton.swift
//  PigPopper
//
//  Created by Evan Corriere on 9/12/20.
//  Copyright © 2020 Evan Corriere. All rights reserved.
//

import UIKit

class MenuButton: UIButton {
    
    let defaultFont = "AmericanTypewriter-Bold"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        titleLabel?.font = UIFont(name: defaultFont, size: 18)
        layer.cornerRadius = 5
        setTitleColor(.white, for: .normal)
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }

}

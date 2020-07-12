//
//  LightOnlyModeViewController.swift
//  Droar_Example
//
//  Created by Feng Chang on 7/11/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class LightOnlyModeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //Setup
    func setupUI() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }
}

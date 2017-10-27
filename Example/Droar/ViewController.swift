//
//  ViewController.swift
//  Droar
//
//  Created by Janglinator on 06/05/2017.
//  Copyright (c) 2017 Janglinator. All rights reserved.
//

import UIKit
import Droar

class ViewController: UIViewController, DroarKnob {
    func droarKnobTitle() -> String {
        return "ViewController"
    }
    
    func droarKnobPosition() -> PositionInfo {
        return PositionInfo(position: .top, priority: .low)
    }
    
    func droarKnobNumberOfCells() -> Int {
        return 1
    }
    
    func droarKnobCellForIndex(index: Int, tableView: UITableView) -> DroarCell {
        return DroarLabelCell.create(title: "Dynamic knob!", detail: "Neat!", allowSelection: false)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


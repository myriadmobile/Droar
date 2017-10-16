//
//  ViewController.swift
//  Droar
//
//  Created by Janglinator on 06/05/2017.
//  Copyright (c) 2017 Janglinator. All rights reserved.
//

import UIKit
import Droar

class ViewController: UIViewController, IDroarSource {
    func droarSectionTitle() -> String {
        return "ViewController"
    }
    
    func droarSectionPosition() -> PositionInfo {
        return PositionInfo(position: .top, priority: .low)
    }
    
    func droarSectionNumberOfCells() -> Int {
        return 1
    }
    
    func droarSectionCellForIndex(index: Int, tableView: UITableView) -> UITableViewCell {
        return DroarLabelCell.create(title: "Dynamic source!", detail: "Neat!", allowSelection: false)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


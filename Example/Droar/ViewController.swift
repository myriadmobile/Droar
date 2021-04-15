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
        
        view.backgroundColor = UIColor.white
        
        if #available(iOS 12.0, *) {
            // Start observing style change
            startObserving(&UserInterfaceStyleManager.shared)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func presentTest(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let rootVC = storyboard.instantiateInitialViewController() else { return }
        present(rootVC, animated: true, completion: nil)
    }
    
    @IBAction func showLightOnlyModeView(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "LightOnlyMode", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LightOnlyModeViewController") as! LightOnlyModeViewController
        self.present(vc, animated: true, completion: nil)
    }
}


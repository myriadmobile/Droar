//
//  DroarViewController.swift
//  Pods
//
//  Created by Nathan Jangula on 8/15/17.
//
//

import UIKit

class DroarViewController: UITableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return SectionManager.sharedInstance.sources.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SectionManager.sharedInstance.sources[section].droarSectionNumberOfCells()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return SectionManager.sharedInstance.sources[indexPath.section].droarSectionCellForIndex(index: indexPath.row, tableView: tableView)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let indexSelectedAction = SectionManager.sharedInstance.sources[indexPath.section].droarSectionIndexSelected {
            indexSelectedAction(tableView, indexPath.row)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

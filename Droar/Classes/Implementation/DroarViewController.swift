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
        return SectionManager.sharedInstance.sources[section].sectionNumberOfCells()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return SectionManager.sharedInstance.sources[indexPath.section].sectionCellForIndex(index: indexPath.row, tableView: tableView)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var shouldDeselect = true
        SectionManager.sharedInstance.sources[indexPath.section].indexSelected(tableView: tableView, selectedIndex: indexPath.row, shouldDeselect: &shouldDeselect)
        
        if (shouldDeselect) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

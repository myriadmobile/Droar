//
//  DroarViewController.swift
//  Pods
//
//  Created by Nathan Jangula on 8/15/17.
//
//

import UIKit

class DroarViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "DROAR"
        
        if let fontUrl = Bundle.podBundle.url(forResource: "RussoOne-Regular", withExtension: ".ttf") {
            do {
                try UIFont.register(url: fontUrl)
            } catch let error {
                NSLog(error.localizedDescription)
            }
        }
        
        navigationController?.navigationBar.barStyle = UIBarStyle.blackOpaque
        navigationController?.navigationBar.barTintColor = UIColor(red: 45/255, green: 88/255, blue: 124/255, alpha: 1.0)
        navigationController?.navigationBar.tintColor = UIColor.white
        let font = UIFont(name: "Russo One", size: 30) ?? UIFont.systemFont(ofSize: 30)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: font]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return SectionManager.sharedInstance.visibleKnobs.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SectionManager.sharedInstance.visibleKnobs[section].droarSectionNumberOfCells()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return SectionManager.sharedInstance.visibleKnobs[indexPath.section].droarSectionCellForIndex(index: indexPath.row, tableView: tableView) as! UITableViewCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let indexSelectedAction = SectionManager.sharedInstance.visibleKnobs[indexPath.section].droarSectionIndexSelected {
            indexSelectedAction(tableView, indexPath.row)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return SectionManager.sharedInstance.visibleKnobs[section].droarSectionTitle()
    }
}

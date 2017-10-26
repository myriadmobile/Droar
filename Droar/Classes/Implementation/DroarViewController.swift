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
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 45
        
        let font = UIFont(name: "Russo One", size: 30) ?? UIFont.systemFont(ofSize: 30)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        label.textAlignment = .center
        label.autoresizingMask = [.flexibleWidth]
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "Droar_icon", in: Bundle.podBundle, compatibleWith: nil)
        attachment.bounds = CGRect(x: 0, y: -8, width: 40, height: 40)
        let attributedString = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
        attributedString.append(NSAttributedString(string: " DROAR", attributes: [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: UIColor.white]))
        label.attributedText = attributedString
        navigationItem.titleView = label
        
        navigationController?.navigationBar.barStyle = UIBarStyle.blackOpaque
        navigationController?.navigationBar.barTintColor = UIColor.droarBlue
        navigationController?.navigationBar.tintColor = UIColor.white
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
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Russo One", size: 15)
        header.textLabel?.textColor = UIColor.droarBlue
    }
}

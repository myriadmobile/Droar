//
//  DroarViewController.swift
//  Pods
//
//  Created by Nathan Jangula on 8/15/17.
//
//

import UIKit

class DroarViewController: UITableViewController {
    
    //Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        setupNav()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    //Setup
    func setupTable() {
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func setupNav() {
        //Styling
        navigationController?.navigationBar.barStyle = .blackOpaque
        navigationController?.navigationBar.barTintColor = .droarBlue
        navigationController?.navigationBar.tintColor = .white
        
        //Title
        let droarIcon = UIImage(named: "Droar_icon", in: Bundle.podBundle, compatibleWith: nil)
        
        let attachment = NSTextAttachment()
        attachment.image = droarIcon
        attachment.bounds = CGRect(x: 0, y: -8, width: 40, height: 40)
        let attributedString = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
        attributedString.append(NSAttributedString(string: " DROAR", attributes: [NSAttributedString.Key.font: UIFont.russo(30), NSAttributedString.Key.foregroundColor: UIColor.white]))
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        label.textAlignment = .center
        label.autoresizingMask = [.flexibleWidth]
        label.attributedText = attributedString
        
        navigationItem.titleView = label
    }
    
}

//Datasource
extension DroarViewController {
    
    //Counts
    override func numberOfSections(in tableView: UITableView) -> Int {
        return KnobManager.sharedInstance.visibleSections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return KnobManager.sharedInstance.visibleSections[section].numberOfCells()
    }
    
    //Cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return KnobManager.sharedInstance.visibleSections[indexPath.section].droarKnobCellForIndex(index: indexPath.row, tableView: tableView)
    }
    
    //Headers
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return KnobManager.sharedInstance.visibleSections[section].title
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = .russo(15)
        header.textLabel?.textColor = .droarBlue
    }
    
    //Footers
    
}

//Delegate
extension DroarViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        guard cell.selectionStyle != .none else { return }
        
        KnobManager.sharedInstance.visibleSections[indexPath.section].droarKnobIndexSelected(tableView: tableView, selectedIndex: indexPath.row)
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
}

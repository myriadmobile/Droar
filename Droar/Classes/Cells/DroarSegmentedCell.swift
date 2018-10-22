//
//  DroarSegmentedCell.swift
//  Droar
//
//  Created by Nathan Jangula on 10/26/17.
//

import Foundation

public class DroarSegmentedCell : UITableViewCell, DroarCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var onValueChanged: ((Int) -> Void)?
    
    public var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    public var selectedIndex: Int? {
        get {
            #if swift(>=4.2)
            return segmentedControl.selectedSegmentIndex == UISegmentedControl.noSegment ? nil : segmentedControl.selectedSegmentIndex
            #else
            return segmentedControl.selectedSegmentIndex == UISegmentedControlNoSegment ? nil : segmentedControl.selectedSegmentIndex
            #endif
        }
        set {
            #if swift(>=4.2)
            segmentedControl.selectedSegmentIndex = (newValue == nil) ? UISegmentedControl.noSegment : newValue!
            #else
            segmentedControl.selectedSegmentIndex = (newValue == nil) ? UISegmentedControlNoSegment : newValue!
            #endif
        }
    }
    
    public var allowSelection: Bool {
        get { return selectionStyle != .none }
        set { selectionStyle = newValue ? .gray : .none }
    }
    
    public static func create(title: String? = "", values:[String] = [], defaultIndex:Int? = nil, allowSelection: Bool = false, onValueChanged: ((Int) -> Void)? = nil) -> DroarSegmentedCell {
        var cell: DroarSegmentedCell?
        
        for view in Bundle.podBundle.loadNibNamed("DroarSegmentedCell", owner: self, options: nil) ?? [Any]() {
            if view is DroarSegmentedCell {
                cell = view as? DroarSegmentedCell
                break
            }
        }
        
        cell?.title = title
        cell?.segmentedControl.removeAllSegments()
        for value in values {
            cell?.segmentedControl.insertSegment(withTitle: value, at: values.index(of: value)!, animated: false)
        }
        cell?.selectedIndex = defaultIndex
        cell?.allowSelection = allowSelection
        cell?.onValueChanged = onValueChanged
        
        let font = UIFont(name: "Russo One", size: 12) ?? UIFont.systemFont(ofSize: 12)
        cell?.segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font : font], for: .normal)
        
        return cell ?? DroarSegmentedCell()
    }
    
    @IBAction func handleValueChanged(_ sender: Any) {
        guard let onValueChanged = onValueChanged else { return }
        onValueChanged(segmentedControl.selectedSegmentIndex)
    }
    
    public func setEnabled(_ enabled: Bool) {
        titleLabel.isEnabled = enabled
        segmentedControl.isEnabled = enabled
        backgroundColor = enabled ? UIColor.white : UIColor.disabledGray
        isUserInteractionEnabled = enabled
    }
    
    public func stateDump() -> [String : String]? {
        guard let text = titleLabel.text else { return nil }
        guard segmentedControl.selectedSegmentIndex > 0 else { return [text: ""]}
        guard let value = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex) else { return nil }
        return [text : value]
    }
}

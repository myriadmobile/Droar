//
//  DroarSwitchCell.swift
//  Droar
//
//  Created by Nathan Jangula on 10/26/17.
//

import Foundation

public class DroarSwitchCell : UITableViewCell, DroarCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var toggleSwitch: UISwitch!
    var onValueChanged: ((Bool) -> Void)?
    
    public static func create(title: String? = "", defaultValue: Bool = false, allowSelection: Bool = false, onValueChanged: ((Bool) -> Void)? = nil) -> DroarSwitchCell {
        var cell: DroarSwitchCell?
        
        for view in Bundle.podBundle.loadNibNamed("DroarSwitchCell", owner: self, options: nil) ?? [Any]() {
            if view is DroarSwitchCell {
                cell = view as? DroarSwitchCell
                break
            }
        }
        
        cell?.titleLabel.text = title
        cell?.toggleSwitch.isOn = defaultValue
        cell?.selectionStyle = allowSelection ? .gray : .none
        cell?.onValueChanged = onValueChanged
        
        return cell ?? DroarSwitchCell()
    }
    
    @IBAction func handleSwitchChanged(_ sender: Any) {
        guard let onValueChanged = onValueChanged else { return }
        onValueChanged(toggleSwitch.isOn)
    }
    
    public func setEnabled(_ enabled: Bool) {
        titleLabel.isEnabled = enabled
        toggleSwitch.isEnabled = enabled
        backgroundColor = enabled ? UIColor.white : UIColor.disabledGray
        isUserInteractionEnabled = enabled
    }
    
    public func stateDump() -> [String : String]? {
        guard let text = titleLabel.text else { return nil }
        return [text : toggleSwitch.isOn ? "True" : "False"]
    }
}

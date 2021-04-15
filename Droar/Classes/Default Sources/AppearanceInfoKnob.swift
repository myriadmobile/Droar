//
//  AppearanceInfoKnob.swift
//  Droar
//
//  Created by Feng Chang on 7/11/20.
//

import Foundation

@available(iOS 12.0, *)
internal class AppearanceInfoKnob : DroarKnob {
    
    private enum BuildInfoRow: Int {
        case mode = 0
        case count = 1
    }
    
    func droarKnobTitle() -> String {
        return "Appearance Info"
    }
    
    func droarKnobPosition() -> PositionInfo {
        return PositionInfo(position: .bottom, priority: .low)
    }
    
    func droarKnobNumberOfCells() -> Int {
        return BuildInfoRow.count.rawValue
    }
    
    func droarKnobCellForIndex(index: Int, tableView: UITableView) -> DroarCell {
        let defaultIndex = UserDefaults.standard.bool(forKey: UserInterfaceStyleManager.userInterfaceStyleDarkModeOn) ? 1 : 0
        let cell = DroarSegmentedCell.create(title: "Appearance", values: ["Light", "Dark"], defaultIndex: defaultIndex, allowSelection: false, onValueChanged: { (value) in
            let darkModeOn = value == 1
            
            // Store in UserDefaults
            UserDefaults.standard.set(darkModeOn, forKey: UserInterfaceStyleManager.userInterfaceStyleDarkModeOn)
            
            // Update interface style
            UserInterfaceStyleManager.shared.updateUserInterfaceStyle(darkModeOn)
        })
        
        return cell
    }
}

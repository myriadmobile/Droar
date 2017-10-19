//
//  netfox_Droar.swift
//  netfox-Droar
//
//  Created by Nathan Jangula on 10/12/17.
//

import Foundation
import Droar
import netfox

@objc public class netfox_Droar : NSObject, IDroarSource {
    public func droarSectionTitle() -> String {
        return "Sample Cells"
    }
    
    public func droarSectionPosition() -> PositionInfo {
        return PositionInfo(position: .top, priority: .high)
    }
    
    public func droarSectionNumberOfCells() -> Int {
        return 1
    }
    
    public func droarSectionCellForIndex(index: Int, tableView: UITableView) -> UITableViewCell {
        return DroarLabelCell.create(title: "Launch Netfox", detail: "", allowSelection: true)
    }
    
    public func droarSectionIndexSelected(tableView: UITableView, selectedIndex: Int) {
        Droar.toggleVisibility()
        NFX.sharedInstance().show()
    }
    
    private static let sharedInstance = netfox_Droar()
    private static let dispatchOnce = DispatchOnce()
    
    @objc internal static func start() {
        dispatchOnce.perform {
            // We need to let the application load first
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                NFX.sharedInstance().start()
                NFX.sharedInstance().setGesture(NFX.ENFXGesture.custom)
                Droar.register(source: sharedInstance)
            })
        }
    }
}

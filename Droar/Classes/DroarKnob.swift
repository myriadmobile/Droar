//
//  DroarKnob.swift
//  Pods
//
//  Created by Nathan Jangula on 9/1/17.
//
//

import Foundation

@objc public enum KnobPosition: UInt {
    case top = 1
    case middle = 2
    case bottom = 3
}

extension KnobPosition : Comparable {
    public static func <(lhs: KnobPosition, rhs: KnobPosition) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

@objc public enum PositionPriority: UInt {
    case high = 1
    case medium = 2
    case low = 3
}

extension PositionPriority : Comparable {
    public static func <(lhs: PositionPriority, rhs: PositionPriority) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

@objc public class PositionInfo: NSObject {
    @objc public init(position: KnobPosition = .middle, priority:PositionPriority = .medium) {
        self.position = position
        self.priority = priority
    }
    @objc public private(set) var position: KnobPosition
    @objc public private(set) var priority: PositionPriority
}

@objc public protocol DroarKnob {
    // Invoked after the knob is first registered, and Droar is started.
    @objc optional func droarKnobDidFinishRegistering()
    
    // Perform any setup before this knob loads (Register table cells, clear cached data, etc)
    @objc optional func droarKnobWillBeginLoading(tableView: UITableView?)
    
    // Title for this knob.  If title matches existing knob, they will be combined
    @objc func droarKnobTitle() -> String
    
    // The positioning and priorty for this knob
    @objc func droarKnobPosition() -> PositionInfo
    
    // The number of cells for this knob
    @objc func droarKnobNumberOfCells() -> Int
    
    // The cell at the specified index.  There are many pre-defined cells, just use Droar<#type#>Cell.create(), or create your own.
    @objc func droarKnobCellForIndex(index: Int, tableView: UITableView) -> DroarCell
    
    // Indicates the cell was selected.  This will not be called if `UITableViewCell.selectionStyle == .none`
    @objc optional func droarKnobIndexSelected(tableView: UITableView, selectedIndex: Int)
}

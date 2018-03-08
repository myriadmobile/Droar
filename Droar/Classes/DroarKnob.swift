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
    @objc optional func droarKnobWillBeginLoading(tableView: UITableView?)
    @objc func droarKnobTitle() -> String
    @objc func droarKnobPosition() -> PositionInfo
    @objc func droarKnobNumberOfCells() -> Int
    @objc func droarKnobCellForIndex(index: Int, tableView: UITableView) -> DroarCell
    @objc optional func droarKnobIndexSelected(tableView: UITableView, selectedIndex: Int)
}

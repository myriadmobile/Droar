//
//  IDroarKnob.swift
//  Pods
//
//  Created by Nathan Jangula on 9/1/17.
//
//

import Foundation

@objc public enum SectionPosition: UInt {
    case top = 1
    case middle = 2
    case bottom = 3
}

@objc public enum PositionPriority: UInt {
    case high = 1
    case medium = 2
    case low = 3
}

@objc public class PositionInfo: NSObject {
    @objc public init(position: SectionPosition = .middle, priority:PositionPriority = .medium) {
        self.position = position
        self.priority = priority
    }
    @objc public private(set) var position: SectionPosition
    @objc public private(set) var priority: PositionPriority
}

@objc public protocol IDroarKnob {
    @objc optional func droarSectionWillBeginLoading(tableView: UITableView?)
    @objc func droarSectionTitle() -> String
    @objc func droarSectionPosition() -> PositionInfo
    @objc func droarSectionNumberOfCells() -> Int
    @objc func droarSectionCellForIndex(index: Int, tableView: UITableView) -> UITableViewCell
    @objc optional func droarSectionIndexSelected(tableView: UITableView, selectedIndex: Int)
}

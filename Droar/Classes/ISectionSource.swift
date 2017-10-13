//
//  ISectionSource.swift
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
    init(position: SectionPosition = .middle, priority:PositionPriority = .medium) {
        self.position = position
        self.priority = priority
    }
    private(set) var position: SectionPosition
    private(set) var priority: PositionPriority
}

@objc public protocol ISectionSource {
    func sectionTitle() -> String
    func sectionPosition() -> PositionInfo
    func sectionNumberOfCells() -> Int
    func sectionCellForIndex(index: Int, tableView: UITableView) -> UITableViewCell
}

public extension ISectionSource {
    func performSetup(tableView: UITableView) {}
    func indexSelected(tableView: UITableView, selectedIndex: Int, shouldDeselect: inout Bool) {}
}

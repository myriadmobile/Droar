//
//  ISectionSource.swift
//  Pods
//
//  Created by Nathan Jangula on 9/1/17.
//
//

import Foundation

public enum SectionPosition: UInt {
    case top = 1
    case middle = 2
    case bottom = 3
}

public enum PositionPriority: UInt {
    case high = 1
    case medium = 2
    case low = 3
}

public struct PositionInfo {
    init(position: SectionPosition = SectionPosition.middle, priority:PositionPriority) {
        self.position = position
        self.priority = priority
    }
    private(set) var position: SectionPosition
    private(set) var priority: PositionPriority
}

public protocol ISectionSource {
    func sectionTitle() -> String
    func sectionPosition() -> PositionInfo
    func sectionNumberOfCells() -> Int
    func sectionCellForIndex(index: Int, tableView: UITableView) -> UITableViewCell
}

public extension ISectionSource {
    func performSetup(tableView: UITableView) {}
    func indexSelected(tableView: UITableView, selectedIndex: Int, shouldDeselect: inout Bool) {}
}

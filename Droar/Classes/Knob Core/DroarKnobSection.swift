//
//  DroarKnobSection.swift
//  Droar
//
//  Created by Alex Larson on 10/14/19.
//

import UIKit

public class DroarKnobSection {
    
    //State
    public private(set) var knobs: [DroarKnob]
    public private(set) var title: String
    public private(set) var positionInfo: PositionInfo
    public private(set) var cellCountMappings: [Int]
    
    //Init
    public init(_ knob: DroarKnob) {
        self.knobs = [knob]
        self.title = knob.droarKnobTitle()
        self.positionInfo = knob.droarKnobPosition()
        self.cellCountMappings = [knob.droarKnobNumberOfCells()]
    }
    
    //Accessors
    public func add(_ knob: DroarKnob) {
        self.knobs.append(knob)
        
        let positionInfo = knob.droarKnobPosition()
        let position = max(self.positionInfo.position, positionInfo.position)
        let priority = max(self.positionInfo.priority, positionInfo.priority)
        self.positionInfo = PositionInfo(position: position, priority: priority)
        
        cellCountMappings.append(knob.droarKnobNumberOfCells())
    }
    
    //Table Logic
    func numberOfCells() -> Int {
        var count = 0
    
        for sectionCount in cellCountMappings {
            count += sectionCount
        }
        
        return count
    }
    
    func droarKnobCellForIndex(index: Int, tableView: UITableView) -> DroarCell {
        let indexPath = mappedIndex(index)
        return knobs[indexPath.section].droarKnobCellForIndex(index: indexPath.row, tableView: tableView)
    }
    
    func droarKnobIndexSelected(tableView: UITableView, selectedIndex: Int) {
        let indexPath = mappedIndex(selectedIndex)
        knobs[indexPath.section].droarKnobIndexSelected?(tableView: tableView, selectedIndex: indexPath.row)
    }
    
    private func mappedIndex(_ index: Int) -> NSIndexPath {
        var section = 0
        var count = 0
        
        for sectionCount in cellCountMappings {
            if count + sectionCount <= index {
                section += 1
                count += sectionCount
            } else {
                break
            }
        }
        
        return NSIndexPath(row: index - count, section: section)
    }
    
}

//
//  SectionManger.swift
//  Pods
//
//  Created by Nathan Jangula on 9/1/17.
//
//

import Foundation

class SectionManager {
    
    static let sharedInstance = SectionManager()
    public private(set) var sources = [ISectionSource]()
    
    private init() {
        sources.append(BuildInfoSource())
        sources.append(DeviceInfoSource())
        sortSources()
    }
    
    public func registerSource(source: ISectionSource) {
        if (!sources.contains(where: { (existingSource) -> Bool in
            return existingSource.sectionTitle() == source.sectionTitle()
        })) {
            cacheSources(newSource: source)
        }
    }
    
    private func cacheSources(newSource: ISectionSource) {
        sources.append(newSource)
        sortSources()
    }
    
    private func sortSources() {
        sources.sort { (source1, source2) -> Bool in
            let position1 = source1.sectionPosition()
            let position2 = source2.sectionPosition()
            
            if (position1.position != position2.position)
            {
                return position1.position.rawValue >= position2.position.rawValue
            }
            
            return position1.priority.rawValue >= position2.priority.rawValue
        }
    }
    
    public func initializeSections(tableView: UITableView) {
        for section in sources {
            section.performSetup(tableView: tableView)
        }
    }
}

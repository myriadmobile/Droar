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
    public private(set) var sources = [IDroarSource]()
    
    private init() {
        sources.append(BuildInfoSource())
        sources.append(DeviceInfoSource())
        sortSources()
    }
    
    public func registerSource(source: IDroarSource) {
        if (!sources.contains(where: { (existingSource) -> Bool in
            return existingSource.droarSectionTitle() == source.droarSectionTitle()
        })) {
            cacheSources(newSource: source)
        }
    }
    
    private func cacheSources(newSource: IDroarSource) {
        sources.append(newSource)
        sortSources()
    }
    
    private func sortSources() {
        sources.sort { (source1, source2) -> Bool in
            let position1 = source1.droarSectionPosition()
            let position2 = source2.droarSectionPosition()
            
            if (position1.position != position2.position)
            {
                return position1.position.rawValue <= position2.position.rawValue
            }
            
            return position1.priority.rawValue <= position2.priority.rawValue
        }
    }
    
    public func initializeSections(tableView: UITableView) {
        for section in sources {
            if let performSetupAction = section.droarSectionPerformSetup {
                performSetupAction(tableView)
            }
        }
    }
}

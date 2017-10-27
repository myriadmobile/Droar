//
//  ProcessInfoKnob.swift
//  Droar
//
//  Created by Nathan Jangula on 10/26/17.
//

import Foundation

internal class ProcessInfoKnob : DroarKnob {
    
    private enum ProcessInfoRow: Int {
        case processorCount = 0
        case activeProcessorCount = 1
        case physicalMemory = 2
        case systemUptime = 3
        case thermalState = 4
        case lowPowerEnabled = 5
        case count = 6
    }
    
    func droarKnobTitle() -> String {
        return "Process Info"
    }
    
    func droarKnobPosition() -> PositionInfo {
        return PositionInfo(position: .bottom, priority: .low)
    }
    
    func droarKnobNumberOfCells() -> Int {
        return ProcessInfoRow.count.rawValue
    }
    
    func droarKnobCellForIndex(index: Int, tableView: UITableView) -> DroarCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DroarLabelCell") as? DroarLabelCell ?? DroarLabelCell.create()
        cell.selectionStyle = .none

        let info = ProcessInfo.processInfo
        
        switch ProcessInfoRow(rawValue:index)! {
        case .processorCount:
            cell.titleLabel.text = "Processor Count"
            cell.detailLabel.text = info.processorCount.description
        case .activeProcessorCount:
            cell.titleLabel.text = "Active Processor Count"
            cell.detailLabel.text = info.activeProcessorCount.description
        case .physicalMemory:
            cell.titleLabel.text = "Physical Memory"
            cell.detailLabel.text = String(format:"%.2fMB", Double(info.physicalMemory)/1000000)
        case .systemUptime:
            cell.titleLabel.text = "System Uptime"
            let interval = info.systemUptime
            let seconds = Int(interval.truncatingRemainder(dividingBy: 60))
            let minutes = Int((interval / 60).truncatingRemainder(dividingBy: 60))
            let hours = Int(interval / 3600)
            cell.detailLabel.text = String(format: "%dhr %dmin %dsec", hours, minutes, seconds)
        case .thermalState:
            cell.titleLabel.text = "Thermal State"
            var detailText = ""
            if #available(iOS 11.0, *) {
                switch info.thermalState {
                case .critical:
                    detailText = "Critical"
                case .fair:
                    detailText = "Fair"
                case .nominal:
                    detailText = "Nominal"
                case .serious:
                    detailText = "Serious"
                }
            }
            cell.detailLabel.text = detailText
        case .lowPowerEnabled:
            cell.titleLabel.text = "Low Power Mode Enabled"
            cell.detailLabel.text = info.isLowPowerModeEnabled ? "True" : "False"
        case .count:
            cell.titleLabel.text = ""
            cell.detailLabel.text = ""
        }
        
        return cell
    }
}

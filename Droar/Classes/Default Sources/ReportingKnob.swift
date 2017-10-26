//
//  ReportingKnob.swift
//  Droar
//
//  Created by Nathan Jangula on 10/16/17.
//

import Foundation

internal class ReportingKnob : DroarKnob {
    
    private enum ReportingRow: Int {
        case screenshot = 0
        case count = 1
    }
    
    func droarSectionTitle() -> String {
        return "Reporting"
    }
    
    func droarSectionPosition() -> PositionInfo {
        return PositionInfo(position: .middle, priority: .low)
    }
    
    func droarSectionNumberOfCells() -> Int {
        return ReportingRow.count.rawValue
    }
    
    func droarSectionCellForIndex(index: Int, tableView: UITableView) -> DroarCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DroarLabelCell") as? DroarLabelCell ?? DroarLabelCell.create()
        
        switch ReportingRow(rawValue:index)! {
        case .screenshot:
            cell.titleLabel.text = "Screenshot"
            cell.detailLabel.text = ""
            cell.isUserInteractionEnabled = true
        case .count:
            cell.titleLabel.text = ""
            cell.detailLabel.text = ""
        }
        
        return cell
    }
    
    func droarSectionIndexSelected(tableView: UITableView, selectedIndex: Int) {
        switch ReportingRow(rawValue: selectedIndex)! {
        case .screenshot:
            if let image = Droar.captureScreen() {
                let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                Droar.present(activityVC, animated: true, completion: nil)
            }
            break
        default:
            break
        }
    }
}

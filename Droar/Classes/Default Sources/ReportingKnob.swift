//
//  ReportingKnob.swift
//  Droar
//
//  Created by Nathan Jangula on 10/16/17.
//

import Foundation

internal class ReportingKnob : DroarKnob {
    
    private var screenshotCell: UITableViewCell?
    
    private enum ReportingRow: Int {
        case screenshot = 0
        case dump = 1
        case count = 2
    }
    
    func droarKnobTitle() -> String {
        return "Reporting"
    }
    
    func droarKnobPosition() -> PositionInfo {
        return PositionInfo(position: .middle, priority: .low)
    }
    
    func droarKnobNumberOfCells() -> Int {
        return ReportingRow.count.rawValue
    }
    
    func droarKnobCellForIndex(index: Int, tableView: UITableView) -> DroarCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DroarLabelCell") as? DroarLabelCell ?? DroarLabelCell.create()
        cell.selectionStyle = .gray

        switch ReportingRow(rawValue:index)! {
        case .screenshot:
            cell.titleLabel.text = "Screenshot"
            cell.detailLabel.text = ""
            screenshotCell = cell
        case .dump:
            cell.titleLabel.text = "Generate Current State Dump"
            cell.detailLabel.text = ""
        case .count:
            cell.titleLabel.text = ""
            cell.detailLabel.text = ""
        }
        
        return cell
    }
    
    func droarKnobIndexSelected(tableView: UITableView, selectedIndex: Int) {
        switch ReportingRow(rawValue: selectedIndex)! {
        case .screenshot:
            if let image = captureScreen() {
                let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                if activityVC.responds(to: #selector(getter: UIActivityViewController.popoverPresentationController)) {
                    activityVC.popoverPresentationController?.sourceView = screenshotCell ?? tableView
                }
                Droar.present(activityVC, animated: true, completion: nil)
            }
        case .dump:
            let dump = KnobManager.sharedInstance.generateStateDump()
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dump, options: .prettyPrinted)
                if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                    Droar.pushViewController(StateDumpViewController.create(stateDump: jsonString), animated: true)
                }
            } catch let error {
                let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                Droar.present(alert, animated: true, completion: nil)
            }
        default:
            break
        }
    }
    
    func captureScreen() -> UIImage? {
        //Find all the windows we want to capture; these will be layered, NOT taken individually.
        var capturableWindows = UIApplication.shared.windows
        capturableWindows.removeAll(where: { $0 == Droar.window })
        
        //Find the necessary size
        var size: CGSize = .zero
        size.height = capturableWindows.compactMap({ $0.frame.height }).max() ?? 0
        size.width = capturableWindows.compactMap({ $0.frame.width }).max() ?? 0
        
        //Capture
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return .none }
        capturableWindows.forEach({ $0.layer.render(in: context) })
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
}


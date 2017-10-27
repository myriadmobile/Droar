//
//  MyriadKnob.swift
//  Droar
//
//  Created by Nathan Jangula on 10/26/17.
//

import Foundation
import WebKit

internal class MyriadKnob : DroarKnob {
    
    func droarKnobTitle() -> String {
        return ""
    }
    
    func droarKnobPosition() -> PositionInfo {
        return PositionInfo(position: .bottom, priority: .low)
    }
    
    func droarKnobNumberOfCells() -> Int {
        return 1
    }
    
    func droarKnobCellForIndex(index: Int, tableView: UITableView) -> DroarCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DroarImageCell") as? DroarImageCell ?? DroarImageCell.create()
        
        cell.titleLabel.text = "Powered By:"
        cell.largeImageView.image = UIImage(named: "Myriad_logo",  in: Bundle.podBundle, compatibleWith: nil)
        cell.selectionStyle = .gray

        return cell
    }
    
    func droarKnobIndexSelected(tableView: UITableView, selectedIndex: Int) {
        if let url = URL(string: "https://www.myriadmobile.com") {
            let alert = UIAlertController(title: "Open in Safari?", message: url.absoluteString, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                UIApplication.shared.openURL(url)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            Droar.present(alert, animated: true, completion: nil)
        }
    }
}

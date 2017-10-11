//
//  DroarLabelCell.swift
//  Droar
//
//  Created by Nathan Jangula on 10/11/17.
//

import Foundation

public class DroarLabelCell : UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    public static func create(title: String = "", detail: String = "", allowSelection: Bool = false) -> DroarLabelCell {
        var cell: DroarLabelCell?
        
        for view in Bundle.podBundle.loadNibNamed("DroarLabelCell", owner: self, options: nil) ?? [Any]() {
            if view is DroarLabelCell {
                cell = view as? DroarLabelCell
            }
        }
        
        cell?.titleLabel.text = title
        cell?.detailLabel.text = detail
        cell?.isUserInteractionEnabled = false
        
        return cell ?? DroarLabelCell()
    }
}

//
//  DroarLabelCell.swift
//  Droar
//
//  Created by Nathan Jangula on 10/11/17.
//

import Foundation

public class DroarLabelCell : UITableViewCell, DroarCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    public static func create(title: String? = "", detail: String? = "", allowSelection: Bool = false) -> DroarLabelCell {
        var cell: DroarLabelCell?
        
        for view in Bundle.podBundle.loadNibNamed("DroarLabelCell", owner: self, options: nil) ?? [Any]() {
            if view is DroarLabelCell {
                cell = view as? DroarLabelCell
                break
            }
        }
        
        cell?.titleLabel.text = title
        cell?.detailLabel.text = detail
        cell?.selectionStyle = allowSelection ? .gray : .none
        
        return cell ?? DroarLabelCell()
    }
    
    public func setEnabled(_ enabled: Bool) {
        titleLabel.isEnabled = enabled
        detailLabel.isEnabled = enabled
        backgroundColor = enabled ? UIColor.white : UIColor.disabledGray
        isUserInteractionEnabled = enabled
    }
    
    public func stateDump() -> [String : String]? {
        guard let text = titleLabel.text, let detailText = detailLabel.text else { return nil }
        return [text : detailText]
    }
}

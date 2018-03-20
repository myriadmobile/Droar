//
//  DroarSliderCell.swift
//  Droar
//
//  Created by Nathan Jangula on 3/19/18.
//

import Foundation

public class DroarSliderCell : UITableViewCell, DroarCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var detailLabel: UILabel!
    
    private var onValueChanged: ((Float) -> Void)?
    
    public static func create(title: String? = "", value: Float = 0, min: Float = 0, max: Float = 1, allowSelection: Bool = false, onValueChanged: ((Float) -> Void)? = nil) -> DroarSliderCell {
        var cell: DroarSliderCell?
        
        for view in Bundle.podBundle.loadNibNamed("DroarSliderCell", owner: self, options: nil) ?? [Any]() {
            if view is DroarSliderCell {
                cell = view as? DroarSliderCell
                break
            }
        }
        
        cell?.onValueChanged = onValueChanged
        
        cell?.titleLabel.text = title
        cell?.slider.minimumValue = min
        cell?.slider.maximumValue = max
        cell?.slider.value = value
        cell?.selectionStyle = allowSelection ? .gray : .none
        cell?.detailLabel.text = String(format: "%.2f", cell?.slider.value ?? 0)

        return cell ?? DroarSliderCell()
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        detailLabel.text = String(format: "%.2f", slider.value)
        onValueChanged?(slider.value)
    }
    
    public func setEnabled(_ enabled: Bool) {
        titleLabel.isEnabled = enabled
        slider.isEnabled = enabled
        detailLabel.isEnabled = enabled
        backgroundColor = enabled ? UIColor.white : UIColor.disabledGray
        isUserInteractionEnabled = enabled
    }
    
    public func stateDump() -> [String : String]? {
        guard let text = titleLabel.text, let detailText = detailLabel.text else { return nil }
        return [text : detailText]
    }
}

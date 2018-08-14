//
//  DroarTextFieldCell.swift
//  Droar
//
//  Created by Nathan Jangula on 10/26/17.
//

import Foundation

public class DroarTextFieldCell : UITableViewCell, DroarCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    var onTextChanged: ((String?)-> Void)?
    
    
    public var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    public var value: String? {
        get { return textField.text }
        set { textField.text = newValue }
    }
    
    public var placeholder: String? {
        get { return textField.placeholder }
        set { textField.placeholder = newValue }
    }
    
    public var allowSelection: Bool {
        get { return selectionStyle != .none }
        set { selectionStyle = newValue ? .gray : .none }
    }
    
    public static func create(title: String? = "", placeholder: String? = "", text: String? = "", allowSelection: Bool = false, onTextChanged: ((String?)-> Void)? = nil) -> DroarTextFieldCell {
        var cell: DroarTextFieldCell?
        
        for view in Bundle.podBundle.loadNibNamed("DroarTextFieldCell", owner: self, options: nil) ?? [Any]() {
            if view is DroarTextFieldCell {
                cell = view as? DroarTextFieldCell
                break
            }
        }
        
        cell?.title = title
        cell?.placeholder = placeholder
        cell?.value = text
        cell?.allowSelection = allowSelection
        cell?.onTextChanged = onTextChanged
        
        return cell ?? DroarTextFieldCell()
    }
    
    @IBAction func handleTextChanged(_ sender: Any) {
        guard let onTextChanged = onTextChanged else { return }
        onTextChanged(textField.text)
    }
    
    public func setEnabled(_ enabled: Bool) {
        titleLabel.isEnabled = enabled
        textField.isEnabled = enabled
        backgroundColor = enabled ? UIColor.white : UIColor.disabledGray
        isUserInteractionEnabled = enabled
    }
    
    public func stateDump() -> [String : String]? {
        guard let text = titleLabel.text, let enteredText = textField.text else { return nil }
        return [text : enteredText]
    }
}

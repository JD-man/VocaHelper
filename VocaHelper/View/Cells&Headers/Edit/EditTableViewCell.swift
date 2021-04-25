//
//  EditTableViewCell.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/04/24.
//

import UIKit

class EditTableViewCell: UITableViewCell {
    
    static let identifier: String = "EditTableViewCell"
    
    let wordTextField: UITextField = {
        let textfield = UITextField()
        textfield.textAlignment = .center
        textfield.autocorrectionType = .no
        textfield.autocapitalizationType = .none
        textfield.adjustsFontSizeToFitWidth = true
        textfield.font = UIFont.systemFont(ofSize: 30)
        textfield.returnKeyType = .continue        
        return textfield
    }()
    
    let meaningTextField: UITextField = {
        let textfield = UITextField()
        textfield.textAlignment = .center
        textfield.autocorrectionType = .no
        textfield.autocapitalizationType = .none
        textfield.font = UIFont.systemFont(ofSize: 30)
        textfield.returnKeyType = .done
        return textfield
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let width = self.bounds.width / 2
        let height = self.bounds.height
        
        wordTextField.frame = CGRect(x: 0, y: 0, width: width, height: height)
        meaningTextField.frame = CGRect(x: wordTextField.bounds.origin.x + wordTextField.bounds.width, y: 0, width: width, height: height)
        
        wordTextField.delegate = self
        meaningTextField.delegate = self
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        wordTextField.text = ""
        wordTextField.text = ""
    }
    
    private func addSubViews() {
        contentView.addSubview(wordTextField)
        contentView.addSubview(meaningTextField)
    }
}

extension EditTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == wordTextField {
            wordTextField.resignFirstResponder()
            meaningTextField.becomeFirstResponder()
            return true
        } else {
            meaningTextField.resignFirstResponder()            
        }
        return true
    }
}

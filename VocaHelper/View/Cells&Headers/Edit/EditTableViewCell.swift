//
//  EditTableViewCell.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/04/24.
//

import UIKit

protocol EditTableViewCellDelegate: AnyObject {
    func keyboardWillAppear()
    func keyboardWillDisappear()
    func reload(word: String, meaning: String)
}

class EditTableViewCell: UITableViewCell {
    
    static let identifier: String = "EditTableViewCell"
    
    weak var delegate: EditTableViewCellDelegate?
    private var isKeyboardMove: Bool = false
    
    let wordTextField: UITextField = {
        let textfield = UITextField()
        textfield.textAlignment = .center
        textfield.autocorrectionType = .no
        textfield.autocapitalizationType = .none
        textfield.adjustsFontSizeToFitWidth = true
        textfield.font = UIFont.systemFont(ofSize: 30)
        textfield.returnKeyType = .done
        textfield.keyboardType = .alphabet
        textfield.clipsToBounds = true
        textfield.layer.cornerRadius = 10
        textfield.layer.borderWidth = 1.5
        return textfield
    }()
    
    let meaningTextField: UITextField = {
        let textfield = UITextField()
        textfield.textAlignment = .center
        textfield.autocorrectionType = .no
        textfield.autocapitalizationType = .none
        textfield.adjustsFontSizeToFitWidth = true
        textfield.font = UIFont.systemFont(ofSize: 30)
        textfield.returnKeyType = .done
        textfield.clipsToBounds = true
        textfield.layer.cornerRadius = 10
        textfield.layer.borderWidth = 1.5
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
        let width = self.bounds.width / 2 - 10
        let height = self.bounds.height / 1.5
        
        wordTextField.frame = CGRect(x: 5,
                                                          y: self.bounds.height/2 - height/2,
                                                          width: width,
                                                          height: height)
        meaningTextField.frame = CGRect(x: self.bounds.width / 2 + 5,
                                                               y: self.bounds.height/2 - height/2,
                                                               width: width,
                                                               height: height)
        
        wordTextField.delegate = self
        meaningTextField.delegate = self
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        wordTextField.text = ""
        meaningTextField.text = ""
    }
    
    private func addSubViews() {
        self.addSubview(wordTextField)
        self.addSubview(meaningTextField)
    }
}

extension EditTableViewCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.frame.origin.y >= 300 {
            delegate?.keyboardWillAppear()
            isKeyboardMove = true
        }
        textField.placeholder = ""
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if isKeyboardMove{
            delegate?.keyboardWillDisappear()
            isKeyboardMove = false
        }
        
        if textField == wordTextField, textField.text == "" {
            wordTextField.placeholder = "Word"
        } else {
            meaningTextField.placeholder = "Meaning"
        }
        delegate?.reload(word: wordTextField.text!, meaning: meaningTextField.text!)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == wordTextField {
            wordTextField.resignFirstResponder()
            meaningTextField.becomeFirstResponder()
        } else {
            meaningTextField.resignFirstResponder()
            wordTextField.becomeFirstResponder()
        }
        
        return true
    }
}

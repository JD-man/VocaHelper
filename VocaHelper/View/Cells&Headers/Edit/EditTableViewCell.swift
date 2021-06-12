//
//  EditTableViewCell.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/04/24.
//

import UIKit

//protocol EditTableViewCellDelegate: AnyObject {
//    func keyboardWillAppear()
//    func keyboardWillDisappear()
//    func reload(word: String, meaning: String)
//}

class EditTableViewCell: UITableViewCell {
    
    static let identifier: String = "EditTableViewCell"
    private var isKeyboardMove: Bool = false
    
    public var didTapWord: (() -> Void)?
    public var didTapMeaning: (() -> Void)?
    
    
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
        textfield.backgroundColor = .systemIndigo
        textfield.textColor = .systemBackground
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
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        wordTextField.text = ""
        meaningTextField.text = ""
    }
    
    private func addSubViews() {
        contentView.addSubview(wordTextField)
        contentView.addSubview(meaningTextField)
        let wordGesture = UITapGestureRecognizer()
        wordGesture.addTarget(self, action: #selector(didTapWordCell))
        wordGesture.cancelsTouchesInView = false
        wordTextField.addGestureRecognizer(wordGesture)
        
        let meaningGesture = UITapGestureRecognizer()
        meaningGesture.addTarget(self, action: #selector(didTapMeaningCell))
        meaningGesture.cancelsTouchesInView = false
        meaningTextField.addGestureRecognizer(meaningGesture)
    }
    
    @objc private func didTapWordCell() {
        guard let didTapWord = didTapWord else {
            return
        }
        didTapWord()
        wordTextField.becomeFirstResponder()
    }
    
    @objc private func didTapMeaningCell() {
        guard let didTapMeaning = didTapMeaning else {
            return
        }
        didTapMeaning()
        meaningTextField.becomeFirstResponder()
    }
}

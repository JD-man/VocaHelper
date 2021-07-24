//
//  EditTableViewCell.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/04/24.
//

import UIKit

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
        textfield.clipsToBounds = true
        textfield.layer.cornerRadius = 10
        textfield.layer.borderWidth = 1.5
        textfield.backgroundColor = UIColor(red: 93/255, green: 163/255, blue: 178/255, alpha: 1.0)
        textfield.textColor = .systemBackground
        textfield.translatesAutoresizingMaskIntoConstraints = false
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
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubViews()
        constraintConfigure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
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
    
    private func constraintConfigure() {
//        let width = self.bounds.width / 2 - 10
//        let height = self.bounds.height / 1.5
        
        let gap: CGFloat = 10
        wordTextField.leftAnchor.constraint(equalTo: leftAnchor, constant: gap).isActive = true
        wordTextField.rightAnchor.constraint(equalTo: centerXAnchor, constant: -gap).isActive = true
        wordTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        wordTextField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/1.5).isActive = true
        
        meaningTextField.leftAnchor.constraint(equalTo: centerXAnchor, constant: gap).isActive = true
        meaningTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -gap).isActive = true
        meaningTextField.centerYAnchor.constraint(equalTo: wordTextField.centerYAnchor).isActive = true
        meaningTextField.heightAnchor.constraint(equalTo: wordTextField.heightAnchor).isActive = true
    }
}

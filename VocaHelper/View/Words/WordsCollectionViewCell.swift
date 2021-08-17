//
//  WordsCollectionViewCell.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/04/23.
//

import UIKit

class WordsCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "WordsCollectionViewCell"
    
    var didTap: (() -> Void)?
    
    let backGroundButton: UIButton = {
        let button = UIButton(type: .system)        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let folderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "folder")
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let fileNameTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.textColor = .label
        textField.backgroundColor = .label
        textField.adjustsFontSizeToFitWidth = true
        textField.textColor = .systemBackground
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 2, height: 0))
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 2, height: 0))
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        textField.isUserInteractionEnabled = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        constraintsConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        fileNameTextField.text = ""
    }
    
    private func configure() {
        backGroundButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        contentView.addSubview(backGroundButton)
        contentView.addSubview(folderImageView)
        contentView.addSubview(fileNameTextField)
        //backgroundColor = .systemBackground
        contentView.backgroundColor = .systemBackground
        
        
        contentView.layer.cornerRadius = 5
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    private func constraintsConfigure() {
        backGroundButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backGroundButton.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        backGroundButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        backGroundButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        folderImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        folderImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10).isActive = true
        folderImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
        folderImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.45).isActive = true
        
        fileNameTextField.centerXAnchor.constraint(equalTo: folderImageView.centerXAnchor).isActive = true
        fileNameTextField.widthAnchor.constraint(equalTo: widthAnchor, constant: -20).isActive = true
        fileNameTextField.topAnchor.constraint(equalTo: folderImageView.bottomAnchor, constant: 5).isActive = true
        fileNameTextField.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.22).isActive = true
    }
    
    @objc private func didTapButton() {
        guard let didTap = didTap else {
            return
        }
        didTap()
    }
}

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
    
    let button: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(systemName: "folder"), for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let label: UILabel = {
        let label = UILabel()        
        label.textAlignment = .center
        label.textColor = .label
        label.backgroundColor = .label
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .systemBackground
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        label.text = ""
    }
    
    private func configure() {
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        contentView.addSubview(button)
        contentView.addSubview(label)
        //backgroundColor = .systemBackground
        contentView.backgroundColor = .systemBackground
        
        contentView.layer.cornerRadius = 5
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    private func constraintsConfigure() {
        button.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10).isActive = true
        button.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
        button.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.45).isActive = true
        
        label.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: widthAnchor, constant: -20).isActive = true
        label.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 5).isActive = true
        label.heightAnchor.constraint(equalTo: label.widthAnchor, multiplier: 0.25).isActive = true
    }
    
    @objc private func didTapButton() {
        guard let didTap = didTap else {
            return
        }
        didTap()
    }
}

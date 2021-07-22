//
//  EditTableViewFooter.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/04/24.
//

import UIKit

class EditTableViewFooter: UIView {
    
    public let addButton: UIButton = {
        let button = UIButton()
        button.tintColor = .systemGreen
        button.backgroundColor = .systemBackground
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .systemBackground
        addButton.setBackgroundImage(UIImage(systemName: "plus.circle"), for: .normal)
        
        addButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        addButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        addButton.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 1 / 1.5).isActive = true
        addButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1 / 1.5).isActive = true
    }
    
    private func addSubViews() {
        addSubview(addButton)
    }
}

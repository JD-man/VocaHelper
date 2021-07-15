//
//  AddCollectionViewCell.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/04/23.
//

import UIKit

class AddCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "AddCollectionViewCell"
    
    public var didTap: (() -> Void)?
    
    public let button: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "folder.badge.plus"), for: .normal)
        button.tintColor = .systemGreen
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
    }
    
    private func configure() {
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        addSubview(button)
        backgroundColor = .systemBackground
    }
    
    private func constraintsConfigure() {
        button.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        button.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
        button.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.45).isActive = true
    }
    
    @objc private func didTapButton() {
        guard let didTap = didTap else {
            return
        }
        didTap()
    }
}

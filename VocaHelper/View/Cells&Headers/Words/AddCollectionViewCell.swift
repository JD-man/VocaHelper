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
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSizeWidth = self.bounds.width/2
        let imageSizeheight = self.bounds.width/2.5
        
        button.frame = CGRect(x: self.bounds.width/2 - imageSizeWidth/2 , y: self.bounds.height/2 - imageSizeheight/2, width: imageSizeWidth, height: imageSizeheight)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func configure() {
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        addSubview(button)
        backgroundColor = .systemBackground
    }
    
    @objc private func didTapButton() {
        guard let didTap = didTap else {
            return
        }
        didTap()
    }
}

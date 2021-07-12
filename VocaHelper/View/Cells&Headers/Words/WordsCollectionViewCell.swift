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
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "folder"), for: .normal)
        button.tintColor = .label
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
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = nil
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSizeWidth = self.bounds.width/2
        let imageSizeheight = self.bounds.width/2.5
        
        button.frame = CGRect(x: self.bounds.width/2 - imageSizeWidth/2 , y: self.bounds.height/2 - imageSizeheight/1.5, width: imageSizeWidth, height: imageSizeheight)
        
        label.frame = CGRect(x: 10, y:  self.bounds.width/6 + imageSizeWidth, width: self.bounds.width-20, height: imageSizeheight/2)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = ""
    }
    
    private func configure() {
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        contentView.addSubview(button)
        contentView.addSubview(label)
        backgroundColor = .systemBackground
    }
    
    @objc private func didTapButton() {
        guard let didTap = didTap else {
            return
        }
        didTap()
    }
}

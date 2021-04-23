//
//  AddCollectionViewCell.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/04/23.
//

import UIKit

class AddCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "AddCollectionViewCell"
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "folder.badge.plus")
        imageView.tintColor = .systemGreen
        return imageView
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
        
        imageView.frame = CGRect(x: self.bounds.width/2 - imageSizeWidth/2 , y: self.bounds.height/2 - imageSizeheight/2, width: imageSizeWidth, height: imageSizeheight)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func configure() {
        addSubview(imageView)
        backgroundColor = .systemBackground
    }    
}

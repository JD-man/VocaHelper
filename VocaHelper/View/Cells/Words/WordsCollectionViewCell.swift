//
//  WordsCollectionViewCell.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/04/23.
//

import UIKit

class WordsCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "WordsCollectionViewCell"
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "folder")
        imageView.tintColor = .label
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "text"
        label.textAlignment = .center
        label.backgroundColor = .systemBackground
        label.adjustsFontSizeToFitWidth = true
        return label
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
        
        imageView.frame = CGRect(x: self.bounds.width/2 - imageSizeWidth/2 , y: self.bounds.height/2 - imageSizeheight/1.5, width: imageSizeWidth, height: imageSizeheight)
        label.frame = CGRect(x: 10, y:  self.bounds.width/6 + imageSizeWidth, width: self.bounds.width-20, height: imageSizeheight/2)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = ""
    }
    
    private func configure() {
        addSubview(imageView)
        addSubview(label)
        backgroundColor = .systemBackground
    }
}

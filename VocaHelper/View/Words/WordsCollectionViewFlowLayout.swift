//
//  WordsCollectionViewFlowLayout.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/09/01.
//

import UIKit

class WordsCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
    }
    
    convenience init(view: UIView) {
        self.init()
        let margin: CGFloat = 20
        let numberOfCell: CGFloat = 3
        let width = view.bounds.width < view.bounds.height ?
            (view.bounds.width - 2*margin)/numberOfCell - margin/1.5 : (view.bounds.height - 2*margin)/numberOfCell - margin/1.5
        
        sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        itemSize = CGSize(width: width, height: width)
        scrollDirection = .vertical
        minimumInteritemSpacing = 0
        minimumLineSpacing = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

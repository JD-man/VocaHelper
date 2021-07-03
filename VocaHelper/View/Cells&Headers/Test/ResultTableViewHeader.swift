//
//  ResultTableViewHeader.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/07/03.
//

import UIKit

class ResultTableViewHeader: UIView {
    
    let wordLabel: UILabel = {
        let label = UILabel()
        label.text = "단어"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        return label
    }()
    
    let userAnswerLabel: UILabel = {
        let label = UILabel()
        label.text = "제출한답"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        wordLabel.frame = CGRect(x: 0, y: 0, width: self.bounds.width/2, height: self.bounds.height)
        userAnswerLabel.frame = CGRect(x: self.bounds.width/2, y: 0, width: self.bounds.width/2, height: self.bounds.height)
    }
    
    private func addSubviews() {
        self.addSubview(wordLabel)
        self.addSubview(userAnswerLabel)
    }
}

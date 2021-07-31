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
        label.text = "문제"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let userAnswerLabel: UILabel = {
        let label = UILabel()
        label.text = "결과"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        constraintsConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func addSubviews() {
        self.addSubview(wordLabel)
        self.addSubview(userAnswerLabel)
    }
    
    private func constraintsConfigure() {
        wordLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        wordLabel.rightAnchor.constraint(equalTo: centerXAnchor).isActive = true
        wordLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        wordLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        userAnswerLabel.leftAnchor.constraint(equalTo: centerXAnchor).isActive = true
        userAnswerLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        userAnswerLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        userAnswerLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}

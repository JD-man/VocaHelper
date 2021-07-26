//
//  ResultTableViewFooter.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/04/30.
//

import UIKit

class ResultTableViewFooter: UIView {
    
    let scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "결과"
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 25, weight: .regular)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let examButton: UIButton = {
        let button = UIButton()
        button.setTitle("다시하기", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .label
        button.setTitleColor(.systemBackground, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let homeButton: UIButton = {
        let button = UIButton()
        button.setTitle("홈화면으로", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .label
        button.setTitleColor(.systemBackground, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        self.addSubview(scoreLabel)
        self.addSubview(examButton)
        self.addSubview(homeButton)
    }
    
    private func constraintsConfigure() {
        scoreLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        scoreLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        scoreLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        scoreLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.25).isActive = true
        
        examButton.widthAnchor.constraint(equalTo: scoreLabel.widthAnchor, multiplier: 0.25).isActive = true
        examButton.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 10).isActive = true
        examButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        NSLayoutConstraint(
            item: examButton,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerX,
            multiplier: 0.5,
            constant: 0).isActive = true
        
        homeButton.widthAnchor.constraint(equalTo: scoreLabel.widthAnchor, multiplier: 0.25).isActive = true
        homeButton.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 10).isActive = true
        homeButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        NSLayoutConstraint(
            item: homeButton,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerX,
            multiplier: 1.5,
            constant: 0).isActive = true
    }
}

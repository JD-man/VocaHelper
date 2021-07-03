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
        return label
    }()
    
    let testButton: UIButton = {
        let button = UIButton()
        button.setTitle("다시하기", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .label
        button.setTitleColor(.systemBackground, for: .normal)
        button.layer.masksToBounds = true
        button.clipsToBounds = true
        return button
    }()
    
    let homeButton: UIButton = {
        let button = UIButton()
        button.setTitle("홈화면으로", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .label
        button.setTitleColor(.systemBackground, for: .normal)
        button.layer.masksToBounds = true
        button.clipsToBounds = true
        return button
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
        let offset: CGFloat = 100
        scoreLabel.frame = CGRect(x: 0, y: 10, width: self.bounds.width, height: self.bounds.height/4)
        testButton.frame = CGRect(x: 0.5 * offset, y: self.bounds.height/2, width: self.bounds.width/2 - offset, height: self.bounds.height/4)
        homeButton.frame = CGRect(x: self.bounds.width/2 + 0.5 * offset, y: self.bounds.height/2, width: self.bounds.width/2 - offset, height: self.bounds.height/4)
        testButton.layer.cornerRadius = 10
        homeButton.layer.cornerRadius = 10
    }
    
    private func addSubviews() {
        self.addSubview(scoreLabel)
        self.addSubview(testButton)
        self.addSubview(homeButton)
    }
}

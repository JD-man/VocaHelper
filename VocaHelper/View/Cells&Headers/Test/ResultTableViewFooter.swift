//
//  ResultTableViewFooter.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/04/30.
//

import UIKit

protocol ResultTableViewFooterDelegate: AnyObject {
    func didTapTest()
    func didTapHome()
}

class ResultTableViewFooter: UIView {

    weak var delegate: ResultTableViewFooterDelegate?
    
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
        button.backgroundColor = .systemBackground
        return button
    }()
    
    let homeButton: UIButton = {
        let button = UIButton()
        button.setTitle("홈화면으로", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemBackground
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
        scoreLabel.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height/2)
        testButton.frame = CGRect(x: 0, y: self.bounds.height/2, width: self.bounds.width/2, height: self.bounds.height/2)
        homeButton.frame = CGRect(x: self.bounds.width/2, y: self.bounds.height/2, width: self.bounds.width/2, height: self.bounds.height/2)
        
        testButton.addTarget(self, action: #selector(didTapTestButton), for: .touchUpInside)
        homeButton.addTarget(self, action: #selector(didTapHomeButton), for: .touchUpInside)
    }
    
    private func addSubviews() {
        self.addSubview(scoreLabel)
        self.addSubview(testButton)
        self.addSubview(homeButton)
    }
    
    @objc private func didTapTestButton() {
        delegate?.didTapTest()
    }
    
    @objc private func didTapHomeButton() {
        delegate?.didTapHome()
    }
}

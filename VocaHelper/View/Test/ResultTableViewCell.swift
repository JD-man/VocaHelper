//
//  ResultTableViewCell.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/04/30.
//

import UIKit

class ResultTableViewCell: UITableViewCell {
    
    static let identifier: String = "ResultTableViewCell"
    
    let wordLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.textAlignment = .center
        label.backgroundColor = .systemIndigo
        label.clipsToBounds = true
        label.layer.cornerRadius = 15
        label.textColor = .systemBackground
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let userAnswerLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 25, weight: .regular)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        constraintsConfigure()
        self.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        wordLabel.text = nil
        userAnswerLabel.text = nil
    }
    
    private func addSubviews() {
        self.addSubview(wordLabel)
        self.addSubview(userAnswerLabel)
    }
    
    private func constraintsConfigure() {
        let padding: CGFloat = 10
        
        wordLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
        wordLabel.rightAnchor.constraint(equalTo: centerXAnchor, constant: -padding).isActive = true
        wordLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding).isActive = true
        wordLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding).isActive = true
        
        
        userAnswerLabel.leftAnchor.constraint(equalTo: centerXAnchor, constant: padding).isActive = true
        userAnswerLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding).isActive = true
        userAnswerLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding).isActive = true
        userAnswerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding).isActive = true
    }
}

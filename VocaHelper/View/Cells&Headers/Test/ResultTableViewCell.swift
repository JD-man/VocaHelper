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
        label.font = UIFont.systemFont(ofSize: 50, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    let userAnswerLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 25, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    let resultLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 25, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        self.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let answerLabelsHeight = self.bounds.height/2
        wordLabel.frame = CGRect(x: 0, y: 0, width: self.bounds.width/2, height: self.bounds.height)
        userAnswerLabel.frame = CGRect(x: self.bounds.width/2, y: 0, width: self.bounds.width/2, height: answerLabelsHeight)
        resultLabel.frame = CGRect(x: self.bounds.width/2, y: answerLabelsHeight, width: self.bounds.width/2, height: answerLabelsHeight)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        wordLabel.text = nil
        userAnswerLabel.text = nil        
        resultLabel.text = nil
    }
    
    private func addSubviews() {
        self.addSubview(wordLabel)
        self.addSubview(userAnswerLabel)        
        self.addSubview(resultLabel)
    }
}

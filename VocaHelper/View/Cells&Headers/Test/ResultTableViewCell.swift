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
        label.layer.cornerRadius = 20
        label.textColor = .systemBackground
        return label
    }()
    
    let userAnswerLabel: UILabel = {
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
        let answerLabelsHeight = self.bounds.height
        let wordLabelPadding: CGFloat = 10
        wordLabel.frame = CGRect(x: wordLabelPadding / 2,
                                                    y: wordLabelPadding / 2,
                                                    width: self.bounds.width/2 - wordLabelPadding,
                                                    height: self.bounds.height - wordLabelPadding
        )
        userAnswerLabel.frame = CGRect(x: self.bounds.width/2, y: 0, width: self.bounds.width/2, height: answerLabelsHeight)
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
}

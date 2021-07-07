//
//  WebTableViewCell.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/07/06.
//

import UIKit

class WebTableViewCell: UITableViewCell {

    static let identifier: String = "WebTableViewCell"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "test"
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        label.textColor = .label
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        return label
    }()
    
    let backgroundButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .link
        return button
    }()
    
    let writerLabel: UILabel = {
        let label = UILabel()
        label.text = "작성자 닉네임"
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.textColor = .label
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "간단설명"
        label.font = .systemFont(ofSize: 25, weight: .light)
        label.textColor = .label
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        return label
    }()
    
    let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundButton.layer.masksToBounds = true
        backgroundButton.layer.cornerRadius = 25
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let backGroundOffsetX: CGFloat = 20
        let backGroundOffsetY: CGFloat = 25
        backgroundButton.frame = CGRect(x: backGroundOffsetX, y: backGroundOffsetY, width: frame.width - 2 * backGroundOffsetX, height: frame.height - 2 * backGroundOffsetY)
        gradientConfigure()
        cellConfigure()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
    
    @objc private func didTapButton() {
        print("Hh")
    }
    
    private func gradientConfigure() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.white.cgColor, UIColor.systemTeal.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        backgroundButton.layer.addSublayer(gradient)
        gradient.frame = backgroundButton.layer.bounds
    }
    
    private func cellConfigure() {
        contentView.addSubview(backgroundButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(writerLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(likeButton)
        
        backgroundButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        titleLabel.frame = CGRect(x: backgroundButton.frame.minX + 20, y: backgroundButton.frame.minY + 20, width: backgroundButton.frame.width / 2, height: 50)
        writerLabel.frame = CGRect(x: titleLabel.frame.maxX + 10, y: titleLabel.frame.minY, width: backgroundButton.frame.width / 2 - 10, height: 50)
        likeButton.frame = CGRect(x: writerLabel.frame.minX, y: backgroundButton.frame.maxY - 40, width: 30, height: 30)
        
        descriptionLabel.frame = CGRect(x: titleLabel.frame.minX, y: titleLabel.frame.maxY + 10, width: backgroundButton.frame.width - titleLabel.frame.minX * 2, height: backgroundButton.frame.height - (backgroundButton.frame.maxY - 40 + titleLabel.frame.maxY + 10))
        descriptionLabel.backgroundColor = .black
        
    }
}

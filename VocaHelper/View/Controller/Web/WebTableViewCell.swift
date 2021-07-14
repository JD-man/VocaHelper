//
//  WebTableViewCell.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/07/06.
//

import UIKit

class WebTableViewCell: UITableViewCell {

    static let identifier: String = "WebTableViewCell"
    public var tapFunction: (() -> Void)?
    
    let backgroundButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .link
        return button
    }()
    
    let shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "data"
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        label.textColor = .label
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        return label
    }()
    
    let writerLabel: UILabel = {
        let label = UILabel()
        label.text = "작성자 닉네임"
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .label
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.textAlignment = .right
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "간단설명한 단어장 설명부분 간단설명한 단어장 설명부분 간단설명한 단어장 설명부분 "
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .label
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
        return button
    }()
    
    let likeLabel: UILabel = {
        let label = UILabel()
        label.text = "888"
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.textAlignment = .right
        return label
    }()
    
    let downloadButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.down.square"), for: .normal)
        return button
    }()
    
    let downloadLabel: UILabel = {
        let label = UILabel()
        label.text = "777"
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundButton.layer.masksToBounds = true
        backgroundButton.layer.cornerRadius = 25
        shadowView.layer.masksToBounds = true
        shadowView.layer.cornerRadius = 25
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let backGroundOffsetX: CGFloat = 20
        let backGroundOffsetY: CGFloat = 25
        backgroundButton.frame = CGRect(x: backGroundOffsetX, y: backGroundOffsetY, width: frame.width - 2 * backGroundOffsetX, height: frame.height - 2 * backGroundOffsetY)
        shadowView.frame = CGRect(x: backgroundButton.frame.minX + 5, y: backgroundButton.frame.minY + 5, width: backgroundButton.frame.width, height: backgroundButton.frame.height)
        gradientConfigure()
        cellConfigure()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundButton.layer.sublayers = nil
        titleLabel.text = "초기화"
        likeLabel.text = "초기화"
        writerLabel.text = "초기화"
        downloadLabel.text = "초기화"
        descriptionLabel.text = "초기화"
        likeButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
    }
    
    @objc private func didTapButton() {
        guard let tapFunc = tapFunction else {
            return
        }
        tapFunc()
    }
    
    private func gradientConfigure() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.init(red: CGFloat.random(in: 0.0...1.0), green: CGFloat.random(in: 0.0...1.0), blue: CGFloat.random(in: 0.0...1.0), alpha: CGFloat.random(in: 0.0...1.0)).cgColor, UIColor.tertiarySystemBackground.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        backgroundButton.layer.addSublayer(gradient)
        gradient.frame = backgroundButton.layer.bounds
    }
    
    private func cellConfigure() {
        contentView.addSubview(shadowView)
        contentView.addSubview(backgroundButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(writerLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(likeButton)
        contentView.addSubview(likeLabel)
        contentView.addSubview(downloadButton)
        contentView.addSubview(downloadLabel)
        
        
        backgroundButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        titleLabel.frame = CGRect(x: backgroundButton.frame.minX + 20, y: backgroundButton.frame.minY + 15, width: backgroundButton.frame.width / 2, height: 50)
        descriptionLabel.frame = CGRect(x: titleLabel.frame.minX, y: titleLabel.frame.maxY + 10, width: bounds.width - (2 * titleLabel.frame.minX), height: 70)
        
        writerLabel.frame = CGRect(x: descriptionLabel.frame.maxX - 120, y: backgroundButton.frame.maxY - 50, width: 120, height: 20)
        
        likeButton.frame = CGRect(x: writerLabel.frame.minX, y: backgroundButton.frame.maxY - 35, width: 30, height: 30)
        likeLabel.frame = CGRect(x: likeButton.frame.maxX, y: likeButton.frame.minY, width: 30, height: 30)
        downloadButton.frame = CGRect(x: likeLabel.frame.maxX, y: likeButton.frame.minY, width: 30, height: 30)
        downloadLabel.frame = CGRect(x: downloadButton.frame.maxX, y: likeButton.frame.minY, width: 30, height: 30)
        
        // top align
        descriptionLabel.numberOfLines = 0
        descriptionLabel.sizeToFit()
    }
}

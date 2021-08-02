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
        let button = UIButton(type: .system)
        button.backgroundColor = .systemBackground
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 25
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "data"
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        label.textColor = .label
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "간단설명한 단어장 설명부분 간단설명한 단어장 설명부분 간단설명한 단어장 설명부분 "
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 0        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
        button.contentMode = .scaleToFill
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let likeLabel: UILabel = {
        let label = UILabel()
        label.text = "888"
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let downloadButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.down.square"), for: .normal)
        button.contentMode = .scaleAspectFill
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let downloadLabel: UILabel = {
        let label = UILabel()
        label.text = "777"
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        let randomRed = CGFloat.random(in: 0.0...1.0)
        let randomGreen = CGFloat.random(in: 0.0...1.0)
        let randomBlue = CGFloat.random(in: 0.0...1.0)
        let randomAlpha = CGFloat.random(in: 0.0...1.0)
        gradient.colors = [UIColor.init(red: randomRed, green: randomGreen, blue: randomBlue, alpha: randomAlpha).cgColor, UIColor.grayBlackDynamicColor.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        return gradient
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        cellConfigure()
        constraintsConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = backgroundButton.layer.bounds
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let gradientColor = gradient.colors,
              let leftTopColor = gradientColor.first else {
            return
        }
        gradient.colors = [leftTopColor, UIColor.grayBlackDynamicColor.cgColor]
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
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
    
    private func cellConfigure() {
        backgroundButton.layer.addSublayer(gradient)
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
    }
    
    private func constraintsConfigure() {
        
        backgroundButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        backgroundButton.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
        backgroundButton.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.85).isActive = true
        backgroundButton.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.75).isActive = true
        
        shadowView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor, constant: 5).isActive = true
        shadowView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: 5).isActive = true
        shadowView.widthAnchor.constraint(equalTo: backgroundButton.widthAnchor).isActive = true
        shadowView.heightAnchor.constraint(equalTo: backgroundButton.heightAnchor).isActive = true
        
        titleLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: backgroundButton.topAnchor, constant: 20).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: backgroundButton.widthAnchor, multiplier: 0.85).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: backgroundButton.heightAnchor, multiplier: 0.15).isActive = true
        
        descriptionLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        descriptionLabel.widthAnchor.constraint(equalTo: titleLabel.widthAnchor).isActive = true
        descriptionLabel.heightAnchor.constraint(lessThanOrEqualTo: backgroundButton.heightAnchor, multiplier: 0.4).isActive = true
        
        downloadLabel.rightAnchor.constraint(equalTo: descriptionLabel.rightAnchor).isActive = true
        downloadLabel.bottomAnchor.constraint(equalTo: backgroundButton.bottomAnchor, constant: -12).isActive = true
        downloadLabel.widthAnchor.constraint(lessThanOrEqualTo: writerLabel.widthAnchor, multiplier: 0.4).isActive = true
        downloadLabel.heightAnchor.constraint(equalTo: writerLabel.widthAnchor, multiplier: 0.1).isActive = true
        
        downloadButton.rightAnchor.constraint(equalTo: downloadLabel.leftAnchor, constant: -3).isActive = true
        downloadButton.bottomAnchor.constraint(equalTo: downloadLabel.bottomAnchor).isActive = true
        downloadButton.widthAnchor.constraint(equalTo: writerLabel.widthAnchor, multiplier: 0.1).isActive = true
        downloadButton.heightAnchor.constraint(equalTo: downloadLabel.heightAnchor).isActive = true

        likeLabel.rightAnchor.constraint(equalTo: downloadButton.leftAnchor, constant: -5).isActive = true
        likeLabel.bottomAnchor.constraint(equalTo: downloadLabel.bottomAnchor).isActive = true
        likeLabel.widthAnchor.constraint(lessThanOrEqualTo: writerLabel.widthAnchor, multiplier: 0.4).isActive = true
        likeLabel.heightAnchor.constraint(equalTo: downloadLabel.heightAnchor).isActive = true

        likeButton.rightAnchor.constraint(equalTo: likeLabel.leftAnchor, constant: -3).isActive = true
        likeButton.bottomAnchor.constraint(equalTo: downloadLabel.bottomAnchor).isActive = true
        likeButton.widthAnchor.constraint(equalTo: downloadLabel.heightAnchor).isActive = true
        likeButton.heightAnchor.constraint(equalTo: downloadLabel.heightAnchor).isActive = true
        
        writerLabel.bottomAnchor.constraint(equalTo: downloadLabel.topAnchor, constant: -5).isActive = true
        writerLabel.rightAnchor.constraint(equalTo: descriptionLabel.rightAnchor).isActive = true
        writerLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        writerLabel.heightAnchor.constraint(equalTo: titleLabel.heightAnchor, multiplier: 0.5).isActive = true
    }
}

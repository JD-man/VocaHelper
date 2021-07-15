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
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "data"
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        label.textColor = .label
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let writerLabel: UILabel = {
        let label = UILabel()
        label.text = "작성자 닉네임"
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .label
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
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
        gradientConfigure()
        cellConfigure()
        constraintsConfigure()
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
    }
    
    private func constraintsConfigure() {
        
        backgroundButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        backgroundButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true        
        backgroundButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85).isActive = true
        backgroundButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.75).isActive = true
        
        shadowView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 5).isActive = true
        shadowView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 5).isActive = true
        shadowView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85).isActive = true
        shadowView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.75).isActive = true
        
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: backgroundButton.topAnchor, constant: 20).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: backgroundButton.widthAnchor, multiplier: 0.9).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: backgroundButton.heightAnchor, multiplier: 0.15).isActive = true
        
        descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        descriptionLabel.widthAnchor.constraint(equalTo: backgroundButton.widthAnchor, multiplier: 0.9).isActive = true
        descriptionLabel.heightAnchor.constraint(lessThanOrEqualTo: backgroundButton.heightAnchor, multiplier: 0.4).isActive = true
        
        downloadLabel.rightAnchor.constraint(equalTo: descriptionLabel.rightAnchor).isActive = true
        downloadLabel.bottomAnchor.constraint(equalTo: backgroundButton.bottomAnchor, constant: -10).isActive = true
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
        writerLabel.leftAnchor.constraint(equalTo: centerXAnchor).isActive = true
        writerLabel.heightAnchor.constraint(equalTo: titleLabel.heightAnchor, multiplier: 0.5).isActive = true
    }
}

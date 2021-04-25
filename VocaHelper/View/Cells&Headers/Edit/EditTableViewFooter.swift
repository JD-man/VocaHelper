//
//  EditTableViewFooter.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/04/24.
//

import UIKit

protocol EditTableViewFooterDelegate: AnyObject {
    func addLine()
}

class EditTableViewFooter: UIView {
    
    weak var delegate: EditTableViewFooterDelegate?
    
    let addButton: UIButton = {
        let button = UIButton()
        button.tintColor = .systemGreen
        button.backgroundColor = .systemBackground
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        addSubViews()        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let buttonSize = frame.height / 1.5
        addButton.frame = CGRect(x: self.bounds.width / 2 - buttonSize / 2, y: 0, width: buttonSize, height: buttonSize)
        addButton.setBackgroundImage(UIImage(systemName: "plus.circle"), for: .normal)
        addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .systemBackground
    }
    
    private func addSubViews() {
        addSubview(addButton)
    }
    
    @objc private func didTapAddButton() {
        delegate?.addLine()
    }
    
}

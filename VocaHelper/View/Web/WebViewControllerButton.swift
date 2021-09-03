//
//  WebViewControllerButton.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/09/03.
//

import UIKit

class WebViewControllerButton: UIButton {

    func setWebButton(title: String) {
        setTitle(title, for: .normal)
        setTitleColor(title == "로그인" ? .white : .label, for: .normal)
        backgroundColor = title == "로그인" ? .link : .systemBackground
        //layer.masksToBounds = true
        layer.cornerRadius = 10
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        
        //shadow configure
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 1, height: 1)
        
        translatesAutoresizingMaskIntoConstraints = false
    }
}

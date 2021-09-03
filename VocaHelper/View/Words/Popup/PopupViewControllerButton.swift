//
//  PopupViewControllerButton.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/09/01.
//

import UIKit

class PopupViewControllerButton: UIButton {
    
    func setPopupButton(title: String) {
        setTitle(title, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        setTitleColor(title == "삭제하기" ? .systemRed : .label, for: .normal)
        backgroundColor = .systemBackground
        layer.masksToBounds = true
    }
}

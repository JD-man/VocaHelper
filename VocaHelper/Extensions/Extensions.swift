//
//  Extensions.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/07/31.
//

import Foundation
import UIKit

extension UIColor {
    open class var whiteBlackDynamicColor: UIColor {
        // 다크모드를 위한 DynamicColor.
        // 텍스트필드의 외곽선에 사용된다.
        return UITraitCollection.current.userInterfaceStyle == .dark ? .white : .black
    }
}

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
        return UITraitCollection.current.userInterfaceStyle == .dark ? .white : .black
    }
}

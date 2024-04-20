//
//  CommonExtension.swift
//  Acharya Prashant Foundation
//
//  Created by Ashok Singh on 16/04/24.
//

import UIKit

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension UIView {

    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}

//
//  ReusableView.swift
//  ChatDemo
//
//  Created by Shehryar Hussain on 8/16/18.
//  Copyright © 2018 Shehryar Hussain. All rights reserved.
//

import Foundation
import UIKit

protocol ReusableView: class {
}

extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

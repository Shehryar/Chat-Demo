//
//  String+Size.swift
//  ChatDemo
//
//  Created by Shehryar Hussain on 8/16/18.
//  Copyright © 2018 Shehryar Hussain. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var stringSize: CGSize {
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let rect = NSString(string: self).boundingRect(with: size, options: options, attributes: [.font: UIFont.systemFont(ofSize: 18)], context: nil)
        return CGSize(width: rect.width, height: rect.height)
    }
}

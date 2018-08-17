//
//  MessageCell.swift
//  ChatDemo
//
//  Created by Shehryar Hussain on 8/16/18.
//  Copyright © 2018 Shehryar Hussain. All rights reserved.
//

import Foundation
import UIKit

enum MessageType {
    case text
    case media
}

class MessageCell: UICollectionViewCell {
    var message: Message?
    
    func update(message: Message) {
        self.message = message
    }
}

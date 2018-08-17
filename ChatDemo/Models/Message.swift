//
//  Message.swift
//  ChatDemo
//
//  Created by Shehryar Hussain on 8/16/18.
//  Copyright © 2018 Shehryar Hussain. All rights reserved.
//

import Foundation
import UIKit

class Message {
    var id: Int?
    var type: MessageType
    var text: String?
    var media: UIImage?
    var isSender: Bool
    var date: Date
    
    init(text: String?, media: UIImage?, type: MessageType, isSender: Bool) {
        self.text = text
        self.media = media
        self.type = type
        self.isSender = isSender
        self.date = Date()
    }
}

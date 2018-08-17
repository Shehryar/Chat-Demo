//
//  MediaMessageCell.swift
//  ChatDemo
//
//  Created by Shehryar Hussain on 8/16/18.
//  Copyright © 2018 Shehryar Hussain. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

class MediaMessageCell: MessageCell, ReusableView {
    var mediaMessage: Message?
    let messageBubbleView = UIView()
    var mediaView = UIImageView(frame: .zero)
    var messageWidthConstraint: Constraint?
    
    let lightGrayBubbleColor = UIColor(red: 230/250, green: 230/250, blue: 230/250, alpha: 1)
    let blueBubbleColor = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 1)
    
    func senderMaskedCorners(isSender: Bool) -> CACornerMask {
        if isSender {
            return [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner]
        } else {
            return [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureSubviews() {
        messageBubbleView.layer.cornerRadius = 10
        messageBubbleView.clipsToBounds = true
        
        contentView.addSubview(messageBubbleView)
        messageBubbleView.addSubview(mediaView)
    }
    
    override func update(message: Message) {
        if let image = message.media {
            mediaView.image = image
            messageBubbleView.backgroundColor = message.isSender ? blueBubbleColor : lightGrayBubbleColor
            messageBubbleView.layer.maskedCorners = senderMaskedCorners(isSender: message.isSender)
            updateMessageWidthConstraint(isSender: message.isSender)
            layoutIfNeeded()
        }
    }
    
    func setupConstraints() {
        messageBubbleView.snp.makeConstraints { (make) in
            make.height.equalTo(120) // default
            make.width.equalTo(120) // default
            make.centerY.equalTo(contentView)
        }
        
        mediaView.snp.makeConstraints { (make) in
            make.left.right.equalTo(messageBubbleView).inset(8)
            make.top.bottom.equalTo(messageBubbleView).inset(8)
        }
    }
    
    func updateMessageWidthConstraint(isSender: Bool) {
        messageWidthConstraint?.deactivate()
        messageBubbleView.snp.remakeConstraints { (make) in
            make.height.equalTo(120) // default
            make.width.equalTo(120) // default
            make.centerY.equalTo(contentView)
            if isSender {
                make.right.equalTo(contentView).inset(TextMessageCell.leftRightMargin)
            } else {
                make.left.equalTo(contentView).inset(TextMessageCell.leftRightMargin)
            }
        }
        mediaView.snp.remakeConstraints { (make) in
            make.left.right.equalTo(messageBubbleView).inset(TextMessageCell.leftRightMargin)
            make.top.bottom.equalTo(messageBubbleView)
        }
        layoutIfNeeded()
    }
}

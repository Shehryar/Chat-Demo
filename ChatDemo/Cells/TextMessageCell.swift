//
//  TextMessageCell.swift
//  ChatDemo
//
//  Created by Shehryar Hussain on 8/16/18.
//  Copyright © 2018 Shehryar Hussain. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class TextMessageCell: MessageCell, ReusableView {
    static let bubbleWidthPadding: CGFloat = 15.0
    static let leftRightMargin: CGFloat = 8.0
    var textMessage: Message?
    let messageBubbleView = UIView()
    var messageLabel = UILabel()
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
        messageLabel.numberOfLines = 0
        messageLabel.textColor = .white
        messageBubbleView.layer.cornerRadius = 10
        messageBubbleView.clipsToBounds = true
        
        
        contentView.addSubview(messageBubbleView)
        messageBubbleView.addSubview(messageLabel)
    }
    
    override func update(message: Message) {
        textMessage = message
        if let text = message.text {
            messageLabel.text = text
            messageBubbleView.backgroundColor = message.isSender ? blueBubbleColor : lightGrayBubbleColor
            messageLabel.textColor = message.isSender ? .white : .black
            messageBubbleView.layer.maskedCorners = senderMaskedCorners(isSender: message.isSender)
            updateMessageWidthConstraint(width: text.stringSize.width, isSender: message.isSender)
        }
    }
    
    func setupConstraints() {
        
        messageBubbleView.snp.makeConstraints { (make) in
            messageWidthConstraint = make.width.equalTo(contentView).constraint
            make.height.equalTo(contentView)
            make.centerY.equalTo(contentView)
        }
        
        messageLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(messageBubbleView)
        }
    }
    
    func updateMessageWidthConstraint(width: CGFloat, isSender: Bool) {
        messageWidthConstraint?.deactivate()
        messageBubbleView.snp.remakeConstraints { (make) in
            make.width.equalTo(width + TextMessageCell.bubbleWidthPadding)
            make.height.equalTo(contentView)
            make.centerY.equalTo(contentView)
            if isSender {
                make.right.equalTo(contentView).inset(TextMessageCell.leftRightMargin)
            } else {
                make.left.equalTo(contentView).inset(TextMessageCell.leftRightMargin)
            }
        }
        messageLabel.snp.remakeConstraints { (make) in
            make.left.right.equalTo(messageBubbleView).inset(TextMessageCell.leftRightMargin)
            make.top.bottom.equalTo(messageBubbleView)
        }
        layoutIfNeeded()
    }
}

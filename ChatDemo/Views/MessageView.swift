//
//  MessageView.swift
//  ChatDemo
//
//  Created by Shehryar Hussain on 8/16/18.
//  Copyright © 2018 Shehryar Hussain. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

protocol MessageViewDelegate: class {
    func sendButtonPressed()
    func cameraButtonPressed()
}

class MessageView: UIView {
    weak var delegate: MessageViewDelegate?
    //    var messageTextField = UITextField(frame: .zero)
    var messageTextField = UITextView()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.setTitleColor(UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 1.0), for: .normal)
        button.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let cameraButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "camera"), for: .normal)
        button.imageView?.tintColor = .lightGray
        button.addTarget(self, action: #selector(cameraButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
        addSubview(cameraButton)
        addSubview(messageTextField)
        addSubview(sendButton)
        messageTextField.font = UIFont.systemFont(ofSize: 15)
        messageTextField.backgroundColor = .white
        messageTextField.layer.cornerRadius = 3.0
        messageTextField.textColor = .lightGray
        messageTextField.text = " Enter message"
        messageTextField.delegate = self
        setupConstraints()
    }
    
    // add a gesture recognizer for the messagefield?
    
    private func setupConstraints() {
        sendButton.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.top.bottom.equalTo(self)
            make.right.equalTo(self).inset(2)
        }
        
        cameraButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(24)
            make.left.equalTo(self).inset(10)
            make.centerY.equalTo(self)
        }
        
        messageTextField.snp.makeConstraints { (make) in
            make.left.equalTo(cameraButton.snp.right).offset(10)
            make.right.equalTo(sendButton.snp.left).offset(-8)
            make.top.bottom.equalTo(self).inset(5)
        }
    }
    
    func resetTextField() {
        messageTextField.textColor = .lightGray
        messageTextField.text = " Enter message"
    }
    
    @objc private func sendButtonPressed() {
        delegate?.sendButtonPressed()
    }
    
    @objc private func cameraButtonPressed() {
        delegate?.cameraButtonPressed()
    }
}

extension MessageView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
}

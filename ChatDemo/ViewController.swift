//
//  ViewController.swift
//  ChatDemo
//
//  Created by Shehryar Hussain on 8/13/18.
//  Copyright © 2018 Shehryar Hussain. All rights reserved.
//

import UIKit
import SnapKit
import Foundation

class ViewController: UIViewController {
    static let keyboardToolbarHeight: CGFloat = 48.0
    static let messageHeightPadding: CGFloat = 10.0
    
    var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    let messageField: MessageView = {
        let messageView = MessageView()
        return messageView
    }()
    
    var messages = [Message]()
    var collectionViewBottomConstraint: Constraint?
    var bottomConstraint: Constraint?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        unsubscribeToKeyboardNotification()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Chat with us"
        view.backgroundColor = UIColor.gray
        configureSubviews()
        setupConstraints()
        subscribeToKeyboardNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidShow),
            name: NSNotification.Name.UIKeyboardDidShow,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil
        )
    }
    
    private func unsubscribeToKeyboardNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func configureSubviews() {
        view.addSubview(collectionView)
        view.addSubview(messageField)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = true
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: ViewController.keyboardToolbarHeight, right: 0)
        messageField.delegate = self
        registerCells()
    }
    
    private func registerCells() {
        collectionView.register(TextMessageCell.self)
        collectionView.register(MediaMessageCell.self)
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints{ (make) -> Void in
            make.left.right.top.equalTo(view)
            collectionViewBottomConstraint = make.bottom.equalTo(view).constraint
        }
        
        messageField.snp.makeConstraints({ (make) in
            make.left.right.equalTo(view)
            make.height.equalTo(ViewController.keyboardToolbarHeight)
            bottomConstraint = make.bottom.equalTo(view).constraint
        })
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            bottomConstraint?.update(offset: -keyboardRectangle.height)
            collectionViewBottomConstraint?.update(offset: -keyboardRectangle.height - 30)
            
            UIView.animate(withDuration: 0) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardDidShow(_ notification: Notification) {
        if messages.count > 0 {
            collectionView.scrollToItem(at: IndexPath(item: messages.count - 1, section: 0), at: UICollectionViewScrollPosition.bottom, animated: true)
        }
    }
    
    func photoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            present(myPickerController, animated: true, completion: nil)
        }
    }
}

extension ViewController: MessageViewDelegate {
    func sendButtonPressed() {
        guard let text = messageField.messageTextField.text, !text.isEmpty else { return }
        let message = Message(text: text, media: nil, type: .text, isSender: true)
        let counterMessage = Message(text: text, media: nil, type: .text, isSender: false)
        messageField.messageTextField.text = ""
        messages.append(message)
        insertRow()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.messages.append(counterMessage)
            self.insertRow()
        }
    }
    
    func cameraButtonPressed() {
        photoLibrary()
    }
    
    func insertRow() {
        let index = IndexPath(row: messages.count - 1, section: 0)
        collectionView.insertItems(at: [index])
        collectionView.scrollToItem(at: index, at: .bottom, animated: true)
    }
    
    func insertImage(image: UIImage) {
        let imageMessage = Message(text: nil, media: image, type: .media, isSender: true)
        messages.append(imageMessage)
        insertRow()
    }
}
extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            insertImage(image: image)
        } else {
            print("Something went wrong")
        }
        dismiss(animated: true, completion: nil)
    }
}

extension ViewController: UINavigationControllerDelegate { // Stub
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if let messageText = messages[indexPath.row].text {
            return CGSize(width: collectionView.frame.size.width, height: messageText.stringSize.height + ViewController.messageHeightPadding)
        }
        return CGSize(width: view.bounds.width, height: 120) // Random default
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let message = messages[indexPath.row]
        
        switch message.type {
        case .text:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as TextMessageCell
            cell.update(message: message)
            return cell
        case .media:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as MediaMessageCell
            cell.update(message: message)
            return cell
        }
    }
}

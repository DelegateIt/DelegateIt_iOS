//
//  newOrder.swift
//  DelegateIt
//
//  Created by Ben Wernsman on 11/26/15.
//  Copyright © 2015 Ben Wernsman. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class newOrder: JSQMessagesViewController {
    
    var userName = ""
    var messages = [JSQMessage]()
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor(red: 74/255, green: 186/255, blue: 251/255, alpha: 1.0 ))
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor(red: 229/255, green: 229/255, blue: 234/255, alpha: 1.0))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = "Logout"
        self.collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSizeMake(0.1, 0.1);
        self.collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSizeMake(0.1, 0.1);
        
        // Do any additional setup after loading the view, typically from a nib.
        self.userName = "iPhone"
        for i in 1...10 {
            let sender = (i%2 == 0) ? "Syncano" : self.userName
            let message = JSQMessage(senderId: sender, displayName: sender, text: "Text")
            self.messages += [message]
        }
        self.collectionView!.reloadData()
        self.senderDisplayName = self.userName
        self.senderId = self.userName
        
        automaticallyScrollsToMostRecentMessage = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        let data = self.messages[indexPath.row]
        return data
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let data = self.messages[indexPath.row]
        if (data.senderId == self.senderId) {
            return self.outgoingBubble
        } else {
            return self.incomingBubble
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count;
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        let newMessage = JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text);
        messages += [newMessage]
        self.finishSendingMessage()
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
    }
    
    
}
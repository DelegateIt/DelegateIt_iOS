//
//  CustomOrder.swift
//  DelegateIt
//
//  Created by Ben Wernsman on 11/10/15.
//  Copyright © 2015 Ben Wernsman. All rights reserved.
//

import Foundation
import UIKit

class CustomOrder: JSQMessagesViewController {
    
    @IBOutlet weak var orderBox: UITextField!
    
    var orderText:String = ""
    
    var userName = ""
    var messages = [JSQMessage]()

    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor.lightGrayColor())
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor(red: 74/255, green: 186/255, blue: 251/255, alpha: 1.0))
    let paymentBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor(red: 254/255, green: 198/255, blue: 61/255, alpha: 1.0))
    
    var counter:Int = 0
    var transactionUUID:String = ""
    var messageQue:[String] = []
    // -1 means no messages sent
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        mainInstance.setMessageCount(0)
        self.keyboardController.textView!.becomeFirstResponder()
        
        //orderBox.becomeFirstResponder()
        
        navigationController?.navigationBar.topItem?.title = "NEW ORDER"
        self.collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSizeMake(0.1, 0.1);
        self.collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSizeMake(0.1, 0.1);
        
        // Do any additional setup after loading the view, typically from a nib.
        
        /*
        self.userName = "iPhone"
        for i in 1...10 {
            var sender = (i%2 == 0) ? "Syncano" : self.userName
            var message = JSQMessage(senderId: sender, displayName: sender, text: "htts:www.apple.com")
            self.messages += [message]
        }
        
        var sender = (4%2 == 0) ? "Syncano" : self.userName
        var message = JSQMessage(senderId: sender, displayName: sender, text: "ACCEPT ORDER")
        self.messages += [message]
        */
        
        self.collectionView!.reloadData()
        self.senderDisplayName = self.userName
        self.senderId = self.userName
        self.inputToolbar!.contentView!.textView!.placeHolder = "Make a new order";
        self.inputToolbar!.contentView!.textView!.text = orderText;
        
        //self.messages. //textColor = UIColor(red: 74/255, green: 186/255, blue: 251/255, alpha: 1.0)
        
        //self.inputToolbar!.contentView!.textView!.placeHolderTextColor = UIColor(red: 74/255, green: 186/255, blue: 251/255, alpha: 1.0)
        automaticallyScrollsToMostRecentMessage = true
        //self.inputToolbar!.contentView!.rightBarButtonItem?.
        //self.inputToolbar!.contentView!.leftBarButtonItem = nil
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
        
        print(data.text)
        if (data.senderId == self.senderId) {
            return self.outgoingBubble
        } else {
            if(data.text == "ACCEPT ORDER"){
                //data.text = "HEYYYY"
                return self.paymentBubble
            }
            else{
                return self.incomingBubble
            }
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
        counter++
        print(counter)
        if(counter == 1){
           print("create new transaction")
            //create new transaction
            transactionUUID = RestApiManager.sharedInstance.createTransaction(mainInstance.uuid,token: mainInstance.token,newMessage: newMessage.text)
            mainInstance.addMessage()
        }
        if(mainInstance.currentTransaction == ""){
            mainInstance.addtoQue(newMessage.text)
        } else{
            
            RestApiManager.sharedInstance.sendMessage(mainInstance.currentTransaction,token: mainInstance.token,message: newMessage.text)
        }
        
        messages += [newMessage]
        self.finishSendingMessage()
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        print("button pressed")
    }
    
    
}
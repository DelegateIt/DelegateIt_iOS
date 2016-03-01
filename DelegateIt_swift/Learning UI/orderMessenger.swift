//
//  orderMessenger.swift
//  DelegateIt
//
//  Created by Ben Wernsman on 1/31/16.
//  Copyright © 2016 Ben Wernsman. All rights reserved.
//

import Foundation
import UIKit
import JSQMessagesViewController
import SwiftyJSON

class orderMessenger: JSQMessagesViewController {
    static let sharedInstance2 = CustomOrder()
    
    @IBOutlet weak var orderBox: UITextField!
    
    var timer: NSTimer = NSTimer()
    
    var orderText:String = ""
    
    var data:String = ""
    
    var userName = ""
    var messages = [JSQMessage]()

    
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor(red: 229/255, green: 229/255, blue: 234/255, alpha: 1.0))
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor(red: 74/255, green: 186/255, blue: 251/255, alpha: 1.0))
    var paymentBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor(red: 255/255, green: 199/255, blue: 40/255, alpha: 1.0))
    
    var bubbleFactory = JSQMessagesBubbleImageFactory()
    var outgoingBubbleImage: JSQMessagesBubbleImage!
    var incomingBubbleImage: JSQMessagesBubbleImage!
    
    
    var counter:Int = 0
    var transactionUUID:String = ""
    var messageQue:[String] = []
    
    var tapBtn:String = "\nTAP TO PAY \u{203A}\n"
    
    var oldMessageCount = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var messageCount = 0
        var messagesJSON:JSON = ""
        
        outgoingBubbleImage = bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
        incomingBubbleImage = bubbleFactory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
        
        let messageIndex = mainInstance.getIndex(data)
        mainInstance.currentTransaction = mainInstance.active_transaction_uuids2[messageIndex]
        transactionUUID = mainInstance.currentTransaction.transactionUUID
        messageCount = mainInstance.active_transaction_uuids2[messageIndex].messageCount
        messagesJSON = mainInstance.active_transaction_uuids2[messageIndex].messages
            
        if(mainInstance.active_transaction_uuids2[messageIndex].paymentStatus == "proposed" || mainInstance.active_transaction_uuids2[messageIndex].paymentStatus == "pending") {
            //let rightBtn = UIBarButtonItem(title: "PAY", style: .Plain, target: self, action: "sayHello:")
            //self.navigationItem.rightBarButtonItem = rightBtn
        }
        
        self.userName = "customer"
        var index = 0
        for (index = 0; index < messageCount; index++){
            if(messagesJSON[index]["type"].stringValue == "receipt"){
                //let rightBtn = UIBarButtonItem(title: "PAY", style: .Plain, target: self, action: "sayHello:")
                //self.navigationItem.rightBarButtonItem = rightBtn
                var paymentBtnImage = UIImage(named: "payment.png")
                if(mainInstance.active_transaction_uuids2[messageIndex].paymentStatus == "completed"){
                    paymentBtnImage = UIImage(named: "receipt.png")
                }
                
                let mediaItem = JSQPhotoMediaItem(image: paymentBtnImage)
                mediaItem.appliesMediaViewMaskAsOutgoing = false
                let message = JSQMessage(senderId: "customer2", displayName: "customer2", media:mediaItem)
                messages += [message]
            }
            else if(messagesJSON[index]["from_customer"].boolValue){
                let message = JSQMessage(senderId: "customer", displayName: "customer", text:messagesJSON[index]["content"].stringValue)
                
                
                messages += [message]
            }
            else{
                let message = JSQMessage(senderId: "customer2", displayName: "customer2", text:messagesJSON[index]["content"].stringValue)
                messages += [message]
            }
            counter++
        }
        
        
        
    
        self.reloadMessagesView()
        
        self.title = "ORDER"
        
        self.collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSizeMake(0.1, 0.1)
        self.collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSizeMake(0.1, 0.1)
        
        self.senderDisplayName = self.userName
        self.senderId = self.userName
        self.inputToolbar!.contentView!.textView!.placeHolder = "Message";
        self.inputToolbar!.contentView!.textView!.text = orderText;
        
        oldMessageCount = messageCount
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadList:",name:"load", object: nil)
        automaticallyScrollsToMostRecentMessage = true
        
        self.inputToolbar!.contentView!.leftBarButtonItem = nil
        
        if(mainInstance.active_transaction_uuids2[messageIndex].paymentStatus == "completed"){
            self.inputToolbar!.contentView!.textView!.placeHolder = "Transaction Completed";
            self.inputToolbar!.contentView!.textView!.hidden = true
            self.inputToolbar!.contentView!.hidden = true
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = self.messages[indexPath.item]
        if message.senderId == self.senderId {
            return outgoingBubbleImage
        }
        return incomingBubbleImage
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: JSQMessagesCollectionViewCell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        let msg: JSQMessage = self.messages[indexPath.item] as JSQMessage
        
        if !msg.isMediaMessage {
            if msg.senderId == self.senderId {
                cell.textView!.textColor = UIColor.whiteColor()
                cell.textView!.linkTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor(), NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
            }
            else if(cell.textView?.text == tapBtn){
                cell.textView!.textColor = UIColor.whiteColor()
                cell.textView!.font = UIFont.boldSystemFontOfSize(30.0)
                cell.textView!.linkTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor(), NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
            }
            else {
                cell.textView!.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
                cell.textView!.linkTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor(), NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
            }
        }
        
        cell.userInteractionEnabled = true;
        
        if(msg.isMediaMessage){
            cell.tag = 1
        }else{
            cell.tag = 0
        }
        
        let recognizer = UITapGestureRecognizer(target: self, action:Selector("cellTappedOn:"))
        cell.addGestureRecognizer(recognizer)
        return cell
    }
    
    func cellTappedOn(pressed: UITapGestureRecognizer){
        if(pressed.view?.tag == 1){
            self.performSegueWithIdentifier("acceptOrder", sender: self);
        }

    }
    
    
    
    func loadList(notification: NSNotification){
        var messageCount = 0
        var messagesJSON:JSON = ""
        let messageIndex = mainInstance.getIndex(data)
        mainInstance.currentTransaction = mainInstance.active_transaction_uuids2[messageIndex]
        transactionUUID = mainInstance.currentTransaction.transactionUUID
        messageCount = mainInstance.active_transaction_uuids2[messageIndex].messageCount
        messagesJSON = mainInstance.active_transaction_uuids2[messageIndex].messages
        self.userName = "customer"
        var index = 0
        for (index = oldMessageCount; index < messageCount; index++){
            if(messagesJSON[index]["type"].stringValue == "receipt"){
                //let rightBtn = UIBarButtonItem(title: "PAY", style: .Plain, target: self, action: "sayHello:")
                //self.navigationItem.rightBarButtonItem = rightBtn
                var paymentBtnImage = UIImage(named: "payment.png")
                if(mainInstance.active_transaction_uuids2[messageIndex].paymentStatus == "completed"){
                    paymentBtnImage = UIImage(named: "receipt.png")
                }
                let mediaItem = JSQPhotoMediaItem(image: paymentBtnImage)
                mediaItem.appliesMediaViewMaskAsOutgoing = false
                let message = JSQMessage(senderId: "customer2", displayName: "customer2", media:mediaItem)
                messages += [message]
            }
            else if(messagesJSON[index]["from_customer"].boolValue){
                let message = JSQMessage(senderId: "customer", displayName: "customer", text:messagesJSON[index]["content"].stringValue)
                messages += [message]
            }
            else{
                let message = JSQMessage(senderId: "customer2", displayName: "customer2", text:messagesJSON[index]["content"].stringValue)
                messages += [message]
            }
            counter++
        }
        
        
        if(mainInstance.active_transaction_uuids2[messageIndex].paymentStatus == "proposed" || mainInstance.active_transaction_uuids2[messageIndex].paymentStatus == "pending") {
            //let rightBtn = UIBarButtonItem(title: "PAY", style: .Plain, target: self, action: "sayHello:")
            //self.navigationItem.rightBarButtonItem = rightBtn
        }
        
        if(mainInstance.active_transaction_uuids2[messageIndex].paymentStatus == "completed"){
            self.inputToolbar!.contentView!.textView!.placeHolder = "Transaction Completed";
            self.inputToolbar!.contentView!.textView!.hidden = true
        }
        
        oldMessageCount = messageCount
        
        
        self.reloadMessagesView()
        automaticallyScrollsToMostRecentMessage = true
        self.scrollToBottomAnimated(true)
    }
    
    
    func reloadMessagesView() {
        self.collectionView?.reloadData()
    }
    
    
    func sayHello(sender: UIBarButtonItem) {
        print("test22")
        //backToOrder
        self.performSegueWithIdentifier("acceptOrder", sender: self);
    }
    
    func sayHello2(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("cancleOrder", sender: self);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        let data = self.messages[indexPath.row]
        return data
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
            transactionUUID = RestApiManager.sharedInstance.createTransaction(mainInstance.uuid,token: mainInstance.token,newMessage: newMessage.text)
            mainInstance.addMessage()
        }
        print(mainInstance.currentTransaction)
        if(mainInstance.currentTransaction.transactionUUID == ""){
            mainInstance.addtoQue(newMessage.text)
        } else{
            RestApiManager.sharedInstance.sendMessage(mainInstance.currentTransaction.transactionUUID,token: mainInstance.token,message: newMessage.text)
        }
        
        //messages += [newMessage]
        self.finishSendingMessage()
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        print("button pressed")
        //Create the AlertController
        let actionSheetController: UIAlertController = UIAlertController(title: "Send a picture or your location", message: "", preferredStyle: .ActionSheet)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)
        //Create and add first option action
        let takePictureAction: UIAlertAction = UIAlertAction(title: "Take Picture", style: .Default) { action -> Void in
            //Code for launching the camera goes here
        }
        actionSheetController.addAction(takePictureAction)
        //Create and add a second option action
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "Choose From Camera Roll", style: .Default) { action -> Void in
            //Code for picking from camera roll goes here
        }
        actionSheetController.addAction(choosePictureAction)
        
        let chooseLocationAction: UIAlertAction = UIAlertAction(title: "Send Location", style: .Default) { action -> Void in
            //Code for picking from camera roll goes here
        }
        actionSheetController.addAction(chooseLocationAction)
        
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    //Leave View
    override func viewWillDisappear(animated: Bool) {
        print("Left View")
    }
}

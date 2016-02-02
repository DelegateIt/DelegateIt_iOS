//
//  CustomOrder.swift
//  DelegateIt
//
//  Created by Ben Wernsman on 11/10/15.
//  Copyright © 2015 Ben Wernsman. All rights reserved.
//

import Foundation
import UIKit
import JSQMessagesViewController
import SwiftyJSON

class CustomOrder: JSQMessagesViewController {
    static let sharedInstance2 = CustomOrder()
    
    @IBOutlet weak var orderBox: UITextField!
    
    var timer: NSTimer = NSTimer()
    
    var orderText:String = ""
    
    var data:Int = -1
    
    var userName = ""
    var messages = [JSQMessage]()

    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor(red: 254/255, green: 198/255, blue: 61/255, alpha: 1.0)) //JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor.lightGrayColor())
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor(red: 74/255, green: 186/255, blue: 251/255, alpha: 1.0))
    let paymentBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor(red: 254/255, green: 198/255, blue: 61/255, alpha: 1.0))
    
    var counter:Int = 0
    var transactionUUID:String = ""
    var messageQue:[String] = []
    // -1 means no messages sent
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        var messageCount = 0
        var messagesJSON:JSON = ""
        if(data == -1){
            //new order
            mainInstance.setMessageCount(0)
            var leftBtn = UIBarButtonItem(title: "CANCLE", style: .Plain, target: self, action: "sayHello2:")
            self.navigationItem.leftBarButtonItem = leftBtn
            
        }
        else{
            //already created
            mainInstance.currentTransaction = mainInstance.active_transaction_uuids2[data]
            transactionUUID = mainInstance.currentTransaction.transactionUUID
            messageCount = mainInstance.active_transaction_uuids2[data].messageCount
            messagesJSON = mainInstance.active_transaction_uuids2[data].messages
            
            if(mainInstance.currentTransaction.paymentStatus == "proposed" || mainInstance.currentTransaction.paymentStatus == "pending") {
                var rightBtn = UIBarButtonItem(title: "PAY NOW", style: .Plain, target: self, action: "sayHello:")
                self.navigationItem.rightBarButtonItem = rightBtn
            }
        }
        
        
        var replyBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
        replyBtn.setImage(UIImage(named: "x.png"), forState: UIControlState.Normal)
        replyBtn.addTarget(self, action: Selector("goHome:"), forControlEvents:  UIControlEvents.TouchUpInside)
        var item = UIBarButtonItem(customView: replyBtn)
        self.navigationItem.leftBarButtonItem = item

        
        
        self.keyboardController.textView!.becomeFirstResponder()
        
        //orderBox.becomeFirstResponder()
        
        //navigationController?.navigationBar.topItem?.title = "NEW ORDER"
        self.title = "ORDER"
        
        self.collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSizeMake(0.1, 0.1);
        self.collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSizeMake(0.1, 0.1);
        
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        self.userName = "customer"
        var index = 0
        for (index = 0; index < messageCount; index++){
            if(messagesJSON[index]["from_customer"].boolValue){
                var message = JSQMessage(senderId: "customer", displayName: "customer", text:messagesJSON[index]["content"].stringValue)
                
                messages += [message]
            }
            else{
                var message = JSQMessage(senderId: "customer2", displayName: "customer2", text:messagesJSON[index]["content"].stringValue)
                messages += [message]
            }
            counter++
        }
        
        
        self.reloadMessagesView()
        self.senderDisplayName = self.userName
        self.senderId = self.userName
        self.inputToolbar!.contentView!.textView!.placeHolder = "Make a new order";
        self.inputToolbar!.contentView!.textView!.text = orderText;
        
        //self.messages. //textColor = UIColor(red: 74/255, green: 186/255, blue: 251/255, alpha: 1.0)
        
        //self.inputToolbar!.contentView!.textView!.placeHolderTextColor = UIColor(red: 74/255, green: 186/255, blue: 251/255, alpha: 1.0)
        automaticallyScrollsToMostRecentMessage = true
        //self.inputToolbar!.contentView!.rightBarButtonItem?.
        //self.inputToolbar!.contentView!.leftBarButtonItem = nil
    
        
        //var leftBtn = UIBarButtonItem(title: "CANCEL", style: .Plain, target: self, action: "sayHello2:")
       
        
        
        //var leftNavBarButton = UIBarButtonItem(customView:b)
        
        //self.navigationItem.leftBarButtonItem = leftBtn
        
        //print(self.inputToolbar?.si)
    }
    
    func goHome(sender:UIButton!){
        print("Going Back")
        self.performSegueWithIdentifier("cancleOrder", sender: self);
        
    }
    
    func loadMessages(){
        print("Checking")
        /*
        if(mainInstance.currentTransaction.paymentStatus == "proposed" || mainInstance.currentTransaction.paymentStatus == "pending" && mainInstance.currentTransaction.paymentStatus != mainInstance.active_transaction_uuids2[data].paymentStatus){
            var rightBtn = UIBarButtonItem(title: "PAY NOW", style: .Plain, target: self, action: "sayHello:")
            self.navigationItem.rightBarButtonItem = rightBtn
        }
        if(mainInstance.currentTransaction.messageCount == mainInstance.active_transaction_uuids2[data].messageCount){
            //do nothing
            
        }else{
            /*
            self.userName = "customer"
            var index = 0
            for (index = mainInstance.currentTransaction.messageCount; index < mainInstance.active_transaction_uuids2[data].messageCount; index++){
                if(mainInstance.active_transaction_uuids2[data].messages[index]["from_customer"].boolValue){
                    var message = JSQMessage(senderId: "customer", displayName: "customer", text:mainInstance.active_transaction_uuids2[data].messages[index]["content"].stringValue)
                    messages += [message]
                }
                else{
                    var message = JSQMessage(senderId: "customer2", displayName: "customer2", text:mainInstance.active_transaction_uuids2[data].messages[index]["content"].stringValue)
                    messages += [message]
                }
                counter++
            }
            //self.reloadMessagesView()
            mainInstance.currentTransaction = mainInstance.active_transaction_uuids2[data]
            */
            print("----")
            print(transactionUUID)
            print(data)
            print(mainInstance.active_transaction_uuids2[mainInstance.getIndex(transactionUUID)].messages)
            var message = JSQMessage(senderId: "customer2", displayName: "customer2", text:mainInstance.active_transaction_uuids2[mainInstance.getIndex(transactionUUID)].lastMessage)
            messages += [message]
            
            print("------")
            print(mainInstance.active_transaction_uuids2[0].messages)
        }
        */
        
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
            transactionUUID = RestApiManager.sharedInstance.createTransaction(mainInstance.uuid,token: mainInstance.token,newMessage: newMessage.text)
            mainInstance.addMessage()
        }
        print(mainInstance.currentTransaction)
        if(mainInstance.currentTransaction.transactionUUID == ""){
            mainInstance.addtoQue(newMessage.text)
        } else{
            RestApiManager.sharedInstance.sendMessage(mainInstance.currentTransaction.transactionUUID,token: mainInstance.token,message: newMessage.text)
        }
        
        messages += [newMessage]
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

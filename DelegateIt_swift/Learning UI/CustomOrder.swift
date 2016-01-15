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

    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor.lightGrayColor())
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor(red: 74/255, green: 186/255, blue: 251/255, alpha: 1.0))
    let paymentBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor(red: 254/255, green: 198/255, blue: 61/255, alpha: 1.0))
    
    var counter:Int = 0
    var transactionUUID:String = ""
    var messageQue:[String] = []
    // -1 means no messages sent
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        print(data)
        
        mainInstance.setMessageCount(0)
        self.keyboardController.textView!.becomeFirstResponder()
        
        //orderBox.becomeFirstResponder()
        
        //navigationController?.navigationBar.topItem?.title = "NEW ORDER"
        self.title = "ORDER"
        
        self.collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSizeMake(0.1, 0.1);
        self.collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSizeMake(0.1, 0.1);
        
        // Do any additional setup after loading the view, typically from a nib.
        
        mainInstance.currentTransaction = mainInstance.active_transaction_uuids2[data].transactionUUID
        
        self.userName = "customer"
        var messageCount = mainInstance.active_transaction_uuids2[data].messageCount
        var messagesJSON = mainInstance.active_transaction_uuids2[data].messages
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
        
        addMessages()
        
        //var sender = (4%2 == 0) ? "Syncano" : self.userName
        //var message = JSQMessage(senderId: sender, displayName: sender, text: "ACCEPT ORDER")
        //self.messages += [message]
        
        
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
       
        var b = UIBarButtonItem(title: "PAY NOW", style: .Plain, target: self, action: "sayHello:")

        
        //var leftNavBarButton = UIBarButtonItem(customView:b)
        self.navigationItem.rightBarButtonItem = b
        //self.navigationItem.leftBarButtonItem = leftBtn
        
        //print(self.inputToolbar?.si)
        
        //timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "loadMessages", userInfo: nil, repeats: true)
    }
    
    func loadMessages(){
        print("loading")
        addMessages()
        self.reloadMessagesView()
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
            //create new transaction
            //
            transactionUUID = RestApiManager.sharedInstance.createTransaction(mainInstance.uuid,token: mainInstance.token,newMessage: newMessage.text)
            mainInstance.addMessage()
        }
        print(mainInstance.currentTransaction)
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
    
    func printData() {
        print("Hey");
    }
}



extension CustomOrder {
    func addMessages(){
        print("New message")
        print(messages)
        let message = JSQMessage(senderId: "sender", displayName: "sender", text: "2222222")
        //messages += [message]
        self.messages.append(message)
        self.reloadMessagesView()
        //collectionView!.reloadData()
    }
}
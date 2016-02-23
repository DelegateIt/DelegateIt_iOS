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
import Whisper

class CustomOrder: JSQMessagesViewController {
    
    var orderText:String = ""
    var userName = ""
    var messages = [JSQMessage]()
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor(red: 254/255, green: 198/255, blue: 61/255, alpha: 1.0))
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor(red: 74/255, green: 186/255, blue: 251/255, alpha: 1.0))
    let paymentBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor(red: 254/255, green: 198/255, blue: 61/255, alpha: 1.0))
    
    var messageQue:[String] = []
    var currentT:transaction = transaction(dataInput: nil)
    var creatingTransaction = false
    var transactionCreated = false
    
     var replyBtn = UIButton()
    
    
    override func viewWillAppear(animated: Bool) {
        self.keyboardController.textView!.becomeFirstResponder()
    }
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if(transactionCreated){
            replyBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
            replyBtn.setImage(UIImage(named: "x.png"), forState: UIControlState.Normal)
            replyBtn.addTarget(self, action: Selector("goHome:"), forControlEvents:  UIControlEvents.TouchUpInside)
            let item = UIBarButtonItem(customView: replyBtn)
            self.navigationItem.leftBarButtonItem = item
        }
        else{
            let replyBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
            replyBtn.setImage(UIImage(named: "x.png"), forState: UIControlState.Normal)
            replyBtn.addTarget(self, action: Selector("goHome:"), forControlEvents:  UIControlEvents.TouchUpInside)
            let item = UIBarButtonItem(customView: replyBtn)
            self.navigationItem.leftBarButtonItem = item
        }
        
        self.title = "ORDER"
        self.collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSizeMake(0.1, 0.1);
        self.collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSizeMake(0.1, 0.1);
        self.userName = "customer"
        self.reloadMessagesView()
        self.senderDisplayName = self.userName
        self.senderId = self.userName
        self.inputToolbar!.contentView!.textView!.placeHolder = "Make a new order";
        self.inputToolbar!.contentView!.textView!.text = orderText;
        automaticallyScrollsToMostRecentMessage = true
        self.inputToolbar?.toggleSendButtonEnabled()

        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadList:",name:"load", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "addBackBtn:",name:"updateTransaction", object: nil)
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard:")
        self.collectionView?.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func gestureRecognizer(_: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
            return true
    }
    
    func dismissKeyboard(gesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func addBackBtnCode(){
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.replyBtn.hidden = true
            let backBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
            backBtn.setImage(UIImage(named: "backBtn.png"), forState: UIControlState.Normal)
            backBtn.addTarget(self, action: Selector("goHome:"), forControlEvents:  UIControlEvents.TouchUpInside)
            let item = UIBarButtonItem(customView: backBtn)
            self.navigationItem.leftBarButtonItem = item
        })
    }
    
    func addBackBtn(notification: NSNotification){
        addBackBtnCode()
    }
    
    func goHome(sender:UIButton!){
        print("Going Back")
        self.performSegueWithIdentifier("cancleOrder", sender: self);
        
    }
    
    func loadList(notification: NSNotification){
        var index = 0
        for (index = 0; index < mainInstance.active_transaction_uuids2.count; index++){
            
            print(mainInstance.active_transaction_uuids2[index].transactionUUID)
            
        }
    }
    
    
    
    func reloadMessagesView() {
        self.collectionView?.reloadData()
    }
    
    
    func sayHello(sender: UIBarButtonItem) {
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
        
        if(!transactionCreated){
            RestApiManager.sharedInstance.createTransaction(mainInstance.uuid,token: mainInstance.token,newMessage: newMessage.text)
            transactionCreated = true
            addBackBtnCode()
        }
        else{
            
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

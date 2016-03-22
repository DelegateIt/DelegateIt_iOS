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
import Google

class CustomOrder: JSQMessagesViewController {
    
    var orderText:String = ""
    var userName = ""
    var messages = [JSQMessage]()
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor(red: 229/255, green: 229/255, blue: 234/255, alpha: 1.0))
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor(red: 74/255, green: 186/255, blue: 251/255, alpha: 1.0))
    var paymentBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor(red: 255/255, green: 199/255, blue: 40/255, alpha: 1.0))
    
    var bubbleFactory = JSQMessagesBubbleImageFactory()
    var outgoingBubbleImage: JSQMessagesBubbleImage!
    var incomingBubbleImage: JSQMessagesBubbleImage!
    
    var messageQue:[String] = []
    var currentT:transaction = transaction(dataInput: nil)
    var creatingTransaction = false
    var transactionCreated = false
    
    var transactionUUID:String = ""
    
    var oldMessageCount = 0
    
    var messageIndex = -1;
    
    var tapBtn:String = "\nTAP TO PAY \u{203A}\n"
    
    var replyBtn = UIButton()
    
    var label = UILabel()

    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainInstance.gotoOrders = false
        
        outgoingBubbleImage = bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
        incomingBubbleImage = bubbleFactory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
        
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
            
            let screenSize: CGRect = UIScreen.mainScreen().bounds
            label = UILabel(frame: CGRectMake(0, 0, 300, 300))
            label.center = CGPointMake(screenSize.width/2, 60)
            if(orderText == ""){
                label.center.y = label.center.y + 60
            }
            label.textAlignment = NSTextAlignment.Center
            label.text = "Please send us a text message with your request or desired item"
            label.font = UIFont.systemFontOfSize(16, weight: UIFontWeightLight)
            label.numberOfLines = 2
            self.view.addSubview(label)
        }
        
        self.title = "ORDER"
        self.collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSizeMake(0.1, 0.1);
        self.collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSizeMake(0.1, 0.1);
        self.userName = "customer"
        self.reloadMessagesView()
        self.senderDisplayName = self.userName
        self.senderId = self.userName
        self.inputToolbar!.contentView!.textView!.placeHolder = "Make a new order";
        
        
        automaticallyScrollsToMostRecentMessage = true
        self.inputToolbar?.toggleSendButtonEnabled()

        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadList:",name:"load", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "addBackBtn:",name:"updateTransaction", object: nil)
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard:")
        self.collectionView?.addGestureRecognizer(tapGestureRecognizer)
        
        self.inputToolbar!.contentView!.leftBarButtonItem = nil
        
        
    }

    
    override func viewWillAppear(animated: Bool) {
        if(messageIndex == -1){
            NSTimer.scheduledTimerWithTimeInterval(0.001, target: self, selector: Selector("updateText"), userInfo: nil, repeats: false)
        }
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Custom order")
            
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    func updateText(){
        if(messageIndex == -1){
            self.inputToolbar!.contentView!.textView!.text = orderText;
            NSNotificationCenter.defaultCenter().postNotificationName(UITextViewTextDidChangeNotification, object:  self.inputToolbar!.contentView!.textView!)
            self.inputToolbar?.toggleSendButtonEnabled()
            NSTimer.scheduledTimerWithTimeInterval(0.001, target: self, selector: Selector("moveKeyboard"), userInfo: nil, repeats: false)
        }
    }
    
    func moveKeyboard(){
        self.keyboardController.textView!.becomeFirstResponder()
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
        //print("Going Back")
        self.performSegueWithIdentifier("cancleOrder", sender: self);
        //self.performSegueWithIdentifier("backToOrder", sender: self);
        
        //backToOrder
        
        //let appDelegate = UIApplication.sharedApplication().delegate! as! AppDelegate
        
        //var initialViewController = self.storyboard!.instantiateViewControllerWithIdentifier("myTabbarControllerID") as! UIViewController
        //appDelegate.window?.rootViewController = initialViewController
        //appDelegate.window?.makeKeyAndVisible()
        
        //let mainStoryboard = UIStoryboard(name: "Storyboard", bundle: NSBundle.mainBundle())
        //let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ordersView") as UIViewController
        //self.presentViewController(vc, animated: true, completion: nil)
        
        //let ordersView:ordersView = UIViewController()
        
        //self.presentViewController(ordersView, animated: true, completion: nil)
        
        //let vc = ordersView() //change this to your class name
        //self.presentViewController(vc, animated: true, completion: nil)
        
        //Actually Works but loses view controller
        //let vc = self.storyboard?.instantiateViewControllerWithIdentifier("orders_22") as! ordersView
        //self.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    func loadList(notification: NSNotification){
        loadnewMessages()
    }
    
    func loadnewMessages(){
        var messageCount = 0
        var messagesJSON:JSON = ""
        //print("LOADING")
        messageIndex = mainInstance.getIndex(mainInstance.currentTransactionUUID)
        //print(messageIndex)
        for(var index = 0; index < mainInstance.active_transaction_uuids2.count; index++){
            //print(mainInstance.active_transaction_uuids2[index].transactionUUID)
        }
        if(messageIndex != -1){
            mainInstance.currentTransaction = mainInstance.active_transaction_uuids2[messageIndex]
            transactionUUID = mainInstance.currentTransaction.transactionUUID
            messageCount = mainInstance.active_transaction_uuids2[messageIndex].messageCount
            messagesJSON = mainInstance.active_transaction_uuids2[messageIndex].messages
            //print("current")
            //print(mainInstance.currentTransactionUUID)
            //print(mainInstance.active_transaction_uuids2[messageIndex].messageCount)
            self.userName = "customer"
            var index = 0
            //print("COUNT")
            //print(messageCount)
            for (index = oldMessageCount; index < messageCount; index++){
                if(messagesJSON[index]["type"].stringValue == "receipt"){
                    //let rightBtn = UIBarButtonItem(title: "PAY", style: .Plain, target: self, action: "sayHello:")
                    //self.navigationItem.rightBarButtonItem = rightBtn
                    let paymentBtnImage = UIImage(named: "payment.png")
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
            }
            
            
            if(mainInstance.active_transaction_uuids2[messageIndex].paymentStatus == "proposed" || mainInstance.active_transaction_uuids2[messageIndex].paymentStatus == "pending") {
                //let rightBtn = UIBarButtonItem(title: "PAY", style: .Plain, target: self, action: "sayHello:")
                //self.navigationItem.rightBarButtonItem = rightBtn
            }
            
            oldMessageCount = messageCount
            
            self.reloadMessagesView()
            automaticallyScrollsToMostRecentMessage = true
            self.scrollToBottomAnimated(true)
        }
        else{
            messageIndex = mainInstance.getIndex(mainInstance.currentTransactionUUID)
            NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("loadnewMessages"), userInfo: nil, repeats: false)
        }
    }

    
    
    
    func reloadMessagesView() {
        self.collectionView?.reloadData()
    }
    
    
    func sayHello(sender: UIBarButtonItem) {
        view.endEditing(true)
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
        let message = self.messages[indexPath.item]
        if message.senderId == self.senderId {
            return outgoingBubbleImage
        }
        return incomingBubbleImage
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count;
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
    
    
    
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        let newMessage = JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text);
        oldMessageCount++
        
        if(!transactionCreated && !creatingTransaction){
            self.label.hidden = true
            self.label.removeFromSuperview()
            creatingTransaction = true
            mainInstance.gotoOrders = true
            RestApiManager.sharedInstance.createTransaction(mainInstance.uuid,token: mainInstance.token,newMessage: newMessage.text)
            transactionCreated = true
            self.inputToolbar!.contentView!.textView!.placeHolder = "Message"
            addBackBtnCode()
            transactionUUID = mainInstance.currentTransactionUUID
            messageIndex = mainInstance.getIndex(mainInstance.currentTransactionUUID)
        }
        else{
            if(mainInstance.currentTransactionUUID == ""){
                messageQue.append(newMessage.text)
                NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("sendMessage"), userInfo: nil, repeats: false)
            }
            else{
                RestApiManager.sharedInstance.sendMessage(mainInstance.currentTransactionUUID,token: mainInstance.token,message: newMessage.text)
            }
        }
        messages += [newMessage]
        self.finishSendingMessage()
    }
    
    func sendMessage(){
        if(mainInstance.currentTransactionUUID == ""){
            NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("sendMessage"), userInfo: nil, repeats: false)
        }
        else{
            RestApiManager.sharedInstance.sendMessage(mainInstance.currentTransactionUUID,token: mainInstance.token,message: messageQue[0])
            messageQue.removeFirst()
        }
    }

    
    
    override func didPressAccessoryButton(sender: UIButton!) {
        //print("button pressed")
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
        //print("Left View")
    }
}

/*
 The MIT License (MIT)

 Copyright (c) 2015-present Badoo Trading Limited.

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
*/

import UIKit
import Chatto
import ChattoAdditions
import PKHUD

class DemoChatViewController: BaseChatViewController {
    
    var connected = false;

    var messageSender: FakeMessageSender!
    var dataSource: FakeDataSource! {
        didSet {
            self.chatDataSource = self.dataSource
        }
    }

    lazy private var baseMessageHandler: BaseMessageHandler = {
        return BaseMessageHandler(messageSender: self.messageSender)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        super.chatItemsDecorator = ChatItemsDemoDecorator()
        
        title = "Group"
        
        addHandler()
        join()
    }
    
    func addHandler() {
        ChatManager.manager.socket.on("disconnect") { (data, SocketAckEmitter) in
            log.info("disconnect")
            self.connected = false
            log.info(data)
            log.info(SocketAckEmitter)
            HUD.flash(.label("You Have Disconnected"), delay: HUD_DELAY_TIME)
        }
        
        ChatManager.manager.socket.on("user joined") { (data, SocketAckEmitter) in
            log.info("user joined")
            self.connected = true
            log.info(data)
            log.info(SocketAckEmitter)
            let jsonArray = data
            let jsonDict = jsonArray.last as! NSDictionary
            let numUsers = jsonDict["numUsers"]
            let username = jsonDict["username"]
            self.title = String.init(format: "Group(%@)", numUsers as! CVarArg)
            HUD.flash(.label(String.init(format: "%@ Joined", username as! CVarArg)), delay: HUD_DELAY_TIME)
        }
        
        ChatManager.manager.socket.on("login") { (data, SocketAckEmitter) in
            log.info("login")
            self.connected = true
            log.info(data)
            log.info(SocketAckEmitter)
            let jsonArray = data
            let jsonDict = jsonArray.last as! NSDictionary
            let numUsers = jsonDict["numUsers"]
            self.title = String.init(format: "Group(%@)", numUsers as! CVarArg)
            HUD.flash(.label("Connect Success"), delay: HUD_DELAY_TIME)
        }
        
        ChatManager.manager.socket.on("new message") { (data, SocketAckEmitter) in
            log.info("new message")
            self.connected = true
            log.info(data)
            log.info(SocketAckEmitter)
            let jsonArray = data
            let jsonDict = jsonArray.last as! NSDictionary
            let message = jsonDict["message"]
            self.dataSource.addIncomingTextMessage(message as! String)
        }
        
        ChatManager.manager.socket.on("user left") { (data, SocketAckEmitter) in
            log.info("user left")
            self.connected = true
            log.info(data)
            log.info(SocketAckEmitter)
            let jsonArray = data
            let jsonDict = jsonArray.last as! NSDictionary
            let numUsers = jsonDict["numUsers"]
            let username = jsonDict["username"]
            self.title = String.init(format: "Group(%@)", numUsers as! CVarArg)
            HUD.flash(.label(String.init(format: "%@ Left", username as! CVarArg)), delay: HUD_DELAY_TIME)
        }
        
        ChatManager.manager.socket.on("typing") { (data, SocketAckEmitter) in
            log.info("typing")
            self.connected = true
            log.info(data)
            log.info(SocketAckEmitter)
        }
        
        ChatManager.manager.socket.on("stop typing") { (data, SocketAckEmitter) in
            log.info("stop typing")
            self.connected = true
            log.info(data)
            log.info(SocketAckEmitter)
        }
        
        ChatManager.manager.socket.on("reconnect") { (data, SocketAckEmitter) in
            log.info("reconnect")
            self.connected = true
            log.info(data)
            log.info(SocketAckEmitter)
            HUD.flash(.label("Reconnecting"), delay: HUD_DELAY_TIME)
        }
        
        ChatManager.manager.socket.on("reconnect_error") { (data, SocketAckEmitter) in
            log.info("reconnect_error")
            self.connected = false
            log.info(data)
            log.info(SocketAckEmitter)
            HUD.flash(.label("Reconnect Failed"), delay: HUD_DELAY_TIME)
        }
    }
    
    func join() {
        ChatManager.manager.socket.emit("add user", AppTool.shared.nickName())
    }

    @objc
    private func addRandomIncomingMessage() {
        self.dataSource.addRandomIncomingMessage()
    }

    var chatInputPresenter: BasicChatInputBarPresenter!
    override func createChatInputView() -> UIView {
        let chatInputView = ChatInputBar.loadNib()
        var appearance = ChatInputBarAppearance()
        appearance.sendButtonAppearance.title = NSLocalizedString("Send", comment: "")
        appearance.textInputAppearance.placeholderText = NSLocalizedString("Type a message", comment: "")
        self.chatInputPresenter = BasicChatInputBarPresenter(chatInputBar: chatInputView, chatInputItems: self.createChatInputItems(), chatInputBarAppearance: appearance)
        chatInputView.maxCharactersCount = 1000
        return chatInputView
    }

    override func createPresenterBuilders() -> [ChatItemType: [ChatItemPresenterBuilderProtocol]] {

        let textMessagePresenter = TextMessagePresenterBuilder(
            viewModelBuilder: DemoTextMessageViewModelBuilder(),
            interactionHandler: DemoTextMessageHandler(baseHandler: self.baseMessageHandler)
        )
        textMessagePresenter.baseMessageStyle = BaseMessageCollectionViewCellAvatarStyle()

        let photoMessagePresenter = PhotoMessagePresenterBuilder(
            viewModelBuilder: DemoPhotoMessageViewModelBuilder(),
            interactionHandler: DemoPhotoMessageHandler(baseHandler: self.baseMessageHandler)
        )
        photoMessagePresenter.baseCellStyle = BaseMessageCollectionViewCellAvatarStyle()

        return [
            DemoTextMessageModel.chatItemType: [
                textMessagePresenter
            ],
            DemoPhotoMessageModel.chatItemType: [
                photoMessagePresenter
            ],
            SendingStatusModel.chatItemType: [SendingStatusPresenterBuilder()],
            TimeSeparatorModel.chatItemType: [TimeSeparatorPresenterBuilder()]
        ]
    }

    func createChatInputItems() -> [ChatInputItemProtocol] {
        var items = [ChatInputItemProtocol]()
        items.append(self.createTextInputItem())
//        items.append(self.createPhotoInputItem())
        return items
    }

    private func createTextInputItem() -> TextChatInputItem {
        let item = TextChatInputItem()
        item.textInputHandler = { [weak self] text in
            self?.dataSource.addTextMessage(text)
            ChatManager.manager.socket.emit("new message", text)
        }
        return item
    }

    private func createPhotoInputItem() -> PhotosChatInputItem {
        let item = PhotosChatInputItem(presentingController: self)
        item.photoInputHandler = { [weak self] image in
            self?.dataSource.addPhotoMessage(image)
            ChatManager.manager.socket.emit("new message", UIImageJPEGRepresentation(image, 1.0)!)
        }
        return item
    }
}

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
        let image = UIImage(named: "bubble-incoming-tail-border", in: Bundle(for: DemoChatViewController.self), compatibleWith: nil)?.bma_tintWithColor(.blue)
        super.chatItemsDecorator = ChatItemsDemoDecorator()
        let addIncomingMessageButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(DemoChatViewController.addRandomIncomingMessage))
        self.navigationItem.rightBarButtonItem = addIncomingMessageButton
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addHandler()
        if !connected {
            join()
        }
    }
    
    func addHandler() {
        ChatManager.manager.socket.on("disconnect") { (data, SocketAckEmitter) in
            log.info("disconnect")
            log.info(data)
            log.info(SocketAckEmitter)
        }
        
        ChatManager.manager.socket.on("user joined") { (data, SocketAckEmitter) in
            log.info("user joined")
            log.info(data)
            log.info(SocketAckEmitter)
        }
        
        ChatManager.manager.socket.on("login") { (data, SocketAckEmitter) in
            log.info("login")
            self.connected = true
            log.info(data)
            log.info(SocketAckEmitter)
        }
        
        ChatManager.manager.socket.on("new message") { (data, SocketAckEmitter) in
            log.info("new message")
            log.info(data)
            log.info(SocketAckEmitter)
            
            self.dataSource.addIncomingTextMessage(String.init(format: "%@", data))
        }
        
        ChatManager.manager.socket.on("user left") { (data, SocketAckEmitter) in
            log.info("user left")
            log.info(data)
            log.info(SocketAckEmitter)
        }
        
        ChatManager.manager.socket.on("typing") { (data, SocketAckEmitter) in
            log.info("typing")
            log.info(data)
            log.info(SocketAckEmitter)
        }
        
        ChatManager.manager.socket.on("stop typing") { (data, SocketAckEmitter) in
            log.info("stop typing")
            log.info(data)
            log.info(SocketAckEmitter)
        }
        
        ChatManager.manager.socket.on("reconnect") { (data, SocketAckEmitter) in
            log.info("reconnect")
            log.info(data)
            log.info(SocketAckEmitter)
        }
        
        ChatManager.manager.socket.on("reconnect_error") { (data, SocketAckEmitter) in
            log.info("reconnect_error")
            self.connected = false
            log.info(data)
            log.info(SocketAckEmitter)
        }
    }
    
    func join() {
        ChatManager.manager.socket.emit("add user", "范东同学")
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
        items.append(self.createPhotoInputItem())
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
        }
        return item
    }
}

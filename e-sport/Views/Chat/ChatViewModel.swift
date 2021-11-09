//
//  ChatViewModel.swift
//  e-sport
//
//  Created by MacBook on 22.10.21.
//

import Foundation
import Combine

class ChatViewModel: GeneralARViewModel {
    private let chatBotService = ChatBotService(ApiErrorLogger())
    
    @Published var messages = [TextMessage]()
    @Published var message: String = .empty
    @Published var onMessageAdded: Int = 0
    private let onMessageAddedSubject = PassthroughSubject<Void, Never>()
    @Published var greatingAvatarAvailable = true
    
    override init() {
        super.init()
        
        onMessageAddedSubject
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .sink { [unowned self] in onMessageAdded = messages.count }
            .store(in: &cancellables)
    }
    
    func addGreatingAvatar() {
        greatingAvatarAvailable = false
    }
    
    func sendHelpMessage() {
        handleMessageResponce(chatBotService.fetchHelpMessage())
    }
    
    func sendMessage() {
        messages.append(TextMessage(isIncoming: false, text: message))
        onMessageAddedSubject.send()
        handleMessageResponce(chatBotService.sendMessage(message))
        message = .empty
    }
    
    private func handleMessageResponce(_ publisher: AnyPublisher<MessageResponce, APIError>) {
        publisher
            .first()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: {_ in},
                receiveValue: { [unowned self] in
                    messages.append(TextMessage(isIncoming: true, text: $0.text))
                    onMessageAddedSubject.send()
                })
            .store(in: &cancellables)
    }
}

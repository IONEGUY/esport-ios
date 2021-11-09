//
//  ChatBotService.swift
//  e-sport
//
//  Created by MacBook on 22.10.21.
//

import Foundation
import Combine
 
class ChatBotService: BaseApiService {
    func sendMessage(_ text: String) -> AnyPublisher<MessageResponce, APIError> {
        let location = LocationManager.shared.location
        return request(URLRequestBuilder(.get, ApiConstants.conversationAnswerPath, ["lat": location.latitude, "lon": location.longitude, "q": text]))
    }
    
    func fetchHelpMessage() -> AnyPublisher<MessageResponce, APIError> {
        return request(URLRequestBuilder(.get, ApiConstants.conversationHelpPath))
    }
}

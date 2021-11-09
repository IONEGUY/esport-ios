//
//  SmARtApp.swift
//  SmARt
//
//  Created by MacBook on 2/3/21.
//

import Foundation
import Alamofire

struct ApiConstants {
    static let baseUrl = "http://34.89.71.254:8090/"
    static let menuBaseUrl = "http://34.89.71.254:8083/"
        
    static let navigationPath = "v1/public/navigation"
    static let conversationAnswerPath = "v1/public/conversation/answer"
    static let conversationHelpPath = "v1/public/conversation/help"
    static let aboutUrl = "https://esportsscotland.challonge.com/tournaments"
    static let g5Url = "https://scotland5gcentre.org/s5gconnect/s5gconnect-dundee/"
    static let smartMenuPath = "/open/environment/global_ios"
    static let videosUrl = "\(baseUrl)api-video/open/video/download/"
    static let modelsUrl = "\(baseUrl)api-files/open/file/download/"
    static let imagesUrl = "\(baseUrl)api-image/open/image/download/"
    
    static let fileUrls: [AugmentedObjectType : String] = [
        .image: ApiConstants.imagesUrl,
        .object3D: ApiConstants.modelsUrl,
        .video: ApiConstants.videosUrl
    ]

    static let fileExtensions: [AugmentedObjectType : String] = [
        .image: "png",
        .object3D: "usdz",
        .video: "mp4"
    ]

    enum HttpHeaderField: String {
        case authentication = "Authorization"
        case contentType = "Content-Type"
        case acceptType = "Accept"
        case acceptEncoding = "Accept-Encoding"
    }

    enum ContentType: String {
        case json = "application/json"
    }
}

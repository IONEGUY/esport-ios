//
//  SmARtApp.swift
//  SmARt
//
//  Created by MacBook on 2/3/21.
//

import Foundation
import Alamofire

struct URLRequestBuilder: URLRequestConvertible {
    var method: HTTPMethod
    var path: String
    var parameters: Parameters?
    var baseUrl: String = .empty

    init(_ method: HTTPMethod,
         _ path: String,
         _ parameters: Parameters? = nil,
         _ baseUrl: String = ApiConstants.baseUrl) {
        self.baseUrl = baseUrl
        self.method = method
        self.path = path
        self.parameters = parameters
    }

    func asURLRequest() throws -> URLRequest {
        
        let url: URL = try baseUrl.asURL()

        var urlRequest = URLRequest(url: url.appendingPathComponent(path))

        urlRequest.httpMethod = method.rawValue

        urlRequest.setValue(ApiConstants.ContentType.json.rawValue,
                            forHTTPHeaderField: ApiConstants.HttpHeaderField.acceptType.rawValue)
        urlRequest.setValue(ApiConstants.ContentType.json.rawValue,
                            forHTTPHeaderField: ApiConstants.HttpHeaderField.contentType.rawValue)

        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()

        return try encoding.encode(urlRequest, with: parameters)
    }
}

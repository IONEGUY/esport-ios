//
//  MapNavigationService.swift
//  SmARt
//
//  Created by MacBook on 2/9/21.
//

import Foundation
import Combine

class MapNavigationService: BaseApiService {
    func getMapPoints() -> AnyPublisher<[MapPoint], APIError> {
        return request(URLRequestBuilder(.get, ApiConstants.navigationPath))
    }
}

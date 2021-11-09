//
//  MapPoint.swift
//  e-sport
//
//  Created by MacBook on 19.10.21.
//

import Foundation
import MapKit

struct MapPoint: Codable, Identifiable {
    let id = UUID()
    var lat: Double
    var lon: Double
    var description: String
    var title: String
    var createdAt: Int64
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
    enum CodingKeys: String, CodingKey {
        case lat
        case lon
        case description
        case title
        case createdAt
    }
}

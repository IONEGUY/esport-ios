//
//  MapNavigationViewModel.swift
//  e-sport
//
//  Created by MacBook on 19.10.21.
//

import Foundation
import SwiftUI
import Combine
import MapKit

class MapNavigationViewModel: ObservableObject {
    private let locationManager = LocationManager()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var currentLocation: MKCoordinateRegion =
        MKCoordinateRegion(MKMapRect(x: 0, y: 0, width: 0, height: 0))
    @Published var pins = [MapPoint]()
    @Published var mapTrackingMode = MapUserTrackingMode.follow
    @Published var currentSelectedPin: MapPoint?
    
    init() {
        locationManager.onLocationUpdated
            .map { MKCoordinateRegion(center: $0, span:
                    MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)) }
            .assign(to: \.currentLocation, on: self)
            .store(in: &cancellables)
        
        MapNavigationService(ApiErrorLogger()).getMapPoints()
            .sink(receiveCompletion: {_ in },
                  receiveValue: { [weak self] in self?.pins = $0 })
            .store(in: &cancellables)
    }
}

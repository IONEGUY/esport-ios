//
//  MapView.swift
//  e-sport
//
//  Created by MacBook on 14.11.21.
//

import MapKit
import SwiftUI
import Combine

struct MapViewWithRoute: UIViewRepresentable {
    typealias UIViewType = MKMapView
    
    @Binding var userLocation: MKCoordinateRegion
  
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }
  
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        return mapView
    }
  
  func updateUIView(_ uiView: MKMapView, context: Context) {
      uiView.setRegion(userLocation, animated: false)
  
      let p1 = MKPlacemark(coordinate: userLocation.center)
      let p2 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 56.45757542349847, longitude: -2.975059430331243))
  
      let request = MKDirections.Request()
      request.source = MKMapItem(placemark: p1)
      request.destination = MKMapItem(placemark: p2)
      request.transportType = .automobile
      
      let directions = MKDirections(request: request)
      directions.calculate { response, error in
          guard let route = response?.routes.first else { return }
            uiView.addAnnotations([p1, p2])
            uiView.addOverlay(route.polyline)
            uiView.setVisibleMapRect(
            route.polyline.boundingMapRect,
            edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
            animated: false)
      }
  }
  
  class MapViewCoordinator: NSObject, MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
      let renderer = MKPolylineRenderer(overlay: overlay)
      renderer.strokeColor = .systemBlue
      renderer.lineWidth = 5
      return renderer
    }
  }
}

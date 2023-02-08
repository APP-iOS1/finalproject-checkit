//
//  MapViewWithUserLocation.swift
//  CheckIt
//
//  Created by sole on 2023/02/08.
//

import Foundation
import MapKit
import CoreLocation
import SwiftUI

struct MapViewWithUserLocation: View {
    @StateObject private var locationManager = LocationManager()
    @State var userTrackingMode: MapUserTrackingMode = .none
    
        var region: Binding<MKCoordinateRegion>? {
            guard let location = locationManager.location else {
                return MKCoordinateRegion.goldenGateRegion().getBinding()
            }
            
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            
            return region.getBinding()
        }
    
    var body: some View {
            if let region = region {
                Map(coordinateRegion: region, interactionModes: .all, showsUserLocation: true, userTrackingMode: $userTrackingMode)
                    .ignoresSafeArea()
                
            }
        }
}

final class LocationManager: NSObject, ObservableObject {
    @Published var location: CLLocation?
 
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestWhenInUseAuthorization()
//        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
            DispatchQueue.main.async {
                self.location = location
            }
    }
}

extension MKCoordinateRegion {
    
    static func goldenGateRegion() -> MKCoordinateRegion {
        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude:  0), latitudinalMeters: 500, longitudinalMeters: 500)
    }
    
    func getBinding() -> Binding<MKCoordinateRegion>? {
        return Binding<MKCoordinateRegion>(.constant(self))
    }
}


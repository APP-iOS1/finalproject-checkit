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
    @StateObject var locationManager: LocationManager
    @State var userTrackingMode: MapUserTrackingMode = .none
    var mapMarkers: [Marker] {
        [Marker(location: MapMarker(coordinate: locationManager.toCoordinate, tint: .green))]
    }
    
    var region: Binding<MKCoordinateRegion>? {
        guard let location = locationManager.location else {
            return MKCoordinateRegion.noneRegion().getBinding()
        }
        
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        
        return region.getBinding()
    }
    
    var body: some View {
        if let region = region {
            Map(coordinateRegion: region, interactionModes: .all, showsUserLocation: true, userTrackingMode: $userTrackingMode, annotationItems: mapMarkers) { marker in
                marker.location
            }
            .ignoresSafeArea()
            
        }
    }
}

struct Marker: Identifiable {
    var id = UUID()
    var location: MapMarker
}


final class LocationManager: NSObject, ObservableObject {
    @Published var location: CLLocation?
    @Published var distance: Double = -1.0
    @Published var isInAttendanceRegion: Bool = false
    var toCoordinate: CLLocationCoordinate2D
    private let locationManager = CLLocationManager()
    
    init(toCoordinate: CLLocationCoordinate2D) {
        self.toCoordinate = toCoordinate
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    
}


extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.location = location
            self.distance = CLLocationCoordinate2D.distance(from: location.coordinate, to: self.toCoordinate)
            if CLLocationCoordinate2D.isInAttendanceRegion(from: location.coordinate, to: self.toCoordinate) {
                self.isInAttendanceRegion = true
            }
            else {
                self.isInAttendanceRegion = false
            }
        }
    }
}

extension MKCoordinateRegion {
    static func noneRegion() -> MKCoordinateRegion {
        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude:  0), latitudinalMeters: 500, longitudinalMeters: 500)
    }
    
    func getBinding() -> Binding<MKCoordinateRegion>? {
        return Binding<MKCoordinateRegion>(.constant(self))
    }
}


extension CLLocationCoordinate2D {
    /// Returns distance from coordianate in meters.
    /// - Parameter from: coordinate which will be used as start point.
    /// - Parameter to: coordinate which will be used as end point.
    /// - Returns: Returns distance in meters.
    static func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return from.distance(from: to)
    }
    
    static func isInAttendanceRegion(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Bool {
        // meter 단위로 계산
        let distance = CLLocationCoordinate2D.distance(from: from, to: to)
        return distance <= 50 ? true : false
    }
}

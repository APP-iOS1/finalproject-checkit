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
    @Binding var userTrackingMode: MKUserTrackingMode
    var mapMarkers: [Marker] {
        [Marker(location: locationManager.toCoordinate)]
    }
    
    var region: Binding<CLLocationCoordinate2D>? {
        guard let location = locationManager.location else {
            return CLLocationCoordinate2D.noneRegion(locationManager: locationManager).getBinding()
        }
        
        let region = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        return region.getBinding()
    }
    
    var body: some View {
        if let region = region {
            MapView(radius: 50, circleCenter: locationManager.toCoordinate, userLocation: region, userTrackingMode: $userTrackingMode)
        }
    }
}


//MARK: - Marker
struct Marker: Identifiable {
    let id = UUID()
    let location: CLLocationCoordinate2D
}



//MARK: - ViewModel(LocationManager)
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

extension CLLocationCoordinate2D {
    static func noneRegion(locationManager: LocationManager) -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
    
    func getBinding() -> Binding<CLLocationCoordinate2D>? {
        return Binding<CLLocationCoordinate2D>(.constant(self))
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
    /// 두 점 사이의 거리를 계산하는 메서드입니다. (미터 단위)
    static func isInAttendanceRegion(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Bool {
        // meter 단위로 계산
        let distance = CLLocationCoordinate2D.distance(from: from, to: to)
        return distance <= 50 ? true : false
    }
}

class MapPin: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}


//MARK: - OverlayCircleClass
class CustomCircleRenderer: MKCircleRenderer {
    override var fillColor: UIColor? {
        get {
            return UIColor.red.withAlphaComponent(0.4)
        }
        set {
            super.fillColor = newValue
        }
    }
}

struct MapView: UIViewRepresentable {
    var radius: Double
    var circleCenter: CLLocationCoordinate2D
    @Binding var userLocation: CLLocationCoordinate2D
    @Binding var userTrackingMode: MKUserTrackingMode
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.delegate = context.coordinator
        
        
        let center = CLLocationCoordinate2D(latitude: circleCenter.latitude, longitude: circleCenter.longitude)
        let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)

        let pin = MKPointAnnotation()
        pin.coordinate = circleCenter
        pin.title = "모임 장소"
        mapView.addAnnotation(pin)

        let circle = MKCircle(center: center, radius: radius)
        mapView.addOverlay(circle)
        
        
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        if userTrackingMode == .follow {
            let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 500, longitudinalMeters: 500)
            uiView.setRegion(region, animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = CustomCircleRenderer(overlay: overlay)
            return renderer
        }
    }
}

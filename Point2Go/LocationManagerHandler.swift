//
//  LocationManagerHandler.swift
//  Point2Go
//
//  Created by Agenor Junior on 19/08/25.
//

import Foundation
import CoreLocation
import MapKit

class LocationManagerHandler: NSObject, CLLocationManagerDelegate
{
    private var mapView: MKMapView?
    private let locationManager = CLLocationManager()

    // MARK: - Configure the location manager and center map on user's location
    
    func configure(for map: MKMapView)
    {
        self.mapView = map
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        print("DEBUG: location manager initialized")
    }

    // MARK: - Center the map on the user's current location
    
    func centerMapOnUserLocation(map: MKMapView)
    {
        if let userLocation = locationManager.location?.coordinate
        {
            let region = MKCoordinateRegion(
                center: userLocation,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
            map.setRegion(region, animated: true)
        }
        else
        {
            print("User location not available yet")
        }
    }

    // MARK: - Update map region when user location changes
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        guard let userLocation = locations.last
        else
        {
            return
        }
        let region = MKCoordinateRegion(center: userLocation.coordinate,
                                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView?.setRegion(region, animated: true)
    }

    // MARK: - Handle failure to retrieve user location
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Failed to get user location: \(error.localizedDescription)")
    }
    
}



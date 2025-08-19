//
//  MapTapHandler.swift
//  Point2Go
//
//  Created by Agenor Junior on 19/08/25.
//
import Foundation
import UIKit
import MapKit

class MapTapHandler
{
    // MARK: - Handle the tap on the map and save the location
    
    static func handleTap(on map: MKMapView, sender: UITapGestureRecognizer)
    {
        let touchPoint = sender.location(in: map)
        let coordinate = map.convert(touchPoint, toCoordinateFrom: map)
        
        // Verify if pin already exist
        let existingPins = map.annotations.filter
        {
            abs($0.coordinate.latitude - coordinate.latitude) < 0.0001 &&
            abs($0.coordinate.longitude - coordinate.longitude) < 0.0001
        }
        
        if !existingPins.isEmpty
        {
            print("Pin already exists here.")
            return
        }
        
        // Geocodificate and add pin
        GeocodingService.reverseGeocode(coordinate: coordinate)
        { address, streetNumber, streetName, city in
            CoreDataService.saveLocation(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude,
                address: address,
                streetNumber: streetNumber,
                streetName: streetName,
                city: city
            )

            DispatchQueue.main.async
            {
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = address
                map.addAnnotation(annotation)
            }
        }
    }
}


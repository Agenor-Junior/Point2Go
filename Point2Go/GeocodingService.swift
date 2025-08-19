//
//  GeocodingService.swift
//  Point2Go
//
//  Created by Agenor Junior on 19/08/25.
//

import Foundation
import CoreLocation

class GeocodingService
{
    // MARK: - Perform reverse geocoding to get address from coordinates
    
    static func reverseGeocode(coordinate: CLLocationCoordinate2D, completion: @escaping (String, String, String, String) -> Void)
    {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

        CLGeocoder().reverseGeocodeLocation(location)
        { placemarks, error in
            guard let placemark = placemarks?.first, error == nil
            else
            {
                completion("Unknown address", "", "", "")
                return
            }

            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            let city = placemark.locality ?? ""

            // If there is not enough data, mark as unknown
            if streetNumber.isEmpty && streetName.isEmpty && city.isEmpty
            {
                completion("Unknown address", "", "", "")
            }
            else
            {
                let parts = [streetNumber, streetName, city].filter { !$0.isEmpty }
                let fullAddress = parts.joined(separator: ", ")
                completion(fullAddress, streetNumber, streetName, city)
            }
        }
    }
}


//
//  ViewController.swift
//  Point2Go
//
//  Created by Agenor Junior on 19/08/25.
//

import UIKit
import CoreData
import CoreLocation
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate
{
    @IBOutlet weak var map: MKMapView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let locationHandler = LocationManagerHandler()

    override func viewDidLoad()
    {
        super.viewDidLoad()

        map.delegate = self
        map.showsUserLocation = true
        locationHandler.configure(for: map)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(_:)))
        map.addGestureRecognizer(tapGesture)

        loadSavedLocations()
    }
    
    @IBAction func reCenter(_ sender: UIButton)
    {
        locationHandler.centerMapOnUserLocation(map: map)
    }
    
    @IBAction func deleteAllPins(_ sender: UIButton)
    {
        CoreDataService.deleteAllLocations()
        map.removeAnnotations(map.annotations.filter { !($0 is MKUserLocation) })
    }
    
    // MARK: - Handle user tap on the map
    
    @objc func handleMapTap(_ sender: UITapGestureRecognizer)
    {
        let locationInView = sender.location(in: map)
            
            // Verify ifg pin was touched
            let tappedView = map.hitTest(locationInView, with: nil)
            if tappedView is MKAnnotationView || tappedView is UIControl
        {
            // avoid pin touches
            return
        }

            MapTapHandler.handleTap(on: map, sender: sender)
    }

    // MARK: - Load all saved locations from Core Data and display them as pins
    
    func loadSavedLocations()
    {
        let savedLocations = CoreDataService.fetchAllLocations()
        for location in savedLocations
        {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            annotation.title = location.address
            map.addAnnotation(annotation)
        }
        print("Pins loaded:", savedLocations.count)
    }

    // MARK: - Customize the appearance of map pins
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        guard !(annotation is MKUserLocation)
        else
        {
            return nil
        }

        let identifier = "Pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView

        if annotationView == nil
        {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .close)
        }
        else
        {
            annotationView?.annotation = annotation
        }

        return annotationView
    }

    // MARK: - Handle pin deletion when the callout button is tapped
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        guard let annotation = view.annotation
        else
        {
            return
        }

        CoreDataService.deleteLocation(latitude: annotation.coordinate.latitude,
                                       longitude: annotation.coordinate.longitude)

        let matchingPins = mapView.annotations.filter
        {
            $0.coordinate.latitude == annotation.coordinate.latitude &&
            $0.coordinate.longitude == annotation.coordinate.longitude &&
            !($0 is MKUserLocation)
        }

        for pin in matchingPins
        {
            mapView.removeAnnotation(pin)
        }

        mapView.deselectAnnotation(annotation, animated: false)
    }
}


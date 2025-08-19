//
//  CoreDataService.swift
//  Point2Go
//
//  Created by Agenor Junior on 19/08/25.
//

import Foundation
import UIKit
import CoreData

class CoreDataService
{
    // MARK: - Save a new location to Core Data
    
    static func saveLocation(latitude: Double, longitude: Double, address: String, streetNumber: String, streetName: String, city: String)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else {return}
        let context = appDelegate.persistentContainer.viewContext

        let newLocation = SavedLocation(context: context)
        newLocation.latitude = latitude
        newLocation.longitude = longitude
        newLocation.address = address
        newLocation.streetNumber = streetNumber
        newLocation.streetName = streetName
        newLocation.city = city

        do
        {
            try context.save()
            print("Local salvo: \(address)")
        }
        catch
        {
            print("Erro ao salvar local: \(error.localizedDescription)")
        }
    }

    // MARK: - Fetch all saved locations from Core Data
    
    static func fetchAllLocations() -> [SavedLocation]
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else
        {
            return []
        }
        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<SavedLocation> = SavedLocation.fetchRequest()

        do
        {
            return try context.fetch(fetchRequest)
        }
        catch
        {
            print("Error searching locals: \(error.localizedDescription)")
            return []
        }
    }
    
    // MARK: - Delete a location from Core Data using coordinates
    
    static func deleteLocation(latitude: Double, longitude: Double)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else
        {
            return
        }
        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<SavedLocation> = SavedLocation.fetchRequest()

        do
        {
            let results = try context.fetch(fetchRequest)
            for location in results
            {
                let latDiff = abs(location.latitude - latitude)
                let lonDiff = abs(location.longitude - longitude)

                if latDiff < 0.0001 && lonDiff < 0.0001
                {
                    context.delete(location)
                }
            }
            try context.save()
            print("Place removed from CoreData.")
        }
        catch
        {
            print("Error while removing place: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Delete all saved locations from Core Data
    
    static func deleteAllLocations()
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else { return }
        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = SavedLocation.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do
        {
            try context.execute(deleteRequest)
            try context.save()
            print("All locations deleted.")
        } catch
        {
            print("Error deleting all locations: \(error.localizedDescription)")
        }
    }

}


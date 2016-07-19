//
//  MapViewController.swift
//  VirtualTourist
//
//  Created by Sean Perez on 7/13/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locations = [Pin]()
    
    var sharedContext: NSManagedObjectContext {
        return (CoreDataStack.sharedInstance?.context)!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "OK", style: .Plain, target: nil, action: nil)
        title = "Virtual Tourist"
        mapView.delegate = self
        
        self.locations = fetchAllPins()
        loadAllPins()
        
        let longPressRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.handleLongPress(_:)))
        longPressRecogniser.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(longPressRecogniser)
    }
    
    func handleLongPress(getstureRecognizer : UIGestureRecognizer){
        if getstureRecognizer.state != .Began {
            return
        } else {
            let touchPoint = getstureRecognizer.locationInView(self.mapView)
            let touchMapCoordinate = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = touchMapCoordinate
            let newPin = Pin(dictionary: ["longitude": annotation.coordinate.longitude, "latitude": annotation.coordinate.latitude], context: (sharedContext))
            print("\(newPin.longitude) + \(newPin.latitude)")
            mapView.addAnnotation(annotation)
            CoreDataStack.sharedInstance?.save()
        }
    }
    
    func fetchAllPins() -> [Pin] {
        let fetchRequest = NSFetchRequest(entityName: "Pin")
        do {
            return try sharedContext.executeFetchRequest(fetchRequest) as! [Pin]
        } catch let error as NSError {
            print("Error fetching pins: \(error)")
            return [Pin]()
        }
    }
    
    func loadAllPins() {
        for pin in locations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(pin.latitude!), longitude: CLLocationDegrees(pin.longitude!))
            mapView.addAnnotation(annotation)
        }
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        let coordinate = view.annotation?.coordinate
        let photoVC = storyboard?.instantiateViewControllerWithIdentifier("PhotoViewController") as! PhotoViewController
        for pin in locations {
            if (coordinate?.latitude == pin.latitude && coordinate?.longitude == pin.longitude) {
                photoVC.pin = pin
            }
        }
        navigationController?.pushViewController(photoVC, animated: true)
    }
}

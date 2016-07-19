//
//  PhotoViewController.swift
//  VirtualTourist
//
//  Created by Sean Perez on 7/18/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var pin: Pin!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var newCollectionButton: UIButton!
    var pictures: [String]!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.allowsMultipleSelection = true
        
        setMapView()

        if pin.alreadyHasPhotos == false {
            FlickrClient.sharedInstance.taskForGet(pin.latitude!, pinLongitude: pin.longitude!, completionHandler: { (success, pictures, errorString) in
                if success {
                    self.pictures = pictures
                } else {
                    print(errorString)
                }
            })
            pin.alreadyHasPhotos = true
        }
    }

    func setMapViewRegionAndScale(location: CLLocationCoordinate2D) {
        let span = MKCoordinateSpanMake(0.07, 0.07)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: false)
    }
    
    func setMapView() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(pin.latitude!), longitude: CLLocationDegrees(pin.longitude!))
        setMapViewRegionAndScale(annotation.coordinate)
        mapView.addAnnotation(annotation)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}


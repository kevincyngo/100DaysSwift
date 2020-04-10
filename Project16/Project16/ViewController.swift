//
//  ViewController.swift
//  Project16
//
//  Created by Kevin Ngo on 2020-04-10.
//  Copyright © 2020 Kevin Ngo. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
        
        //        mapView.addAnnotation(london)
        //        mapView.addAnnotation(oslo)
        //        mapView.addAnnotation(paris)
        //        mapView.addAnnotation(rome)
        //        mapView.addAnnotation(washington)
        mapView.addAnnotations([london, oslo, paris, rome, washington])
        
        let mapPicker = UIAlertController(title: "Map picker",
                                          message: "Pick map style",
                                          preferredStyle: .alert)
        mapPicker.addAction(UIAlertAction(title: "Satellite", style: .default, handler: { _ in
            self.mapView.mapType = .satellite
        }))
        
        mapPicker.addAction(UIAlertAction(title: "Standard", style: .default, handler: { _ in
            self.mapView.mapType = .standard
        }))
        
        present(mapPicker, animated: true)
        
        
    }
    
    /*
     
     1. If the annotation isn't from a capital city, it must return nil so iOS uses a default view.
     2. Define a reuse identifier. This is a string that will be used to ensure we reuse annotation views as much as possible.
     3. Try to dequeue an annotation view from the map view's pool of unused views.
     4. If it isn't able to find a reusable view, create a new one using MKPinAnnotationView and sets its canShowCallout property to true. This triggers the popup with the city name.
     5. Create a new UIButton using the built-in .detailDisclosure type. This is a small blue "i" symbol with a circle around it.
     6. If it can reuse a view, update that view to use a different annotation.
     
     
     */
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 1
        guard annotation is Capital else { return nil }
        
        // 2
        let identifier = "Capital"
        
        // 3
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        
        if annotationView == nil {
            //4
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            // 5
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            // 6
            annotationView?.annotation = annotation
        }
        
        guard annotationView is MKPinAnnotationView else {return nil}
        annotationView?.tintColor = .red
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "WikiWebsite") as? WikiWebController {
            // 2: success! Set its selectedImage property
            vc.capital = capital.title
            // 3: now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
        
        
//        guard let capital = view.annotation as? Capital else { return }
//        let placeName = capital.title
//        let placeInfo = capital.info
//
//
//
//        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .default))
//        present(ac, animated: true)
    }
}


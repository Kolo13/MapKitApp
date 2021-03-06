//
//  MapViewController.swift
//  MapKitApp
//
//  Created by Kori Kolodziejczak on 11/3/14.
//  Copyright (c) 2014 Kori Kolodziejczak. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

  @IBOutlet weak var mapView: MKMapView!
  
  let locationManager = CLLocationManager()
  var localNotifier = UILocalNotification()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.locationManager.delegate = self
    self.mapView.delegate = self
    
    let longPress = UILongPressGestureRecognizer(target: self, action: "didLongPressMap:")
    self.mapView.addGestureRecognizer(longPress)
    
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "reminderAdded:", name: "REMINDER_ADDED", object: nil)


    switch CLLocationManager.authorizationStatus() as CLAuthorizationStatus {
      
      case .Authorized:
        println("Authorized")
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
      case .NotDetermined:
        println("Not Determined")
        self.locationManager.requestAlwaysAuthorization()
      case .Restricted:
        println("Restricted")
      case .Denied:
        println("Denied")
      default:
        println("default")
      }
    }
  
    deinit {
      NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
      switch status {
      case .Authorized:
        println("Changed to Authorized")
        self.locationManager.startUpdatingLocation()
      default:
        println("default authorization status")
      }
    }
    
    func didLongPressMap(sender: UILongPressGestureRecognizer) {
      
      if sender.state == UIGestureRecognizerState.Began{
        let touchPoint = sender.locationInView(self.mapView)
        let touchCoordinate = self.mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
        let date = NSDate()
        println("\(touchCoordinate.latitude) \(touchCoordinate.longitude)")
        
        //add pin and annotation
        var annotation = MKPointAnnotation()
        annotation.coordinate = touchCoordinate
        annotation.title = "Add Reminder"
        self.mapView.addAnnotation(annotation)
      }
    }
    
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
      let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "ANNOTATION")
      annotationView.animatesDrop = true
      annotationView.canShowCallout = true
      let addButton = UIButton.buttonWithType(UIButtonType.ContactAdd) as UIButton
      annotationView.rightCalloutAccessoryView = addButton
      return annotationView    
    }
  
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
      let reminderVC = self.storyboard?.instantiateViewControllerWithIdentifier("REMINDER_VC") as AddReminderViewController
      reminderVC.locationManager = self.locationManager
      reminderVC.selectedAnnotation = view.annotation
      
      self.presentViewController(reminderVC, animated: true, completion: nil)
    }
  
  
  
  
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
      let renderer = MKCircleRenderer(overlay: overlay)
      renderer.fillColor = UIColor.purpleColor().colorWithAlphaComponent(0.20)
      renderer.strokeColor = UIColor.blackColor()
      renderer.lineWidth = 1.0
      
      return renderer
    }
  
  
  
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
      self.localNotifier.alertBody = "ENTERING REGION"
      self.localNotifier.alertAction = "WooHoo"
      self.localNotifier.fireDate = NSDate()
      UIApplication.sharedApplication().scheduleLocalNotification(self.localNotifier)
      println("great success!")

  }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
      println("left region")
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
      println("we got a location update!")
      if let location = locations.last as? CLLocation {
      }
    }
    
    func reminderAdded(notification : NSNotification) {
      println("reminder added")
      let userInfo = notification.userInfo!
      let geoRegion = userInfo["region"] as CLCircularRegion
      let overlay = MKCircle(centerCoordinate: geoRegion.center, radius: geoRegion.radius)
      self.mapView.addOverlay(overlay)
    }
}

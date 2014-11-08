//
//  AddReminderViewController.swift
//  MapKitApp
//
//  Created by Kori Kolodziejczak on 11/4/14.
//  Copyright (c) 2014 Kori Kolodziejczak. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class AddReminderViewController: UIViewController, CLLocationManagerDelegate {
  
  @IBOutlet weak var mapView: MKMapView!
  var locationManager: CLLocationManager!
  var selectedAnnotation: MKAnnotation!
  var managedObjectContext: NSManagedObjectContext!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    self.managedObjectContext = appDelegate.managedObjectContext
    
    //      let regionSet = self.locationManager.monitoredRegions
    //      let regions = regionSet.allObjects
    //      println(regions.count)
    
    let location = CLLocationCoordinate2D(latitude: selectedAnnotation.coordinate.latitude , longitude: selectedAnnotation.coordinate.longitude )
    let span = MKCoordinateSpanMake(0.01, 0.01)
    let region = MKCoordinateRegion(center: location, span: span)
    
    mapView.setRegion(region, animated: true)
  }
  
  @IBAction func didPressAddReminderButton(sender: AnyObject) {
    
    var geoRegion = CLCircularRegion(center: selectedAnnotation.coordinate, radius: 4000.0, identifier: "TestRegion")
    self.locationManager.startMonitoringForRegion(geoRegion)
    
    var newReminder = NSEntityDescription.insertNewObjectForEntityForName("Reminder", inManagedObjectContext: self.managedObjectContext) as Reminder
    newReminder.name = geoRegion.identifier
    newReminder.radius = "\(geoRegion.radius)"
    newReminder.date = NSDate()
    newReminder.coordinate = "\(geoRegion.center.latitude), \(geoRegion.center.longitude)"
    
    var error : NSError?
    if error != nil {
      println("ERROR: \(error?.localizedDescription)")
    }
    
    NSNotificationCenter.defaultCenter().postNotificationName("REMINDER_ADDED", object: self, userInfo: ["region" : geoRegion])
    
    self.managedObjectContext.save(&error)
    self.dismissViewControllerAnimated(true, completion: nil)

  }
  
}

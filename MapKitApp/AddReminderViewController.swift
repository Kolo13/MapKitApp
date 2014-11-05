//
//  AddReminderViewController.swift
//  MapKitApp
//
//  Created by Kori Kolodziejczak on 11/4/14.
//  Copyright (c) 2014 Kori Kolodziejczak. All rights reserved.
//

import UIKit
import MapKit

class AddReminderViewController: UIViewController, CLLocationManagerDelegate {
  
  var locationManager: CLLocationManager!
  var selectedAnnotation: MKAnnotation!

  
  @IBAction func didPressAddReminderButton(sender: AnyObject) {
    var geoRegion = CLCircularRegion(center: selectedAnnotation.coordinate, radius: 40000.0, identifier: "TestRegion")
    self.locationManager.startMonitoringForRegion(geoRegion)
    self.dismissViewControllerAnimated(true, completion: nil)
    
     NSNotificationCenter.defaultCenter().postNotificationName("REMINDER_ADDED", object: self, userInfo: ["region" : geoRegion])

  }
  
    override func viewDidLoad() {
        super.viewDidLoad() 

//      
//      let regionSet = self.locationManager.monitoredRegions
//      let regions = regionSet.allObjects
//      println(regions.count)
      
        // Do any additional setup after loading the view.
    }
}

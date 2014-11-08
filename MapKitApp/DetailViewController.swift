//
//  DetailViewController.swift
//  MapKitApp
//
//  Created by Kori Kolodziejczak on 11/5/14.
//  Copyright (c) 2014 Kori Kolodziejczak. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
  
  var managedObjectContext: NSManagedObjectContext!
  var fetchedResultsController: NSFetchedResultsController!
  let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
  
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()

  }
  
  func didGetCloudChanges( notification : NSNotification){
    self.managedObjectContext.mergeChangesFromContextDidSaveNotification(notification)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.tableView.delegate = self
    self.tableView.dataSource = self
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "didGetCloudChanges:", name: NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: appDelegate.persistentStoreCoordinator)
    
    self.managedObjectContext  = appDelegate.managedObjectContext
    
    let fetchRequest = NSFetchRequest(entityName: "Reminder")
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    
    self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Reminders")
      self.fetchedResultsController.delegate = self

    var error : NSError?

    if !self.fetchedResultsController.performFetch(&error) {
      println("error: \(error)")
    }
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.fetchedResultsController.fetchedObjects?.count ?? 0
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("CELL", forIndexPath: indexPath) as UITableViewCell
    cell.textLabel.text = self.fetchedResultsController.fetchedObjects?[indexPath.row].name!
    return cell
  }
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
      let context = self.fetchedResultsController.managedObjectContext
      context.deleteObject(self.fetchedResultsController.objectAtIndexPath(indexPath) as NSManagedObject)
      
      var error: NSError? = nil
      if !context.save(&error) {
        println(error)
      }
    }
  }
  
  func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
    switch type {
    case .Delete:
      tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
    default:
      return
    }
  }


  func controllerDidChangeContent(controller: NSFetchedResultsController) {
    self.tableView.reloadData()
  }

}

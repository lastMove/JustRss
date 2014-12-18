//
//  FirstViewController.swift
//  JustRss
//
//  Created by jason akakpo on 16/12/2014.
//  Copyright (c) 2014 More Than That. All rights reserved.
//

import CoreData
import UIKit

class FeedsManagerViewController: UITableViewController,NSFetchedResultsControllerDelegate {

    @IBAction func AddFeed(sender: UIButton)
    {
        var alertController = UIAlertController(title: "Ajouter", message: "Ajouter un flux", preferredStyle: .Alert)
        
       let cancelAction = UIAlertAction(title: "Annuler", style: .Default, handler: nil)
        presentViewController(alertController, animated: true, completion: nil)
        alertController.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Nom"
        });
        
        alertController.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Lien"
        });
        
        
        let okHandler: ((UIAlertAction!) -> Void)! = { action in
            println("other was tapped")
            let nameTF = alertController.textFields![0] as UITextField
            let linkTF = alertController.textFields![1] as UITextField
            var newFeed = DataManager.sharedInstance.getNewFeed();
            newFeed.name = nameTF.text;
            newFeed.link = linkTF.text;
            //DataManager.sharedInstance.getDatas();

        }
        let okAction = UIAlertAction(title: "OK", style: .Default, handler:okHandler);
        alertController.addAction(okAction);
        alertController.addAction(cancelAction)

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // DataManager.sharedInstance.getDatas();

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return self.fetchedResultsController.sections?.count ?? 1
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let context = self.fetchedResultsController.managedObjectContext
            context.deleteObject(self.fetchedResultsController.objectAtIndexPath(indexPath) as NSManagedObject)
            
            var error: NSError? = nil
            if !context.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                //println("Unresolved error \(error), \(error.userInfo)")
                abort()
            }
        }
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as Feeds
        cell.textLabel!.text = object.name;
        cell.detailTextLabel!.text = object.link;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FeedsCell", forIndexPath: indexPath) as UITableViewCell
        
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    
    // MARK: - FETCHED RESUTS CONTROLLER
    
    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest();
        
        fetchRequest.entity = DataManager.sharedInstance.getFeedDescription();
        fetchRequest.fetchBatchSize = 20;
        
        let sortDescriptor = NSSortDescriptor(key: "orderId", ascending: true)
        let sortDescriptors = [sortDescriptor]
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataManager.sharedInstance.moc!, sectionNameKeyPath: nil, cacheName: "FeedsManagerViewController")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        var error: NSError? = nil
        if !_fetchedResultsController!.performFetch(&error) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //println("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController? = nil
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Left)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        case .Update:
            self.configureCell(tableView.cellForRowAtIndexPath(indexPath)!, atIndexPath: indexPath)
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
        default:
            return
        }
    }
    // MARK - ACtions
    /*
    @IBAction func newPossibility(sender: AnyObject)
    {
        UIAlertWrapper.presentAlert(title: "Nouvelle possibilité",
            message: "Entrez le nom de la possibilité",
            withTextField:true,
            cancelButtonTitle: "Annuler",
            otherButtonTitles: ["OK"])
            { (buttonIndex, text) -> () in
                var possibility = DataManager.sharedInstance.addPossibilityIfNew(text!)
        }
        
    }
    @IBAction func doneTapped(sender: AnyObject) {
        var tv = self.tableView as UITableView;
        
        if ((tv.indexPathsForSelectedRows()) != nil)
        {
            for selectedIP in tv.indexPathsForSelectedRows()!
            {
                var poss = self.fetchedResultsController.objectAtIndexPath(selectedIP as NSIndexPath) as Possibilities;
                decision?.addPossibiliy(poss);
            }
            DataManager.sharedInstance.saveContext();
        }
        self.performSegueWithIdentifier("next", sender: nil);
        
    }*/
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }


}


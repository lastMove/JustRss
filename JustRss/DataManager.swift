//
//  DataManager.swift
//  ChachaDrawing
//
//  Created by jason akakpo on 09/12/2014.
//  Copyright (c) 2014 jason akakpo. All rights reserved.
//

import Foundation
import CoreData

let _SingletonSharedInstance = DataManager()


class DataManager  {
    
    var moc:NSManagedObjectContext? = nil;
    var mom:NSManagedObjectModel? = nil;
    var psc:NSPersistentStoreCoordinator? = nil;
    var maxOrderId = 0;
    
    //  MARK: - INITIALIZATION
    init()
    {
        initAll();
    }
    
    class var sharedInstance : DataManager {
        return _SingletonSharedInstance
    }
    
    func saveContext() -> Bool
    {
        var error: NSError?;
        self.moc?.save(&error);
        return error == nil;
    }
    
    func applicationDocumentsDirectory() -> NSURL
    {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains:.UserDomainMask) as Array<NSURL>;
        return urls.last!;
    }
    
    func initAll()
    {
        if (mom == nil)
        {
            let modelURL = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd");
            mom = NSManagedObjectModel(contentsOfURL: modelURL!);
        }
        if (psc == nil)
        {
            let storeURL = self.applicationDocumentsDirectory().URLByAppendingPathComponent("JC1.0.sqlite");
            var error: NSError?;
            
            psc = NSPersistentStoreCoordinator(managedObjectModel: mom!);
            if ((psc!.addPersistentStoreWithType(NSSQLiteStoreType , configuration: nil, URL: storeURL, options: nil, error: &error)) == nil)
            {
                NSLog("Unresolved error %@, %@", error!, error!.userInfo!);
                abort();
                
            }
        }
        if (moc == nil)
        {
            moc = NSManagedObjectContext();
            moc!.persistentStoreCoordinator = psc;
        }
    }
    
    
    // MARK: - GET NEW INSTANCE
    func getNewFeed() -> Feeds
    {
        return  NSEntityDescription.insertNewObjectForEntityForName("Feeds", inManagedObjectContext: moc!) as Feeds;
    }
    func getFeedDescription() -> NSEntityDescription
    {
        return NSEntityDescription.entityForName("Feeds", inManagedObjectContext: moc!)!;
    }
    
    // MARK: - EDIT BDD FUNCtIONS
    
    /*func addParticipantIfNew(name:NSString) -> Participants
    {
    var obj = self.getFirstOccurenceForKey("name", value: name, entity: self.getParticipantsDescription());
    if (obj != nil)
    {
    return obj! as Participants
    }
    var newParticipant = getNewParticipants()
    newParticipant.name = name;
    self.saveContext()
    return newParticipant;
    }
    func addPossibilityIfNew(title:NSString) ->Possibilities
    {
    // SEARCH IN POSSIBILITy
    // IF NOT ADD AND RETURN
    // IF YES RETURN IT
    var obj = self.getFirstOccurenceForKey("title", value: title, entity: self.getPossibilitiesDescription());
    if (obj != nil)
    {
    return obj! as Possibilities
    }
    var newPossiibility = getNewPossibilities()
    newPossiibility.title = title;
    return newPossiibility;
    }
    
    func checkUniqueNessForKey(key:String, value:NSObject, entity:NSEntityDescription) -> Bool
    {
    return (self.countOcurencesForKey(key, value: value, entity: entity) == 0);
    }
    func getFirstOccurenceForKey(key:String, value:NSObject, entity:NSEntityDescription) -> NSManagedObject?
    {
    var fetch = NSFetchRequest();
    var error:NSError? = nil;
    fetch.entity = entity;
    fetch.sortDescriptors = [NSSortDescriptor(key: key, ascending:true) ];
    fetch.predicate = NSPredicate(format: "%K == %@", key, value);
    
    var array = self.moc?.executeFetchRequest(fetch, error:&error);
    if (error != nil)
    {
    NSLog("Unresolved error %@, %@", error!, error!.userInfo!);
    }
    return array!.first as? NSManagedObject;
    }
    func countOcurencesForKey(key:String, value:NSObject, entity:NSEntityDescription) -> Int
    {
    var fetch = NSFetchRequest();
    fetch.entity = entity;
    fetch.predicate = NSPredicate(format: "%K == %@", key, value);
    var array = self.moc?.executeFetchRequest(fetch, error: nil);
    return array!.count;
    }
    */
    
}

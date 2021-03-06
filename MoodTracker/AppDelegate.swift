//
//  AppDelegate.swift
//  MoodTracker
//
//  Created by Frank Novello on 10/30/20.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var moodValues:[Double] = []
    var coreDataMoodValues:[NSManagedObject] = []
    
    var moods:[Mood] = []
    var calander: Calendar = Calendar.current
   
    
    
    var manageContext: NSManagedObjectContext {
        return persistentContainer.viewContext
     }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        
       
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MoodValueEntity")
        
        do{
            coreDataMoodValues = try manageContext.fetch(fetchRequest)
            //print(coreDataMoodValues[1].value(forKey: "moodValue"))
            
//            for moodvalue in coreDataMoodValues
//            {
//                self.moodValues.append(moodvalue.value(forKey: "moodValue") as! Double)
//
//            }
            
            for mood in coreDataMoodValues
            {
                if mood.value(forKey: "moodDate") == nil
                {
                    mood.setValue(Date(), forKey: "moodDate")
                }
                
                let currentMood = Mood(submitMoodWithValue: mood.value(forKey: "moodValue") as! Double, moodDate: mood.value(forKey: "moodDate") as! Date,coords: Mood.CoordinateValues(x: 50, y: 50))
                
            
                
//                if let unwrappedMoodNote = currentMood.moodNote {
//                    currentMood.moodNote = unwrappedMoodNote
//                    print("mood note")
//
//                }else { print("error")}
                
                //print(currentMood.moodNote)
                
                self.moods.append(currentMood)
                
                
                                
            }
            
//            for mood in moods
//            {
               // print("mood value: \(mood.moodValue)")
                //print("\(calander.component(.hour, from: mood.moodDate)):\(calander.component(.minute, from: mood.moodDate)):\(calander.component(.second, from: mood.moodDate))")
                
//            }
     
            
            //print("application launched\(moodValues)")
            
        }catch let error as NSError{
            print("could not fetch \(error)")
        }
        
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "MoodsModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }


}


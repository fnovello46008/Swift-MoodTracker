//
//  ViewController.swift
//  MoodTracker
//
//  Created by Frank Novello on 10/30/20.
//

import UIKit
import CoreMotion
import Charts

class ViewController: UIViewController {

    @IBOutlet var moodView: UIView!
    
    var orientationLast = UIInterfaceOrientation(rawValue: 0)!
    var motionManager: CMMotionManager?
    
    var backgroundColours = [UIColor()]
    var backgroundLoop = 0
    
    var selectedMood:String = "No mood selected";
    
    


//    backgroundColours = [UIColor(red: 175/255, green: 213/255, blue:170/255, alpha: 1),UIColor(red: 90/255, green: 110/255, blue: 175/255, alpha: 1)];
    
    override func viewDidAppear(_ animated: Bool) {
        //UIView.setAnimationsEnabled(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UIView.setAnimationsEnabled(true)
        // Do any additional setup after loading the view.
        
        backgroundColours = [UIColor(red: 149/255, green: 125/255, blue: 173/255, alpha: 1),UIColor(red: 90/255, green: 110/255, blue: 175/255, alpha: 1)]
         backgroundLoop = 0
         self.animateBackgroundColour()
        
        self.initializeMotionManager()
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        motionManager = nil
        
        if segue.identifier == "Graph Segue" {
            //let vc = segue.destination as! GraphViewController
            
//            vc.amounts = amounts
//            vc.names = names
//            vc.categories = categories
//
//            vc.transactions = transactions
//            vc.categoriesAndAmounts = categoriesAndAmounts
//            vc.modalPresentationStyle = .fullScreen
            
            //vc.mood = selectedMood
            
        }
        
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    
    @IBAction func ExcitedButton(_ sender: Any) {
        backgroundColours = [UIColor(red: 246/255, green: 168/255, blue:166/255, alpha: 1),
                             UIColor(red: 149/255, green: 125/255, blue: 173/255, alpha: 1)];
        
        selectedMood = "Excited"
            
    }
    
    @IBAction func HappyButton(_ sender: Any) {
        backgroundColours = [UIColor(red: 249/255, green: 240/255, blue:193/255, alpha: 1),
                             UIColor(red: 149/255, green: 125/255, blue: 173/255, alpha: 1)];
        selectedMood = "Happy"
    }
    
    @IBAction func ContentButton(_ sender: Any) {
        backgroundColours = [UIColor(red: 192/255, green: 236/255, blue:204/255, alpha: 1),
                             UIColor(red: 149/255, green: 125/255, blue: 173/255, alpha: 1)];
        
        selectedMood = "Content"
    }
    
    @IBAction func SadButton(_ sender: Any) {
        backgroundColours = [UIColor(red: 112/255, green: 161/255, blue:215/255, alpha: 1),
                             UIColor(red: 149/255, green: 125/255, blue: 173/255, alpha: 1)];
        
        selectedMood = "Sad"
    }
    
    @IBAction func DepressedButton(_ sender: Any) {
        backgroundColours = [UIColor(red: 67/255, green: 70/255, blue:109/255, alpha: 1),
                             UIColor(red: 149/255, green: 125/255, blue: 173/255, alpha: 1)];
        
        selectedMood = "Depressed"
    }
    @IBAction func AngryButton(_ sender: Any) {
        backgroundColours = [UIColor(red: 220/255, green: 69/255, blue:61/255, alpha: 1),
                             UIColor(red: 149/255, green: 125/255, blue: 173/255, alpha: 1)];
        
        selectedMood = "Angry"
    }
    
    
    
    func animateBackgroundColour () {
        if backgroundLoop < backgroundColours.count - 1 {
            backgroundLoop+=1
        } else {
            backgroundLoop = 0
        }
        if(backgroundColours.count > 0)
        {
            UIView.animate(withDuration: 2, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: { () -> Void in
                    self.view.backgroundColor =  self.backgroundColours[self.backgroundLoop];
                }) {(Bool) -> Void in
                    self.animateBackgroundColour();
                }
        }

    }
    
    func initializeMotionManager() {
     motionManager = CMMotionManager()
     motionManager?.accelerometerUpdateInterval = 0.2
     motionManager?.gyroUpdateInterval = 0.2
     motionManager?.startAccelerometerUpdates(to: (OperationQueue.current)!, withHandler: {
        (accelerometerData, error) -> Void in
        if error == nil {
            self.outputAccelertionData((accelerometerData?.acceleration)!)
        }
        else {
            print("\(error!)")
        }
        })
     }
    
    func outputAccelertionData(_ acceleration: CMAcceleration) {
       var orientationNew: UIInterfaceOrientation
       if acceleration.x >= 0.75 {
           orientationNew = .landscapeLeft
         //UIView.setAnimationsEnabled(false)
           performSegue(withIdentifier: "Graph Segue", sender: nil)
           //print("landscapeLeft")
       }
       else if acceleration.x <= -0.75 {
           orientationNew = .landscapeRight
        //UIView.setAnimationsEnabled(false)
           performSegue(withIdentifier: "Graph Segue", sender: nil)
        // print("landscapeRight")
       }
       else if acceleration.y <= -0.75 {
           orientationNew = .portrait
        //print("portrait")

       }
       else if acceleration.y >= 0.75 {
           orientationNew = .portraitUpsideDown
        //print("portraitUpsideDown")
       }
       else {
           // Consider same as last time
           return
       }

       if orientationNew == orientationLast {
           return
       }
       orientationLast = orientationNew
   }


    
}







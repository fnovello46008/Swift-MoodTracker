//
//  ViewController.swift
//  MoodTracker
//
//  Created by Frank Novello on 10/30/20.
//

import UIKit
import CoreMotion
import Charts
import QuartzCore

class ViewController: UIViewController {


    
    var orientationLast = UIInterfaceOrientation(rawValue: 0)!
    var motionManager: CMMotionManager?
    
    var backgroundColours = [UIColor()]
    var backgroundLoop = 0
      
    var didSubmit = false
  
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    @IBOutlet weak var MoodBar: UIProgressView!
    @IBOutlet weak var MoodSlider: UISlider!
    
    

    
    override func viewDidAppear(_ animated: Bool) {
        
        didSubmit = false

    }
    
    override func viewDidLoad() {
     
        
        super.viewDidLoad()
        
        
        
        backgroundColours = [UIColor(red: 149/255, green: 125/255, blue: 173/255, alpha: 1),UIColor(red: 90/255, green: 110/255, blue: 175/255, alpha: 1)]
         backgroundLoop = 0
        
        
        MoodBar.transform = CGAffineTransform(rotationAngle: .pi * -0.5)
        
        MoodBar.transform = MoodBar.transform.scaledBy(x: 1, y: 50)
        
        self.animateBackgroundColour()
        self.initializeMotionManager()
        
    

    }
    
    
  
    @IBAction func ExcitedButton(_ sender: Any) {
        MoodBar.setProgress(1, animated: true)
        MoodSlider.setValue(1, animated: true)
        updateBackgroundColors(moodValue: 1)
        
    }
    
    @IBAction func HappyButton(_ sender: Any) {
        MoodBar.setProgress(0.75, animated: true)
        MoodSlider.setValue(0.75, animated: true)
        updateBackgroundColors(moodValue: 0.75)
    }
    
    @IBAction func ContentButton(_ sender: Any) {
        MoodBar.setProgress(0.5, animated: true)
        MoodSlider.setValue(0.5, animated: true)
        updateBackgroundColors(moodValue: 0.5)
    }
    
    @IBAction func SadButton(_ sender: Any) {
        MoodBar.setProgress(0.3, animated: true)
        MoodSlider.setValue(0.3, animated: true)
        updateBackgroundColors(moodValue: 0.3)
    }
    
    @IBAction func DepressedButton(_ sender: Any) {
        MoodBar.setProgress(0.125, animated: true)
        MoodSlider.setValue(0.125, animated: true)
        updateBackgroundColors(moodValue: 0.125)
    }
    
    
    
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {

         MoodBar.progress = sender.value
        
        
        
        if(sender.value <= 0)
        {
            MoodBar.progress = 0.01
        }
        
        updateBackgroundColors(moodValue: sender.value)
        print(sender.value)
    }
    
    func updateBackgroundColors(moodValue:Float)
    {
        
        //Excited
        if(moodValue > 0.9)
        {
            backgroundColours = [UIColor(red: 244/255, green: 124/255, blue: 124/255, alpha: 1),UIColor(red: 221/255, green: 125/255, blue: 125/255, alpha: 1)]
            MoodBar.tintColor = UIColor(red: 244/255, green: 124/255, blue: 124/255, alpha: 1)
        }
        //Happy
        if(moodValue < 0.9 && moodValue >= 0.7)
        {
            backgroundColours = [UIColor(red: 247/255, green: 244/255, blue: 139/255, alpha: 1),UIColor(red: 198/255, green: 195/255, blue: 111/255, alpha: 1)]
            MoodBar.tintColor = UIColor(red: 247/255, green: 244/255, blue: 139/255, alpha: 1)
        }
        //Content
        if(moodValue < 0.7 && moodValue >= 0.5)
        {
            backgroundColours = [UIColor(red: 161/255, green: 222/255, blue: 147/255, alpha: 1),UIColor(red: 129/255, green: 178/255, blue: 119/255, alpha: 1)]
            MoodBar.tintColor = UIColor(red: 161/255, green: 222/255, blue: 147/255, alpha: 1)
        }
        
        //Sad
        
        if(moodValue < 0.5 && moodValue >= 0.3)
        {
            backgroundColours = [UIColor(red: 112/255, green: 161/255, blue: 215/255, alpha: 1),UIColor(red: 115/255, green: 154/255, blue: 198/255, alpha: 1)]
            MoodBar.tintColor = UIColor(red: 112/255, green: 161/255, blue: 215/255, alpha: 1)
        }
        
        //Depressed
        
        if(moodValue < 0.3)
        {
            backgroundColours = [UIColor(red: 115/255, green: 154/255, blue: 198/255, alpha: 1),UIColor(red: 56/255, green: 81/255, blue: 108/255, alpha: 1)]
            MoodBar.tintColor = UIColor(red: 115/255, green: 154/255, blue: 198/255, alpha: 1)
        }
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        motionManager = nil
        
        if segue.identifier == "Graph Segue" && didSubmit == true {
            let vc = segue.destination as! LineChartViewController
            
//            vc.amounts = amounts
//            vc.names = names
//            vc.categories = categories
//
//            vc.transactions = transactions
//            vc.categoriesAndAmounts = categoriesAndAmounts
//            vc.modalPresentationStyle = .fullScreen
            
            
            vc.moodValues = self.appDelegate.moodValues
            
            print("moodes submitted \(self.appDelegate.moodValues)")
            
            
        }
        
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    
    @IBAction func SubmitMood(_ sender: Any) {
        
        let alert = UIAlertController(title: "Submit Mood?", message: "Are you sure this is how you feel?", preferredStyle: .alert)
        
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                //run your function here
                self.submitHandler()
            self.appDelegate.moodValues.append(Double(self.MoodSlider.value * 100))
            }))

        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        self.present(alert, animated: true)
        
        
        
    }
    
    func submitHandler()
    {
//        let alert = UIAlertController(title: "Mood Submitted", message: "Your mood has been submitted.. Rotate your phone to see your graph", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
//        self.present(alert, animated: true)
        
        didSubmit = true
      
    }
    
    func animateBackgroundColour () {
        

        if backgroundLoop < backgroundColours.count - 1 {
            backgroundLoop+=1
        } else {
            backgroundLoop = 0
        }
        if(backgroundColours.count > 0)
        {
            UIView.animate(withDuration: 0.9, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: { () -> Void in
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







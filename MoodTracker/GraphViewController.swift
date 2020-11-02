////
////  GraphViewController.swift
////  MoodTracker
////
////  Created by Frank Novello on 10/31/20.
////
//
//import UIKit
//import CoreMotion
//
//class GraphViewController: UIViewController {
//    
//    var orientationLast = UIInterfaceOrientation(rawValue: 0)!
//    var motionManager: CMMotionManager?
//    
//    var mood:String = "";
//
//    
//    override func viewDidAppear(_ animated: Bool) {
//        UIView.setAnimationsEnabled(true)
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.initializeMotionManager()
//        
//        print(mood)
//      
//    }
//    
//    
//    
//    func initializeMotionManager() {
//     motionManager = CMMotionManager()
//     motionManager?.accelerometerUpdateInterval = 0.2
//     motionManager?.gyroUpdateInterval = 0.2
//     motionManager?.startAccelerometerUpdates(to: (OperationQueue.current)!, withHandler: {
//        (accelerometerData, error) -> Void in
//        if error == nil {
//            self.outputAccelertionData((accelerometerData?.acceleration)!)
//        }
//        else {
//            print("\(error!)")
//        }
//        })
//     }
//    
//    func outputAccelertionData(_ acceleration: CMAcceleration) {
//       var orientationNew: UIInterfaceOrientation
//       if acceleration.x >= 0.75 {
//           orientationNew = .landscapeLeft
//
//        //print("landscapeLeft")
//       }
//       else if acceleration.x <= -0.75 {
//           orientationNew = .landscapeRight
//        //print("landscapeRight")
//       }
//       else if acceleration.y <= -0.75 {
//           orientationNew = .portrait
//       // performSegue(withIdentifier: "Mood Seque", sender: nil)
//        //print("portrait")
//            UIView.setAnimationsEnabled(false)
//            performSegue(withIdentifier: "Mood Segue", sender: nil)
//
//       }
//       else if acceleration.y >= 0.75 {
//           orientationNew = .portraitUpsideDown
//        //performSegue(withIdentifier: "Mood Seque", sender: nil)
//        //print("portraitUpsideDown")
//            UIView.setAnimationsEnabled(false)
//            performSegue(withIdentifier: "Mood Segue", sender: nil)
//       }
//       else {
//           // Consider same as last time
//           return
//       }
//
//       if orientationNew == orientationLast {
//           return
//       }
//       orientationLast = orientationNew
//   }
//
//    
//    
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return .landscape
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        motionManager = nil
//
//        if segue.identifier == "Mood Segue" {
//            
//            
////            vc.amounts = amounts
////            vc.names = names
////            vc.categories = categories
////
////            vc.transactions = transactions
////            vc.categoriesAndAmounts = categoriesAndAmounts
////            vc.modalPresentationStyle = .fullScreen
//            
//            
//            let vc = segue.destination as! ViewController
//            vc.selectedMood = mood
//            
//        }
//        
//    }
//
//}

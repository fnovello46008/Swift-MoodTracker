//
//  ViewController.swift
//  MoodTracker
//
//  Created by Frank Novello on 10/30/20.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func ExcitedButton(_ sender: Any) {
        backgroundColours = [UIColor(red: 246/255, green: 168/255, blue:166/255, alpha: 1),
                             UIColor(red: 149/255, green: 125/255, blue: 173/255, alpha: 1)];
            
    }
    
    @IBAction func HappyButton(_ sender: Any) {
        backgroundColours = [UIColor(red: 249/255, green: 240/255, blue:193/255, alpha: 1),
                             UIColor(red: 149/255, green: 125/255, blue: 173/255, alpha: 1)];
    }
    
    @IBAction func ContentButton(_ sender: Any) {
        backgroundColours = [UIColor(red: 192/255, green: 236/255, blue:204/255, alpha: 1),
                             UIColor(red: 149/255, green: 125/255, blue: 173/255, alpha: 1)];
    }
    
    @IBAction func SadButton(_ sender: Any) {
        backgroundColours = [UIColor(red: 112/255, green: 161/255, blue:215/255, alpha: 1),
                             UIColor(red: 149/255, green: 125/255, blue: 173/255, alpha: 1)];
    }
    
    @IBAction func DepressedButton(_ sender: Any) {
        backgroundColours = [UIColor(red: 67/255, green: 70/255, blue:109/255, alpha: 1),
                             UIColor(red: 149/255, green: 125/255, blue: 173/255, alpha: 1)];
    }
    @IBAction func AngryButton(_ sender: Any) {
        backgroundColours = [UIColor(red: 220/255, green: 69/255, blue:61/255, alpha: 1),
                             UIColor(red: 149/255, green: 125/255, blue: 173/255, alpha: 1)];
    }
    
    
    
    
    @IBOutlet var moodView: UIView!
    
    var backgroundColours = [UIColor()]
    var backgroundLoop = 0
    
    


//    backgroundColours = [UIColor(red: 175/255, green: 213/255, blue:170/255, alpha: 1),UIColor(red: 90/255, green: 110/255, blue: 175/255, alpha: 1)];
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        backgroundColours = [UIColor(red: 149/255, green: 125/255, blue: 173/255, alpha: 1),UIColor(red: 90/255, green: 110/255, blue: 175/255, alpha: 1)]
         backgroundLoop = 0
         self.animateBackgroundColour()
        
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
    

}


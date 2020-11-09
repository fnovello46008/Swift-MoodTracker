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
import CoreData

class ViewController: UIViewController,ChartViewDelegate {


    
    var orientationLast = UIInterfaceOrientation(rawValue: 0)!
    var motionManager: CMMotionManager?
    
    var backgroundColours = [UIColor()]
    var backgroundLoop = 0
    
  
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var selectedMood:Mood?
    
    @IBOutlet weak var MoodBar: UIProgressView!
    @IBOutlet weak var MoodSlider: UISlider!
    
    @IBOutlet weak var chartView: LineChartView!
    
    @IBOutlet weak var moodValueLabel: UILabel!
    
    @IBOutlet weak var NoteView: UITextView!
    
    @IBOutlet weak var AddNoteViewButton: UIButton!
    @IBOutlet weak var ClearSubmitButton: UIButton!
    
    //CORE DATA
    var coreDataMoodValues:[NSManagedObject] = []
    
    struct MoodCoordsValues {
        var x = 0.0
        var y = 0.0
    }
    
    var moodCoordsValues = MoodCoordsValues(x: 0, y: 0)
    
    
    var context: NSManagedObjectContext{
        return appDelegate.persistentContainer.viewContext
     }
//
//    func save(moodValue: Double)
//    {
//        guard let appDelegate = UIApplication.shared.delegate
//                as? AppDelegate else {return}
//
//        let manageContext = appDelegate.persistentContainer.viewContext
//
//        let entity = NSEntityDescription.entity(forEntityName: "MoodValueEntity", in: manageContext)!
//
//        let coreMoodValue = NSManagedObject(entity: entity, insertInto: manageContext)
//
//        coreMoodValue.setValue(moodValue, forKey: "moodValue")
//
//        do {
//            try manageContext.save()
//            coreDataMoodValues.append(coreMoodValue)
//
//            //print("MoodValues\(coreDataMoodValues)")
//        }catch let error as NSError{
//            print("could not save to core data\(error)")
//        }
//
//    }
//
    
//    func saveMood(mood: Mood)
//    {
//
//
//        guard let appDelegate = UIApplication.shared.delegate
//                as? AppDelegate else {return}
//
//        let manageContext = appDelegate.persistentContainer.viewContext
//
//        let entity = NSEntityDescription.entity(forEntityName: "MoodValueEntity", in: manageContext)!
//
//        var coreDataMood = NSManagedObject(entity: entity, insertInto: manageContext)
//
//         let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MoodValueEntity")
//            fetchRequest.predicate = NSPredicate(format: "moodId = %@", String(mood.moodId))
//
//         let results = try? manageContext.fetch(fetchRequest)
//
//         if results?.count == 0 {
//            // here you are inserting
//            //user = Users(context: context)
//
//            coreDataMood.setValue(mood.moodValue,      forKey: "moodValue")
//            coreDataMood.setValue(mood.moodDate, forKey: "moodDate")
//            coreDataMood.setValue(mood.moodId, forKey: "moodId")
//            coreDataMood.setValue(mood.moodNote, forKey: "moodNote")
//
//            print("hello")
//
//
//         } else {
//            // here you are updating
//            //user = results?.first
//
//            print("resutls\(results)" )
//
//            print("hello")
//         }
//
//
//
//        do {
//            try manageContext.save()
//            coreDataMoodValues.append(coreDataMood)
//
//            //print("MoodValues\(coreDataMoodValues)")
//        }catch let error as NSError{
//            print("could not save to core data\(error)")
//        }
//
//
//
//    }
    
    
    func saveMood(mood: Mood)
    {


        guard let appDelegate = UIApplication.shared.delegate
                as? AppDelegate else {return}

        let manageContext = appDelegate.persistentContainer.viewContext

        let entity = NSEntityDescription.entity(forEntityName: "MoodValueEntity", in: manageContext)!

        let coreDataMood = NSManagedObject(entity: entity, insertInto: manageContext)

        coreDataMood.setValue(mood.moodValue,      forKey: "moodValue")
        coreDataMood.setValue(mood.moodDate, forKey: "moodDate")
        coreDataMood.setValue(mood.moodId, forKey: "moodId")
        coreDataMood.setValue(mood.moodNote, forKey: "moodNote")




        do {
            try manageContext.save()
            coreDataMoodValues.append(coreDataMood)

            //print("MoodValues\(coreDataMoodValues)")
        }catch let error as NSError{
            print("could not save to core data\(error)")
        }



    }
    

    
    func deleteAllData(entity:String)
    {
        
        let context = appDelegate.persistentContainer.viewContext

        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try context.execute(deleteRequest)
            try context.save()
            print("deleted data")
        } catch {
            print ("There was an error")
        }
        
    }
    
    


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        

    }
    
    override func viewDidLoad() {
     
        
        super.viewDidLoad()
        self.chartView.delegate = self
        
       // self.deleteAllData(entity: "MoodValueEntity")
        
        //print(self.appDelegate.moodValues)
        
        
        
        backgroundColours = [UIColor(red: 149/255, green: 125/255, blue: 173/255, alpha: 1),UIColor(red: 90/255, green: 110/255, blue: 175/255, alpha: 1)]
         backgroundLoop = 0
        
        
        //MoodBar.transform = CGAffineTransform(rotationAngle: .pi * -0.5)
        
        //MoodBar.transform = MoodBar.transform.scaledBy(x: 1, y: 50)
        
        self.animateBackgroundColour()
        self.initializeMotionManager()
        
        updateGraph()
        
        //Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.updateGraph), userInfo: nil, repeats: true)
        
        
        self.moodValueLabel.text = String(self.MoodSlider.value * 10)
        
        
        self.NoteView.isHidden = true
        self.AddNoteViewButton.isHidden = true
        
        let tapBackgroundView: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        //let tapChartView: UITapGestureRecognizer = UITapGestureRecognizer(target: chartView, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tapBackgroundView)
       // chartView.addGestureRecognizer(tapChartView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        ClearSubmitButton.setTitle("Clear", for: .normal)
        
        
        //NoteView.layer.cornerRadius = NoteView.frame.size.height/2
        NoteView.clipsToBounds = true
        NoteView.layer.shadowOpacity=0.4
        NoteView.layer.shadowOffset = CGSize(width:3, height:3)

    }
    
    @objc func keyboardWillDisappear() {
        //Do something here
        
        ClearSubmitButton.setTitle("Clear", for: .normal)
    }
    
    @objc func keyboardWillAppear() {
        //Do something here
        
       // print("Keyboard appeared")
        
        ClearSubmitButton.setTitle("Submit", for: .normal)
        
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        
        self.NoteView.isHidden = true
        
    }
    
    

    
    
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        dismissKeyboard()
        for mood in appDelegate.moods
        {
            if(mood.coords.x == entry.x && mood.coords.y == entry.y)
            {
                //Chart Value selected
                self.selectedMood = mood
                self.AddNoteViewButton.isHidden = false
                
                //print(self.selectedMood?.moodNote)
                
                if let unwrappedNote = self.selectedMood?.moodNote {

                    self.AddNoteViewButton.setTitle("View Note", for: .normal)
                    self.selectedMood?.moodNote = unwrappedNote
                    self.NoteView.text = self.selectedMood?.moodNote
        

                }else { self.AddNoteViewButton.setTitle("Add Note", for: .normal)
                    
                    self.NoteView.text = ""
                }
          }
    
        }
        
    }
    
    
    @IBAction func AddNote(_ sender: Any) {
        self.NoteView.isHidden = false
        self.NoteView.becomeFirstResponder()
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
            
        self.AddNoteViewButton.isHidden = true
        dismissKeyboard()
            
    }
    
    
    
    
//    var i = 0
//    func updateCounter() {
//        self.chartView.data?.addEntry(ChartDataEntry, dataSetIndex: 0)
//        self.chartView.data?.addEntry(ChartDataEntry(value: reading_b[i], xIndex: i), dataSetIndex: 1)
//        self.chartView.data?.addXValue(String(i))
//        self.chartView.setVisibleXRange(minXRange: CGFloat(1), maxXRange: CGFloat(50))
//        self.chartView.notifyDataSetChanged()
//        self.chartView.moveViewToX(CGFloat(i))
//        i = i + 1
//    }
    
    @objc func updateGraph(){
        var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        //print("updating")
        
        //here is the for loop
        
        for i in 0..<appDelegate.moods.count {
            
            
            moodCoordsValues.x = (appDelegate.moods[i].moodDate.timeIntervalSince1970 * 1000).rounded()
            moodCoordsValues.y = appDelegate.moods[i].moodValue
            
            appDelegate.moods[i].setMood(AtCoordinate: moodCoordsValues.x, y: moodCoordsValues.y)
            
            
            let value = ChartDataEntry(x:moodCoordsValues.x, y: moodCoordsValues.y) // here we set the X and Y status in a data chart entry
            
            lineChartEntry.append(value) // here we add it to the data set
        }
        
//        if(appDelegate.moods.count > 0)
//        {
//            moodCoordsValues.x = (appDelegate.moods.last!.moodDate.timeIntervalSince1970 * 1000).rounded() + 100000
//            moodCoordsValues.y = appDelegate.moods.last!.moodValue
//
//
//            let lastValue = ChartDataEntry(x:moodCoordsValues.x, y: moodCoordsValues.y)
//            lineChartEntry.append(lastValue)
//
//            self.chartView.notifyDataSetChanged()
//            self.chartView.moveViewToX(moodCoordsValues.x)
//
//            print("update chart")
//
//        }
        
       // self.chartView.moveViewToX(appDelegate.moods.last!.coords.x+1000000)

        let line1 = LineChartDataSet(entries: lineChartEntry, label: "Number") //Here we convert lineChartEntry to a LineChartDataSet
        line1.colors = [NSUIColor.white] //Sets the colour to blue
        //line1.mode = .horizontalBezier
        //line1.colors = ChartColorTemplates.joyful()
        //line1.drawFilledEnabled = true
        //line1.fillColor = UIColor(red: 149/255, green: 125/255, blue: 173/255, alpha: 1)
        line1.fillAlpha = 0.5
        
        line1.highlightColor = UIColor.black
        
        let gradientColors = [
            UIColor.purple.cgColor,
            UIColor.blue.cgColor,
            UIColor.green.cgColor,
            UIColor.yellow.cgColor,
            UIColor.red.cgColor]
        as CFArray // Colors of the gradient
        
        
        let colorLocations:[CGFloat] = [0.0, 0.33, 0.5, 0.70,1] // Positioning of the gradient
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
        line1.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient
        line1.drawFilledEnabled = true // Draw the Gradient
        
        
        
        let data = LineChartData() //This is the object that will be added to the chart
        data.addDataSet(line1) //Adds the line to the dataSet
        
        data.setDrawValues(true)
        
        
    
        
        chartView.data = data //finally - it adds the chart data to the chart and causes an update
        chartView.chartDescription?.text = "My awesome chart" // Here we set the description for the graph
        
       // chtChart.backgroundColor = UIColor.red
        
        //chtChart.backgroundColor = UIColor(red: 90/255, green: 110/255, blue: 175/255, alpha: 0.5)
        chartView.leftAxis.axisMinimum = 0
        chartView.leftAxis.axisMaximum = 100
        
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.rightAxis.drawLabelsEnabled = false
        chartView.leftAxis.drawLabelsEnabled = true

        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.xAxis.drawLabelsEnabled = false

        chartView.leftAxis.drawAxisLineEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = false

        chartView.drawGridBackgroundEnabled = false
        
        chartView.rightAxis.drawGridLinesEnabled = false
        
        //chtChart.backgroundColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)

//          **********UPDATE IN REAL TIME*****************
        
//        let value = ChartDataEntry(x: (moods.last!.moodDate.timeIntervalSince1970 * 1000).rounded(), y: moods.last!.moodValue) // here we set the X and Y status in a data chart entry
//       var looplineChartEntry = [ChartDataEntry]()
//
//        looplineChartEntry.append(value)
//
//
//        chtChart.data?.addEntry(looplineChartEntry[0], dataSetIndex: 0)
    }
    
    
  
//    @IBAction func ExcitedButton(_ sender: Any) {
//        MoodBar.setProgress(1, animated: true)
//        MoodSlider.setValue(1, animated: true)
//        updateBackgroundColors(moodValue: 1)
//
//    }
//
//    @IBAction func HappyButton(_ sender: Any) {
//        MoodBar.setProgress(0.75, animated: true)
//        MoodSlider.setValue(0.75, animated: true)
//        updateBackgroundColors(moodValue: 0.75)
//    }
//
//    @IBAction func ContentButton(_ sender: Any) {
//        MoodBar.setProgress(0.5, animated: true)
//        MoodSlider.setValue(0.5, animated: true)
//        updateBackgroundColors(moodValue: 0.5)
//    }
//
//    @IBAction func SadButton(_ sender: Any) {
//        MoodBar.setProgress(0.3, animated: true)
//        MoodSlider.setValue(0.3, animated: true)
//        updateBackgroundColors(moodValue: 0.3)
//    }
//
//    @IBAction func DepressedButton(_ sender: Any) {
//        MoodBar.setProgress(0.125, animated: true)
//        MoodSlider.setValue(0.125, animated: true)
//        updateBackgroundColors(moodValue: 0.125)
//    }
    
    
    
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {

         //MoodBar.progress = sender.value
        
        
        if(sender.value <= 0)
        {
            //MoodBar.progress = 0.01
        }
        
        updateBackgroundColors(moodValue: sender.value)
        moodValueLabel.text = String(format: "%.01f", sender.value * 10)
        //print(sender.value)
    }
    
    func updateBackgroundColors(moodValue:Float)
    {
        
        //Excited
        if(moodValue > 0.9)
        {
            backgroundColours = [UIColor(red: 244/255, green: 124/255, blue: 124/255, alpha: 1),UIColor(red: 221/255, green: 125/255, blue: 125/255, alpha: 1)]
            //MoodBar.tintColor = UIColor(red: 244/255, green: 124/255, blue: 124/255, alpha: 1)
        }
        //Happy
        if(moodValue < 0.9 && moodValue >= 0.7)
        {
            backgroundColours = [UIColor(red: 247/255, green: 244/255, blue: 139/255, alpha: 1),UIColor(red: 198/255, green: 195/255, blue: 111/255, alpha: 1)]
            //MoodBar.tintColor = UIColor(red: 247/255, green: 244/255, blue: 139/255, alpha: 1)
        }
        //Content
        if(moodValue < 0.7 && moodValue >= 0.5)
        {
            backgroundColours = [UIColor(red: 161/255, green: 222/255, blue: 147/255, alpha: 1),UIColor(red: 129/255, green: 178/255, blue: 119/255, alpha: 1)]
            //MoodBar.tintColor = UIColor(red: 161/255, green: 222/255, blue: 147/255, alpha: 1)
        }
        
        //Sad
        
        if(moodValue < 0.5 && moodValue >= 0.3)
        {
            backgroundColours = [UIColor(red: 112/255, green: 161/255, blue: 215/255, alpha: 1),UIColor(red: 115/255, green: 154/255, blue: 198/255, alpha: 1)]
            //MoodBar.tintColor = UIColor(red: 112/255, green: 161/255, blue: 215/255, alpha: 1)
        }
        
        //Depressed
        
        if(moodValue < 0.3)
        {
            backgroundColours = [UIColor(red: 115/255, green: 154/255, blue: 198/255, alpha: 1),UIColor(red: 56/255, green: 81/255, blue: 108/255, alpha: 1)]
           // MoodBar.tintColor = UIColor(red: 115/255, green: 154/255, blue: 198/255, alpha: 1)
        }
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        motionManager = nil
        
        if segue.identifier == "Graph Segue"{
            let vc = segue.destination as! LineChartViewController

//            vc.amounts = amounts
//            vc.names = names
//            vc.categories = categories
//
//            vc.transactions = transactions
//            vc.categoriesAndAmounts = categoriesAndAmounts
//            vc.modalPresentationStyle = .fullScreen

           
            
            //vc.moodValues = self.appDelegate.moodValues
            vc.moods = self.appDelegate.moods
            //print("mood submitted \(self.appDelegate.moodValues)")


        }
        
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    
    @IBAction func ClearButton(_ sender: Any) {
        
        if(ClearSubmitButton.titleLabel!.text == "Clear")
        {
            let alert = UIAlertController(title: "Clear Data", message: "Are you sure you want to clear all Data?", preferredStyle: .alert)
            
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                    //run your function here
                
                    //self.appDelegate.moodValues = []
                    self.appDelegate.moods = []
                    self.deleteAllData(entity: "MoodValueEntity")
                    self.updateGraph()
                
                }))

            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

            self.present(alert, animated: true)
        }else {
            
            //SUBMITT NOTE
            
            dismissKeyboard()
            
            self.selectedMood?.moodNote = NoteView.text
            
            //saveMood(mood: selectedMood!)
            
            if let unwrappedNote = self.selectedMood?.moodNote
            {
                self.selectedMood?.moodNote = unwrappedNote
                
                self.AddNoteViewButton.setTitle("View Note", for: .normal)
            }

        }
                
        
    }
    
    func updateMood(mood:Mood)
    {
        //let user: Users!
        
       // print(mood.moodNote)
        
        saveMood(mood: mood)
        for mood in appDelegate.moods
        {
            
            if mood.moodNote != nil
            {
                print(mood.moodNote!)
        
            }
        }


//        let fetchUser = NSFetchRequest<NSManagedObject>(entityName: "MoodValueEntity")
//        fetchUser.predicate = NSPredicate(format: "moodId = %@", String(mood.moodId))
//
//        let results = try? context.fetch(fetchUser)
//
//        if results?.count == 0 {
//           // here you are inserting
//           //user = Users(context: context)
//            print("null")
//            saveMood(mood: mood)
//        } else {
//           // here you are updating
//           //user = results?.first
//
//            print(results)
//        }

    }
    
    @IBAction func SubmitMood(_ sender: Any) {
        
        let alert = UIAlertController(title: "Submit Mood?", message: "Are you sure this is how you feel?", preferredStyle: .alert)
        
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                //run your function here
            
                self.submitHandler()
        
            
            }))

        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        self.present(alert, animated: true)
        
        
        
    }
    
    func submitHandler()
    {
//        self.appDelegate.moodValues.append(Double(self.MoodSlider.value * 100))
//        self.save(moodValue: Double(self.MoodSlider.value * 100))
        
        //NEW
        self.appDelegate.moods.append(Mood(submitMoodWithValue: Double(self.MoodSlider.value * 100), moodDate: Date(),coords: Mood.CoordinateValues(x: 50, y: 50)))
        self.saveMood(mood: Mood(submitMoodWithValue: Double(self.MoodSlider.value * 100), moodDate: Date(),coords: Mood.CoordinateValues(x: 50, y: 50)))
        
        updateGraph()
        
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
           //performSegue(withIdentifier: "Graph Segue", sender: nil)
           //print("landscapeLeft")
       }
       else if acceleration.x <= -0.75 {
           orientationNew = .landscapeRight
        //UIView.setAnimationsEnabled(false)
           //performSegue(withIdentifier: "Graph Segue", sender: nil)
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







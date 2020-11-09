//          **********    NOTES       *****************
//          ********** UPDATE IN REAL TIME*****************


import UIKit
import Charts // You need this line to be able to use Charts Library
import CoreMotion

class LineChartViewController: UIViewController {


    @IBOutlet weak var chtChart: LineChartView!
    
    var orientationLast = UIInterfaceOrientation(rawValue: 0)!
    var motionManager: CMMotionManager?
    
    var numbers : [Double] = [10,10,200,150,15,30,50,45] //This is where we are going to store all the numbers. This can be a set of numbers that come from a Realm database, Core data, External API's or where ever else
    
    var moodValues: [Double] = []
    var moods:[Mood] = []
    
    var calender: Calendar = Calendar.current
    var seconds:TimeInterval = 1
    
    var timer = Timer()
    
    override func viewDidAppear(_ animated: Bool) {
        //UIView.setAnimationsEnabled(true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            self.initializeMotionManager()
     
        //OLD
       // numbers = moodValues
        
        //NEW
        //numbers = []
//        for i in 0..<moods.count
//        {
//            numbers.append(moods[i].moodValue)
//        }
        
        // Do any additional setup after loading the view, typically from a nib.
        updateGraph()
        //NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateCounting"), userInfo: nil, repeats: true)
        
        Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(self.updateGraph), userInfo: nil, repeats: true)
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func updateGraph(){
        var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        //print("updating")
        
        //here is the for loop
        for i in 0..<moods.count {
                        
            let value = ChartDataEntry(x: (moods[i].moodDate.timeIntervalSince1970 * 1000).rounded(), y: moods[i].moodValue) // here we set the X and Y status in a data chart entry
            lineChartEntry.append(value) // here we add it to the data set
        }

        let line1 = LineChartDataSet(entries: lineChartEntry, label: "Number") //Here we convert lineChartEntry to a LineChartDataSet
        line1.colors = [NSUIColor.white] //Sets the colour to blue
        //line1.mode = .horizontalBezier
        //line1.colors = ChartColorTemplates.joyful()
        //line1.drawFilledEnabled = true
        //line1.fillColor = UIColor(red: 149/255, green: 125/255, blue: 173/255, alpha: 1)
        line1.fillAlpha = 0.5
        
        
        
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
        
        
    
        
        chtChart.data = data //finally - it adds the chart data to the chart and causes an update
        chtChart.chartDescription?.text = "My awesome chart" // Here we set the description for the graph
        
       // chtChart.backgroundColor = UIColor.red
        
        //chtChart.backgroundColor = UIColor(red: 90/255, green: 110/255, blue: 175/255, alpha: 0.5)
        chtChart.leftAxis.axisMinimum = 0
        chtChart.leftAxis.axisMaximum = 100
        
        chtChart.leftAxis.drawGridLinesEnabled = false
        chtChart.rightAxis.drawLabelsEnabled = false
        chtChart.leftAxis.drawLabelsEnabled = true

        chtChart.xAxis.drawGridLinesEnabled = false
        chtChart.xAxis.drawAxisLineEnabled = false
        chtChart.xAxis.drawLabelsEnabled = false

        chtChart.leftAxis.drawAxisLineEnabled = false
        chtChart.leftAxis.drawGridLinesEnabled = false

        chtChart.drawGridBackgroundEnabled = false
        
        chtChart.rightAxis.drawGridLinesEnabled = false
        
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
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
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
    
            //print("landscapeLeft")
           }
           else if acceleration.x <= -0.75 {
               orientationNew = .landscapeRight
            //print("landscapeRight")
           }
           else if acceleration.y <= -0.75 {
               orientationNew = .portrait
           // performSegue(withIdentifier: "Mood Seque", sender: nil)
            //print("portrait")q
                //UIView.setAnimationsEnabled(false)
                performSegue(withIdentifier: "Mood Segue", sender: nil)
    
           }
           else if acceleration.y >= 0.75 {
               orientationNew = .portraitUpsideDown
            //performSegue(withIdentifier: "Mood Seque", sender: nil)
            //print("portraitUpsideDown")
                //UIView.setAnimationsEnabled(false)
                performSegue(withIdentifier: "Mood Segue", sender: nil)
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

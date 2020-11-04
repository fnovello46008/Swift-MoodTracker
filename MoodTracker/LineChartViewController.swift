import UIKit
import Charts // You need this line to be able to use Charts Library
import CoreMotion

class LineChartViewController: UIViewController {


    @IBOutlet weak var chtChart: LineChartView!
    
    var orientationLast = UIInterfaceOrientation(rawValue: 0)!
    var motionManager: CMMotionManager?
    
    var numbers : [Double] = [10,10,200,150,15,30,50,45] //This is where we are going to store all the numbers. This can be a set of numbers that come from a Realm database, Core data, External API's or where ever else
    
    var moodValues: [Double] = []
    
    
    override func viewDidAppear(_ animated: Bool) {
        //UIView.setAnimationsEnabled(true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            self.initializeMotionManager()
     
        numbers = moodValues
        
        // Do any additional setup after loading the view, typically from a nib.
        updateGraph()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateGraph(){
        var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        
        
        //here is the for loop
        for i in 0..<numbers.count {

            let value = ChartDataEntry(x: Double(i), y: numbers[i]) // here we set the X and Y status in a data chart entry
            lineChartEntry.append(value) // here we add it to the data set
        }

        let line1 = LineChartDataSet(entries: lineChartEntry, label: "Number") //Here we convert lineChartEntry to a LineChartDataSet
        line1.colors = [NSUIColor.blue] //Sets the colour to blue

        let data = LineChartData() //This is the object that will be added to the chart
        data.addDataSet(line1) //Adds the line to the dataSet
        

        chtChart.data = data //finally - it adds the chart data to the chart and causes an update
        chtChart.chartDescription?.text = "My awesome chart" // Here we set the description for the graph
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

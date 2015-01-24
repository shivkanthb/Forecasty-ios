//
//  ViewController.swift
//  Forecasty
//
//  Created by shivkanth on 31/12/14.
//  Copyright (c) 2014 shivkanth. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var dewLabel: UILabel!
    
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var summaryLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        getForecast()
        
        
    }
    
    func getForecast()
    {
        let baseURL1 = NSURL(string: "http://api.zippopotam.us/us/76543")
        
        let urldata = NSData(contentsOfURL: baseURL1!, options: nil, error: nil)
        
        
        let parsedObject : NSDictionary = NSJSONSerialization.JSONObjectWithData(urldata!, options:nil, error:nil) as NSDictionary
        //println(parsedObject["places"]!)
        
        let placesArr : NSArray = parsedObject["places"] as NSArray
        let placesDict : NSDictionary = placesArr[0] as NSDictionary
        println(placesDict)
        
        var state = placesDict["state"]! as String
        var lat = placesDict["latitude"]! as String
        var long = placesDict["longitude"] as String
        var placeName = placesDict["place name"] as String
        
        println(state)
        println("\(lat),\(long)")
        println(placeName)
        var longitude = "-122.423"
        var latitude = "37.8267"
        
        //var latitude : Double = placesDict["latitude"]! as Double
        //var longitude : Double = placesDict["longitude"]! as Double
        
        let baseURL = NSURL(string: "https://api.forecast.io/forecast/679dabfb8a1db5a2d53599f4e10db597/\(lat),\(long)")
        
        //        let baseURL1 = NSURL(string: "https://represent.io/shivkanthb.json")
        //
        //        let urldata = NSData(contentsOfURL: baseURL!, options: nil, error: nil)
        //
        //
        //        let parsedObject : AnyObject? = NSJSONSerialization.JSONObjectWithData(urldata!, options:nil, error:nil)
        //        println(parsedObject!)
        
        let sharedSession : NSURLSession = NSURLSession.sharedSession()
        let downloadTask : NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(baseURL!, completionHandler: { (location: NSURL!, response: NSURLResponse!, error: NSError!) -> Void in
            
            if(error == nil)
            {
                let dataObj = NSData(contentsOfURL: location)
                
                let weatherDictionary : NSDictionary = NSJSONSerialization.JSONObjectWithData(dataObj!, options:nil, error:nil) as NSDictionary
                
                //println(weatherDictionary)
                
                var dictValues = current(weather: weatherDictionary)
                //println(dictValues.currtime!)
                
                
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tempLabel.text = "\(dictValues.currTemp)"  // if in closure we need to add the self keyword
                    
                    self.timeLabel.text = "\(dictValues.currtime!)"
                    self.humidityLabel.text = "\(dictValues.humidity)"
                    self.dewLabel.text = "\(dictValues.dew)"
                    self.summaryLabel.text = "\(dictValues.summary)"
                    self.iconView.image = dictValues.iconImg
                    self.locationLabel.text = "\(placeName), \(state)"
                })
            }
            else{
                println("OOPS")
            }
        })
        downloadTask.resume()
    }
    
    func refresh(sender: AnyObject)
    {
        self.tempLabel.text = "88"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


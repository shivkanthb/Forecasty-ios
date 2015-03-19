//
//  ViewController.swift
//  Forecasty
//
//  Created by shivkanth on 31/12/14.
//  Copyright (c) 2014 shivkanth. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate{

    let locationManager = CLLocationManager()
    var ZIPCODE = "";
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var dewLabel: UILabel!
    
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var summaryLabel: UILabel!
    
    @IBOutlet weak var zipSearchBar: UISearchBar!
    
    @IBOutlet weak var refreshButton: UIButton!
    
    @IBOutlet weak var refreshActivityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        refreshActivityIndicator.hidden = true;
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()

        
        
        
        //getForecast("76543")
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "hideKeyboard:")
        self.view.addGestureRecognizer(tapGesture)
        
    }
    
    func getForecast(zipc : String)
    {
        
        let baseURL1 = NSURL(string: "http://api.zippopotam.us/us/\(zipc)")
        
        let urldata = NSData(contentsOfURL: baseURL1!, options: nil, error: nil)
        
        if(urldata != nil)
        {
        ZIPCODE = zipc
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
                    //self.view.backgroundColor = UIColor(red: 245.0/255.0, green: 215.0/255.0, blue: 110.0/255.0, alpha: 1.0)
                    self.refreshActivityIndicator.stopAnimating()
                    self.refreshActivityIndicator.hidden = true
                    self.refreshButton.hidden = false
                })
            }
            else{
                println("OOPS")
                
            }
        })
        downloadTask.resume()
        } // if not nil
        else
        {
            print("error in zipcode")
            var alert = UIAlertController(title: "Alert", message: "The zipcode entered is not valid", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            //refresh()
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        //searchBar.color = UIColor.whiteColor()
        getForecast(searchBar.text)
        println(searchBar.text)
        searchBar.resignFirstResponder()
        searchBar.text = ""
    }
    
    func hideKeyboard(recognizer : UITapGestureRecognizer)
    {
        println("tapped")
        self.zipSearchBar.resignFirstResponder()
    }
    
    
    
    @IBAction func refresh() {
        refreshButton.hidden = true
        refreshActivityIndicator.hidden = false
        refreshActivityIndicator.startAnimating()
//        self.locationManager.requestWhenInUseAuthorization()
//        self.locationManager.startUpdatingLocation()
        getForecast(ZIPCODE)
    }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                println("Error: " + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as CLPlacemark
                self.displayLocationInfo(pm)
            } else {
                println("Error with the data.")
            }
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark) {
        
        self.locationManager.stopUpdatingLocation()
        println(placemark.locality)
        println(placemark.postalCode)
        println(placemark.administrativeArea)
        println(placemark.country)
        
        getForecast(placemark.postalCode)
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error: " + error.localizedDescription)
    }

    
    
    
}


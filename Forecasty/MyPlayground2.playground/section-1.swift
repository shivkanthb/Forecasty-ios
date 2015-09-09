// Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var longitude = "37.8267"
var latitude = "-122.423"

let baseURL = NSURL(string: "https://api.forecast.io/forecast/679dabfb8a1db5a2d53599f4e10db597/\(longitude),\(latitude)")

//let baseURL1 = NSURL(string: "https://represent.io/shivkanthb.json")

let urldata = NSData(contentsOfURL: baseURL!, options: nil, error: nil)


//let parsedObject : AnyObject? = NSJSONSerialization.JSONObjectWithData(urldata!, options:nil, error:nil)
//println(parsedObject!)

let sharedSession : NSURLSession = NSURLSession.sharedSession()
let downloadTask : NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(baseURL!, completionHandler: { (location: NSURL!, response: NSURLResponse!, error: NSError!) -> Void in
    
    })
downloadTask.resume()

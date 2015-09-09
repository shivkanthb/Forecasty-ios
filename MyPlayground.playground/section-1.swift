// Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var longitude = "37.8267"
var latitude = "-122.423"
let baseURL1 = NSURL(string: "https://represent.io/shivkanthb.json")

//let baseURL1 = NSURL(string: "http://unetapp.herokuapp.com/api/v1/users?user[handle]=jordan&user[token]=338978d97d78984830d3629f1838cde8")
let urldata1 = NSData(contentsOfURL: baseURL1!, options: nil, error: nil)

let parsedObject1 : NSDictionary = NSJSONSerialization.JSONObjectWithData(urldata1!, options:nil, error:nil) as! NSDictionary
if( parsedObject1["error"] == nil)
{
println(parsedObject1["city"])
}
else{
println("OOPS")
}

let date = NSDate(timeIntervalSince1970: 1415637900)



let baseURL = NSURL(string: "https://api.forecast.io/forecast/679dabfb8a1db5a2d53599f4e10db597/\(longitude),\(latitude)")

//let baseURL1 = NSURL(string: "https://represent.io/shivkanthb.json")

let urldata = NSData(contentsOfURL: baseURL!, options: nil, error: nil)


let parsedObject : AnyObject? = NSJSONSerialization.JSONObjectWithData(urldata!, options:nil, error:nil)
println(parsedObject!)

let sharedSession : NSURLSession = NSURLSession.sharedSession()
let downloadTask : NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(baseURL!, completionHandler: { (location: NSURL!, response: NSURLResponse!, error: NSError!) -> Void in
    
    if(error == nil)
    {
        let dataObj = NSData(contentsOfURL: location)
        
        let parsedObject : NSDictionary = NSJSONSerialization.JSONObjectWithData(dataObj!, options:nil, error:nil) as! NSDictionary
        println(parsedObject)
    }
})
downloadTask.resume()


//
//  CurrentWeather.swift
//  Forecasty
//
//  Created by shivkanth on 17/01/15.
//  Copyright (c) 2015 shivkanth. All rights reserved.
//

import Foundation
import UIKit   // needed for UIImage
struct current {
    
    var currTemp: Int
    var humidity: Double
    //var icon: String   // No longer need cos we got the UIImage by using the string obtained
    var dew: Double
    var summary: String
    var currtime: String?
    var iconImg : UIImage?
    init(weather : NSDictionary){
        
        let currWeather: NSDictionary = weather["currently"] as NSDictionary   // they have to be downcasted as swift wont know automatically as it reads from json
        
        
        var currentUnixTime = currWeather["time"] as Int
        currTemp = currWeather["temperature"] as Int
        humidity = currWeather["humidity"] as Double
        //icon = currWeather["icon"] as String
        dew = currWeather["dewPoint"] as Double
        summary = currWeather["summary"] as String
        
        currtime = convertTime(currentUnixTime)
        
        iconImg = getIcon(currWeather["icon"] as String)

    }
    
    func convertTime(unixTime : Int) -> String {
        let unixtime = NSTimeInterval(unixTime)  // important to convert this to NSTimeInterval type.
        var date1  = NSDate(timeIntervalSince1970: unixtime)
        var dateformatter = NSDateFormatter()
        dateformatter.timeStyle = .ShortStyle
        
        var modTime = dateformatter.stringFromDate(date1)
        return(modTime)
    }
    
    func getIcon(iconString : String) -> UIImage {
        
        var imageName : NSString
        
        if (iconString == "clear-day")
        {
            imageName = "clear-day"
        }
        else if(iconString == "clear-night"){
            imageName = "clear-night"
        }
        else if(iconString == "cloudy"){
            imageName = "cloudy"
        }
        else if(iconString == "cloudy-night"){
            imageName = "cloudy-night"
        }
        else if(iconString == "rain"){
            imageName = "rain"
        }
        else if(iconString == "snow"){
            imageName = "snow"
        }
        else if(iconString == "sleet"){
            imageName = "sleet"
        }else if(iconString == "wind"){
            imageName = "wind"
        }else if(iconString == "fog"){
            imageName = "fog"
        }
        else if(iconString == "partly-cloudy-day"){
            imageName = "partly-cloudy"
        }
        else{
            imageName = "default"
        }
    
        var icoImage = UIImage(named: imageName)
        return icoImage!
        
    }
}








/*
  YoutubeParser.swift
  Trackr

  Parses the ID of Youtube videos to get the
  audio stream URL.

  Created by Omar Dlhz on 5/31/16.
  Copyright © 2016 Omar De La Hoz. All rights reserved.
*/

import UIKit
import Alamofire

public extension NSURL {
    /**
     Parses a query string of an NSURL
     
     @return key value dictionary with each parameter as an array
     */
    func dictionaryForQueryString() -> [String: AnyObject]? {
        if let query = self.query {
            return query.dictionaryFromQueryStringComponents()
        }
        
        // Note: find youtube ID in m.youtube.com "https://m.youtube.com/#/watch?v=1hZ98an9wjo"
        let result = absoluteString.componentsSeparatedByString("?")
        if result.count > 1 {
            return result.last?.dictionaryFromQueryStringComponents()
        }
        return nil
    }
}


public extension NSString {
    /**
     Convenient method for decoding a html encoded string
     */
    func stringByDecodingURLFormat() -> String {
        let result = self.stringByReplacingOccurrencesOfString("+", withString:" ")
        return result.stringByRemovingPercentEncoding!
    }
    
    
    /**
     Parses a query string
     
     @return key value dictionary with each parameter as an array
     */
    func dictionaryFromQueryStringComponents() -> [String: AnyObject] {
        var parameters = [String: AnyObject]()
        for keyValue in componentsSeparatedByString("&") {
            let keyValueArray = keyValue.componentsSeparatedByString("=")
            if keyValueArray.count < 2 {
                continue
            }
            let key = keyValueArray[0].stringByDecodingURLFormat()
            let value = keyValueArray[1].stringByDecodingURLFormat()
            parameters[key] = value
        }
        return parameters
    }
}


public class YoutubeParser: NSObject{
    
    static let infoURL = "http://www.youtube.com/get_video_info?video_id="
    static var userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1229.79 Safari/537.4"
    static let YTKey = "AIzaSyD7FSFPxgIqpy-vEZ74FF89vNsjnRyzgw8"
    
    
    /**
     Asynchronously looks for the YoutubeID 
     of the top result of a query.
     
     @param keyword: String searched for in youtube API.
     
     @return none
     
    **/
    public static func searchTopResult(keyword: String, completionHandler: (videoID: String) -> ()){
        
        
        Alamofire.request(.GET, "https://www.googleapis.com/youtube/v3/search", parameters: ["part": "snippet", "q": keyword, "maxResults": 1 ,"format": 5, "key": YTKey]) .responseJSON { response in
            
            if let videoInfo = response.result.value{
                
                let data = videoInfo["items"] as! NSArray
                
                let idArray = data.valueForKeyPath("id.videoId") as! NSArray
                let videoID = idArray[0] as! String
                
                completionHandler(videoID: videoID)
                
            }
        }
    }
    
    
    
    /**
     Parses the audio link of a Youtube video by
     its ID.
     
     @param youtubeID: the ID of a Youtube video.
     
     return: An object of a videos components.
     
    **/
    public static func parseById(youtubeID: String) -> [String: AnyObject]? {
        
        let urlString = String(format: "%@%@", infoURL, youtubeID) as String
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.timeoutInterval = 5.0
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        request.HTTPMethod = "GET"
        var responseString = NSString()
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let group = dispatch_group_create()
        dispatch_group_enter(group)
        session.dataTaskWithRequest(request, completionHandler: { (data, response, _) -> Void in
            if let data = data as NSData? {
                
                responseString = NSString(data: data, encoding: NSUTF8StringEncoding)!
            }
            dispatch_group_leave(group)
        }).resume()
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER)
        let parts = responseString.dictionaryFromQueryStringComponents()
        if parts.count > 0 {
            
            var videoTitle: String = ""
            var streamImage: String = ""
            if let title = parts["title"] as? String {
                videoTitle = title
            }
            if let image = parts["iurl"] as? String {
                streamImage = image
            }
            
            
            if let fmtStreamMap = parts["url_encoded_fmt_stream_map"] as? String {
                
                // Live Stream
                if let _: AnyObject = parts["live_playback"]{
                    if let hlsvp = parts["hlsvp"] as? String {
                        return [
                            "url": "\(hlsvp)",
                            "title": "\(videoTitle)",
                            "image": "\(streamImage)",
                            "isStream": true
                        ]
                    }
                } else {
                    let fmtStreamMapArray = fmtStreamMap.componentsSeparatedByString(",")
                    for videoEncodedString in fmtStreamMapArray {
                        var videoComponents = videoEncodedString.dictionaryFromQueryStringComponents()
                        
                        videoComponents["title"] = videoTitle
                        videoComponents["isStream"] = false
                        return videoComponents as [String: AnyObject]
                    }
                }
            }
        }
        return nil
    }
    
    
}

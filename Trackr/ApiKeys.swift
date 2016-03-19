//
//  ApiKeys.swift
//  Trackr
//
//  Created by Omar Dlhz on 3/19/16.
//  Copyright © 2016 Omar De La Hoz. All rights reserved.
//

import Foundation

func valueForAPIKey(keyname keyname:String) -> String {
    // Credit to the original source for this technique at
    // http://blog.lazerwalker.com/blog/2014/05/14/handling-private-api-keys-in-open-source-ios-apps
    let filePath = NSBundle.mainBundle().pathForResource("ApiKeys", ofType:"plist")
    let plist = NSDictionary(contentsOfFile:filePath!)
    
    let value:String = plist?.objectForKey(keyname) as! String
    return value
}
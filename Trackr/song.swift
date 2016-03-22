//
//  song.swift
//  Trackr
//
//  Created by Omar Dlhz on 3/22/16.
//  Copyright © 2016 Omar De La Hoz. All rights reserved.
//

import Foundation

class Song {
    
    var name: String!
    var artist: String!
    var artwork: NSURL!
    var ytId: String!
    var adUrl: NSURL!
    
    init(name: String, artist: String, artwork: String){
        
        self.name = name
        self.artist = artist
        self.artwork = NSURL(string: artwork)
        self.ytId = nil
        self.adUrl = nil
        
    }
    
    init(name: String, artist: String, artwork:String, ytId: String, adUrl: String){
        
        self.name = name
        self.artist = artist
        self.artwork = NSURL(string: artwork)
        self.ytId = ytId
        self.adUrl = NSURL(string: adUrl)
        
    }
    
}
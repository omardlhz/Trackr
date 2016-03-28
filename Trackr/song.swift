/*
  song.swift
  Trackr
  
  Class for the Song object.

  name:String = Name of the song.
  artist: String = Name of the artist.
  artwork: NSRURL = URL of the song artwork.
  ytId: String = The Youtube ID of the song.
  adUrl:String = The URL of the song when downloaded (Optional).


  Created by Omar Dlhz on 3/22/16.
  Copyright © 2016 Omar De La Hoz. All rights reserved.
*/

import Foundation

class Song {
    
    var name: String!
    var artist: String!
    var artwork: String!
    var ytId: String!
    var adUrl: NSURL!
    var duration:Int!
    
    init(name: String, artist: String, artwork: String){
        
        self.name = name
        self.artist = artist
        self.artwork = artwork
        self.ytId = nil
        self.adUrl = nil
        self.duration = nil
    }
    
    init(name: String, artist: String, artwork:String, ytId: String, adUrl: String, duration:Int){
        
        self.name = name
        self.artist = artist
        self.artwork = artwork
        self.ytId = ytId
        self.adUrl = NSURL(string:adUrl)
        self.duration = duration
        
    }
    
    
    
}
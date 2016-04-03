//
//  album.swift
//  Trackr
//
//  Created by Omar Dlhz on 4/3/16.
//  Copyright © 2016 Omar De La Hoz. All rights reserved.
//

import Foundation

class Album{
    
    var albumId:Int!
    var name:String!
    var artist:String!
    var artwork:String!
    var songs:[Song]!
    
    
    init(albumId:Int!, name:String!, artist:String!, artwork:String!){
        
        self.albumId = albumId
        self.name = name
        self.artist = artist
        self.artwork = artwork
        self.songs = []
        
    }
    
    init(albumId:Int!, name:String!, artist:String!, artwork:String!, songs:[Song]!){
        
        self.albumId = albumId
        self.name = name
        self.artist = artist
        self.artwork = artwork
        self.songs = songs
        
    }
}

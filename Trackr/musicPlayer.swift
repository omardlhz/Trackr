/*
  musicPlayer.swift
  Trackr

  Singleton class music player for Trackr.

  Created by Omar Dlhz on 3/24/16.
  Copyright © 2016 Omar De La Hoz. All rights reserved.
*/

import Foundation
import AVFoundation
import Alamofire
import UIKit



class musicPlayer{
    
    private var mPlayer = AVPlayer()
    private var currentSong:Song!
    private var timer:NSTimer!
    
    
    class var sharedInstance: musicPlayer {
        
        struct Static{
            
            static var instance: musicPlayer?
            static var token: dispatch_once_t = 0
            
        }
        dispatch_once(&Static.token){
            Static.instance = musicPlayer()
        }
        
        return Static.instance!
        
        
        
    }
    
    
    func playSong(song: Song){
        
        if timer != nil{
            
            timer.invalidate()
            
        }
        
        currentSong = song
        
        
        if(song.adUrl == nil){
            
            retrieveURL(song) { (result) in
                
                if result.0 != nil{
                    
                    
                    self.mPlayer = AVPlayer(URL: result.0)
                    self.currentSong.duration = result.1
                    self.mPlayer.play()
                    let nc = NSNotificationCenter.defaultCenter()
                    nc.postNotificationName("songplaying", object: nil)
                    
                }
            }
            
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                print("AVAudioSession Category Playback OK")
                do {
                    try AVAudioSession.sharedInstance().setActive(true)
                    print("AVAudioSession is Active")
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "finishPlaying", userInfo: nil, repeats: true)
            
            
        }
        else{
            
            self.mPlayer = AVPlayer(URL: song.adUrl)
            self.mPlayer.play()
            
            
        }
    }
 
    
    /*
    Requests the streaming link of the song that is
    about to play.
    
    Returns a NSURL which is the stream url.
    */
    func retrieveURL(song: Song, completionHandler: (result: NSURL!, Int!) -> ()) -> (){
        
        let metadata = song.name + "%20" + song.artist + "%20audio"
        let searchArray = metadata.componentsSeparatedByString(" ")
        let fString:String! = searchArray.joinWithSeparator("%20")
        let url = "http://trackrapi.omardlhz.com/search?name=" + fString
        
        Alamofire.request(.GET, url) .responseJSON { response in
            
            if let resultJSON = response.result.value{
                
                let urlString = resultJSON["url"] as! String
                let url = NSURL(string: urlString)
                
                let duration = resultJSON["duration"] as! Int
                
                completionHandler(result: url, duration)
                
            }
        }
    }
    
    
    /*
    Gets the cover image of the song that is currently
    playing.
    
    Returns the NSURL of the cover image.
    */
    func getCoverImage(size:String) -> NSURL{
        
        let artworkUrl = currentSong.artwork
        
        if size == "small" {
            
            let smallUrl = artworkUrl.stringByReplacingOccurrencesOfString("100x100", withString: "50x50")
            
            return NSURL(string: smallUrl)!
            
        }
        else if size == "player"{
            
            let playerUrl = artworkUrl.stringByReplacingOccurrencesOfString("100x100", withString: "300x300")
            
            return NSURL(string: playerUrl)!
            
        }
        else{
            
           return NSURL(string: artworkUrl)!
            
        }
    }
    
    
    /*
    Returns the metadata (Name and artist) of the
    song that is currently playing.
    */
    func getMeta() -> (String, String) {
        
        return (currentSong.name, currentSong.artist)
        
    }
    
    func loadedSong() -> Bool{
        
        return mPlayer.currentItem != nil
        
    }
    
    func resumePlaying(){
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.postNotificationName("songplaying", object: nil)
        
        mPlayer.play()
    }
    
    func pausePlaying(){
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.postNotificationName("pauseplaying", object: nil)
        
        mPlayer.pause()
        
    }
    
    dynamic func finishPlaying(){
        
        
        if mPlayer.currentItem != nil{
            
            print("currentTime:",mPlayer.currentTime().seconds)
            print("duration:", self.currentSong.duration)
            
            if Int(self.mPlayer.currentTime().seconds) >= self.currentSong.duration{
                
                print("se acabo")
                
                mPlayer = AVPlayer()
                timer.invalidate()
                
            }
            
        }
        
    }
    
 
    
}
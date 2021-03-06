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
    private var currentTime:Double = 0
    private var songQueue:[Song] = []
    private var songPointer:Int = 0
    private var loopSong:Bool = false
    private var shuffle:Bool = false
    private var songsPlayed:[String] = []
    
    
    class var sharedInstance: musicPlayer {
        
        struct Static{
            
            static var instance: musicPlayer?
            static var token: dispatch_once_t = 0
            
        }
        dispatch_once(&Static.token){
            
            Static.instance = musicPlayer()
            
            
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                do {
                    try AVAudioSession.sharedInstance().setActive(true)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        return Static.instance!
    }
    
    func playSong(song: Song){
        
        if timer != nil{ timer.invalidate() }
        
        currentSong = song
        
        NSNotificationCenter.defaultCenter().postNotificationName("songUpdate", object: nil)
        
        if(song.adUrl == nil){
            
            let keyword = song.name + " " + song.artist + " audio"
            
            
            YoutubeParser.searchTopResult(keyword) { (videoID) in
                
                let info = YoutubeParser.parseById(videoID)
                let url = info!["url"] as! String
                print(url)
                self.mPlayer = AVPlayer(URL: NSURL(string: url)!)
                self.mPlayer.play()
                
            }
        }
        else{
            
            self.mPlayer = AVPlayer(URL: song.adUrl)
            self.mPlayer.play()
            
        }
        
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "timeChange", userInfo: nil, repeats: true)
        
    }
 
    
    /*
    Requests the streaming link of the song that is
    about to play.
    
    Returns a NSURL which is the stream url.
    */
    func retrieveURL(song: Song, completionHandler: (result: (link: NSURL!, duration: Int!)) -> ()) -> (){
        
        let metadata = song.name + " " + song.artist + " audio"
        
        Alamofire.request(.GET, "http://trackrapi.omardlhz.com/search", parameters: ["name": metadata]) .responseJSON { response in
            
            if let resultJSON = response.result.value{
                
                let urlString = resultJSON["url"] as! String
                let url = NSURL(string: urlString)
                let duration = resultJSON["duration"] as! Int
                
                completionHandler(result: (link: url, duration: duration))
                
            }
        }
    }
    
    
    /*
    Gets the cover image of the song that is currently
    playing.
    
    Returns the NSURL of the cover image.
    */
    func getCoverImage(song:Song, size:String) -> NSURL{
        
        let artworkUrl = song.artwork
        
        if size == "small" {
            
            let smallUrl = artworkUrl.stringByReplacingOccurrencesOfString("100x100", withString: "60x60")
            
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
    Triggered if a song is tapped.
    */
    func playNow(song:Song){
        
        if songQueue.count == 0{

            songQueue.append(song)
            
        }
        else{
            
            songPointer += 1;
            songQueue.insert(song, atIndex: songPointer)
            
        }
        
        playSong(song)
        
    }
    
    
    /*
    Returns the current song Data.
    */
    func getSong() -> Song {
        
        return currentSong
        
    }
    
    
    /*
    Checks if there is a song loaded in mPlayer.
    */
    func loadedSong() -> Bool{
        
        return mPlayer.currentItem != nil
        
    }
    
    
    /*
    Play a song after the one that is currently playing,
    if no song is in Queue, just play it.
    */
    func playNext(song: Song){
        
        if songQueue.count != 0{
            
            songQueue.insert(song, atIndex: songPointer + 1)
            
        }
        else{
            
            songQueue.append(song)
            playSong(song)
            
        }
    }
    
    
    /*
    Add a song to the end of the queue, if no song is
    in Queue, just play it.
    */
    func addQueue(song: Song){
        
        songQueue.append(song)
        
        if songQueue.count ==  0{
            
            playSong(song)
            
        }
    }
    
    /*
    Returns the current song queue.
    */
    func getQueue() -> [Song]{
        
        return songQueue
        
    }
    
    /*
    Adds songs of an album to the queue and
    plays it.
    */
    func albumToQueue(songs:[Song]){
        
        songPointer = songQueue.count
        songQueue.appendContentsOf(songs)
        playSong(songQueue[songPointer])
        
    }
    
    
    /*
    Plays song if it has been paused.
    Posts songplaying notification.
    */
    func resumePlaying(){
        
        NSNotificationCenter.defaultCenter().postNotificationName("songplaying", object: nil)
        
        mPlayer.play()
    }
    
    
    /*
    Pauses song.
    Posts pauseplaying notification.
    */
    func pausePlaying(){
        
        NSNotificationCenter.defaultCenter().postNotificationName("pauseplaying", object: nil)
        
        mPlayer.pause()
      
    }
    
    
    /*
    Plays the song before the current one if any.
    Triggered when the back button is tapped twice.
    */
    func backQueue(){
        
        if songPointer - 1 >= 0{
            
            songPointer -= 1;
            playSong(songQueue[songPointer])
        
        }
    
    }
    
    
    /*
    Replays the current song.
    Triggered when the back button is tapped once.
    */
    func replaySong(){
        
        mPlayer.seekToTime(kCMTimeZero)
        mPlayer.play()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "timeChange", userInfo: nil, repeats: true)
        
    }
    
    
    /*
    Triggered when next song button gets clicked.
    If there are no songs in queue, the playing session
    is stopped.
    */
    func forwardQueue(){
        
        if songPointer + 1 < songQueue.count && !shuffle{
            
            songPointer += 1;
            
            playSong(songQueue[songPointer])
            
        }
        else if shuffle{
            
            songPointer = shuffleSong()
            playSong(songQueue[songPointer])
            
        }
        else{
            
            replaySong()
            pausePlaying()
            
        }
    }
    
    
    /*
    Triggered when loop button is tapped.
    */
    func loopButton(){
        
        if loopSong == true {
            
            NSNotificationCenter.defaultCenter().postNotificationName("notReplaying", object: nil)
            
            loopSong = false
            
        }
        else{
            
            NSNotificationCenter.defaultCenter().postNotificationName("isReplaying", object: nil)
            
            loopSong = true
            
        }
    }
    
    
    /*
    Generates random integers between the range of the
    size of songQueue with the condition that the
    song at index random integer in songQueue
    hasnt played yet.
    
    return: a random integer.
    */
    func shuffleSong() -> Int {
        
        var randomNumber : Int
        repeat {
            randomNumber = Int(arc4random_uniform(UInt32(songQueue.count)))
        } while songsPlayed.contains(songQueue[randomNumber].name)
        
        songsPlayed.append(songQueue[randomNumber].name)
        
        return randomNumber
        
    }
    
    
    /*
    Changes the status of the song shuffling.
    Triggered when the shuffle button is pressed.
    */
    func shuffleButton(){
        
        if shuffle {
            
            shuffle = false
            NSNotificationCenter.defaultCenter().postNotificationName("notShuffle", object: nil)
            
        }
        else{
            
            shuffle = true
            NSNotificationCenter.defaultCenter().postNotificationName("isShuffle", object: nil)
            
        }
    }
    
    
    /*
    Updates the AVPlayers time when user moves
    the slider.
    */
    func seekToTime(progress:Double){
        
        let seconds = progress * Double(currentSong.duration)
        let newTime = CMTimeMakeWithSeconds(seconds, mPlayer.currentTime().timescale)
        mPlayer.seekToTime(newTime)
        
    }
    
    
    /*
    Returns the current song pointer.
    */
    func currentPointer() -> Int{
        
        return songPointer
    }
    
    
    /*
    Returns the player's currentTime and song
    duration.
    */
    func getPlayerTime() -> (current: Double, duration: Double){
        
        return (current: mPlayer.currentTime().seconds, duration: Double(currentSong.duration))
    }
    
    
    /*
    Posts notification when there is a change in time
    and when the song has ended.
    
    Triggered by NSTimer.
    */
    dynamic func timeChange(){
        
        if mPlayer.currentItem != nil && self.currentSong.duration != nil{
            
            if mPlayer.currentTime().seconds != currentTime{
                
                currentTime = mPlayer.currentTime().seconds
                NSNotificationCenter.defaultCenter().postNotificationName("changeInTime", object: nil)
            }
            
            if Int(self.mPlayer.currentTime().seconds) >= self.currentSong.duration{
                
                timer.invalidate()
                
                if !loopSong {
                    
                    forwardQueue()
                    
                }
                else{
                    
                    replaySong()
                    
                }
                
            }
        }
    }
    
}
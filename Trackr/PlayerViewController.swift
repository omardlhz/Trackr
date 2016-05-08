/*
  PlayerViewController.swift
  Trackr

  Created by Omar Dlhz on 3/26/16.
  Copyright © 2016 Omar De La Hoz. All rights reserved.
*/

import UIKit

class PlayerViewController: UIViewController {

    @IBAction func closeButton(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: {});
        
    }
    
    @IBOutlet weak var coverImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var artistLabel: UILabel!
        
    @IBOutlet weak var songSlider: UISlider!
    
    @IBAction func songSlider(sender: AnyObject) {
        
        musicPlayer.sharedInstance.seekToTime(Float64(songSlider.value))
        
    }
    
    
    
    @IBOutlet weak var playBackLabel: UILabel!
    
    @IBOutlet weak var remainTimeLabel: UILabel!
    
    @IBOutlet weak var replayButton: UIButton!
    
    @IBAction func replayButton(sender: AnyObject) {
        
        musicPlayer.sharedInstance.loopButton()
        
        
    }
    
    @IBOutlet weak var shuffleButton: UIButton!
    
    @IBAction func shuffleButton(sender: AnyObject) {
        
        musicPlayer.sharedInstance.shuffleButton()
        
    }
    
    
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBAction func playButton(sender: AnyObject) {
        
        if songPlaying == false{
            
            musicPlayer.sharedInstance.resumePlaying()
            
        }
        else{
            
            musicPlayer.sharedInstance.pausePlaying()
            
        }
        
    }
    
    
    @IBOutlet weak var backButton: UIButton!
    
    
    @IBAction func forwardButton(sender: AnyObject) {
        
        musicPlayer.sharedInstance.forwardQueue()
        
    }
    
    
    
    var songPlaying = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateView", name: "songUpdate", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "isPlaying", name: "songplaying", object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "isNotPlaying", name: "pauseplaying", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "notLooping", name: "notReplaying", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "isLooping", name: "isReplaying", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "isShuffle", name: "isShuffle", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "notShuffle", name: "notShuffle", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "timeChange", name: "changeInTime", object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "replaySong")
        tapGesture.numberOfTapsRequired = 1
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: "backSong")
        doubleTapGesture.numberOfTapsRequired = 2
        
        backButton.addGestureRecognizer(tapGesture)
        backButton.addGestureRecognizer(doubleTapGesture)
        
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        let statusBar = UIApplication.sharedApplication().valueForKey("statusBarWindow")?.valueForKey("statusBar") as? UIView
        
        statusBar!.backgroundColor = nil
        
        
    }
    
    
    /*
    Updates the variable songPlaying to true.
    Sets the image of the playButton to pauseButton.
    Gets triggered by songplaying notification.
    */
    func isPlaying(){
        
        songPlaying = true
        playButton.setImage(UIImage(named: "pauseButton"), forState: .Normal)
        
    }
    
    
    /*
    Updates the variable songPlaying to false.
    Sets the image of the playButton to playButton
    Gets triggered by pauseplaying notification.
    */
    func isNotPlaying(){
        
        songPlaying = false
        playButton.setImage(UIImage(named: "playButton"), forState: .Normal)
        
    }
    
    /*
    Sets the image of the replayButton to onReplay
    when replaying is activated.
    Gets triggered by isReplaying notification
    */
    func isLooping(){
        
        replayButton.setImage(UIImage(named: "onReplay"), forState: .Normal)
        
    }
    
    
    /*
    Sets the image of the replayButton to offReplay
    when replaying is deactivated.
    Gets triggered by notReplaying notification
    */
    func notLooping(){
        
        replayButton.setImage(UIImage(named: "offReplay"), forState: .Normal)
        
    }
    
    /*
    Sets the image of the shuffleButton to onShuffle
    when shuffling is activated.
    Gets triggered by isShuffle notification
    */
    func isShuffle(){
        
        
        shuffleButton.setImage(UIImage(named: "onShuffle"), forState: .Normal)
        
    }
    
    
    /*
    Sets the image of the shuffleButton to offShuffle
    when shuffling is deactivated.
    Gets triggered by notShuffle notification
    */
    func notShuffle(){
        
        
        shuffleButton.setImage(UIImage(named: "offShuffle"), forState: .Normal)
        
    }
    
    
    /*
    Adds the songs metadata to the view.
    */
    func updateView(){
        
        songSlider.setValue(0, animated: false)
        
        let songMeta = musicPlayer.sharedInstance.getSong()
        
        let imageData = NSData(contentsOfURL: musicPlayer.sharedInstance.getCoverImage(songMeta,size: "player"))
        
        if imageData != nil{
            
            coverImage.image = UIImage(data: imageData!)
            
        }
        
        titleLabel.text = songMeta.name
        artistLabel.text = songMeta.artist
        
    }
    
    
    /*
    Replays current song.
    Triggered when back button is tapped once.
    */
    func replaySong(){
        
        musicPlayer.sharedInstance.replaySong()
        
    }
    
    
    /*
    Plays the song previous song in Queue if any.
    Triggered when badck button is tapped twice.
    */
    func backSong(){
        
        musicPlayer.sharedInstance.backQueue()
        
    }
    
    
    /*
    Updates the progress bar and the time labels.
    Gets triggered by changeInTime noitification.
    */
    func timeChange(){
        
        let playerTime = musicPlayer.sharedInstance.getPlayerTime()
        let remainTime = playerTime.duration - playerTime.current
        
        let (cM,cS) = convertMinSec(playerTime.current)
        let (rM,rS) = convertMinSec(remainTime)
        
        playBackLabel.text = String(format: "%02d:%02d", cM, cS)
        remainTimeLabel.text = "-" + String(format: "%02d:%02d", rM, rS)
        
        let progress = Float(playerTime.current / playerTime.duration)
        
        songSlider.setValue(progress, animated: true)
        
    }
    
    
    /*
    Converts a double in seconds to minutes and seconds.
    */
    func convertMinSec(seconds: Double) -> (Int, Int){
        
        let minutes = (Int(seconds) % 3600) / 60
        let seconds = (Int(seconds) % 3600) % 60
        
        return (minutes, seconds)
    }

}

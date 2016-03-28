//
//  PlayerViewController.swift
//  Trackr
//
//  Created by Omar Dlhz on 3/26/16.
//  Copyright © 2016 Omar De La Hoz. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {

    @IBAction func closeButton(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: {});
        
    }
    
    @IBOutlet weak var coverImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var artistLabel: UILabel!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBAction func playButton(sender: AnyObject) {
        
        if songPlaying == false{
            
            musicPlayer.sharedInstance.resumePlaying()
            
        }
        else{
            
            musicPlayer.sharedInstance.pausePlaying()
            
        }
        
    }
    
    
    
    
    var songPlaying = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "isPlaying", name: "songplaying", object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "isNotPlaying", name: "pauseplaying", object: nil)
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        let imageData = NSData(contentsOfURL: musicPlayer.sharedInstance.getCoverImage("player"))
        
        if imageData != nil{
            
            coverImage.image = UIImage(data: imageData!)
            
        }
        
        
        let songMeta = musicPlayer.sharedInstance.getMeta()
        
        titleLabel.text = songMeta.0
        
        artistLabel.text = songMeta.1
        
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isPlaying(){
        
        songPlaying = true
        playButton.setImage(UIImage(named: "pauseButton"), forState: .Normal)
        
    }
    
    func isNotPlaying(){
        
        songPlaying = false
        playButton.setImage(UIImage(named: "playButton"), forState: .Normal)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

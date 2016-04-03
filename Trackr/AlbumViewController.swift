//
//  AlbumViewController.swift
//  Trackr
//
//  Created by Omar Dlhz on 4/3/16.
//  Copyright © 2016 Omar De La Hoz. All rights reserved.
//

import UIKit
import Alamofire

class AlbumViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var albumData:Album!
    var lightColor = false;
    var colors:UIImageColors!
    
    
    
    @IBOutlet var backView: UIView!
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var songTable: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!
    
    @IBAction func playAlbum(sender: AnyObject) {
        
        if albumData.songs.count > 0{
            
            musicPlayer.sharedInstance.albumToQueue(albumData.songs)
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let imageData = NSData(contentsOfURL: NSURL(string: albumData.artwork)!)
        
        if imageData != nil{
            
            let image = UIImage(data: imageData!)
            colors = image!.getColors()
            
            albumCover.image = image!
            
            backView.backgroundColor = colors.backgroundColor
            let statusBar = UIApplication.sharedApplication().valueForKey("statusBarWindow")?.valueForKey("statusBar") as? UIView
            
            statusBar!.backgroundColor = colors.backgroundColor
            
            self.navigationController!.navigationBar.barTintColor = colors.backgroundColor
            
            self.navigationController!.navigationBar.tintColor = colors.primaryColor
            
            songTable.backgroundColor = colors.backgroundColor
            titleLabel.textColor = colors.primaryColor
            titleLabel.text = albumData.name
            artistLabel.textColor = colors.secondaryColor
            artistLabel.text = albumData.artist
            
            playButton.layer.borderColor = colors.primaryColor.CGColor
            playButton.tintColor = colors.primaryColor
            
            shuffleButton.layer.borderColor = colors.primaryColor.CGColor
            shuffleButton.tintColor = colors.primaryColor
            
            
            hideShadow()
            
            songTable.dataSource = self
            songTable.delegate = self
            searchSongs(albumData.albumId)
            
        }
        
        
    }
    
    func searchSongs(albumId:Int){
        
        Alamofire.request(.GET, "https://itunes.apple.com/lookup", parameters: ["id": albumId, "entity": "song"]) .responseJSON { response in
            
            if let resultJSON = response.result.value{
                
                for song in resultJSON["results"] as! NSMutableArray{
                    
                    if song["wrapperType"] as! String == "track"{
                        
                        let name = song["trackName"] as! String
                        let artist = song["artistName"] as! String
                        let artwork = song["artworkUrl100"] as! String
                        
                        self.albumData.songs.append(Song(name: name, artist: artist, artwork: artwork))
                        
                        
                    }
                }
                
                self.songTable.reloadData()
            }
            else{
                
                let errorAlert = UIAlertController(title: "Error", message: "Could not connect to server. Please check internet connection.", preferredStyle: UIAlertControllerStyle.Alert)
                
                let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
                errorAlert.addAction(okButton)
                self.presentViewController(errorAlert, animated: true, completion: nil)
                
                
            }

        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        musicPlayer.sharedInstance.playNow(albumData.songs[indexPath.row])
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return albumData.songs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = songTable.dequeueReusableCellWithIdentifier("songId") as! SongCell
        
        cell.backgroundColor = colors.backgroundColor
        cell.nameLabel.text = albumData.songs[indexPath.row].name
        cell.nameLabel.textColor = colors.primaryColor
        cell.artistLabel.text = albumData.songs[indexPath.row].artist
        cell.artistLabel.textColor = colors.secondaryColor
        
        return cell
        
    }
    
    
    func isLightColor(color: UIColor) -> Bool
    {
        var isLight = false
        
        let componentColors = CGColorGetComponents(color.CGColor)
        
        let colorBrightness: CGFloat = ((componentColors[0] * 299) + (componentColors[1] * 587) + (componentColors[2] * 114)) / 1000;
        if (colorBrightness >= 0.5)
        {
            isLight = true
            NSLog("my color is light")
        }
        else
        {
            NSLog("my color is dark")
        }  
        return isLight
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hideShadow(){
        for parent in self.navigationController!.navigationBar.subviews {
            for childView in parent.subviews {
                if(childView is UIImageView) {
                    childView.removeFromSuperview()
                }
            }
        }
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

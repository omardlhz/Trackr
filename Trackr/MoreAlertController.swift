/*
  MoreAlertController.swift
  Trackr
  
  AlertController showed when the More button is tapped.

  Created by Omar Dlhz on 4/2/16.
  Copyright © 2016 Omar De La Hoz. All rights reserved.
*/

import Foundation

    
func showAlert(song: Song) -> UIAlertController{
        
        let alertView = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        alertView.view.tintColor = UIColor(red:0.9, green:0.27, blue:0.52, alpha:1.0)
        
        let imageData = NSData(contentsOfURL: musicPlayer.sharedInstance.getCoverImage(song, size: "small"))
        
        // Song cover image UIView
        let coverImg = UIImageView(frame: CGRect(x: 10, y: 20, width: 60, height: 60))
        coverImg.contentMode = UIViewContentMode.Left
        if imageData != nil{ coverImg.image = UIImage(data: imageData!) }
        
        
        //Song title Label
        let titleLabel = UILabel(frame: CGRectMake(80, 27, 200, 21))
        titleLabel.textAlignment = .Left
        titleLabel.text = song.name
        titleLabel.font = UIFont.boldSystemFontOfSize(20)
        
        
        //Song artist Label
        let artistLabel = UILabel(frame: CGRectMake(80, 50, 200, 21))
        artistLabel.textAlignment = .Left
        artistLabel.text = song.artist
        artistLabel.font = UIFont.systemFontOfSize(16)
        
        // Metadata ViewController
        let metaVC = UIViewController()
        metaVC.view.addSubview(coverImg)
        metaVC.view.addSubview(titleLabel)
        metaVC.view.addSubview(artistLabel)
        
        alertView.setValue(metaVC, forKey: "contentViewController")
        
        let nextSong = UIAlertAction(title: "Play Next", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            musicPlayer.sharedInstance.playNext(song)
            
        })
        
        let queueSong = UIAlertAction(title: "Add to Queue", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            musicPlayer.sharedInstance.addQueue(song)
            
        })
        
        let addSong = UIAlertAction(title: "Add to Playlist...", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Add to playlist")
        })
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        alertView.addAction(nextSong)
        alertView.addAction(queueSong)
        alertView.addAction(addSong)
        alertView.addAction(cancelAction)
        
        return alertView
}

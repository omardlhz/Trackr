//
//  AlbumViewController.swift
//  Trackr
//
//  Created by Omar Dlhz on 4/3/16.
//  Copyright © 2016 Omar De La Hoz. All rights reserved.
//

import UIKit

class AlbumViewController: UIViewController {
    
    var albumData:Album!
    var lightColor = false;

    @IBOutlet var backView: UIView!
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var songTable: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let imageData = NSData(contentsOfURL: NSURL(string: albumData.artwork)!)
        
        if imageData != nil{
            
            let image = UIImage(data: imageData!)
            let colors = image!.getColors()
            
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
            
        }
        
        
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

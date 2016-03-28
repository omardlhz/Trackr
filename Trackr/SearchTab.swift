/*
  SearchTab.swift
  Trackr
  
  ViewController for seach tab. Used to search
  for songs, artist and albums in the same tab.

  Created by Omar Dlhz on 3/18/16.
  Copyright © 2016 Omar De La Hoz. All rights reserved.
*/

import UIKit
import Alamofire


class SearchTab: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UISearchBarDelegate{
    
    @IBOutlet var searchTv: UITableView!
    
    var searchController: UISearchController!
    var songs = [Song]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        configureSearchController()
        searchTv.emptyDataSetSource = self;
        searchTv.emptyDataSetDelegate = self;
        searchTv.tableFooterView = UIView();
        
    }
    
    override func viewWillAppear(animated: Bool) {
        if musicPlayer.sharedInstance.loadedSong(){
            print("hay cancion")
        }
        else{
            print("no hay")
        }
    }
    
    
    /*
    Title for when the view is empty.
    
    - It should "Welcome to Trackr".
    - scrollView : The view in which this info is shown.
    
    */
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Welcome to Trackr"
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "Logo")
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "What do you want to listen to today?"
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    

    /*
    Configures the search controller.
    
    - Placeholder is set.
    - Size fits the UINavigationBar
    - Bar color is set to white.
    - The tint color is set to pink (Cancel button).
    
    */
    func configureSearchController() {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search for a song, artist or album..."
        searchController.searchBar.sizeToFit()
        searchController.searchBar.barTintColor = UIColor.whiteColor()
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = UIColor(red:0.9, green:0.27, blue:0.52, alpha:1.0)
        searchController.dimsBackgroundDuringPresentation = false
        
        searchTv.tableHeaderView = searchController.searchBar
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        let searchArray = searchBar.text!.componentsSeparatedByString(" ")
        let fString:String! = searchArray.joinWithSeparator("+")
        
        searchSong(fString)
        
        let artUrl = "http://itunes.apple.com/search?term=" + fString + "&entity=musicArtist"
        let albUrl = "http://itunes.apple.com/search?term=" + fString + "&entity=album"
        
    }
    
  
    
    func searchSong(param:String){
        
        songs.removeAll()

        
        let songUrl = "http://itunes.apple.com/search?term=" + param + "&entity=song"

        Alamofire.request(.GET, songUrl) .responseJSON { response in
            
            if let resultJSON = response.result.value{
                
                for song in resultJSON["results"] as! NSMutableArray{
                    
                    let name = song["trackName"] as! String
                    let artist = song["artistName"] as! String
                    let artwork = song["artworkUrl100"] as! String
                    
                    self.songs.append(Song(name: name, artist: artist, artwork: artwork))
                    
                }
                
                self.searchTv.reloadData()

            }
            else{
                
                let errorAlert = UIAlertController(title: "Error", message: "Could not connect to server. Please check internet connection.", preferredStyle: UIAlertControllerStyle.Alert)
                
                let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
                errorAlert.addAction(okButton)
                self.presentViewController(errorAlert, animated: true, completion: nil)
                
            }
            
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return songs.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("songId", forIndexPath: indexPath) as! SongCell
        
        cell.nameLabel.text = songs[indexPath.row].name
        cell.artistLabel.text = songs[indexPath.row].artist
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        let song = songs[indexPath.row]
        
        musicPlayer.sharedInstance.playSong(song)
        
        
            
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
    }


}

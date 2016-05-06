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


class SearchTab: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet var searchTv: UITableView!
    
    var searchController: UISearchController!
    var songs = [Song]()
    var albums = [Album]()
    
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
        
        let statusBar = UIApplication.sharedApplication().valueForKey("statusBarWindow")?.valueForKey("statusBar") as? UIView
        
        statusBar!.backgroundColor = UIColor.whiteColor()
        
        self.navigationController?.navigationBarHidden = true
        
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
        
        self.definesPresentationContext = true
        
        searchTv.tableHeaderView = searchController.searchBar
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        let searchArray = searchBar.text!.componentsSeparatedByString(" ")
        let fString:String! = searchArray.joinWithSeparator("+")
        
        searchSong(fString)
        searchAlbum(fString)
        
        let artUrl = "http://itunes.apple.com/search?term=" + fString + "&entity=musicArtist"
        
    }
    
  
    /*
    Searches for all the albums in the iTunes API that match
    the search parameter.
    */
    func searchAlbum(param:String){
        
        albums.removeAll()
        
        Alamofire.request(.GET, "http://itunes.apple.com/search", parameters: ["term": param, "entity": "album"]) .responseJSON { response in
            
            if let resultJSON = response.result.value{
                
                
                if resultJSON["resultCount"] as! Int != 0 {
                    
                    for song in resultJSON["results"] as! NSMutableArray{
                        
                        let albumId = song["collectionId"] as! Int
                        let name = song["collectionName"] as! String
                        let artist = song["artistName"] as! String
                        let artwork = song["artworkUrl100"] as! String
                        
                        self.albums.append(Album(albumId: albumId, name: name, artist: artist, artwork: artwork))
                        
                    }
                    
                }
                
            }
            else{
                
                let errorAlert = UIAlertController(title: "Error", message: "Could not connect to server. Please check internet connection.", preferredStyle: UIAlertControllerStyle.Alert)
                
                let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
                errorAlert.addAction(okButton)
                self.presentViewController(errorAlert, animated: true, completion: nil)
                
            }
            
        }
    }
    
    
    /*
    Searches for all the songs in the iTunes API that match
    the search parameter.
    */
    func searchSong(param:String){
        
        songs.removeAll()
        
        Alamofire.request(.GET, "http://itunes.apple.com/search", parameters: ["term": param, "entity": "song"]) .responseJSON { response in
            
            if let resultJSON = response.result.value{
                
                if resultJSON["resultCount"] as! Int != 0 {
                    
                    for song in resultJSON["results"] as! NSMutableArray{
                        
                        let name = song["trackName"] as! String
                        let artist = song["artistName"] as! String
                        let artwork = song["artworkUrl100"] as! String
                        
                        self.songs.append(Song(name: name, artist: artist, artwork: artwork))
                        
                    }
                    
                    
                    
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
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        var sections = 0
        
        if albums.count != 0 {
            
            sections++
            
        }
        
        if songs.count != 0{
            
            sections++
            
        }
    
        return sections
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if albums.count != 0 {
            
            if indexPath.section == 0 {
                
                return 154
                
            }
            else{
                
                return 55
                
            }
            
        }
        else{
            
            return 55
            
        }
        
    }
    

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        
        if albums.count != 0{
            
            if section == 1{
                
                print("here")
                return songs.count
                
            }
            else{
                
                return 1
                
            }
            
        }
        else{
            
            return songs.count
            
        }
        
    }

    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      
        if albums.count != 0 {
            
            if section == 0 {
                
                return "Albums"
                
            }
            else{
                
                return "Songs"
                
            }
            
        }
        else{
            
            if section == 0 {
                
                return "Songs"
                
            }
            else{
                
                return ""
                
            }
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 && albums.count != 0{
            
            
            let cell = tableView.dequeueReusableCellWithIdentifier("albumId",
                forIndexPath: indexPath)
            
            
            return cell
            
        }
        else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("songId", forIndexPath: indexPath) as! SongCell
            
            cell.nameLabel.text = songs[indexPath.row].name
            cell.artistLabel.text = songs[indexPath.row].artist
            cell.songAction.tag = indexPath.row
            cell.songAction.addTarget(self, action: "showAction:", forControlEvents: UIControlEvents.TouchUpInside)
            
            return cell
            
        }
    
    }
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 && albums.count != 0 {
            
            let tableViewCell = cell as! albumCell
            
            tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
            
        }
    }
    
    
    
    func showAction(sender:UIButton){
        
        let alertView = showAlert(songs[sender.tag])
        
        self.presentViewController(alertView, animated: true, completion: nil)
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        let song = songs[indexPath.row]
        
        musicPlayer.sharedInstance.playNow(song)
        
            
    }
    
    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            
            return albums.count
    }
    
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("albumCl", forIndexPath: indexPath) as! albumCV
            
            cell.tag = indexPath.row
            
            cell.nameLabel.text = albums[indexPath.row].name
            cell.artistLabel.text = albums[indexPath.row].artist
            
            let imageData = NSData(contentsOfURL: NSURL(string: albums[indexPath.row].artwork)!)
            
            if imageData != nil{
                
                cell.artworkView.image = UIImage(data: imageData!)
                
            }
            
            return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "goAlbum"{
         
            let destinationViewController = segue.destinationViewController as! AlbumViewController
            
            if let cell = sender as? albumCV
            {
                
                let indexPath = cell.tag
                destinationViewController.albumData = albums[indexPath]
            }
            
        }
        
    }


}

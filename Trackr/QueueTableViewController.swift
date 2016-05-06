//
//  QueueTableViewController.swift
//  Trackr
//
//  Created by Omar Dlhz on 4/19/16.
//  Copyright © 2016 Omar De La Hoz. All rights reserved.
//

import UIKit

class QueueTableViewController: UITableViewController {
    
    @IBOutlet var queueView: UITableView!
    
    var songQueue:[Song] = [Song]()

    @IBAction func playerButton(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

    @IBAction func editButton(sender: AnyObject) {
        
        if(queueView.editing == true){
            
            queueView.editing = false;
            
        }
        else{
            
            queueView.editing = true;
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
    }

    override func viewWillAppear(animated: Bool) {
        
        songQueue = musicPlayer.sharedInstance.getQueue()
        
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
    
    
    override func setEditing(editing: Bool, animated: Bool) {
        print("Editing")
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return songQueue.count
    }
    
    
    func showAction(sender:UIButton){
        
        let alertView = showAlert(songQueue[sender.tag])
        
        self.presentViewController(alertView, animated: true, completion: nil)
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("queueCell", forIndexPath: indexPath) as! SongCell
        
        cell.nameLabel.text = songQueue[indexPath.row].name
        cell.artistLabel.text = songQueue[indexPath.row].artist
        cell.songAction.tag = indexPath.row
        cell.songAction.addTarget(self, action: "showAction:", forControlEvents: UIControlEvents.TouchUpInside)

        return cell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

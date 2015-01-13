//
//  TVC.swift
//  KanjiJisho
//
//  Created by ALABALA on 11/23/14.
//  Copyright (c) 2014 tt. All rights reserved.
//
import Foundation
import UIKit

class TVC: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dataArray : NSArray = []
    
    var search  = ""
    var searchedRadicals : Array<String> = []
    var searchedNrStrokes = ""
    
    
    var resultats = NSMutableArray()
    var gasitStrokes = false
    var gasitSearch = false
    
    func recherche()
    {
        gasitStrokes = false
        gasitSearch = false
        
        //recherche avec no lignes
        if(searchedNrStrokes != "")
        {
            for i in 0...dataArray.count-1
            {
                if (dataArray.objectAtIndex(i).objectForKey("strokes") as String == searchedNrStrokes)
                {
                    resultats.addObject(dataArray.objectAtIndex(i))
                    gasitStrokes = true
                }
            }
        }
        
        
        //recherche par onyomi
        if(search != "" && resultats.count>=1)
        {
            for i in 0...resultats.count-1
            {
                    if (resultats.objectAtIndex(i).objectForKey("on") as String != search+"\n")
                {
                    resultats.removeObjectAtIndex(i)
                }
            }
            
        }else{
            
        if(search != "")
        {for i in 0...dataArray.count-1
            {
                if (dataArray.objectAtIndex(i).objectForKey("on") as String == search + "\n")
                {
                    resultats.addObject(dataArray.objectAtIndex(i))
                    gasitSearch = true
                }
            }
            }}
        
      
        
        //recherche par radicaux
        
        if(searchedRadicals.count >= 1 && resultats.count >= 1)
        {
            var res = NSMutableArray()
            for i in 0...resultats.count-1
            { var gasit = false
                for j in 0...searchedRadicals.count - 1
                {
                    if (resultats.objectAtIndex(i).objectForKey("radical") as String == searchedRadicals[j]+"\n\n")
                    {gasit = true}
                }
                if gasit
                {
                    res.addObject(resultats.objectAtIndex(i))
                    
                }
            }
            resultats = res
        }
        else{
        if(searchedRadicals.count >= 1)
        {
            for i in 0...dataArray.count-1
            { var gasit = false
                for j in 0...searchedRadicals.count - 1
                {
                    if (dataArray.objectAtIndex(i).objectForKey("radical") as String == searchedRadicals[j]+"\n\n")
                    {gasit = true}
                }
                if gasit
                {
                    resultats.addObject(dataArray.objectAtIndex(i))
                }
            }
            }}
        }
    
    override func viewDidLoad() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        var caleKanji = NSBundle.mainBundle().pathForResource("new1", ofType: "xml")
        var urlKanji:NSURL = NSURL (fileURLWithPath: caleKanji!)
        
        var parserKanji : kanjiXMLParser = kanjiXMLParser.alloc().initWithURL(urlKanji) as kanjiXMLParser
        
        dataArray = parserKanji.posts
        recherche()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultats.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell


        var dict : NSDictionary! = resultats.objectAtIndex(indexPath.row) as NSDictionary
        cell.textLabel?.text = resultats.objectAtIndex(indexPath.row).objectForKey("semn") as? String
        cell.detailTextLabel?.text = resultats.objectAtIndex(indexPath.row).objectForKey("translation") as? String

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
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
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}

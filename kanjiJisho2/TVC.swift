//
//  TVC.swift
//  KanjiJisho
//
//  Created by Alexandra Matreata on 11/23/14.
//  Copyright (c) 2014 tt. All rights reserved.
//
import Foundation
import UIKit

class TVC: UITableViewController, UITableViewDelegate, UITableViewDataSource {
// view pour l'affichage des resultats
    
    var dataArray : NSArray = []
    
    //variables et fonction pour le traitement du String avec translation
    var matches : Array<String> = Array<String>()
    var regex = NSRegularExpression(pattern:"[A-Za-z() ]+", options: NSRegularExpressionOptions.CaseInsensitive, error: nil)
    
    //fonction pour la separation des translations
    func traitementSense(t : NSString)
    {
        let all = NSRange(location: 0, length: t.length)
        
        regex?.enumerateMatchesInString(t, options: NSMatchingOptions(0), range: all)
            {
            (result : NSTextCheckingResult!, _, _) in
            self.matches.append(t.substringWithRange(result.range))
            }
    }
    
    
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
        
        
        //recherche par kunyomi, onyomi ou translation
        if(search != "" && resultats.count>=1)
        {
            var res = NSMutableArray()
            for i in 0...resultats.count-1
            {
                traitementSense(resultats.objectAtIndex(i).objectForKey("translation") as String)
                if (resultats.objectAtIndex(i).objectForKey("kun") as String != search+"\n")
                {
                    var b = 0
                    gasitSearch = false
                    while (b <= matches.count - 1) && (!gasitSearch)
                    {
                        if (matches[b] == search || matches[b] == " " + search)
                        {
                            gasitSearch = true
                        }
                        b++
                    }
                    matches = []
                    
                }
                else
                {gasitSearch = true}
                
                if gasitSearch
                {
                    res.addObject(resultats.objectAtIndex(i))
                }else{
                    var b = 0
                    traitementSense(dataArray.objectAtIndex(i).objectForKey("on") as String)
                    while (b <= matches.count - 1) && (!gasitSearch)
                    {
                        if (matches[b] == search) || (matches[b] == " " + search)
                        {
                            gasitSearch = true
                        }
                        b++
                    }
                    matches = []
                    if gasitSearch
                    {
                        resultats.addObject(dataArray.objectAtIndex(i))
                    }                        }
            }
            resultats = res
            
        }else{
            
            if(search != "")
            {
                
                for i in 0...dataArray.count-1
                {
                    if (dataArray.objectAtIndex(i).objectForKey("kun") as String == search + "\n")
                    {
                        resultats.addObject(dataArray.objectAtIndex(i))
                        gasitSearch = true
                    }
                    else
                    {
                        gasitSearch = false
                        var b = 0
                        traitementSense(dataArray.objectAtIndex(i).objectForKey("translation") as String)
                        while (b <= matches.count - 1) && (!gasitSearch)
                        {
                            if (matches[b] == search) || (matches[b] == " " + search)
                            {
                                gasitSearch = true
                            }
                            b++
                        }
                        matches = []
                        if gasitSearch
                        {
                            resultats.addObject(dataArray.objectAtIndex(i))
                        }
                        else{
                            var b = 0
                            traitementSense(dataArray.objectAtIndex(i).objectForKey("on") as String)
                            while (b <= matches.count - 1) && (!gasitSearch)
                            {
                                if (matches[b] == search) || (matches[b] == " " + search)
                                {
                                    gasitSearch = true
                                }
                                b++
                            }
                            matches = []
                            if gasitSearch
                            {
                                resultats.addObject(dataArray.objectAtIndex(i))
                            }                        }
                    }
                }
            }}
        
        
        
        
        //recherche par radicaux
        
        if(searchedRadicals.count >= 1 && resultats.count > 1)
        {println(resultats.objectAtIndex(0))
            var res = NSMutableArray()
            for i in 0...resultats.count-1
            { var gasit = false
                for j in 0...searchedRadicals.count - 1
                {
                    if (resultats.objectAtIndex(i).objectForKey("radical") as String == searchedRadicals[j]+"\n")
                    {gasit = true
                    }
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
                        if (dataArray.objectAtIndex(i).objectForKey("radical") as String == searchedRadicals[j]+"\n")
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
        var caleKanji = NSBundle.mainBundle().pathForResource("kanjiXML-2", ofType: "xml")
        var urlKanji:NSURL = NSURL (fileURLWithPath: caleKanji!)!
        
        var parserKanji : kanjiXMLParser = kanjiXMLParser.alloc().initWithURL(urlKanji) as kanjiXMLParser
        
        dataArray = parserKanji.posts
        recherche()
        tableView.reloadData()
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
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
        
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var dvc:DVC = DVC()
        dvc = segue.destinationViewController as DVC
        
        var path:NSIndexPath = self.tableView.indexPathForSelectedRow()!
        var d : String = ""
        d = resultats.objectAtIndex(path.row).objectForKey("semn") as String
        
            dvc.semn = resultats.objectAtIndex(path.row).objectForKey("semn") as String
            dvc.strokes = resultats.objectAtIndex(path.row).objectForKey("strokes") as String
            dvc.on = resultats.objectAtIndex(path.row).objectForKey("on") as String
            dvc.kun = resultats.objectAtIndex(path.row).objectForKey("kun") as String
            dvc.translation = resultats.objectAtIndex(path.row).objectForKey("translation") as String
            dvc.radical = resultats.objectAtIndex(path.row).objectForKey("radical") as String
    }
    
    
}

//
//  CustomVC.swift
//  kanjiJisho2
//
//  Created by Alexandra Matreata on 1/10/15.
//  Copyright (c) 2015 tt. All rights reserved.
//
import Foundation
import UIKit

class CustomVC: UIViewController, UITextFieldDelegate {
// view pour la recherche customisee
   
    @IBOutlet weak var radicalLbl: UILabel!
    @IBOutlet weak var search: UITextField!
    @IBOutlet weak var strokesTF: UITextField!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var scr: UIScrollView!
      
    
    override func viewDidLoad() {
        super.viewDidLoad()
        search.delegate = self
        strokesTF.delegate = self
        scr.scrollEnabled = true
        scr.bounces = true
        scr.contentSize = CGSizeMake(320, 2515)
    }
    
    @IBAction func showButton(sender: AnyObject) {
        buttonMake()
    }
   
    
    let RegexRadical = "^.{1}$"
    let myRegex = "(.){1,2}"
    var dataArray : NSArray = []
    var radicals : Array<String> = []
    
    var i = 0
    var j = 0
    var aux = ""
    var dict : Dictionary<String, String> = ["":""]
    var x:CGFloat = 35
    var y:CGFloat = 310
    
    //search variables
    var searchedRadicals : Array<String> = []
    var searchedNrStrokes = ""
    
    
    var texte = String()
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        search.resignFirstResponder()
        strokesTF.resignFirstResponder()
        return true
    }
    
    
    func radicalSelected(sender:UIButton)
    {
        var t = 0
        var j = 0
        var gasit:Bool = false
        if let lbl = sender.titleLabel?.text
        {
            var match = lbl.rangeOfString(myRegex, options: .RegularExpressionSearch)
            
            if(searchedRadicals.count>1)
            {for t in 0...searchedRadicals.count-1
            {if(searchedRadicals[t] == lbl.substringWithRange(match!))
            {
                gasit = true
                for j in t...searchedRadicals.count-2
                {searchedRadicals[j] = searchedRadicals[j+1]
                    searchedRadicals.removeLast()
                }
                }
                
                }
            }
            
            if(!gasit)
            {searchedRadicals.append(lbl.substringWithRange(match!))}
            else
            {gasit = false}
            
            radicalLbl.text = searchedRadicals[0]
            
            if searchedRadicals.count > 1
            {for j in 1...searchedRadicals.count-1
            {radicalLbl.text = radicalLbl.text! + ", " + searchedRadicals[j]}
                
            }
        }
        
    }
    
    func buttonMake()
    {
        var edeja = false
        var caleKanji = NSBundle.mainBundle().pathForResource("kanjiXML-2", ofType: "xml")
        var urlKanji:NSURL = NSURL (fileURLWithPath: caleKanji!)!
        
        var parserKanji : kanjiXMLParser = kanjiXMLParser.alloc().initWithURL(urlKanji) as kanjiXMLParser
        
        //verification du radical dans le xml
        
        
        dataArray = parserKanji.posts
        j = dataArray.count - 1
        for i in 0...j
        {
            aux = dataArray.objectAtIndex(i).objectForKey("radical") as String
            if(edeja)
            {edeja = false}
            
            if(radicals.count>=2)
            {for k in 0...radicals.count - 1
            {
                if radicals[k] as NSString == aux
                {edeja = true}
                }}
            
            if (!edeja)
            {
                radicals.append(aux)
            }
        }
        
        for i in 0...radicals.count-1
            {   aux = radicals[i]
                let button = UIButton.buttonWithType(UIButtonType.System) as UIButton
                button.frame = CGRectMake(x, y , 50, 50)
                button.backgroundColor = UIColor.lightGrayColor()
                button.setTitle(aux, forState: UIControlState.Normal)
                button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                button.addTarget(self, action: "radicalSelected:", forControlEvents: UIControlEvents.TouchUpInside)
                self.scr.addSubview(button)
                if(x<=185)
                {x = x+50}
                else
                {y = y+50
                    x = 35}
            
        }
                
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        var tvc:TVC
        tvc = segue.destinationViewController as TVC
        tvc.search = search.text
        tvc.searchedRadicals = searchedRadicals
        searchedNrStrokes = strokesTF.text + "\n"
        tvc.searchedNrStrokes = searchedNrStrokes
        
    }

}

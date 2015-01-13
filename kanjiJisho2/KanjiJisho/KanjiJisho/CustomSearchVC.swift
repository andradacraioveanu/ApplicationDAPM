//
//  CustomSearchVC.swift
//  KanjiJisho
//
//  Created by ALABALA on 12/4/14.
//  Copyright (c) 2014 tt. All rights reserved.
//
import Foundation
import UIKit


class CustomSearchVC: UIViewController, UITextFieldDelegate {
    
    
    @IBAction func showRadicals(sender: AnyObject) {
        
        buttonMake()
    }
    @IBOutlet weak var radicalLbl: UILabel!
    @IBOutlet weak var Strokes: UITextField!
    @IBOutlet weak var tf: UITextField!
    @IBAction func searchButton(sender: AnyObject) {
    }
    
    
    let myRegex = "(.){1,2}"
    var dataArray : NSArray = []
    var radicals : Array<String> = []
    
    var i = 0
    var j = 0
    var aux = ""
    var dict : Dictionary<String, String> = ["":""]
    var x:CGFloat = 35
    var y:CGFloat = 330
    
    //search variables
    var searchedRadicals : Array<String> = []
    var searchedNrStrokes = ""
    
    
    var texte = String()
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        tf.resignFirstResponder()
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
            //else {searchedRadicals.append(lbl.substringWithRange(match!))}
            
            if(!gasit)
            {
                searchedRadicals.append(lbl.substringWithRange(match!))
            }
            else {gasit = false}
            
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
        var caleKanji = NSBundle.mainBundle().pathForResource("new1", ofType: "xml")
        var urlKanji:NSURL = NSURL (fileURLWithPath: caleKanji!)
        
        var parserKanji : kanjiXMLParser = kanjiXMLParser.alloc().initWithURL(urlKanji) as kanjiXMLParser
        
        dataArray = parserKanji.posts
        j = dataArray.count - 1
        for i in 0...j
        {
            if(edeja)
            {edeja = false}
            aux = dataArray.objectAtIndex(i).objectForKey("radical") as String
            if(radicals.count>=2)
            {for k in 0...radicals.count - 1
            {
                if radicals[k] as NSString == aux
                {edeja = true}
            }}
            
            if !edeja
            {
            radicals.append(aux)
            let button = UIButton.buttonWithType(UIButtonType.System) as UIButton
            button.frame = CGRectMake(x, y , 50, 50)
            button.backgroundColor = UIColor.lightGrayColor()
            button.setTitle(aux, forState: UIControlState.Normal)
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button.addTarget(self, action: "radicalSelected:", forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(button)
            if(x<=185)
            {x = x+50}
            else
            {y = y+50
                x = 35}
            }
        }
        println(aux)
    }
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        tf.delegate = self
        println(texte)
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        var tvc:TVC
        tvc = segue.destinationViewController as TVC
        tvc.search = tf.text
        tvc.searchedRadicals = searchedRadicals
        searchedNrStrokes = Strokes.text + "\n"
        tvc.searchedNrStrokes = searchedNrStrokes

    }
}

//
//  ViewController.swift
//  KanjiJisho
//
//  Created by Alexandra Matreata on 11/23/14.
//  Copyright (c) 2014 tt. All rights reserved.
//
import Foundation
import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    var aux = ""
    //regex pour extraction des espaces
    let myRegex = "(.){1}"
    //regex pour les syllabes
    var regex = NSRegularExpression.regularExpressionWithPattern("[bdf-hj-np-tv-z]{1,2}[aeiou]?", options: NSRegularExpressionOptions.CaseInsensitive, error: nil)
    
    //regex pour n simple
    var regexN = NSRegularExpression.regularExpressionWithPattern("([n][bdf-hj-np-tv-z])|[n]$", options: NSRegularExpressionOptions.CaseInsensitive, error: nil)
    
    //regex pour vocales simples
    var regexVoc = NSRegularExpression.regularExpressionWithPattern("([aeiou][aeiou])|(^[aeiou])", options: NSRegularExpressionOptions.CaseInsensitive, error: nil)
    

    // function pour le traitement du texte introduit au clavier
    func traitementTexte(t : NSString)
    {
        let all = NSRange(location: 0, length: t.length)
        var matches : Array<String> = Array<String>()
        regex?.enumerateMatchesInString(t, options: NSMatchingOptions(0), range: all){
            
            (result : NSTextCheckingResult!, _, _) in
            matches.append(t.substringWithRange(result.range))
            
        }
        
        
        
        var l = matches.count - 1
        for c in 0...l
        {
            scris = matches[c] + "\n\n"
            var match = dict[scris]?.rangeOfString(myRegex, options: .RegularExpressionSearch)
            var subst = dict[scris]?.substringWithRange(match!)
            
            descris = descris + subst!
        }

    }
    
    var x = 0
    var c = 0
    

    //variables pour traitement du texte introduit par clavier
    var scris = ""
    var descris = ""
    
    @IBOutlet weak var tf: UITextField!
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        tf.resignFirstResponder()
        return true
    }
    
    
    var scrisfinal : String!
    let myRegexcitire = "[a-z]{1,3}"
    
    @IBAction func searchButton(sender: AnyObject) {
        
        if(tf.text != "")
        { j = dataArray.count - 1
            scrisfinal = tf.text
            
            for i in 0...j
            {
                
                aux = dataArray.objectAtIndex(i).objectForKey("semn") as String
                cheie = dataArray.objectAtIndex(i).objectForKey("citire") as String
                
                var match = aux.rangeOfString(myRegex, options: .RegularExpressionSearch)
                var substaux = aux.substringWithRange(match!)
                
                match = cheie.rangeOfString(myRegexcitire, options: .RegularExpressionSearch)
                var substcheie = cheie.substringWithRange(match!)
                
                scrisfinal = scrisfinal.stringByReplacingOccurrencesOfString(substcheie, withString: substaux, options: nil, range: nil)
                
            }
            
            tf.text = scrisfinal}
            
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var tvc:TVC
       // tvc = segue.destinationViewController as TVC
       // tvc.search = tf.text
        
        var csvc:CustomSearchVC = CustomSearchVC()
        //csvc = segue.destinationViewController as CustomSearchVC
        csvc.texte = "text"
    }
    
    
    @IBOutlet weak var textField: UITextField!
    var dataArray : NSArray = []
    var i = 0
    var j = 0
   // var aux = ""
    var cheie = ""
    var dict : Dictionary<String, String> = ["":""]
    var val : String!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tf.delegate = self
        
        var cale = NSBundle.mainBundle().pathForResource("hiraganaeu", ofType: "xml")
        //var caleKanji = NSBundle.mainBundle().pathForResource("kanjiXML", ofType: "xml")
       // var urlKanji:NSURL = NSURL (fileURLWithPath: caleKanji!)
        var url:NSURL = NSURL(fileURLWithPath: cale!)
        
        var parser : xmlParser = xmlParser.alloc().initWithURL(url) as xmlParser
        //var parserKanji : kanjiXMLParser = kanjiXMLParser.alloc().initWithURL(urlKanji) as kanjiXMLParser
        
        dataArray = parser.posts
        j = dataArray.count - 1
        for i in 0...j
        {
            aux = dataArray.objectAtIndex(i).objectForKey("semn") as String
            cheie = dataArray.objectAtIndex(i).objectForKey("citire") as String
            dict[cheie] = aux

        }
       
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
           }


}


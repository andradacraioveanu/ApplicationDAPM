//
//  DVC.swift
//  kanjiJisho2
//
//  Created by Alexandra Matreata on 12/30/14.
//  Copyright (c) 2014 tt. All rights reserved.
//
 
import UIKit

class DVC: UIViewController {

//view detaillee sur un kanji recherche
    
    @IBOutlet weak var trans: UILabel!
    @IBOutlet weak var k: UILabel!
    @IBOutlet weak var o: UILabel!
    @IBOutlet weak var str: UILabel!
    @IBOutlet weak var rad: UILabel!
    @IBOutlet weak var lbl: UILabel!
    
    var semn : String = ""
    var strokes : String = ""
    var on : String = ""
    var kun : String = ""
    var translation : String = ""
    var radical : String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl.text = semn
        rad.text = radical
        str.text = strokes
        o.text = on
        k.text = kun
        trans.text = translation
        }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}

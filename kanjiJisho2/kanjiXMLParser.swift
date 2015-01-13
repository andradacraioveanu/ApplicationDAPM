//
//  kanjiXMLParser.swift
//  KanjiJisho
//
//  Created by Alexandra Matreata on 12/4/14.
//  Copyright (c) 2014 tt. All rights reserved.
//
import Foundation
import UIKit
 
class kanjiXMLParser: NSObject, NSXMLParserDelegate {
    
//parser pour le fichier xml avec kanji
    
    var parser = NSXMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var semn = NSMutableString()
    var translation = NSMutableString()
    var radical = NSMutableString()
    var strokes = NSMutableString()
    var kun = NSMutableString()
    var on = NSMutableString()
    
    
    func initWithURL(url :NSURL) -> AnyObject {
        beginParsing(url)
        return self
    }
    
    func beginParsing(xmlUrl :NSURL) {
        posts = []
        parser = NSXMLParser(contentsOfURL: xmlUrl)!
        parser.shouldProcessNamespaces = false
        parser.shouldReportNamespacePrefixes = false
        parser.shouldResolveExternalEntities = false
        parser.delegate = self
        
        parser.parse()
    }
    
    func allPosts() -> NSMutableArray {
        return posts
    }
    
    func parserDidStartDocument(parser: NSXMLParser!) {
        
    }
    
    func parserDidEndDocument(parser: NSXMLParser!) {
        
    }
    
    func parser(_parser: NSXMLParser!, parseErrorOccurred parseError: NSError!) {
        
    }
    
    func parser(parser: NSXMLParser!,didStartElement elementName: String!, namespaceURI: String!, qualifiedName : String!, attributes attributeDict: NSDictionary!) {
        
        element = elementName
        
        if (elementName as NSString).isEqualToString("kanji") {
            elements = NSMutableDictionary.alloc()
            elements = [:]
            semn = NSMutableString.alloc()
            semn = ""
            translation = NSMutableString.alloc()
            translation = ""
            kun = NSMutableString.alloc()
            kun = ""
            on = NSMutableString.alloc()
            on = ""
            radical = NSMutableString.alloc()
            radical = ""
            strokes = NSMutableString.alloc()
            strokes = ""
            
        }
    }
    
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        
        if (elementName as NSString).isEqualToString("kanji") {
            if semn != ""
            {elements.setObject(semn, forKey: "semn")}
            if translation != ""
            {elements.setObject(translation, forKey: "translation")}
            if kun != ""
            {elements.setObject(kun, forKey: "kun")}
            if on != ""
            {elements.setObject(on, forKey: "on")}
            if radical != ""
            {elements.setObject(radical, forKey: "radical")}
            if strokes != ""
            {elements.setObject(strokes, forKey: "strokes")}
            
            posts.addObject(elements)
        }
    }
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!) {
        if element.isEqualToString("semn") {
            semn.appendString(string)
        } else if element.isEqualToString("translation") {
            translation.appendString(string)
        }
        else if element.isEqualToString("kun") {
            kun.appendString(string)
        }
        else if element.isEqualToString("on") {
            on.appendString(string)
        }
        else if element.isEqualToString("radical") {
            radical.appendString(string)
        }
        else if element.isEqualToString("strokes") {
            strokes.appendString(string)
        }
        
    }
    
    
}




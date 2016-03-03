//
//  TimerManager.swift
//  SwimTimer
//
//  Created by Viktor Fägerlind on 27/05/15.
//  Copyright (c) 2015 Viktor Fägerlind. All rights reserved.
//

import Foundation
import YamlSwift

class FileManager
{
  static let singleton = FileManager ()
  var fileManager = NSFileManager ()
  
  private init ()
  {
    goToDir (.DocumentDirectory)
  }
  
  func goToDir (directory: NSSearchPathDirectory) -> Bool
  {
    let dirPaths = NSSearchPathForDirectoriesInDomains (directory, .UserDomainMask, true)
    
    let dirPath = dirPaths[0] 
    
    return fileManager.changeCurrentDirectoryPath (dirPath)
  }
  
  func writeFile (fileName : String, contents : String) -> Bool
  {
    var result : Bool
    
    let data = (contents as NSString).dataUsingEncoding(NSUTF8StringEncoding)
    
    if fileManager.fileExistsAtPath (fileName)
    {
      let fileHandle : NSFileHandle? = NSFileHandle (forWritingAtPath: fileName)
      
      if fileHandle == nil
      {
        result = false
      }
      else
      {
        fileHandle!.truncateFileAtOffset (0) // Delete the current contents first
        fileHandle!.writeData (data!)
        fileHandle!.closeFile ()
        result = true;
      }
    }
    else
    {
      result = fileManager.createFileAtPath (fileName, contents: data, attributes: nil)
    }
    
    return result
  }
  
  
  func readFileAsString (fileName : String) -> String?
  {
    let data = readFile (fileName)
    
    if data == nil
    {
      return nil
    }
    
    return NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
  }
  
  func readFile (fileName : String) -> NSData?
  {
    let fileHandle: NSFileHandle? = NSFileHandle (forReadingAtPath: fileName)
    
    let data = fileHandle?.readDataToEndOfFile ()
    
    fileHandle?.closeFile ()

    return data
  }
}

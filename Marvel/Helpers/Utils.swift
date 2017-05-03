//
//  Utils.swift
//  Marvel
//
//  Created by Albert Arroyo on 2/5/17.
//  Copyright © 2017 AlbertArroyo. All rights reserved.
//

import Foundation

class Utils  {
    
    /// Method to print the path simulator (only in debug)
    public class func pathIOSSimulator(){
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        #if DEBUG
            print("AAT Path Simulator: " + documentsPath)
        #endif
    }
    
    /// Method to log only for debug
    public class func DLog(message:String, functionName:String = #function, fileName:String = #file) {
        
        /* For this to work, add the "-D DEBUG" flag to the "Swift Compiler - Custom Flags" to Debug mode, under Build Settings.  */
        
        #if DEBUG
            print("AAT Method_Name = \(functionName)\n File_Name = \(String(describing: fileName.lastPathComponent))\n Print = \(message)");
        #endif
    }
    
}


//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Aaron Justman on 3/11/15.
//  Copyright (c) 2015 AaronJ. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject
{
    let filePathURL: NSURL
    let title: String
    
    // code review TASK 1
    // implement constructor function
    init( filePathURL: NSURL, title: String )
    {
        self.filePathURL = filePathURL
        self.title = title
    }
}
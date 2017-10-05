//
//  BinResponse.swift
//  BinMinder
//
//  Created by Yousef on 20/09/2017.
//  Copyright © 2017 Yousef. All rights reserved.
//

import Foundation
import SwiftSoup

enum HTMLError: Error{
    case badInnerHTML
}

struct BinResponse {
    
    let binDatesData: [BinDate]
    
    init(_ html: Any?) throws  {
        guard let htmlString = html as? String else{
            throw HTMLError.badInnerHTML
        }
        let doc = try SwiftSoup.parse(htmlString)
        let binTypes = try doc.getElementsByClass("binType").array()
        let binMonths = try doc.getElementsByClass("binMonth").array()
        let binDays = try doc.getElementsByClass("binDay").array()
        
        var binDatesArray = [BinDate]()
        
        for i in 0..<binTypes.count{
             let bindate = try BinDate(type: binTypes[i].text(), date: binDays[i].text() + "," + binMonths[i].text() )
            binDatesArray.append(bindate)
        
        }
        
        binDatesData = binDatesArray
        print("the times")
        print(binDatesArray)
    }
}

//
//  Extentions.swift
//  Weather.au
//
//  Created by Dmitrii Zverev on 31/1/17.
//  Copyright © 2017 Dmitrii Zverev. All rights reserved.
//

import Foundation

extension Sequence where Iterator.Element == Array<MazeCellData?> {
    func debugPrint()  {
        if let datArray = self as? [[MazeCellData?]]{
            for index in 0..<datArray.count {
                var debugStr = ""
                datArray[index].forEach({
                    debugStr = debugStr + (($0 == nil || $0!.id.length == 0) ? "⬛" : "⬜")
                })
                print(debugStr)
            }
            print("DONE debugPrint")
        }
    }
    
    func cutEmptyData() -> [[MazeCellData?]] {
        if let datArray = self as? [[MazeCellData?]]{
            var sortedMatrix = [[MazeCellData?]]()
            //Find total number elements in one row and first element in row to cut all empty data
            var maxElements = 0
            var firstElement = datArray.count
            
            for row in 0..<datArray.count {
                var tempFirstElement = 0
                for index in 0..<datArray[row].count {
                    if datArray[row][index] != nil {
                        break
                    }
                    tempFirstElement = index
                }
                if firstElement > tempFirstElement {
                    firstElement = tempFirstElement
                }
                let ar =  datArray[row].flatMap({$0})
                if maxElements < ar.count {
                    maxElements = ar.count
                }
            }
            //Cutting array from unnecessary nil data
            for row in 0..<datArray.count where  datArray[row].flatMap({$0}).count > 1  {
                sortedMatrix.append(Array(datArray[row][(firstElement + 1)...(firstElement + maxElements)]))
            }
            return sortedMatrix
        }
        return []
    }
    
}


extension String {
    var length: Int{
        let str:NSString = NSString(string: self)
        return str == "\n" ? 0 : str.length
    }
}


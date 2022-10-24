//
//  RandomDataGenerator.swift
//  OrrRock
//
//  Created by 황정현 on 2022/10/25.
//

import Foundation

class RandomDataGenerator {
    
    let nameList = ["1암장", "2암장", "3암장", "4암장", "5암장"]
    let dateList = [1, 2, 3, 4, 5]
    let url = "URL"
    let probLevelList = [0, 1, 2, 3, 4, 5]
    let tf = [true, false]
    
    
    func coreDataRandomvideoInformationGenerate(howMany: Int) {

        for _ in 0..<howMany {
            let randomIndex = Int.random(in: 0..<nameList.count)
            let name = nameList[randomIndex]
            let date = Date.random(in: Date(timeIntervalSince1970: 0)..<Date(timeIntervalSince1970: 2000000))
            let url = url
            let level = probLevelList[Int.random(in: 0..<probLevelList.count)]
            let isSucceeded = tf[Int.random(in: 0..<tf.count)]
            let isFavorite = tf[Int.random(in: 0..<tf.count)]
            
            let info = VideoInfo(gymName: name, gymVisitDate: date, videoLocalIdentifier: url, problemLevel: level, isSucceeded: isSucceeded)
            
            DataManager.shared.createData(info: info)
        }
        
        print("---CREATE \(howMany) NEW DATA---")
        
        DataManager.shared.updateRepository()
    }
}

//
//  Structs.swift
//  Canva-Challenge
//
//  Created by Dmitrii Zverev on 8/2/17.
//  Copyright © 2017 Dmitrii Zverev. All rights reserved.
//

import Foundation

struct  MazeCellData {
    var id: String
    var image: String
    
    init(id: String, image: String) {
        self.id = id
        self.image = image
    }
    
    init() { // INIT AS WALL (aka empty cell)
        id = ""
        image = ""
    }
}

struct RoomToDownload {
    var id: String
    var positionX: Int
    var positionY: Int
    var needToUnlock: Bool
}


class MazeCell: UICollectionViewCell {
    @IBOutlet weak var mazeImage: UIImageView!
    
    func fillWith(data: MazeCellData?)  {
        mazeImage.backgroundColor = (data == nil || data!.id.length == 0) ? .black : .white
        if data == nil {
            mazeImage.image = nil
            return
        }
        
    }
}

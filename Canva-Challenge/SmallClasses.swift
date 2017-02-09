//
//  Structs.swift
//  Canva-Challenge
//
//  Created by Dmitrii Zverev on 8/2/17.
//  Copyright © 2017 Dmitrii Zverev. All rights reserved.
//

import Foundation
import Haneke

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
        mazeImage.backgroundColor = (data == nil || data!.id.length == 0) ? .black : .brown
        if data == nil || data!.image.length == 0 {
            mazeImage.image = nil
            return
        }
        if let url = URL(string: data!.image) {
            mazeImage.hnk_setImageFromURL(url)
        }
        
    }
}

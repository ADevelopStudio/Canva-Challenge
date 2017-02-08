//
//  ViewController.swift
//  Canva-Challenge
//
//  Created by Dmitrii Zverev on 8/2/17.
//  Copyright © 2017 Dmitrii Zverev. All rights reserved.
//

import UIKit


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "MazeCell", for: indexPath) as! MazeCell
        cell.fillWith(data: matrix[indexPath.section][indexPath.row])
        return cell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return  matrix.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  matrix[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfElements = CGFloat(matrix.count > 0 ? matrix.first!.count : 1)
        return CGSize(width: collection.bounds.width/numberOfElements, height: collection.bounds.width/numberOfElements)
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var collection: UICollectionView!

    let mazeManager = MazeManager()
    var matrix = [[MazeCellData?]]()
    var roomsToDownload = Array<RoomToDownload>()
    var startTime: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.delegate = self
        collection.dataSource = self
        generateEmptyArray()
    }
    
    
    
    func generateEmptyArray()  {
        matrix = []
        for _ in 0..<500 {
            var arrayRow = [MazeCellData?]()
            for _ in 0..<500 {
                arrayRow.append(nil)
            }
            matrix.append(arrayRow)
        }

    }
    
    @IBAction func genaratePressed(_ sender: Any) {
        generateEmptyArray()
        startTime = Date().timeIntervalSince1970
        startPoint(completion: {
            success, roomId in
            if success {
                self.roomsToDownload.append(RoomToDownload(id: roomId, positionX: 250, positionY: 250, needToUnlock: false))
                self.openNextRoom()
            } else {
                print("Something went wrong")
            }
        })
    }
 
    
    
    func startPoint(completion: @escaping ( _ success: Bool, _ roomId: String) -> ())  {
        mazeManager.fetchStartRoom(callback: {
            result in
            if result.1 != nil {
                print("Some error is here 0")
                completion(false, "")
                return
            }
            if result.0 != nil {
                let json = JSON(data: result.0!)
//                print(json)
                if json["id"].stringValue.length > 0 {
                    completion(true, json["id"].stringValue)
                    return
                }
            }
            print("Some error is here 2")
            completion(false, "")
        })
    }
    
    
    func openARoom(room: RoomToDownload)  {
        if matrix[room.positionX][room.positionY] != nil {
            openNextRoom()
            return
        }
        if room.needToUnlock {
            unlockRoom(room: room)
        } else {
            fetchRoom(room: room)
        }
    }
    
    
    func openNextRoom() {
//        print("NEXT room!")
        if self.roomsToDownload.count > 0 {
            let newRoom = self.roomsToDownload.remove(at: 0)
            openARoom(room: newRoom)
        } else {
            print("All rooms were open in total time: \(Date().timeIntervalSince1970 - startTime) sec")
            matrix =  matrix.cutEmptyData()
            matrix.debugPrint()
            collection.reloadData()
        }
    }
    
    
    
    
    func unlockRoom(room: RoomToDownload)  {
        //IN CASE IF THERE IS A MORE COMPLEX WAY TO UNLOCK DOORS IN FUTURE
//        print("room was locked")
        let newRoom = RoomToDownload(id: mazeManager.unlockRoom(withLock: room.id), positionX: room.positionX, positionY: room.positionY, needToUnlock: false)
        fetchRoom(room: newRoom)
    }
    
    
    func fetchRoom(room: RoomToDownload)  {
        mazeManager.fetchRoom(withIdentifier: room.id, callback: {
            result in
            if result.1 != nil {
                print("Some error is here 1")
                return
            }
//            print("HERE is the room")
            if result.0 != nil {
                let json = JSON(data: result.0!)
//                print(json)
//                print(json["tileUrl"].stringValue)

                if json["rooms"]["east"]["room"].stringValue.length > 0 {
                    self.roomsToDownload.append(RoomToDownload(id: json["rooms"]["east"]["room"].stringValue, positionX: room.positionX, positionY: room.positionY + 1, needToUnlock: false))
                } else if json["rooms"]["east"]["lock"].stringValue.length > 0 {
                    self.roomsToDownload.append(RoomToDownload(id: json["rooms"]["east"]["lock"].stringValue, positionX: room.positionX, positionY: room.positionY + 1, needToUnlock: true))
                } else  {
                    self.matrix[room.positionX][room.positionY + 1] =  MazeCellData()
                }
                
                if json["rooms"]["west"]["room"].stringValue.length > 0 {
                    self.roomsToDownload.append(RoomToDownload(id: json["rooms"]["west"]["room"].stringValue, positionX: room.positionX, positionY: room.positionY - 1, needToUnlock: false))
                    
                } else if json["rooms"]["west"]["lock"].stringValue.length > 0 {
                    self.roomsToDownload.append(RoomToDownload(id: json["rooms"]["west"]["lock"].stringValue, positionX: room.positionX, positionY: room.positionY - 1, needToUnlock: true))
                } else  {
                    self.matrix[room.positionX][room.positionY - 1] =  MazeCellData()
                }
                
                if json["rooms"]["north"]["room"].stringValue.length > 0 {
                    self.roomsToDownload.append(RoomToDownload(id: json["rooms"]["north"]["room"].stringValue, positionX: room.positionX + 1, positionY: room.positionY, needToUnlock: false))
                    
                } else if json["rooms"]["north"]["lock"].stringValue.length > 0 {
                    self.roomsToDownload.append(RoomToDownload(id: json["rooms"]["north"]["lock"].stringValue, positionX: room.positionX + 1, positionY: room.positionY, needToUnlock: true))
                } else  {
                    self.matrix[room.positionX + 1][room.positionY] =  MazeCellData()
                }
                
                if json["rooms"]["south"]["room"].stringValue.length > 0 {
                    self.roomsToDownload.append(RoomToDownload(id: json["rooms"]["south"]["room"].stringValue, positionX: room.positionX - 1, positionY: room.positionY, needToUnlock: false))
                    
                } else if json["rooms"]["south"]["lock"].stringValue.length > 0 {
                    self.roomsToDownload.append(RoomToDownload(id: json["rooms"]["south"]["lock"].stringValue, positionX: room.positionX - 1, positionY: room.positionY, needToUnlock: true))
                } else  {
                    self.matrix[room.positionX - 1][room.positionY] =  MazeCellData()
                }
                self.matrix[room.positionX][room.positionY] =  MazeCellData(id: json["id"].stringValue, image: json["tileUrl"].stringValue)
            }
            self.openNextRoom()
        })
    }
    
    
    
    
}


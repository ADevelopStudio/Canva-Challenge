//
//  ViewController.swift
//  Canva-Challenge
//
//  Created by Dmitrii Zverev on 8/2/17.
//  Copyright © 2017 Dmitrii Zverev. All rights reserved.
//

import UIKit
import KVNProgress

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
        let collectionWidth = UIScreen.main.bounds.width - 56
        let width = collectionWidth / CGFloat(self.matrix[indexPath.section].count)
//        to scale maze on collection view
//        let height = collectionWidth / CGFloat(self.matrix.count)
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 0)
    }

}

class ViewController: UIViewController {
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var generatingIndicator: AASquaresLoading!

    let mazeManager = MazeManager()
    var matrix = [[MazeCellData?]]()
    var roomsToDownload = Array<RoomToDownload>()
    var startTime: Double = 0

    var isGeneratingInProgress = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.delegate = self
        collection.dataSource = self
        collection.isScrollEnabled = false
        collection.backgroundColor = .clear
    }
    
    
    
    func generateEmptyArray(size: Int) -> [[MazeCellData?]]  {
        var newMatrix = [[MazeCellData?]]()
        for _ in 0..<size {
            var arrayRow = [MazeCellData?]()
            for _ in 0..<size {
                arrayRow.append(nil)
            }
            newMatrix.append(arrayRow)
        }
        return newMatrix
    }
    
    
    @IBAction func genaratePressed(_ sender: Any) {
        if isGeneratingInProgress {
            let sheet = UIAlertController(title: "Maze generating in progress.", message: "Do you want to stop it?", preferredStyle: .alert)
            sheet.addAction(UIAlertAction(title: "Stop", style: .destructive, handler: { _ in
                self.generatingIndicator.isHidden = true
                self.isGeneratingInProgress = false
            }))
            sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(sheet, animated: true, completion: nil)
        } else {
            startGeneratingMaze()
        }
    }
    
    
    func startGeneratingMaze() {
        isGeneratingInProgress = true
        generatingIndicator.isHidden = false
        roomsToDownload = []
        matrix = generateEmptyArray(size: 500)
        collection.isHidden = true
        startTime = Date().timeIntervalSince1970
        openFirstRoom(completion: {
            success, roomId in
            if success {
                self.roomsToDownload.append(RoomToDownload(id: roomId, positionX: 250, positionY: 250, needToUnlock: false))
                self.openNextRoom()
            } else {
                KVNProgress.showError(withStatus: "Something went wrong")
            }
        })
    }
     
    
    func openFirstRoom(completion: @escaping ( _ success: Bool, _ roomId: String) -> ())  {
        mazeManager.fetchStartRoom(callback: {
            result in
            if result.1 != nil {
                print("Some error is here 0")
                print(result.1!)
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
        if room.positionX < 0 || room.positionY < 0 || room.positionX > matrix.count - 1 || room.positionY > matrix.count - 1 {
            //THE ROOM IS OUT OF MATRIX RANGE
            isGeneratingInProgress = false
            openNextRoom()
            return
        }
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
        if !self.isGeneratingInProgress { //WAS Stoped by user
            DispatchQueue.main.async(){
                KVNProgress.showError(withStatus: "Stoped")
            }
            return
        }
        if self.roomsToDownload.count > 0 {
            let newRoom = self.roomsToDownload.remove(at: 0)
            openARoom(room: newRoom)
        } else {
            print("All rooms were open in total time: \(Date().timeIntervalSince1970 - startTime) sec")
            matrix =  matrix.cutEmptyData()
            matrix.debugPrint()
            self.isGeneratingInProgress = false
            DispatchQueue.main.async(){
                KVNProgress.showSuccess(withStatus: "All rooms were open in total time: \(Int(Date().timeIntervalSince1970 - self.startTime)) sec")
                self.generatingIndicator.isHidden = true
                self.collection.isHidden = false
                self.collection.isScrollEnabled = self.matrix.count > 0 && self.matrix.count > self.matrix.first!.count
                self.collection.reloadData()
            }
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
                self.isGeneratingInProgress = false
                //ERROR LOADING ROOM ? need to investigate
                print("ERROR LOADING ROOM ? need to investigate tag: 1")
                print(result.1!)
            }
            if result.0 != nil {
                let json = JSON(data: result.0!)
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
            } else {
                //ERROR LOADING ROOM ? need to investigate
                print("ERROR LOADING ROOM ? need to investigate tag: 2")
                self.isGeneratingInProgress = false
            }
            self.openNextRoom()
        })
    }
    
    
    
    
}


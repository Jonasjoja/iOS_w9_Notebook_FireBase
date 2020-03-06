//
//  CloudStorage.swift
//  FirebaseHelloWorld
//
//  Created by admin on 28/02/2020.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class CloudStorage{
    
    //List
    private static var list = [Note]()
    //Reference to entire db
    private static let db = Firestore.firestore()
    private static let storage = Storage.storage() //get instance of storage
    private static let notes = "notes"
    
    
    static func downloadImage(name:String, vc:ViewController) //method to download img
    {
        let imgRef = storage.reference(withPath: name) //Ref to specific img
        imgRef.getData(maxSize: 4000000) { (data, error) in
            if error == nil {
                print("success downloading img")
                //Set image using viewcontroller
                let img = UIImage(data: data!)
                DispatchQueue.main.async { //tells threads that "do it when u have time"
                    vc.imageView.image = img //to avoid interfering with main thread
                }
            } else {
                print("error downloading\(error.debugDescription)")
            }
            
            
        }
        
    }
    
    //func listener, checks database continously
    static func startListener(tableView:UITableView){ //Param so tableview can get it
        print("starting listener")
        db.collection(notes).addSnapshotListener(){ (snap, error) in
            if error == nil{
                self.list.removeAll() //clears all
                for note in snap!.documents {
                    let map = note.data()
                    let head = map["head"] as! String
                    let body = map["body"] as! String
                    let newNote = Note(id: note.documentID, head: head, body: body)
                    self.list.append(newNote)
                }
                DispatchQueue.main.async { //Precaution, to reload data
                    tableView.reloadData()
                }
            }
        }
        
    }
    
    //Read func
    static func readNotes(){
        db.collection(notes).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("error getting doc")
            } else {
                for document in querySnapshot!.documents {
                    document.data()
                }
            }
            
        }
    }
    
    //getnote at
    static func getNoteAt(index:Int) -> Note{
        return list[index]
    }
    
    //Create func
    static func createNote(head:String,body:String){
        //Ref to database
        let docRef = db.collection(notes).document()
        var map = [String:String]()
        map["head"] = head
        map["body"] = body
        docRef.setData(map)
        
    }
    
    //Delete func
    static func deleteNote(id:String){
        //Reference to the database, "notes" and passing it the specificed document id
        let docRef = db.collection(notes).document(id)
        docRef.delete()
    }
    //Update func, index, head, body
    static func updateNote(index:Int,head:String,body:String){
        //get the id
        let note = list[index]
        let docRef = db.collection(notes).document(note.id)
        //Creates a new map, key & value are string
        var map = [String:String]()
        map["head"] = head
        map["body"] = body
        docRef.setData(map)
        
    }
    
    static func getSize() -> Int
    {
        return list.count
    }
    
    
    
}

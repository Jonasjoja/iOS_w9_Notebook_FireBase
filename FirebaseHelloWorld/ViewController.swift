//
//  ViewController.swift
//  FirebaseHelloWorld
//
//  Created by admin on 28/02/2020.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var images = [String]() //Array holds image names
    
    
    @IBOutlet weak var headline: UITextField!
    @IBOutlet weak var body: UITextView! //Connection to body
    var rowNumber = 0 //Initialize a rownumber
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Use rownumber to get right noteobj
        var note = CloudStorage.getNoteAt(index: rowNumber)
        headline.text = note.head //sets the text
        body.text = note.body
        
        if note.imageid != "empty" { //Checks if there is an image
            CloudStorage.downloadImage(name: note.imageid, vc: self)
        }
        
      //  CloudStorage.downloadImage(name: note.imageid, vc: <#T##ViewController#>)
        
     //   CloudStorage.readNotes()
        
        //Delete
         // CloudStorage.deleteNote(id: "DyOA8jpUn1X82dNNS62r")
        //Update
        //CloudStorage.updateNote(index: 0, head: "updated headline", body: "updated body")
        //Create
       // CloudStorage.createNote(head: "New note!", body: "YAAA")
    }

    @IBAction func downloadBtnPressed(_ sender: Any) {
        let image = images.randomElement() ?? "picture1.jpg"
        //Calls download img and prints success
        CloudStorage.downloadImage(name: image, vc:self)

        
    }

}

//
//  ViewController.swift
//  FirebaseHelloWorld
//
//  Created by admin on 28/02/2020.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var images = ["picture1.jpg","picture2.jpg","picture3.jpg","picture4.jpg","picture5.jpg"] //Array holds image names
    private var imgTitle : String = ""
    
    
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
           // CloudStorage.createNote(head: "Hej min ven", body: "sker der G")
        }
        
    }

    @IBAction func downloadBtnPressed(_ sender: Any) {
        let image = images.randomElement()!
        print(images.count)
        //Calls download img and prints success
        CloudStorage.downloadImage(name: image, vc:self)

        
    }

    @IBAction func uploadImgBtn(_ sender: Any) {
    pickImage()
    }
    
    
    
    @IBAction func saveBtnPressed(_ sender: Any) {
       uploadImgToDb(imgData: (imageView.image?.pngData())!)
       
    }
    
    @IBAction func saveNoteBtn(_ sender: Any) {
         CloudStorage.updateNote(index: rowNumber, head: headline.text!, body: body.text)
    }
    
    @IBAction func deleteNoteBtn(_ sender: Any) {
        CloudStorage.deleteNote(index: rowNumber)
    }
    
}

extension ViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate { //Moved to ext. needs imgpickcondel and navcondel

    func pickImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false// allows editting
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage? //to store picked img
        if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            selectedImageFromPicker = originalImage
            imageView.image = selectedImageFromPicker //Sets the selected image on page
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Canceled") //whatever to do if cancel
        dismiss(animated: true, completion: nil) //Dismisses if cancel
    }
    
    func uploadImgToDb(imgData:Data){
               let alert = UIAlertController(title: "Image picked!", message: "Choose a name for it", preferredStyle: UIAlertController.Style.alert)
               alert.addTextField { (imgName:UITextField) in
                   imgName.placeholder = "Insert title here"
               }
               alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                   let txtfield = alert.textFields![0]
                   let imgName = txtfield.text!
                   self.images.append(imgName)//Add to array of img names
                       CloudStorage().uploadImageData(data: imgData, serverFileName: imgName) { (isSuccess, url) in
                           print("uploadImageData: \(isSuccess), \(String(describing: url))")
                               }
                           }))
               //Cancel action
               alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
               self.present(alert,animated: true,completion: nil)
    }
}

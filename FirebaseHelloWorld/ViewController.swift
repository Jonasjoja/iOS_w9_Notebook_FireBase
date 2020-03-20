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
    var images = [String]() //Array holds image names
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
        }
        
    }

    @IBAction func downloadBtnPressed(_ sender: Any) {
        let image = images.randomElement() ?? "picture1.jpg"
        //Calls download img and prints success
        CloudStorage.downloadImage(name: image, vc:self)

        
    }

    @IBAction func uploadImgBtn(_ sender: Any) {
    
    
    }
    
    
    
    @IBAction func saveBtnPressed(_ sender: Any) {
    
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
        let alert = UIAlertController(title: "Image picked!", message: "Choose a name for it", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField { (imgName:UITextField) in
            imgName.placeholder = "Insert title here"
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            let txtfield = alert.textFields![0]
            let imgName = txtfield.text! + ".jpg" //cheap fix
            
            if let data = selectedImageFromPicker?.pngData() { // convert your UIImage into Data object using png representation
                CloudStorage().uploadImageData(data: data, serverFileName: imgName) { (isSuccess, url) in
                    print("uploadImageData: \(isSuccess), \(String(describing: url))")
                        }
                    }
        }))
        //Cancel action
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert,animated: true,completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Canceled") //whatever to do if cancel
        dismiss(animated: true, completion: nil) //Dismisses if cancel
    }
}

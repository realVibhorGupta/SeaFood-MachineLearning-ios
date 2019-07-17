//
//  ViewController.swift
//  SeaFood
//
//  Created by Vibhor Gupta on 2/18/19.
//  Copyright © 2019 Vibhor Gupta. All rights reserved.
//
import UIKit
import CoreML
import Vision

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    let imagePicker = UIImagePickerController()
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Answer"
        // Do any additional setup after loading the view, typically from a nib.
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
    }

    @IBAction func cameraButton(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
        imageView.image = userPickedImage

            guard let ciImage = CIImage(image: userPickedImage ) else {
                fatalError("Something happened !! Could Not Convert Image")
            }

            detect(image: ciImage)
        }

        imagePicker.dismiss(animated: true, completion: nil)
    }

    func detect(image : CIImage){

        //Load the Model
        guard let model =  try? VNCoreMLModel(for: Inceptionv3().model) else{
            fatalError("Loading CoreModel Failed")
        }

        //Send the model For Processing
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results =  request.results   else {
                fatalError("Somthing Went Wrong in sending  request")
            }
         //   print(results)

            //This Will Check the result and change the UI Accordingly After getting the result/Response
            if let  firstResult = results.first {
                if (firstResult as AnyObject).identifier.contains("hotdog"){
                    self.navigationItem.title = "Hot Dog!!"
                }else{
                    self.navigationItem.title = "Not a Hot Dog!!"
                }
            }
        }

        //Handle The Image Recognition
        let handler  = VNImageRequestHandler(ciImage: image )

        do{
        try handler.perform([request])

        }catch{
            print(error)
        }


    }

}


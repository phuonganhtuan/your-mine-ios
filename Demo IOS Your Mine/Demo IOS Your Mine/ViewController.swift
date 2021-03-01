//
//  ViewController.swift
//  Demo IOS Your Mine
//
//  Created by Phương Anh Tuấn on 28/02/2021.
//

import UIKit
import CoreData
import WidgetKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var buttonSaveFemaleName: UIButton!
    @IBOutlet weak var buttonSaveMaleName: UIButton!
    @IBOutlet weak var editFemaleName: UITextField!
    @IBOutlet weak var imageFemale: UIImageView!
    @IBOutlet weak var imageMale: UIImageView!
    @IBOutlet weak var editMaleName: UITextField!
    @IBOutlet weak var buttonTime: UIButton!
    @IBAction func buttonBack(_ sender: Any) {
    }
    
    private var model: YourMineModel = YourMineModel()
    
    var selectingImageIndex = 0
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        initData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let dateMillis = UserDefaults.standard.integer(forKey: "date")
        
        let calendar = Calendar.current

        let date1 = Date(timeIntervalSince1970: (Double(dateMillis) / 1000.0))

        let date2 = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"

        let components = calendar.dateComponents([.day], from: date1, to: date2)
        
        buttonTime.setTitle(String(components.day ?? 0), for: .normal)
        UserDefaults(suiteName:"group.pat.yourmine")?.set(String(components.day ?? 0), forKey: "dayCount")
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    private func initData() {
        
        let maleName = UserDefaults.standard.string(forKey: "maleName")
        let femaleName = UserDefaults.standard.string(forKey: "femaleName")
        let maleImage = UserDefaults.standard.string(forKey: "maleImage") ?? ""
        let femaleImage = UserDefaults.standard.string(forKey: "femaleImage") ?? ""
        let dateMillis = UserDefaults.standard.integer(forKey: "date")
        editMaleName.text = maleName
        editFemaleName.text = femaleName
        
        let calendar = Calendar.current

        let date1 = Date(timeIntervalSince1970: (Double(dateMillis) / 1000.0))

        let date2 = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"

        let components = calendar.dateComponents([.day], from: date1, to: date2)
        
        buttonTime.setTitle(String(components.day ?? 0), for: .normal)
        
        let maleImageDecoded : Data? = Data(base64Encoded: maleImage, options: .ignoreUnknownCharacters) ?? nil
        if maleImageDecoded != nil {
            let decodedimage = UIImage(data: maleImageDecoded!)
            imageMale.image = decodedimage
        }
    
        
        let femaleImageDecoded : Data? = Data(base64Encoded: femaleImage, options: .ignoreUnknownCharacters) ?? nil
        
        if femaleImageDecoded != nil {
            let decodedFemaleimage = UIImage(data: femaleImageDecoded!)
            imageFemale.image = decodedFemaleimage
        }
    }
    
    private func initViews() {
        imageFemale.layer.cornerRadius = 24
        imageMale.layer.cornerRadius = 24
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
    }
   
    @IBAction func selectDateTime(_ sender: Any) {
        print("Select time clicked!")
        performSegue(withIdentifier: "datePickerSeque", sender: self)
    }
    
    @IBAction func selectMaleImage(_ sender: Any) {
        print("Select male image clicked!")
        selectingImageIndex = 0
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func selectFemaleImage(_ sender: Any) {
        print("Select female image clicked!")
        selectingImageIndex = 1
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            let imageAsString = pickedImage.pngData()?.base64EncodedString()
            let imageAsStringSmall = pickedImage.resizeImage(targetSize: CGSize(width: pickedImage.size.width*0.1, height: pickedImage.size.height*0.1)).pngData()?.base64EncodedString()
            if selectingImageIndex == 0 {
                imageMale.image = pickedImage
                model.maleImage = imageAsString ?? ""
                UserDefaults.standard.set(imageAsString, forKey: "maleImage")
                UserDefaults(suiteName:"group.pat.yourmine")?.set(imageAsStringSmall, forKey: "maleImage")
            } else {
                imageFemale.image = pickedImage
                model.femaleImage = imageAsString ?? ""
                UserDefaults.standard.set(imageAsString, forKey: "femaleImage")
                UserDefaults(suiteName:"group.pat.yourmine")?.set(imageAsStringSmall, forKey: "femaleImage")
            }
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    @IBAction func saveMaleName(_ sender: Any) {
        model.maleName = editMaleName.text ?? ""
        UserDefaults.standard.set(editMaleName.text ?? "", forKey: "maleName")
        UserDefaults(suiteName:"group.pat.yourmine")?.set(editMaleName.text ?? "", forKey: "maleName")
        
    }
    
    @IBAction func saveFemaleName(_ sender: Any) {
        model.femaleName = editFemaleName.text ?? ""
        UserDefaults.standard.set(editFemaleName.text ?? "", forKey: "femaleName")
        UserDefaults(suiteName:"group.pat.yourmine")?.set(editFemaleName.text ?? "", forKey: "femaleName")
    }
}

extension UIImage {
  func resizeImage(targetSize: CGSize) -> UIImage {
    let size = self.size
    if(size.width < 300 && size.height < 300) {
        return self
    }
    let scale = size.width / size.height
    if scale <= 0 {
        let widthRatio  = scale*300  / size.width
        let heightRatio = 300 / size.height
        let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    } else {
        let widthRatio  = 300  / size.width
        let heightRatio = (300/scale) / size.height
        let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
  }
}

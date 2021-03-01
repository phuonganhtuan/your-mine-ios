//
//  DatePickerViewController.swift
//  Demo IOS Your Mine
//
//  Created by Phương Anh Tuấn on 28/02/2021.
//

import Foundation
import UIKit

class DatePickerViewController: UIViewController {
    
    @IBOutlet weak var buttonSaveDate: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = UIDatePickerStyle.inline
        }
        let dateMillis = UserDefaults.standard.integer(forKey: "date")
        let date1 = Date(timeIntervalSince1970: (Double(dateMillis) / 1000.0))
        datePicker.date = date1
    }
    
    @IBAction func saveDate(_ sender: Any) {
        print("cancel clicked!")
        print(datePicker.date.timeIntervalSince1970 * 1000)
        UserDefaults.standard.set(datePicker.date.timeIntervalSince1970 * 1000, forKey: "date")
        UserDefaults(suiteName:"group.pat.yourmine")?.set(datePicker.date.timeIntervalSince1970 * 1000, forKey: "date")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backToMain(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

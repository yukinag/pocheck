//
//  WorkSpaceViewController.swift
//  KeepYourMind
//
//  Created by Yuki Nagashima on 2019/01/04.
//  Copyright © 2019 yuki-n.inc. All rights reserved.
//

import UIKit

class WorkSpaceViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet var sampleTextField: UITextField!
    var samplePicker = UIPickerView()
    let lists = ["test1", "test2", "test3"]
    
    @IBOutlet var sampleDateLabel: UILabel!
    var sampleDatePicker = UIDatePicker()
    
    var tempTime: String = ""
    var setTime: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        samplePicker.dataSource = self
        samplePicker.delegate = self
        samplePicker.showsSelectionIndicator = true
        
        let toolbar = UIToolbar(frame:CGRect(x : 0, y : 0, width : 0 , height : 35))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(WorkSpaceViewController.done))
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(WorkSpaceViewController.cancel))
        
        toolbar.setItems([doneItem, cancelItem], animated: true)
        
        self.sampleTextField.inputView = samplePicker
        self.sampleTextField.inputAccessoryView = toolbar
        
        
        /*ここからdatepicker*/
        sampleDateLabel.text = getNowTime()

        
    }

    //現在時刻の取得
    func getNowTime() -> String {
        let nowTime: NSDate = NSDate()
        //整形
        let format = DateFormatter()
        format.dateFormat = "HH:mm"
        let nowTimeStr = format.string(from: nowTime as Date)
        return nowTimeStr
    }
    
    /*datePickerここまで*/
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return lists.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return lists[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.sampleTextField.text = lists[row]
    }
    
    @objc func done() {
        self.sampleTextField.endEditing(true)
    }
    
    @objc func cancel() {
        self.sampleTextField.text = ""
        self.sampleTextField.endEditing(true)
    }
    

}

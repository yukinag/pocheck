
//
//  taskDetailViewController.swift
//  KeepYourMind
//
//  Created by Yuki Nagashima on 2019/01/01.
//  Copyright © 2019 yuki-n.inc. All rights reserved.
//

import UIKit

class taskDetailViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet var taskDetailTableView: UITableView!
    
    var indexLabel = ["", "いつから", "いつまで", "頻度", "どのくらい","何をする", ""]
    var placeHolders = ["目標/タスクを入力", "日付を入力", "日付を入力","(例)毎日","（例）15分", "入力", "入力"]
    
    //timing Picker
    var timingTextField = UITextField()
    var timingPicker = UIPickerView()
    var memoContentView = UITextView()
    let timingOption = ["設定しない","毎日","毎週","毎月"]
    
    //期間picker
    var termDatePicker = UIDatePicker()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskDetailTableView.dataSource = self
        memoContentView.delegate = self
        
        taskDetailTableView.tableFooterView = UIView()
        
        configurePickerView()
        configureCell()
    }
    
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
        configureObserver()
        
    }
    
    /* キーボードに隠れないセル */
    func configureObserver() {
        let notification = NotificationCenter.default
        //キーボード表示
        notification.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        //キーボード隠す
        notification.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    //キーボード
    @objc func keyboardWillShow(notification: Notification?) {
        //セル指定

        let memoCell = taskDetailTableView.cellForRow(at: IndexPath(row: 6, section: 0)) as! TaskMemoTableViewCell
        
        if memoCell.memoContent.isFirstResponder == true {
            let rect = (notification?.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue )?.cgRectValue
            let duration: TimeInterval? = notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
            UIView.animate(withDuration: duration!, animations: { () in
                let transform = CGAffineTransform(translationX: 0, y: -(rect?.size.height)!)
                self.view.transform = transform
            })
        }
    }
    
    
    @objc func keyboardWillHide(notification: Notification?) {
        let duration: TimeInterval? = notification?.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: { () in
            
            self.view.transform = CGAffineTransform.identity
        })
    }
 
    private func configurePickerView() {
        /* pikerビュー関連*/
        timingPicker.dataSource = self
        timingPicker.delegate = self
        timingPicker.showsSelectionIndicator = true
        
        //編集ツールバー
        let pickerToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(taskDetailViewController.done))
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(taskDetailViewController.cancel))
        //アイテムをセット
        pickerToolBar.setItems([doneItem, cancelItem], animated: true)
        //テキストフィールドにセット
        self.timingTextField.inputView = timingPicker
        self.timingTextField.inputAccessoryView = pickerToolBar
        //pickerビューのタグをセット（数字はなんでもいいけど。。）
        timingPicker.tag = 3
        //メモにもツールバーをセット
        memoContentView.delegate = self
        self.memoContentView.inputAccessoryView = pickerToolBar
        
    }

    /*各セルを登録*/
    func configureCell() {
        //タイトルnibの設定
        let nib = UINib(nibName: "TaskTitleTableViewCell", bundle: Bundle.main)
        //タイトルセルの登録
        taskDetailTableView.register(nib, forCellReuseIdentifier: "TaskTitleCell")
        
        //タスク情報nibの設定
        let nibForInfo = UINib(nibName: "TaskInfoTableViewCell", bundle: Bundle.main)
        //タスクじ情報のセルの登録
        taskDetailTableView.register(nibForInfo, forCellReuseIdentifier: "TaskInfoCell")
        
        //memoの設定
        let nibForMemo = UINib(nibName: "TaskMemoTableViewCell", bundle: Bundle.main)
        //memoのセルの登録
        taskDetailTableView.register(nibForMemo, forCellReuseIdentifier: "MemoCell")
        
        //タイミングの設定
        let nibForTiming = UINib(nibName: "TaskTimingOptionTableViewCell", bundle: Bundle.main)
        //タイミングセルの登録
        taskDetailTableView.register(nibForTiming, forCellReuseIdentifier: "TimingCell")
        
        //DatePickerつきセルの設定
        let nibForDatePicker = UINib(nibName: "TaskDatePickerTableViewCell", bundle: Bundle.main)
        //登録
        taskDetailTableView.register(nibForDatePicker, forCellReuseIdentifier: "DatePickerCell")
    }
    
    /*Saveボタンのアクション*/
    @IBAction  func didTapSave() {
        // Title
        let titleCell = taskDetailTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TaskTitleTableViewCell
        let userDefault = UserDefaults.standard
        userDefault.set(titleCell.taskTitle.text, forKey: "titleDefault")
        userDefault.synchronize()
        
        // Start
        let startCell = taskDetailTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! TaskDatePickerTableViewCell
        let startDateUserDefault = UserDefaults.standard
        startDateUserDefault.set(startCell.dateTextField.text, forKey: "startDate")
        startDateUserDefault.synchronize()
        
        //終了日
        let endCell = taskDetailTableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! TaskDatePickerTableViewCell
        let endDateUserDefault = UserDefaults.standard
        endDateUserDefault.set(endCell.dateTextField.text, forKey: "endDate")
        endDateUserDefault.synchronize()
        
        //頻度
        let timingCell = taskDetailTableView.cellForRow(at: IndexPath(row: 3, section: 0)) as! TaskTimingOptionTableViewCell
        let timingUserDefault = UserDefaults.standard
        timingUserDefault.set(timingCell.timingText.text, forKey: "timing")
        timingUserDefault.synchronize()
        
        //タイミング
        let whenCell = taskDetailTableView.cellForRow(at: IndexPath(row: 4, section: 0)) as! TaskInfoTableViewCell
        let whenUserDefault = UserDefaults.standard
        whenUserDefault.set(whenCell.taskTextField.text, forKey: "when")
        whenUserDefault.synchronize()
        
        //何を
        let whatCell = taskDetailTableView.cellForRow(at: IndexPath(row: 5, section: 0)) as! TaskInfoTableViewCell
        let whatUserDefault = UserDefaults.standard
        whatUserDefault.set(whatCell.taskTextField.text, forKey: "what")
        whatUserDefault.synchronize()
     
        //メモ
        let memoCell = taskDetailTableView.cellForRow(at: IndexPath(row: 6, section: 0)) as! TaskMemoTableViewCell
        let memoUserDefault = UserDefaults.standard
        memoUserDefault.set(memoCell.memoContent.text, forKey: "memo")
        memoUserDefault.synchronize()
        print(memoCell.memoContent.text)
        print("thisismemo")
        
        //アラートのひょうじ
        let alert = UIAlertController(title: "完了", message: "タスク内容が保存されました", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default){ (action) in
            //OK押した時のアクション
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    /* date picker 関連の処理 */
    @objc func done() {
        self.timingTextField.endEditing(true)
        print("success")
        taskDetailTableView.reloadData()
    }
    
    @objc func doneStartDate() {
        let datePickerCell = taskDetailTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! TaskDatePickerTableViewCell
        let dateFormatter = DateFormatter()
        // 持ってくるデータのフォーマットを設定
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale    = NSLocale(localeIdentifier: "ja_JP") as Locale
        dateFormatter.dateStyle = DateFormatter.Style.medium
        // textFieldに選択した日付を代入
        datePickerCell.dateTextField.text = dateFormatter.string(from: termDatePicker.date)
        // キーボードを閉じる
        self.view.endEditing(true)
    }
    
    @objc func doneEndDate() {
        let datePickerCell = taskDetailTableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! TaskDatePickerTableViewCell
        let dateFormatter = DateFormatter()
        // 持ってくるデータのフォーマットを設定
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale    = NSLocale(localeIdentifier: "ja_JP") as Locale
        dateFormatter.dateStyle = DateFormatter.Style.medium
        // textFieldに選択した日付を代入
        datePickerCell.dateTextField.text = dateFormatter.string(from: termDatePicker.date)
        // キーボードを閉じる
        self.view.endEditing(true)
    }
    
    @objc func cancel() {
        self.timingTextField.text = ""
        self.timingTextField.endEditing(true)
        taskDetailTableView.reloadData()
    }
    
    //キーボード操作
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
    //ud読み込み
    func loadData() {
        // load
        //タイトル
        let title = UserDefaults.standard.string(forKey: "titleDefault")
        let titleCell = taskDetailTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TaskTitleTableViewCell
        titleCell.taskTitle.text = title
        
        
        //開始日
        let startDate = UserDefaults.standard.string(forKey: "startDate")
        let startDateCell = taskDetailTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! TaskDatePickerTableViewCell
        startDateCell.dateTextField.text = startDate
        
        //終了日
        let endDate = UserDefaults.standard.string(forKey: "endDate")
        let endDateCell = taskDetailTableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! TaskDatePickerTableViewCell
        endDateCell.dateTextField.text = endDate
        
        //頻度
        let timing = UserDefaults.standard.string(forKey: "timing")
        let timingCell = taskDetailTableView.cellForRow(at: IndexPath(row: 3, section: 0)) as! TaskTimingOptionTableViewCell
        timingCell.timingText.text = timing
        
        
        //いつやるのか
        let when = UserDefaults.standard.string(forKey: "when")
        let whenCell = taskDetailTableView.cellForRow(at: IndexPath(row: 4, section: 0)) as!TaskInfoTableViewCell
        whenCell.taskTextField.text = when
        
        //何を
        let what = UserDefaults.standard.string(forKey: "what")
        let whatCell = taskDetailTableView.cellForRow(at: IndexPath(row: 5, section: 0)) as! TaskInfoTableViewCell
        whatCell.taskTextField.text = what
  
        //メモ内容
        let memo = UserDefaults.standard.string(forKey: "memo")
        let memoCell = taskDetailTableView.cellForRow(at: IndexPath(row: 6, section: 0)) as! TaskMemoTableViewCell
        memoCell.memoContent.text = memo
    }
}

// MARK: - TableView
extension taskDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    //数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let number: Int = indexLabel.count
        return number
    }
    
    //セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let titleCell = taskDetailTableView.dequeueReusableCell(withIdentifier: "TaskTitleCell") as! TaskTitleTableViewCell
            titleCell.taskTitle.delegate = self // 追加しました　delegateを登録したよ！
            titleCell.taskTitle.clearButtonMode = .whileEditing
            titleCell.taskTitle.placeholder = placeHolders[0]
            print(titleCell)
            return titleCell
            
        
        case 1:
        
            let datePickerCell = taskDetailTableView.dequeueReusableCell(withIdentifier: "DatePickerCell") as! TaskDatePickerTableViewCell
            
            termDatePicker.datePickerMode = .date
            termDatePicker.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
            
            let pickerToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
            let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(taskDetailViewController.doneStartDate))
            let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(taskDetailViewController.cancel))
            //アイテムをセット
            pickerToolBar.setItems([doneItem, cancelItem], animated: true)
        
            datePickerCell.taskIndexLabel.text = indexLabel[indexPath.row]
            datePickerCell.dateTextField.placeholder = placeHolders[1]
            datePickerCell.dateTextField.inputView = termDatePicker
            datePickerCell.dateTextField.inputAccessoryView = pickerToolBar
    
            return datePickerCell
            
        case 2:
            
            let datePickerCell = taskDetailTableView.dequeueReusableCell(withIdentifier: "DatePickerCell") as! TaskDatePickerTableViewCell
            
            termDatePicker.datePickerMode = .date
            termDatePicker.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
            
            let pickerToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
            let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(taskDetailViewController.doneEndDate))
            let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(taskDetailViewController.cancel))
            //アイテムをセット
            pickerToolBar.setItems([doneItem, cancelItem], animated: true)
            
            datePickerCell.taskIndexLabel.text = indexLabel[indexPath.row]
            datePickerCell.dateTextField.placeholder = placeHolders[1]
            datePickerCell.dateTextField.inputView = termDatePicker
            datePickerCell.dateTextField.inputAccessoryView = pickerToolBar
            
            return datePickerCell
            
            
        case 3:
            let timingCell = taskDetailTableView.dequeueReusableCell(withIdentifier: "TimingCell") as! TaskTimingOptionTableViewCell
            timingCell.taskIndexLabel.text = indexLabel[indexPath.row]
            timingCell.timingText.inputView = timingTextField.inputView
            timingCell.timingText.placeholder = placeHolders[3]
            timingCell.timingText.inputAccessoryView = timingTextField.inputAccessoryView
            return timingCell
            
        case 6:
            let memoCell = taskDetailTableView.dequeueReusableCell(withIdentifier: "MemoCell") as! TaskMemoTableViewCell
            memoCell.memoContent.delegate = self
            memoCell.memoContent.inputAccessoryView = memoContentView.inputAccessoryView
            return memoCell
            
        default:
            let cell = taskDetailTableView.dequeueReusableCell(withIdentifier: "TaskInfoCell") as! TaskInfoTableViewCell
            cell.taskTextField.delegate = self
            cell.taskIndexLabel.text = indexLabel[indexPath.row]
            cell.taskTextField.clearButtonMode = .whileEditing
            cell.taskTextField.placeholder = placeHolders[indexPath.row]
            return cell
        }
    }
}

// MARK: - PickerView
extension taskDetailViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        var number = Int()
        if pickerView.tag == 3 {
            number = 1
        }
        return number
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var number = Int()
        if pickerView.tag == 3 {
            number = timingOption.count
        }
        return number
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var option = String()
        if pickerView.tag == 3 {
            option = timingOption[row]
        }
        return option
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 3 {
            let cell = taskDetailTableView.cellForRow(at: IndexPath(row: 3, section: 0)) as! TaskTimingOptionTableViewCell
            if row != 0 {
                cell.timingText.text = timingOption[row]
            } else {
                cell.timingText.text = nil
            }
            
        } else {
            self.timingTextField.text = timingOption[row]
            taskDetailTableView.reloadData()
        }
    }
}




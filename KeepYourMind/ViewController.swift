//
//  ViewController.swift
//  KeepYourMind
//
//  Created by Yuki Nagashima on 2019/01/01.
//  Copyright © 2019 yuki-n.inc. All rights reserved.
//

import UIKit
import JTAppleCalendar

//保存済みの日付配列
var dayArray:[String] = []

class ViewController: UIViewController {
    
    let formatter = DateFormatter()
    @IBOutlet weak var CalendarView: JTAppleCalendarView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let today = formatter.string(from: now as Date)
  
        CalendarView.calendarDataSource = self
        CalendarView.calendarDelegate = self
        setUpCalendarView()
        loadData()
        CalendarView.scrollToDate(formatter.date(from: today)!)
    }
    
    /* 日にちを選択した時の処理 */
    func handleCellSelected(view: JTAppleCell?, cellState: CellState ) {
        guard  let validCell = view as? CalendarDateCell else { return }
        if cellState.isSelected {
            if validCell.dateLabel.textColor == UIColor.darkGray {
                validCell.selectedDate.isHidden = false
                //文字列に変換
                formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: Locale(identifier: "ja_JP"))
                //選ばれた日
                let theDay = formatter.string(from: cellState.date)
                //配列に追加
                dayArray.append(theDay)

            //すでに選ばれている場合は配列から削除
            } else if validCell.selectedDate.isHidden == false {
                formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: Locale(identifier: "ja_JP"))
                let theDay = formatter.string(from: cellState.date)
                if dayArray.contains( theDay ) == true{
                    dayArray.remove(at: dayArray.index(of: theDay)!)
                    //まるを消す
                    validCell.selectedDate.isHidden = true
                }
            }
        } else {
            validCell.selectedDate.isHidden = true
        }
    }
    
    //日付の色を指定（選択された日・当月・前後の月）
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CalendarDateCell else { return }
        
        if validCell.selectedDate.isHidden == false {
            //選択された日付
            if cellState.isSelected {
                validCell.dateLabel.textColor = UIColor.white
                //選択を外された日付
            } else {
                validCell.dateLabel.textColor = UIColor.darkGray
            }
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                validCell.dateLabel.textColor = UIColor.darkGray
            } else {
                validCell.dateLabel.textColor = UIColor.lightGray
            }
            
            formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: Locale(identifier: "ja_JP"))
            let theDay = formatter.string(from: cellState.date)
            
            if dayArray.contains(theDay) == true {
                validCell.selectedDate.isHidden = false
                validCell.dateLabel.textColor = UIColor.white
            } else {
                validCell.selectedDate.isHidden = true
            }
        }
    }
    
    /* 起動した時に保存データを読み込み */
    func loadData() {
        let udDay2 = UserDefaults.standard
        let input = udDay2.object(forKey: "selectedDay")
        if input != nil {
            dayArray = input as! [String]
            CalendarView.reloadData()
        }
    }
    
    
    func setUpCalendarView() {
        CalendarView.minimumLineSpacing = 0
        CalendarView.minimumInteritemSpacing = 0
        //月と年の表示
        CalendarView.visibleDates { (visibleDates) in
            let date = visibleDates.monthDates.first!.date
            
            self.formatter.dateFormat = "yyyy"
            self.yearLabel.text = self.formatter.string(from: date)
            
            self.formatter.dateFormat = "MMMM"
            self.monthLabel.text = self.formatter.string(from: date)
        }
    }
}


extension ViewController: JTAppleCalendarViewDataSource {
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let myDateCell = cell as! CalendarDateCell
        sharedFunctionToCinfigureCell(myCustomCell: myDateCell, cellState: cellState, date: date)
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2018 01 01")!
        let endDate = formatter.date(from: "2020 04 30")!
        let paramaters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        
        return paramaters
    }
    
    func sharedFunctionToCinfigureCell(myCustomCell: CalendarDateCell, cellState: CellState, date: Date) {
        myCustomCell.backgroundColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0)
        myCustomCell.dateLabel.text = cellState.text
        
        // more code configurations
    }
}

extension ViewController: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setUpCalendarView()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "DateCell", for: indexPath) as! CalendarDateCell
        cell.dateLabel.text = cellState.text
        //押された日付だけviewのまるを表示
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        return
    }
    
    
}

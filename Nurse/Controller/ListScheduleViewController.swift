//
//  ListScheduleViewController.swift
//  Nurse
//
//  Created by An on 12/1/16.
//  Copyright © 2016 An. All rights reserved.
//

import UIKit

class ListScheduleViewController: BaseViewController {

    
    @IBOutlet var tbvSchedule: UITableView!
    
    var arrSchedule: [Schedule]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = K.TITLE_ALL_SCHEDULES
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getAllSchedule()
    }
    
    func getAllSchedule(){
        weak var weakSelf = self
        dbMan().getSchedule { (result, error) in
            if result.status == .success{
                weakSelf?.arrSchedule = result.data as! [Schedule]
                weakSelf?.tbvSchedule.reloadData()
            }
        }
    }
    
    func getPriority(priority: Int) -> String{
        if priority == K.PRIORITY_NUMBER_HIGH{
            return K.PRIORITY_HIGH
        }else if priority == K.PRIORITY_NUMBER_MEDIUM{
            return K.PRIORITY_MEDIUM
        }else if priority == K.PRIORITY_NUMBER_LOW{
            return K.PRIORITY_LOW
        }
        return ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ListScheduleViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrSchedule != nil{
            return arrSchedule.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ScheduleTableViewCell = tbvSchedule.dequeueReusableCell(withIdentifier: CELL_ID.SCHEDULE) as! ScheduleTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let schedule = arrSchedule[indexPath.row]
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        cell.lblTime.text = formatter.string(from: schedule.time as! Date)
        cell.lblDosage.text = "\(schedule.dosage!) \(schedule.dosageType!)"
        cell.lblPriority.text = getPriority(priority: Int(schedule.priority))
        cell.lblPatientName.text = "\(K.PATIENT): \((schedule.patient?.fullname)!)"
        cell.lblMedicineName.text = "\(K.MEDICINE): \((schedule.medicine?.name)!)"
        
        return cell
    }
}

extension ListScheduleViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
}

class ScheduleTableViewCell: UITableViewCell {
    
    @IBOutlet var lblPatientName:UILabel!
    @IBOutlet var lblMedicineName:UILabel!
    @IBOutlet var lblTime:UILabel!
    @IBOutlet var lblDosage:UILabel!
    @IBOutlet var lblPriority:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

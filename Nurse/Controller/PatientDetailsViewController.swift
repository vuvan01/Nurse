//
//  PatientDetailsViewController.swift
//  Nurse
//
//  Created by An on 12/6/16.
//  Copyright © 2016 An. All rights reserved.
//

import UIKit

class PatientDetailsViewController: BaseViewController {

    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblFullName: UILabel!
    @IBOutlet var lblPhone: UILabel!
    
    @IBOutlet var tbvMedication: UITableView!
    
    var patient: Patient!
    var arrSchedule: [Schedule]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = patient.fullname!
        lblEmail.text = patient.email!
        lblFullName.text = patient.fullname!
        lblPhone.text = patient.phone!
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getSchedulesForThisPatient()
    }
    
    func getSchedulesForThisPatient(){
        weak var weakSelf = self
        dbMan().getScheduleForPatient(patient: patient) { (result, error) in
            if result.status == .success{
                weakSelf?.arrSchedule = result.data as! [Schedule]
                weakSelf?.tbvMedication.reloadData()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // insert patient to the "add schedule" segue for ScheduleViewController
        if segue.identifier == SEGUE.ADD_SCHEDULE{
            let scheduleVC = segue.destination as! AddScheduleViewController
            scheduleVC.patient = patient
        }
        
        super.prepare(for: segue, sender: sender)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension PatientDetailsViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
}

extension PatientDetailsViewController: UITableViewDataSource{
    
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
        let cell: MedicineTableViewCell = tbvMedication.dequeueReusableCell(withIdentifier: CELL_ID.MEDICINE) as! MedicineTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let schedule = arrSchedule[indexPath.row]
        cell.lblName.text = schedule.medicine?.name!
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        cell.lblTime.text = formatter.string(from: schedule.time as! Date)
        
        cell.lblDosage.text = "\(schedule.dosage!) \(schedule.dosageType!)"
        cell.lblPriority.text = getPriority(priority: Int(schedule.priority))
        
        return cell
    }
}

class MedicineTableViewCell: UITableViewCell {
    
    @IBOutlet var lblName:UILabel!
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

//
//  PatientsViewController.swift
//  Nurse
//
//  Created by An on 12/6/16.
//  Copyright © 2016 An. All rights reserved.
//

import UIKit

class ListPatientViewController: BaseViewController {

    @IBOutlet var tbvPatient: UITableView!
    var arrPatient:[Patient]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getAssociatedPatients()
    }
    
    func getAssociatedPatients(){
        //weak var weakSelf = self
        if let user = dbMan().getLoggedInUser(){
            let set = user.patient!
            arrPatient = set.allObjects as! [Patient]  //NSArray

            tbvPatient.reloadData()
        }
        
        
        /*dbMan().getAssociatedPatients { (result, error) in
            if result.status == .success{
                weakSelf?.arrPatient = result.data as! [Patient]
                weakSelf?.tbvPatient.reloadData()
            }
        }*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ListPatientViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrPatient != nil{
            return arrPatient.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PatientTableViewCell = tbvPatient.dequeueReusableCell(withIdentifier: CELL_ID.PATIENT) as! PatientTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let patient = arrPatient[indexPath.row]
        cell.lblFullName.text = patient.fullname!
        
        return cell
    }
}

extension ListPatientViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: STORYBOARD_ID.PATIENT_DETAILS) as! PatientDetailsViewController
        let patient = arrPatient[indexPath.row]
        vc.patient = patient
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

class PatientTableViewCell: UITableViewCell {
    
    @IBOutlet var lblFullName:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

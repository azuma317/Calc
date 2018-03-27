//
//  SecondViewController.swift
//  Calc
//
//  Created by Azuma on 2017/05/25.
//  Copyright © 2017年 Azuma. All rights reserved.
//

import UIKit
import RealmSwift

class RecodeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var object: DataSet?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    //tableviewのrowの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getDataSet().count
    }
    
    //cellの追加
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "myCell")
        let object = getDataSet()[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: CGFloat(25))
        cell.textLabel?.text = object.name
        
        return cell
    }
    
    //cellからの画面遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        object = getDataSet()[indexPath.row]
        if object != nil{
            performSegue(withIdentifier: "angle_record", sender: nil)
        }
    }
    
    //cellのデータを消すと同時にRealmのデータも消す
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if(editingStyle == UITableViewCellEditingStyle.delete) {
            do{
                let realm = try Realm()
                try realm.write {
                    realm.delete(self.getDataSet()[indexPath.item])
                }
                tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.fade)
            }catch{
            }
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "angle_record"){
            let angleVC: RealmAngleViewController = (segue.destination as? RealmAngleViewController)!
            angleVC.obj = object
        }
    }
    
    func getDataSet() -> [DataSet]{
        
        let realm = try! Realm()
        let dataItems = realm.objects(DataSet.self)
        var names: [DataSet] = []
        
        if dataItems.count > 0 {
            for data in dataItems {
                names.append(data)
            }
        }
        return names
    }

    // Storyboadでunwind sequeを引くために必要
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        
    }
    
}


//
//  RealmAngleViewController.swift
//  Calc
//
//  Created by Azuma on 2017/05/30.
//  Copyright © 2017年 Azuma. All rights reserved.
//

import UIKit
import RealmSwift

class RealmAngleViewController: UIViewController {
    @IBOutlet weak var a: UILabel!
    @IBOutlet weak var b: UILabel!
    @IBOutlet weak var c: UILabel!
    @IBOutlet weak var angle1: UILabel!
    var obj: DataSet? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = obj?.name
        a.text = String(obj?.a ?? 0)
        b.text = String(obj?.b ?? 0)
        c.text = String(obj?.c ?? 0)
        angle1.text = String(obj?.angle1 ?? 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

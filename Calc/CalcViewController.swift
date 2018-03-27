//
//  FirstViewController.swift
//  Calc
//
//  Created by Azuma on 2017/05/25.
//  Copyright © 2017年 Azuma. All rights reserved.
//

import UIKit

class CalcViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let figure = ["直角三角形"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return figure.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = UITableViewCell(style: .default, reuseIdentifier: "myCell")
        let data = figure[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: CGFloat(35))
        cell.textLabel?.text = data
        return cell
    }
    
    //cellからの画面遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            performSegue(withIdentifier: "angle", sender: nil)
        }
    }
    
    // Storyboadでunwind sequeを引くために必要
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        
    }

}


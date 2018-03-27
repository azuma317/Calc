//
//  AngleViewController.swift
//  Calc
//
//  Created by Azuma on 2017/05/26.
//  Copyright © 2017年 Azuma. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleMobileAds

class AngleViewController: UIViewController, UITextFieldDelegate, GADInterstitialDelegate {

    @IBOutlet weak var bannerSizeView: UIView!
    @IBOutlet weak var a: UITextField!
    @IBOutlet weak var b: UITextField!
    @IBOutlet weak var c: UITextField!
    @IBOutlet weak var angle1: UITextField!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var aNum: Double = 0.0
    var bNum: Double = 0.0
    var cNum: Double = 0.0
    var angleNum1: Double = 0.0
    @IBOutlet weak var clearButton: UIButton!
    var pai = 3.14159265359
    @IBOutlet weak var saveButton: UIButton!
    
    var interstitial: GADInterstitial!
//    let interstitialADTestUnitID = "ca-app-pub-3940256099942544/4411468910"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.a.delegate = self
        self.b.delegate = self
        self.c.delegate = self
        self.angle1.delegate = self
        saveButton.isEnabled = false
        //a,b,cにdoneの追加
        self.addDoneButtonOnKeyboard()
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-9232062184502798/9902205755")
        self.interstitial.delegate = self
        self.interstitial.load(GADRequest())
        
    }
    
    //保存処理
    @IBAction func save(_ sender: UIButton) {
        aNum = Double(a.text ?? "0") ?? 0.0
        bNum = Double(b.text ?? "0") ?? 0.0
        cNum = Double(c.text ?? "0") ?? 0.0
        angleNum1 = Double(angle1.text ?? "0") ?? 0.0
        var figureName: String = ""
        
        //dialogの設定
        let alertController = UIAlertController(title: "名前を登録！", message: "図形の名前を入れてね", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            // OKを押した時入力されていたテキストを表示
            if let textFields = alertController.textFields {
                // アラートに含まれるすべてのテキストフィールドを調べる
                for textField in textFields {
                    //保存する図形の名前を入れる
                    figureName = textField.text!
                    //保存する図形の名前がないとき
                    if !(figureName == ""){
                        do{
                            let data = DataSet()
                            data.a = self.aNum
                            data.b = self.bNum
                            data.c = self.cNum
                            data.angle1 = self.angleNum1
                            data.name = figureName
                            let realm = try! Realm()
                            try realm.write{
                                realm.add(data)
                            }
                        } catch {
                        
                        }
                        DispatchQueue.main.async {
                            if self.interstitial.isReady {
                                self.interstitial.present(fromRootViewController: self)
                            }
                        }
                    }else{
                        
                    }
                }
            }
        })
        
        //textfiledの追加
        alertController.addTextField(configurationHandler: {(textField:UITextField!) -> Void in
        })
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    //returnもしくはdoneが押されたとき
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if a.resignFirstResponder() {
            aNum = Double(a.text ?? "0") ?? 0.0
            bNum = Double(b.text ?? "0") ?? 0.0
            cNum = Double(c.text ?? "0") ?? 0.0
            angleNum1 = Double(angle1.text ?? "0") ?? 0.0
            saveButton.isEnabled = false
            if !aNum.isZero && !bNum.isZero{
                calc1(num1: aNum, num2: bNum)
            }else if !aNum.isZero && !cNum.isZero{
                calc2(num1: cNum, num2: aNum)
            }else if !aNum.isZero && !angleNum1.isZero{
                calc5(num1: aNum, num2: angleNum1)
            }
        }
        if b.resignFirstResponder() {
            aNum = Double(a.text ?? "0") ?? 0.0
            bNum = Double(b.text ?? "0") ?? 0.0
            cNum = Double(c.text ?? "0") ?? 0.0
            angleNum1 = Double(angle1.text ?? "0") ?? 0.0
            saveButton.isEnabled = false
            if !bNum.isZero && !aNum.isZero{
                calc1(num1: aNum, num2: bNum)
            }else if !bNum.isZero && !cNum.isZero{
                calc3(num1: cNum, num2: bNum)
            }else if !bNum.isZero && !angleNum1.isZero{
                calc6(num1: bNum, num2: angleNum1)
            }
        }
        if c.resignFirstResponder(){
            aNum = Double(a.text ?? "0") ?? 0.0
            bNum = Double(b.text ?? "0") ?? 0.0
            cNum = Double(c.text ?? "0") ?? 0.0
            angleNum1 = Double(angle1.text ?? "0") ?? 0.0
            saveButton.isEnabled = false
            if !cNum.isZero && !aNum.isZero{
                calc2(num1: cNum, num2: aNum)
            }else if !cNum.isZero && !bNum.isZero{
                calc3(num1: cNum, num2: bNum)
            }else if !cNum.isZero && !angleNum1.isZero{
                calc8(num1: cNum, num2: angleNum1)
            }
        }
        if angle1.resignFirstResponder(){
            aNum = Double(a.text ?? "0") ?? 0.0
            bNum = Double(b.text ?? "0") ?? 0.0
            cNum = Double(c.text ?? "0") ?? 0.0
            angleNum1 = Double(angle1.text ?? "0") ?? 0.0
            saveButton.isEnabled = false
            if !aNum.isZero && !angleNum1.isZero{
                calc5(num1: aNum, num2: angleNum1)
            }else if !bNum.isZero && !angleNum1.isZero{
                calc6(num1: bNum, num2: angleNum1)
            }else if !cNum.isZero && !angleNum1.isZero{
                calc8(num1: cNum, num2: angleNum1)
            }
        }
        return true
    }
    
    //doneを追加
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 150))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(AngleViewController.textFieldShouldReturn(_:)))
        
        let items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)
        
        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()
        
        a.inputAccessoryView = doneToolbar
        b.inputAccessoryView = doneToolbar
        c.inputAccessoryView = doneToolbar
        angle1.inputAccessoryView = doneToolbar
        
    }
    
    func textDidChange(notification: NSNotification) {
        // textField入力時の処理
    }
    
    //a,bが分かるとき
    func calc1(num1: Double, num2: Double) -> Void {
        if (!num1.isZero && !num2.isZero){
            var num = floor(sqrt(num1*num1 + num2*num2)*10000)/10000
            num = ceil(num*1000)/1000
            c.text = String(num)
            var ang1 = floor(atan(num2 / num1)*180/pai*10000)/10000
            ang1 = ceil(ang1*1000)/1000
            angle1.text = String(ang1)
            saveButton.isEnabled = true
        }
    }
    
    //a,cが分かるとき
    func calc2(num1: Double, num2: Double) -> Void {
        if(!num1.isZero && !num2.isZero){
            var num = floor(sqrt(num1*num1 - num2*num2)*10000)/10000
            num = ceil(num*1000)/1000
            b.text = String(num)
            var ang1 = floor(acos(num2 / num1)*180/pai*10000)/10000
            ang1 = ceil(ang1*1000)/1000
            angle1.text = String(ang1)
            saveButton.isEnabled = true
        }
    }
    
    //b,cが分かるとき
    func calc3(num1: Double, num2: Double) -> Void {
        if(!num1.isZero && !num2.isZero){
            var num = floor(sqrt(num1*num1 - num2*num2)*10000)/10000
            num = ceil(num*1000)/1000
            a.text = String(num)
            var ang1 = floor(asin(num2 / num1)*180/pai*10000)/10000
            ang1 = ceil(ang1*1000)/1000
            angle1.text = String(ang1)
            saveButton.isEnabled = true
        }
    }
    
    //a,sin(a)が分かるとき
    func calc4(num1: Double, num2: Double) -> Void {
        if(!num1.isZero && !num2.isZero){
            let num = pai * num2 / 180
            var n1 = floor(num1 / sin(num)*10000)/10000
            n1 = ceil(n1*1000)/1000
            c.text = String(n1)
            var n2 = floor(Double(n1) * cos(num)*10000)/10000
            n2 = ceil(n2*1000)/1000
            b.text = String(n2)
            saveButton.isEnabled = true
        }
    }
    
    //a,sin(b)が分かるとき
    func calc5(num1: Double, num2: Double){
        if(!num1.isZero && !num2.isZero){
            let num = pai * num2 / 180
            var n1 = floor(num1 / cos(num)*10000)/10000
            n1 = ceil(n1*1000)/1000
            c.text = String(n1)
            var n2 = floor(Double(n1) * sin(num)*10000)/10000
            n2 = ceil(n2*1000)/1000
            b.text = String(n2)
            saveButton.isEnabled = true
        }
    }
    
    //b,sin(b)が分かるとき
    func calc6(num1: Double, num2: Double) -> Void {
        if(!num1.isZero && !num2.isZero){
            let num = pai * num2 / 180
            var n1 = floor(num1 / sin(num)*10000)/10000
            n1 = ceil(n1*1000)/1000
            c.text = String(n1)
            var n2 = floor(Double(n1) * cos(num)*10000)/10000
            n2 = ceil(n2*1000)/1000
            a.text = String(n2)
            saveButton.isEnabled = true
        }
    }
    
    //b,sin(a)が分かるとき
    func calc7(num1: Double, num2: Double){
        if(!num1.isZero && !num2.isZero){
            let num = pai * num2 / 180
            var n1 = floor(num1 / cos(num)*10000)/10000
            n1 = ceil(n1*1000)/1000
            c.text = String(n1)
            var n2 = floor(Double(n1) * sin(num)*10000)/10000
            n2 = ceil(n2*1000)/1000
            a.text = String(n2)
            saveButton.isEnabled = true
        }
    }
    
    //c,sin(b)が分かるとき
    func calc8(num1: Double, num2: Double) -> Void {
        if(!num1.isZero && !num2.isZero){
            let num = pai * num2 / 180
            var n1 = floor(num1 * sin(num)*10000)/10000
            n1 = ceil(n1*1000)/1000
            b.text = String(n1)
            var n2 = floor(num1 * cos(num)*10000)/10000
            n2 = ceil(n2*1000)/1000
            a.text = String(n2)
            saveButton.isEnabled = true
        }
    }
    
    //c,sin(a)が分かるとき
    func calc9(num1: Double, num2: Double){
        if(!num1.isZero && !num2.isZero){
            angle1.text = String(90.0 - num2)
            let num = pai * num2 / 180
            var n1 = floor(num1 * cos(num)*10000)/10000
            n1 = ceil(n1*1000)/1000
            b.text = String(n1)
            var n2 = floor(num1 * sin(num)*10000)/10000
            n2 = ceil(n2*1000)/1000
            a.text = String(n2)
            saveButton.isEnabled = true
        }
    }
    
    //a,b,cのtextをクリアにする
    @IBAction func clear(_ sender: UIButton) {
        a.text = ""
        b.text = ""
        c.text = ""
        angle1.text = ""
        saveButton.isEnabled = false
    }

}

//
//  DataSet.swift
//  Calc
//
//  Created by Azuma on 2017/05/27.
//  Copyright © 2017年 Azuma. All rights reserved.
//

import RealmSwift

class DataSet: Object{
    dynamic var a: Double = 0.0
    dynamic var b: Double = 0.0
    dynamic var c: Double = 0.0
    dynamic var angle1: Double = 0.0
    dynamic var name: String = ""
    dynamic var now = Date()
}

class AdCount: Object {
    @objc dynamic var count: Int = 0
}

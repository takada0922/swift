//
//  MemberData.swift
//  SearchWebApi
//
//  Created by User3 on 2018/03/08.
//  Copyright © 2018年 テストアプリ. All rights reserved.
//

import Foundation

class MemberData: NSObject, NSCoding {
    
    // 名前（性）
    var name1:String
    // 名前（名）
    var name2:String
    //　メール
    var mail:String
    //　パスワード
    var passWord:String
    //  生年月日
    var birth:String?
    
    // 初期化処理
    init(
        name1:String,
        name2:String,
        mail:String,
        passWord:String,
        birth:String
        )
    {
        self.name1 = name1
        self.name2 = name2
        self.mail = mail
        self.passWord = passWord
        self.birth = birth
    }
    // エンコード
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name1, forKey:"name1")
        aCoder.encode(name2, forKey:"name2")
        aCoder.encode(mail, forKey:"mail")
        aCoder.encode(passWord, forKey:"passWord")
        aCoder.encode(birth, forKey:"birth")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name1 = aDecoder.decodeObject(forKey: "name1") as! String
        self.name2 = aDecoder.decodeObject(forKey: "name2") as! String
        self.mail = aDecoder.decodeObject(forKey: "mail") as! String
        self.passWord = aDecoder.decodeObject(forKey: "passWord") as! String
        self.birth = aDecoder.decodeObject(forKey: "birth") as? String
    }
}

extension NSCoding {
    
}

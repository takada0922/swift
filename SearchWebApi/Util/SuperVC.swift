//
//  SuperVC.swift
//  SearchWebApi
//
//  Created by User3 on 2018/03/08.
//  Copyright © 2018年 テストアプリ. All rights reserved.
//

import UIKit

// Protocol Javaでいうインターフェース
protocol StoryboardInstantiable {}

// Protocol Extension http://llcc.hatenablog.com/entry/2015/06/12/234908
// プロトコルにデフォルトの実装ができる機能です。
// 下のようにextensionを使ってprotocolにメソッドを追加します

extension StoryboardInstantiable {
    
    static func instantiate() -> Self {
        let storyBoard = UIStoryboard(name:ClassNameFromStoryboardInstantiable(type:Self.self), bundle:nil)
        return storyBoard.instantiateInitialViewController() as! Self
    }
}

private func ClassNameFromStoryboardInstantiable(type:StoryboardInstantiable.Type) -> String {
    let classString = NSStringFromClass(type as! AnyClass)
    return classString.components(separatedBy: ".").last!
}

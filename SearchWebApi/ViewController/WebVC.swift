//
//  WebVC.swift
//  SearchWebApi
//
//  Created by User3 on 2018/03/08.
//  Copyright © 2018年 テストアプリ. All rights reserved.
//

import UIKit
import SafariServices

class WebVC: UIViewController,SFSafariViewControllerDelegate {
    // URL
    var itemUrl:URL? = nil;
    // 終了フラグ
    var closeFlg:Bool = false
    
    // 画面初期ロード
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    // メモリ警告
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 画面表示アクション
    override func viewDidAppear(_ animated: Bool) {
        
        guard let itemUrl = itemUrl else {
            // 当画面をクローズ
            dismiss(animated:true, completion: nil)
            return
        }
        
        // safariからのクローズか判定
        if closeFlg {
            // 当画面をクローズ
            dismiss(animated:true, completion: nil)
        }else {
            
            // safariviewを開く
            let safariViewController = SFSafariViewController(url: itemUrl)
            
            // 画面表示
            present(safariViewController, animated: true, completion:nil)
            
            //delegateの通知先を自分自身
            safariViewController.delegate = self
        }
        super.viewDidAppear(true)
    }
//    override func viewWillAppear(_ animated: Bool) {
//
//        guard let itemUrl = itemUrl else {
//            // 当画面をクローズ
//            dismiss(animated:true, completion: nil)
//            return
//        }
//
//        // safariからのクローズか判定
//        if closeFlg {
//            // 当画面をクローズ
//            dismiss(animated:true, completion: nil)
//        }else {
//
//            // safariviewを開く
//            let safariViewController = SFSafariViewController(url: itemUrl)
//
//            // 画面表示
//            present(safariViewController, animated: true, completion:nil)
//
//            //delegateの通知先を自分自身
//            safariViewController.delegate = self
//        }
//        super.viewWillAppear(true)
//    }
    // safariviewが閉じられた時に呼ばれるdelegateメソッド
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        closeFlg = true
        // safariを閉じる
        dismiss(animated:true, completion: nil)
        
    }

}
extension WebVC : StoryboardInstantiable{}

//
//  StartVC.swift
//  SearchWebApi
//
//  Created by User3 on 2018/03/08.
//  Copyright © 2018年 テストアプリ. All rights reserved.
//

import UIKit

class StartVC: UIViewController {
    
    // スタートボタンビュー
    @IBOutlet weak var startBtnView: UIView!
    // 編集ボタンビュー
    @IBOutlet weak var editBtnView: UIView!
    // 登録ボタンビュー
    @IBOutlet weak var registBtnView:UIView!
    
    // 保持情報取得用
    private let userDefaults = UserDefaults.standard
    
    // 画面ロード
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setUpUI()
        
    }
    
    // 画面ロード時の初期表示
    private func setUpUI(){
        // 登録データが存在しなかった場合
        guard let _ = userDefaults.object(forKey: "MemberData") as? Data else {
            startBtnView.isHidden = true
            editBtnView.isHidden = true
            registBtnView.isHidden = false
            return
        }
        // 登録データが存在しない場合、会員登録ボタン活性化
        startBtnView.isHidden = false
        editBtnView.isHidden = false
        registBtnView.isHidden = true
        
    }
    
    // メモリ警告
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        // ナビゲーションバー非表示
        navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewWillAppear(true)
    }
    
    // 会員登録ボタン押下
    @IBAction func memberRegistDisp(_ sender: Any) {
        // 会員登録画面へ
        showModalVC(kind:Globals.ButtonKind.regist)
    }
    
    // 編集ボタン押下
    @IBAction func editDisp(_ sender: Any) {
        // 会員登録画面へ（編集）
        showModalVC(kind:Globals.ButtonKind.edit)
    }
    
    // スタートボタン押下
    @IBAction func startDisp(_ sender: Any) {
        // 会員登録画面へ（編集）
        showModalVC(kind:Globals.ButtonKind.start)

    }
    
    // 会員登録画面遷移処理
    private func showModalVC(kind:Globals.ButtonKind){
        
        //　画面情報取得
        switch kind {
        // 会員登録の場合
        case .regist:
            let vc = MemberRegistVC.instantiate()
            // ボタン種別を設定
            vc.kind = kind
            // 画面がクローズされた際のコールバック処理
            vc.callbackReturnTapped = {() -> Void in
                self.setUpUI()
            }
            
            // モーダル遷移設定
            vc.modalPresentationStyle = .overCurrentContext

            // モーダル表示
            present(vc, animated: true, completion: nil)

        // 編集の場合
        case .edit:
            let vc = MemberRegistVC.instantiate()
            // ボタン種別を設定
            vc.kind = kind
            // 画面がクローズされた際のコールバック処理
            vc.callbackReturnTapped = {() -> Void in
                self.setUpUI()
            }
            
            // モーダル遷移設定
            vc.modalPresentationStyle = .overCurrentContext

            // モーダル表示
            present(vc, animated: true, completion: nil)

        // スタートの場合
        case .start:
            let vc = LoginVC.instantiate()
            
            // モーダル遷移設定
            vc.modalPresentationStyle = .overCurrentContext
            
            // 画面がクローズされた際のコールバック処理
            vc.callbackReturnTapped = {() -> Void in
                // ナビゲーションバー表示
                self.navigationController?.setNavigationBarHidden(false, animated: false)
                // 検索画面へ遷移
                let storyboard = UIStoryboard(name: "SearchTableVC", bundle: nil).instantiateViewController(withIdentifier: "SearchTableVC")
                self.navigationController?.pushViewController(storyboard, animated: true)
                
            }
            // モーダル表示
            present(vc, animated: true, completion: nil)
            
        }
    }
}

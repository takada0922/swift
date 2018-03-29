//
//  LoginVC.swift
//  SearchWebApi
//
//  Created by User3 on 2018/03/08.
//  Copyright © 2018年 テストアプリ. All rights reserved.
//

import UIKit
import AudioToolbox

class LoginVC: UIViewController,UITextFieldDelegate {
    // 保存情報取得
    private let userDefaults = UserDefaults.standard
    // メールアドレス
    @IBOutlet weak var mailTextField: UITextField!
    // パスワード
    @IBOutlet weak var passWordTextField: UITextField!
    // 不正解イメージ
    @IBOutlet weak var inCorrectImageView: UIImageView!
    // コールバック
    var callbackReturnTapped:(()   -> Void)? = nil
    
    // 画面ロード処理
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mailTextField.delegate = self
        passWordTextField.delegate = self
    }
    
    // メモリ警告
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ログインボタン押下処理
    @IBAction func login(_ sender: Any) {
        
        // ログイン情報チェック
        if checkUpLoginInfo(){
            // 画面クローズし、コールバック処理実施
            self.dismiss(animated: true, completion: {
                self.callbackReturnTapped!()
            })
        }
    }
    
    //　ログイン情報チェック
    private func checkUpLoginInfo() -> Bool{
        
        // 情報がなければ終了
        guard let data = userDefaults.object(forKey: "MemberData") as? Data else {
            return false
        }
        
        // 会員登録情報のチェック
        if let unarchiveEntry = NSKeyedUnarchiver.unarchiveObject(with: data) as? MemberData {
            //　メールチェック
            if self.mailTextField.text != unarchiveEntry.mail.trimmingCharacters(in: .whitespaces) {
                self.mailTextField.becomeFirstResponder()
                self.mailTextField.resignFirstResponder()
                inCorrectAnimation()
                return false
            }
            // パスワードチェック
            if self.passWordTextField.text != unarchiveEntry.passWord.trimmingCharacters(in: .whitespaces) {
                self.passWordTextField.becomeFirstResponder()
                self.passWordTextField.resignFirstResponder()
                inCorrectAnimation()
                return false
            }
        }
        
        return true
    }
    
    // エラー時のアニメーション表示
    private func inCorrectAnimation(){
        AudioServicesPlayAlertSound(1006)
        UIView.animate(withDuration: 2.0, animations:{
            self.inCorrectImageView.alpha = 1.0
            self.inCorrectImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }) { (Bool) in
            self.inCorrectImageView.alpha = 0.0
            self.inCorrectImageView.transform = CGAffineTransform(scaleX: 0, y: 0)
            return
        }
    }
    // returnキー押下時イベント処理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
}
extension LoginVC : StoryboardInstantiable{}

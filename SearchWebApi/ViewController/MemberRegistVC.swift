//
//  MemberRegistVC.swift
//  SearchWebApi
//
//  Created by User3 on 2018/03/08.
//  Copyright © 2018年 テストアプリ. All rights reserved.
//

import UIKit
import SwiftCop

class MemberRegistVC: UIViewController {
    
    // 名前（性）テキストフィールド
    @IBOutlet weak var name1TextField: UITextField!
    // 名前（名）テキストフィールド
    @IBOutlet weak var name2TextField: UITextField!
    // メールアドレスフィールド
    @IBOutlet weak var mailTextField: UITextField!
    // パスワードテキストフィールド
    @IBOutlet weak var passWordTextField: UITextField!
    // 生年月日テキストフィールド
    @IBOutlet weak var birthTextField: UITextField!
    
    // 遷移元のボタン種別
    var kind:Globals.ButtonKind!
    
    // 保存情報取得
    private let userDefaults = UserDefaults.standard
    
    // 生年月日表示
    let datePickerView:UIDatePicker = UIDatePicker()
    var datePicker : UIDatePicker!
    // コールバック
    var callbackReturnTapped:(()   -> Void)? = nil
    
    // バリデーション
    let swiftCop: SwiftCop = SwiftCop()
    
    // 画面ロード
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 画面データ表示
        setUpUI(kind:self.kind)
        
        // datepicker設定
        pickUpDate()
        
        // バリデーション設定
        setValidation()
    }
    
    // メモリ警告
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 画面初期設定
    private func setUpUI(kind:Globals.ButtonKind){
        
        self.name1TextField.delegate = self
        self.name2TextField.delegate = self
        self.mailTextField.delegate = self
        self.passWordTextField.delegate = self
        
        switch kind {
        // 会員登録の場合、処理は特になし
        case .regist:
            break
        // 編集の場合、登録済データを表示させる
        case .edit:
            setUpEdit()
        // スタートで来ることはないので何もしない
        case .start:
            break
        }
    }
    
    // DatePickerを生年月日に挿入
    private func pickUpDate(){
        
        // DatePicker設定
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.datePickerMode = UIDatePickerMode.date
        self.datePicker.locale = Locale(identifier: "ja_JP")
        self.birthTextField.inputView = self.datePicker
        
        // ツールバー設定
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // ツールバーアクション設定
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(MemberRegistVC.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(MemberRegistVC.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.birthTextField.inputAccessoryView = toolBar
        
    }
    
    // バリデーション設定
    private func setValidation(){
        swiftCop.addSuspect(Suspect(view: name1TextField, sentence: "名前（性）を入力してください", trial: Trial.length(.minimum, 1)))
        swiftCop.addSuspect(Suspect(view: name2TextField, sentence: "名前（名）を入力してください", trial: Trial.length(.minimum, 1)))
        swiftCop.addSuspect(Suspect(view: passWordTextField, sentence: "パスワードを入力してください", trial: Trial.length(.minimum, 1)))
        swiftCop.addSuspect(Suspect(view: mailTextField, sentence: "正しいメールアドレスを入力してください", trial: Trial.email))

    }
    
    // 入力チェック
    private func isErrorCheck() -> Bool{
        if let guilty = swiftCop.isGuilty(name1TextField) {
            name1TextField.becomeFirstResponder()
            popErrorMsg(err: guilty.verdict())
            return true
        }
        
        if let guilty = swiftCop.isGuilty(name2TextField) {
            name2TextField.becomeFirstResponder()
            popErrorMsg(err: guilty.verdict())
            return true
        }
        
        if let guilty = swiftCop.isGuilty(passWordTextField) {
            passWordTextField.becomeFirstResponder()
            popErrorMsg(err: guilty.verdict())
            return true
        }
        
        if let guilty = swiftCop.isGuilty(mailTextField) {
            mailTextField.becomeFirstResponder()
            popErrorMsg(err: guilty.verdict())
            return true
        }
        
        return false
    }
    
    // エラーメッセージ表示
    private func popErrorMsg(err:String){
        let alertController = UIAlertController(title: nil, message: err, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    // 生年月日のdoneを選択した場合
    @objc func doneClick() {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeStyle = .none
        dateFormatter1.dateFormat  = "yyyy/MM/dd"
        birthTextField.text = dateFormatter1.string(from: datePicker.date)
        birthTextField.resignFirstResponder()
    }
    
    // 生年月日のキャンセルを選択した場合
    @objc func cancelClick() {
        birthTextField.resignFirstResponder()
    }
    
    /**
     CGRectMake　Swift3で変更した対応
     
     - parameter x: 横
     - parameter y: 縦
     - parameter width: 幅
     - parameter height: 高さ
     
     - returns:　CGRectのインスタンス
     
     */
    private func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }

    // 編集時の画面表示
    private func setUpEdit(){
        
        // 情報がなければ終了
        guard let data = userDefaults.object(forKey: "MemberData") as? Data else {
            return
        }
        
        // 保存情報取得し、画面に設定
        if let unarchiveEntry = NSKeyedUnarchiver.unarchiveObject(with: data) as? MemberData {
            name1TextField.text = unarchiveEntry.name1
            name2TextField.text = unarchiveEntry.name2
            mailTextField.text = unarchiveEntry.mail
            passWordTextField.text = unarchiveEntry.passWord
            birthTextField.text = unarchiveEntry.birth
        }
    }
    // 登録ボタン押下
    @IBAction func regist(_ sender: Any) {
        
        // 入力チェック
        if isErrorCheck() { return }
        
        // 入力情報を保存
        saveInput()
        
        //callback
        callbackReturnTapped?()
        
        // 画面クローズ
        closeScreen()
    }
    
    // 入力情報を保存
    private func saveInput(){

        // 入力情報を保存
        let memberData = MemberData(
            name1:self.name1TextField.text!,
            name2:self.name2TextField.text!,
            mail:self.mailTextField.text!,
            passWord:self.passWordTextField.text!,
            birth:self.birthTextField.text!
        )
        
        //シリアライズ
        let archive = NSKeyedArchiver.archivedData(withRootObject: memberData)
        userDefaults.set(archive, forKey:"MemberData")
        userDefaults.synchronize()
    }
    
    // 画面クローズ処理
    private func closeScreen(){
        // キーボードを閉じる
        self.view.endEditing(true)
        
        // 画面を閉じる
        self.dismiss(animated:true,completion: nil)
    }
}

extension MemberRegistVC : StoryboardInstantiable{}
extension MemberRegistVC : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

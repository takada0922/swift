//
//  SearchTableVC.swift
//  SearchWebApi
//
//  Created by User3 on 2018/03/08.
//  Copyright © 2018年 テストアプリ. All rights reserved.
//

import UIKit
import SafariServices

class SearchTableVC:UIViewController,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,SFSafariViewControllerDelegate {
    // 検索バー
    @IBOutlet weak var searchText: UISearchBar!
    // 表
    @IBOutlet weak var tableView: UITableView!
    
    // お菓子リスト
    var okashiList : [(maker:String,name:String,price:String,link:URL,image:URL)] = []
    
    let priceFormat = NumberFormatter()
    
    var sendURL = ""
    
    var imageCache = NSCache<AnyObject,UIImage>()
    // 画面初期ロード
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        searchText.delegate = self
        searchText.placeholder = "お菓子の名前を入力してください"
        tableView.dataSource = self
        tableView.delegate = self
        priceFormat.numberStyle = .currency
        priceFormat.currencyCode = "JPY"
    }
    
    // メモリ警告
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 検索バーの検索ボタン押下
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // キーパッドを閉じる
        view.endEditing(true)
        
        // お菓子情報検索処理呼び出し
        if let searchWord = searchBar.text {
            searchOkashi(keyword:searchWord)
        }
    }
    
    // お菓子検索処理
    func searchOkashi(keyword:String) {
        
        // 検索文字列のエンコード
        guard let keyword_encode = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        sendURL = "http://www.sysbird.jp/toriko/api/?apikey=guest&format=json&keyword=\(keyword_encode)&max=110&order=r"
        // リクエストURL作成
        guard let req_url = URL(string:sendURL) else {
            return
        }
        
        // リクエスト生成
        let req = URLRequest(url:req_url)
        print(req_url)
        // セッション生成
        let session = URLSession(configuration:.default,delegate:nil,delegateQueue:OperationQueue.main)
        
        // 検索処理
        let task = session.dataTask(with: req, completionHandler: { (data ,response , error) in
            // 検索終了後の処理内容
            // セッションクローズ
            session.finishTasksAndInvalidate()
            
            // 取得データの整形
            do {
                let decoder = JSONDecoder()
                
                let json = try decoder.decode(ResultJson.self, from: data!)
                
                if let items = json.item {
                    // 初期化
                    self.okashiList.removeAll()
                    
                    // データを配列に格納
                    for item in items {
                        
                        if let maker = item.maker,let name = item.name,let link = item.url,let image = item.image,let price = item.price {
                            
                            let okashi = (maker,name,price,link,image)
                            
                            self.okashiList.append(okashi)
                            
                        }
                    }
                    // 表リロード
                    self.tableView.reloadData()
                }
            }catch{
                print("【エラーが発生しました : \(error)】")
            }
        })
        // データ取得開始
        task.resume()
    }
    
    // 取得データ構造体
    struct ItemJson:Codable {
        // 名称
        let name:String?
        // メーカ
        let maker:String?
        // プライス
        let price:String?
        // 画像
        let image:URL?
        // URL
        let url:URL?

    }
    
    // 取得データリスト構造体
    struct ResultJson:Codable {
        
        enum RootKeys:String, CodingKey{
            case item
        }
        enum ItemKeys:String, CodingKey{
            case maker
            case name
            case price
            case url
            case image
        }
        var item:[ItemJson]?
        public init(from decoder: Decoder) throws{
            var a,b,c:String?
            var d,e:URL?
            
            let root = try decoder.container(keyedBy: RootKeys.self)
            var items = try root.nestedUnkeyedContainer(forKey: .item)
            self.item = []
            while !items.isAtEnd {
                let container = try items.nestedContainer(keyedBy: ItemKeys.self)
                a = try container.decode(String.self, forKey: .name)
                b = try container.decode(String.self, forKey: .maker)
                
                do {
                    c = try container.decode(String.self, forKey: .price)
                }catch{
                    c = ""
                }
                
                do{
                    d = try container.decode(URL.self, forKey: .image)
                }catch{
                    d = URL(string:"")
                }
                
                do {
                    e = try container.decode(URL.self, forKey: .url)
                }catch{
                    e = URL(string:"")
                }
                
                let content = ItemJson(name: a,maker: b,price: c,image: d,url: e)
                self.item?.append(content)
            }
            
        }
    }
    
    // 行数取得
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return okashiList.count
    }
    
    // セルへのデータセット
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // セル情報取得
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "okashiCell", for: indexPath) as? ItemTableViewCell else {
            return UITableViewCell()
        }
        
        // 商品名設定
        cell.itemTitleLabel.text = okashiList[indexPath.row].name
        
        // メーカ名設定
        cell.itemMakerLabel.text = okashiList[indexPath.row].maker
        
        // 価格設定
        if !okashiList[indexPath.row].price.isEmpty {
            if okashiList[indexPath.row].price ==  "該当なし" {
                cell.itemPriceLabel.text = okashiList[indexPath.row].price
            } else {
                let number = NSNumber(integerLiteral:Int(okashiList[indexPath.row].price)!)
                cell.itemPriceLabel.text = priceFormat.string(from: number)
            }
        }else{
            cell.itemPriceLabel.text = "該当なし"
        }

        
        // キャッシュ取り出し
        if let cacheImage = imageCache.object(forKey: okashiList[indexPath.row].image.absoluteString as AnyObject) {
            cell.itemImageView.image = cacheImage
            return cell
        }
        
        // 画像取得
        if let imageData = try? Data(contentsOf: okashiList[indexPath.row].image) {
            // 画像設定
            cell.itemImageView.image = UIImage(data:imageData)
            // キャッシュ設定
            self.imageCache.setObject(UIImage(data:imageData)!, forKey: okashiList[indexPath.row].image.absoluteString as AnyObject)
        }
        return cell
    }
    
    // Cellが選択された際に呼び出されるdelegateメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // ハイライト解除
        tableView.deselectRow(at: indexPath,animated:true)
        
        // 画面遷移
        let vc = WebVC.instantiate()
        vc.itemUrl = okashiList[indexPath.row].link
        present(vc, animated: true, completion: nil)
    }
    
}


//
//  ItemTableViewCell.swift
//  SearchWebApi
//
//  Created by User3 on 2018/03/08.
//  Copyright © 2018年 テストアプリ. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    // 商品名
    @IBOutlet weak var itemTitleLabel: UILabel!
    // メーカー
    @IBOutlet weak var itemMakerLabel: UILabel!
    // 価格
    @IBOutlet weak var itemPriceLabel: UILabel!
    // イメージ
    @IBOutlet weak var itemImageView: UIImageView!
    var itemUrl: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        itemImageView.image = nil
    }
}

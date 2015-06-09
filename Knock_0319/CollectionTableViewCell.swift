//
//  CollectionTableViewCell.swift
//  Knock_0319
//
//  Created by 陳冠宇 on 2015/6/6.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import UIKit

class CollectionTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var boardinfo: Array<boardInfo> = []
    
    @IBOutlet weak var boardTitle: UILabel!
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return boardinfo.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as! TitleCollectionViewCell
        let board = boardinfo[indexPath.row]
        
        if let data = board.picture {
            cell.collectionImage.image = UIImage(data: data)
        }
        cell.collectionLabel.text = board.name
        cell.boardID = board.id!
        cell.boardName = board.name!
        
        return cell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  BorderStyleCell.swift
//  QRcodeGenerator
//
//  Created by 이승기 on 2021/04/13.
//

import UIKit

protocol CustomBorderCollectionViewDelegate: AnyObject {
    func didTapBorderStyle(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
}

class BorderStyleCell: UICollectionViewCell{
    
    private var collectionView: UICollectionView?
    private var indexPath: IndexPath?
    weak var delegate: CustomBorderCollectionViewDelegate?
    
    func configure(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath){
        self.collectionView = collectionView
        self.indexPath = indexPath
    }
    
    @IBOutlet weak var borderStyleButton: UIButton!
    
    
    @IBAction func borderStyleButtonAction(){
        delegate?.didTapBorderStyle(self.collectionView!, cellForItemAt: self.indexPath!)
    }
}

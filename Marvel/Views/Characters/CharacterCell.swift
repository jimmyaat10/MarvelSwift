//
//  CharacterCell.swift
//  Marvel
//
//  Created by Albert Arroyo on 25/8/16.
//  Copyright © 2016 AlbertArroyo. All rights reserved.
//

import UIKit
import Foundation
import Kingfisher

class CharacterCell: UITableViewCell {
    var imgCharacter        = UIImageView()
    var nameCharacterLabel  = UILabel()
    var modifiedDateLabel   = UILabel()
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        nameCharacterLabel.textColor = UIColor.black
        nameCharacterLabel.numberOfLines = 0
        modifiedDateLabel.textColor = UIColor.black
        modifiedDateLabel.numberOfLines = 0
        
        contentView.addSubview(imgCharacter)
        contentView.addSubview(nameCharacterLabel)
        contentView.addSubview(modifiedDateLabel)
        
        imgCharacter.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width:100, height: 100))
            make.leading.equalTo(contentView.snp.leading).inset(10)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        nameCharacterLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(imgCharacter.snp.trailing).offset(10)
            make.trailing.equalTo(contentView.snp.trailing).inset(10)
            make.top.equalTo(contentView.snp.top).offset(10)
        }
        modifiedDateLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(nameCharacterLabel.snp.leading)
            make.trailing.equalTo(nameCharacterLabel.snp.trailing)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
        }
    }
    
    func configureCell(_ character: CharacterModel) {
        nameCharacterLabel.text = character.name
        modifiedDateLabel.text = character.formatModifiedDateToString()
        let urlString = (character.thumbnail?.path)!+"."+(character.thumbnail?.ext)!
        let url = URL(string: urlString)
        
        self.imgCharacter.kf.indicatorType = .activity
        self.imgCharacter.kf.setImage(with: url, placeholder: UIImage.init(named: "placeholder"),
                                      options: [.transition(ImageTransition.fade(1))],
                                              progressBlock: { receivedSize, totalSize in
//                                                dump("download image receivedSize progressBlock: \(receivedSize)/\(totalSize)")
            },
                                              completionHandler: { image, error, cacheType, imageURL in
//                                                dump("download image Finished")
        })
    }
    
    static func preferredHeight() -> CGFloat {
        return 120
    }
}

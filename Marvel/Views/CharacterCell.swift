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
        
        nameCharacterLabel.textColor = UIColor.blackColor()
        nameCharacterLabel.numberOfLines = 0
        modifiedDateLabel.textColor = UIColor.blackColor()
        modifiedDateLabel.numberOfLines = 0
        
        contentView.addSubview(imgCharacter)
        contentView.addSubview(nameCharacterLabel)
        contentView.addSubview(modifiedDateLabel)
        
        imgCharacter.snp_makeConstraints { (make) in
            make.size.equalTo(CGSizeMake(100, 100))
            make.leading.equalTo(contentView.snp_leading).inset(10)
            make.centerY.equalTo(contentView.snp_centerY)
        }
        nameCharacterLabel.snp_makeConstraints { (make) in
            make.leading.equalTo(imgCharacter.snp_trailing).offset(10)
            make.trailing.equalTo(contentView.snp_trailing).inset(10)
            make.top.equalTo(contentView.snp_top).offset(10)
        }
        modifiedDateLabel.snp_makeConstraints { (make) in
            make.leading.equalTo(nameCharacterLabel.snp_leading)
            make.trailing.equalTo(nameCharacterLabel.snp_trailing)
            make.bottom.equalTo(contentView.snp_bottom).offset(-10)
        }
    }
    
    func configureCell(character: CharacterModel) {
        nameCharacterLabel.text = character.name
        modifiedDateLabel.text = character.formatModifiedDateToString()
        let urlString = (character.thumbnail?.path)!+"."+(character.thumbnail?.ext)!
        let url = NSURL(string: urlString)
        
        self.imgCharacter.kf_showIndicatorWhenLoading = true
        self.imgCharacter.kf_setImageWithURL(url, placeholderImage: UIImage.init(named: "placeholder"),
                                              optionsInfo: [.Transition(ImageTransition.Fade(1))],
                                              progressBlock: { receivedSize, totalSize in
//                                                print("download image receivedSize progressBlock: \(receivedSize)/\(totalSize)")
            },
                                              completionHandler: { image, error, cacheType, imageURL in
//                                                print("download image Finished")
        })
    }
    
    static func preferredHeight() -> CGFloat {
        return 120
    }
}

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
    lazy var imgCharacter        = UIImageView()
    lazy var nameCharacterLabel  = UILabel()
    lazy var modifiedDateLabel   = UILabel()
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupViewConfiguration()
    }
    
    static func preferredHeight() -> CGFloat {
        return StyleViewSizes.characterCellPreferredHeight
    }
}

extension CharacterCell: ViewConfiguration {
    func buildViewHierarchy() {
        contentView.addSubviews([imgCharacter, nameCharacterLabel, modifiedDateLabel])
    }
    
    func makeConstraints() {
        imgCharacter.snp.makeConstraints { make in
            make.size.equalTo(StyleViewSizes.characterImageSize).priority(999)
            make.left.equalTo(contentView).inset(StyleViewSizes.characterImageMarginLeft)
            make.top.bottom.centerY.equalTo(contentView)
        }
        nameCharacterLabel.snp.makeConstraints { make in
            make.left.equalTo(imgCharacter.snp.right).offset(StyleViewSizes.characterNameLateralMargins)
            make.right.equalTo(contentView).inset(StyleViewSizes.characterNameLateralMargins)
            make.top.equalTo(contentView).offset(StyleViewSizes.characterNameMarginTop)
            make.height.greaterThanOrEqualTo(16)
        }
        modifiedDateLabel.snp.makeConstraints { make in
            make.left.right.equalTo(nameCharacterLabel)
            make.bottom.equalTo(contentView).inset(StyleViewSizes.characterModifiedDateVerticalMargins)
            make.top.greaterThanOrEqualTo(nameCharacterLabel.snp.bottom).offset(StyleViewSizes.characterModifiedDateVerticalMargins).priority(999)
            make.height.greaterThanOrEqualTo(14)
        }
        
        imgCharacter.setContentCompressionResistancePriority(751, for: .vertical)
        imgCharacter.setContentCompressionResistancePriority(751, for: .horizontal)
        
        nameCharacterLabel.setContentHuggingPriority(251, for: .vertical)
    }
    
    func setupViews() {
        nameCharacterLabel.textColor = StyleViewColors.characterNameColor
        nameCharacterLabel.numberOfLines = 2
        nameCharacterLabel.font = StyleViewFonts.characterNameFont
        
        modifiedDateLabel.textColor = StyleViewColors.characterModifiedDateColor
        modifiedDateLabel.numberOfLines = 1
        modifiedDateLabel.font = StyleViewFonts.characterModifiedDateFont
    }
}

extension CharacterCell: CellTableImpl {
    func configureCell<T>(_ data: T) {
        if let character = data as? CharacterModel {
            nameCharacterLabel.text = character.name
            modifiedDateLabel.text = character.formatModifiedDateToString()
            if let path = character.thumbnail?.path, let ext = character.thumbnail?.ext {
                let urlString = path+"."+ext
                let url = URL(string: urlString)
                
                self.imgCharacter.kf.indicatorType = .activity
                self.imgCharacter.kf.setImage(
                    with: url,
                    placeholder: #imageLiteral(resourceName: "placeholder"),
                    options: [.transition(ImageTransition.fade(1))]
                )
            } else {
                self.imgCharacter.image = #imageLiteral(resourceName: "placeholder")
            }
        }
    }
}

extension CharacterCell {
    /// Struct with view size constants
    struct StyleViewSizes {
        static let characterCellPreferredHeight: CGFloat = 120
        static let characterImageSize: CGSize = CGSize(width:100, height: 100)
        static let characterImageMarginLeft: CGFloat = 10
        static let characterNameLateralMargins: CGFloat = 10
        static let characterNameMarginTop: CGFloat = 10
        static let characterModifiedDateVerticalMargins: CGFloat = 10
    }
    /// Struct with view color constants
    struct StyleViewColors {
        static let characterNameColor: UIColor = AppColors.black
        static let characterModifiedDateColor: UIColor = AppColors.black
    }
    /// Struct with view fonts constants
    struct StyleViewFonts {
        static let characterNameFont: UIFont = UIFont.boldSystemFont(ofSize: 16)
        static let characterModifiedDateFont: UIFont = UIFont.systemFont(ofSize: 14)
    }
}

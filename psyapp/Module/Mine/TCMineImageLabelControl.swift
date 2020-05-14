//
//  TCMineImageLabelControl.swift
//  psyapp
//
//  Created by mac on 2020/4/24.
//  Copyright © 2020 cheersmind. All rights reserved.
//

import UIKit

class TCMineImageLabelControl: UIControl {
    @objc var image : UIImage? {
        set {
            imageView.image = newValue
        }
        get {
            guard let unwrappedImage = imageView.image else { return nil }
            return unwrappedImage;
        }
    }
    
    @objc var text : String?
    @objc var subtext : String?
    
    private var imageView : UIImageView!
    private var textLabel : UILabel!
    private var subtextLabel : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        imageView = UIImageView();
        self.addSubview(imageView)
        imageView.mas_makeConstraints { (maker) in
            maker?.left.offset()(SizeTool.width(15))
            maker?.centerY.offset()(0)
        }

        textLabel = UILabel()
        textLabel.textColor = UIColor.black
        textLabel.font = SizeTool.font(16)
        self.addSubview(textLabel)
        textLabel.mas_makeConstraints { (maker) in
            maker?.left.equalTo()(imageView.mas_right)?.offset()(SizeTool.width(15))
            maker?.top.equalTo()(imageView)
        };
        
        
    }

}

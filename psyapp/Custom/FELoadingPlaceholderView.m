//
//  FELoadingPlaceholderView.m
//  smartapp
//
//  Created by mac on 2020/1/15.
//  Copyright © 2020 jeyie0. All rights reserved.
//

#import "FELoadingPlaceholderView.h"

@implementation FELoadingPlaceholderView {
    UIImageView *_imageView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self didInitialize];
    return self;
}

- (void)didInitialize {
     self.backgroundColor = UIColor.fe_contentBackgroundColor;
    
    _imageInsets = UIEdgeInsetsMake(STWidth(15), STWidth(15), STWidth(15), STWidth(15));
    
    _imageView = [[UIImageView alloc] init];
    _imageView.layer.masksToBounds= YES;
    [self addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_imageInsets);
    }];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    [_imageView setImage:image];
}

- (void)setImageInsets:(UIEdgeInsets)imageInsets {
    _imageInsets = imageInsets;
    [_imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_imageInsets);
    }];
}
@end

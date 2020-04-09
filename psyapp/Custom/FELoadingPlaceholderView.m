//
//  FELoadingPlaceholderView.m
//  smartapp
//
//  Created by mac on 2020/1/15.
//  Copyright © 2020 jeyie0. All rights reserved.
//

#import "FELoadingPlaceholderView.h"
#import <UIImage+GIF.h>

#import <FLAnimatedImage.h>

@implementation FELoadingPlaceholderView {
    UIImageView *_imageView;
    FLAnimatedImageView *_animatedImageView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = UIColor.fe_contentBackgroundColor;
    _imageInsets = UIEdgeInsetsZero;
    return self;
}


- (UIImageView *)imageView {
    [_animatedImageView removeFromSuperview];
    _animatedImageView = nil;
    if (_imageView == nil) {
        _imageView = UIImageView.new;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.layer.masksToBounds = YES;
        [self addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(_imageInsets);
        }];
    }
    return _imageView;
}

- (FLAnimatedImageView *)animatedImageView {
    [_imageView removeFromSuperview];
    _imageView = nil;
    if (_animatedImageView == nil) {
        _animatedImageView = FLAnimatedImageView.new;
        _animatedImageView.contentMode = UIViewContentModeScaleAspectFit;
        _animatedImageView.layer.masksToBounds = YES;
        [self addSubview:_animatedImageView];
        [_animatedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(_imageInsets);
        }];
    }
    return _animatedImageView;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    [self.imageView setImage:image];
}

- (void)setGIFImageName:(NSString *)GIFImageName {
    [_imageView removeFromSuperview];
    _imageView = nil;
    _GIFImageName = GIFImageName;
    NSString *filePath = [NSBundle.mainBundle pathForResource:GIFImageName ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [UIImage sd_imageWithGIFData:data];
//    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:data];
    self.animatedImageView.image = image;
}

- (void)setImageInsets:(UIEdgeInsets)imageInsets {
    _imageInsets = imageInsets;
    UIImageView *imageView;
    if (_animatedImageView) {
        imageView = _animatedImageView;
    } else if (_image) {
        imageView = _imageView;
    }
    if (imageView) {
        [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(_imageInsets);
        }];
    }
}
@end

//
//  FEBaseModel.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/10.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

@interface FEBaseModel : MTLModel<MTLJSONSerializing>
- (instancetype)initWithAVObject:(AVObject *)object;
@end

NS_ASSUME_NONNULL_END

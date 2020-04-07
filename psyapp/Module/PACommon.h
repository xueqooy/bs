//
//  PACommon.h
//  psyapp
//
//  Created by mac on 2020/3/12.
//  Copyright © 2020 cheersmind. All rights reserved.
//

#ifndef PACommon_h
#define PACommon_h

typedef NS_OPTIONS(NSUInteger, TCProductType) {
    TCProductTypeUnknown = 0,
    TCProductTypeTest = 1,
    TCProductTypeCourse = 2
};

typedef NS_OPTIONS(NSUInteger, TCPaymentType) {
    TCPaymentTypeFree = 0,
    TCPaymentTypeWX   = 1,
    TCPaymentTypeZFB  = 2,
    TCPaymentTypeIAP  = 3
};

#define TC_PRODUCT_BEST_CATEGORY_ID @"product_best_category_id"


#define PriceYuanString(priceYuan) \
({\
    NSString *priceYuanString;\
    NSInteger priceLi = priceYuan * 1000;\
    if (priceYuan <= 0) {\
        priceYuanString = @"免费";\
    } else if (priceLi % 100 > 0) {\
        priceYuanString = [NSString stringWithFormat:@"%.2f", priceYuan];\
    } else if (priceLi % 1000 > 0){\
        priceYuanString = [NSString stringWithFormat:@"%.1f", priceYuan];\
    } else {\
        priceYuanString = [NSString stringWithFormat:@"%.0f", priceYuan];\
    }\
   priceYuanString;\
})

#define PriceEmoneyYuanString(priceYuan) \
({\
    NSString *priceYuanString;\
    NSInteger priceLi = priceYuan * 1000;\
    if (priceYuan <= 0) {\
        priceYuanString = @"免费";\
    } else if (priceLi % 100 > 0) {\
        priceYuanString = [NSString stringWithFormat:@"%.2f测点", priceYuan];\
    } else if (priceLi % 1000 > 0){\
        priceYuanString = [NSString stringWithFormat:@"%.1f测点", priceYuan];\
    } else {\
        priceYuanString = [NSString stringWithFormat:@"%.0f测点", priceYuan];\
    }\
   priceYuanString;\
})


#endif /* PACommon_h */

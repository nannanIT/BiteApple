//
//  BATableViewCell.h
//  BiteApple
//
//  Created by jayhuan on 2020/12/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BACellModel;
@interface BATableViewCell : UITableViewCell

- (void)layoutWithCellModel:(BACellModel *)cellModel;

@end

NS_ASSUME_NONNULL_END

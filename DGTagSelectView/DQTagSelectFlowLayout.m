//
//  DQTagSelectFlowLayout.m
//  DGTagSelectView
//
//  Created by 丁强 on 2019/11/8.
//  Copyright © 2019 丁强. All rights reserved.
//

#import "DQTagSelectFlowLayout.h"
#import "ViewController.h"

@interface DQTagSelectFlowLayout()
@property (nonatomic, strong) NSMutableArray *attributeArray;
@end

@implementation DQTagSelectFlowLayout

- (NSMutableArray *)attributeArray {
    if (!_attributeArray) {
        _attributeArray = [NSMutableArray array];
    }
    return _attributeArray;
}

// 瀑布流
//- (void)prepareLayout {
//    [super prepareLayout];
//    //演示方便 我们设置为静态的2列
//    //计算每一个item的宽度
//    float WIDTH = ([UIScreen mainScreen].bounds.size.width - self.sectionInset.left - self.sectionInset.right - self.minimumInteritemSpacing) / 2;
//    //定义数组保存每一列的高度
//    //这个数组的主要作用是保存每一列的总高度，这样在布局时，我们可以始终将下一个Item放在最短的列下面
//    NSMutableArray<NSNumber *> *colHeight = [NSMutableArray arrayWithArray:@[@(self.sectionInset.top), @(self.sectionInset.bottom)]];
//    //itemCount是外界传进来的item的个数 遍历来设置每一个item的布局
//    for (int i = 0; i < _itemCount; i++) {
//        //设置每个item的位置等相关属性
//        NSIndexPath *index = [NSIndexPath indexPathForItem:i inSection:0];
//        //创建一个布局属性类，通过indexPath来创建
//        UICollectionViewLayoutAttributes * attris = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:index];
//        //随机一个高度 在40——190之间
//        CGFloat height = arc4random() % 150 + 40;
//        //哪一列高度小 则放到那一列下面
//        //标记最短的列
//        int width = 0;
//        if ([colHeight[0] floatValue] < [colHeight[1] floatValue]) {
//            //将新的item高度加入到短的一列
//            colHeight[0] = @([colHeight[0] floatValue] + height + self.minimumLineSpacing);
//            width = 0;
//        }else{
//            colHeight[1] = @([colHeight[1] floatValue] + height + self.minimumLineSpacing);
//            width = 1;
//        }
//
//        //设置item的位置
//        attris.frame = CGRectMake(self.sectionInset.left + (self.minimumInteritemSpacing + WIDTH) * width, colHeight[width].floatValue - height - self.minimumLineSpacing, WIDTH, height);
//        [self.attributeArray addObject:attris];
//    }
//
//    //设置itemSize来确保滑动范围的正确 这里是通过将所有的item高度平均化，计算出来的(以最高的列位标准)
//    if (colHeight[0] > colHeight[1]) {
//        self.itemSize = CGSizeMake(WIDTH, (colHeight[0].floatValue - self.sectionInset.top) * 2 / _itemCount - self.minimumLineSpacing);
//    }else{
//        self.itemSize = CGSizeMake(WIDTH, (colHeight[1].floatValue - self.sectionInset.top) * 2 / _itemCount - self.minimumLineSpacing);
//    }
//
//}

- (void)prepareLayout {
    [super prepareLayout];
    
    // 每一行的总宽度
    CGFloat lineWidth = self.sectionInset.left;
    // 总高度
    CGFloat allHeight = 0;
    // item总个数
    NSInteger totalCount = 0;
    
    for (int j = 0; j < self.collectionView.numberOfSections; j++) {
        // 每一个section行数
        NSInteger lineCount = 0;
        // 设置头视图
        UICollectionReusableView *view = [self.collectionView.dataSource collectionView:self.collectionView viewForSupplementaryElementOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:j]];
        if (view) {
            view.frame = CGRectMake(self.sectionInset.left, allHeight + (self.itemHeight + self.minimumLineSpacing) * lineCount, self.collectionView.frame.size.width - self.sectionInset.right - self.sectionInset.left, self.headerReferenceSize.height);
            allHeight += self.headerReferenceSize.height;
        }
        lineWidth = self.sectionInset.left;
        for (int i = 0; i < [self.collectionView numberOfItemsInSection:j]; i++) {
            NSIndexPath *index = [NSIndexPath indexPathForItem:i inSection:j];
            UICollectionViewLayoutAttributes *att = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:index];
            // 获取每个item的宽度
            collectionViewCell *cell = [self.collectionView.dataSource collectionView:self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:j]];
            CGFloat width = cell.width;
            
            CGFloat tempWidth = lineWidth + width + self.minimumInteritemSpacing + self.sectionInset.right;
            
            lineWidth = lineWidth + width + self.minimumInteritemSpacing;
            if (tempWidth <= self.collectionView.frame.size.width) {
                lineWidth = lineWidth - width - self.minimumInteritemSpacing;
            } else {
                lineWidth = self.sectionInset.left;
                lineCount++;
            }
            
            att.frame = CGRectMake(lineWidth, lineCount * (self.itemHeight + self.minimumLineSpacing) + self.sectionInset.top + allHeight , width, self.itemHeight);
            
            lineWidth = lineWidth + width + self.minimumInteritemSpacing;
            
            [self.attributeArray addObject:att];
        }
        totalCount += [self.collectionView numberOfItemsInSection:j];
        allHeight += lineCount * (self.itemHeight + self.minimumLineSpacing) + self.headerReferenceSize.height;
    }
    // 设置itemSize，思路是所有item排一列，一个section的高度就是一个item的高度，所以用总高度除以section数，再减去头视图高度就是每个item高度
    self.itemSize = CGSizeMake(0.1, allHeight / self.collectionView.numberOfSections - self.headerReferenceSize.height);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attributeArray;
}
@end

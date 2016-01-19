//
//  ViewController.m
//  AsyncDisplayKitKiller
//
//  Created by Matt on 1/19/16.
//  Copyright © 2016 InMethod. All rights reserved.
//

#import "ViewController.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import <AsyncDisplayKit/ASDisplayNode+Beta.h>

@interface ViewController () <ASCollectionDataSource, ASCollectionViewDelegateFlowLayout>
{
    ASCollectionNode *collectionNode;
}

@end

@interface CellNode : ASCellNode
{
    ASTextNode *t1;
    ASTextNode *t2;
    ASTextNode *t3;
    
    NSString *t;
}

@property (readwrite) NSString *text;

@end

@implementation CellNode

-(instancetype)init
{
    if (self = [super init])
    {
        t1 = [[ASTextNode alloc] init];
        t1.truncationMode = NSLineBreakByTruncatingTail;
        t1.maximumNumberOfLines = 1;
        [self addSubnode:t1];
        
        t2 = [[ASTextNode alloc] init];
        t2.truncationMode = NSLineBreakByTruncatingTail;
        t2.maximumNumberOfLines = 1;
        [self addSubnode:t2];

        t3 = [[ASTextNode alloc] init];
        t3.truncationMode = NSLineBreakByTruncatingTail;
        t3.maximumNumberOfLines = 1;
        [self addSubnode:t3];
    }
    return self;
}

-(ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    ASStackLayoutSpec *s = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                   spacing:0
                                                            justifyContent:ASStackLayoutJustifyContentCenter
                                                                alignItems:ASStackLayoutAlignItemsStretch
                                                                  children:@[t1, t2, t3]];
    return s;
}

-(NSString *)text
{
    return t;
}

static const CGFloat kFontSize = 5.0f;

-(void)setText:(NSString *)text
{
    if (!text)
        text = @"";
    
    if ([t isEqualToString:text])
        return;
    
    t = [text copy];

    t1.attributedString = [[NSAttributedString alloc] initWithString:text
                                                          attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:kFontSize - 1]}];
    
    t2.attributedString = [[NSAttributedString alloc] initWithString:text
                                                          attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:kFontSize]}];
    
    t3.attributedString = [[NSAttributedString alloc] initWithString:text
                                                          attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:kFontSize + 1]}];
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    collectionNode = [[ASCollectionNode alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    collectionNode.delegate = self;
    collectionNode.dataSource = self;

    [ASDisplayNode setShouldUseNewRenderingRange:YES];
    
    ASRangeTuningParameters tuningParameters = { 0, 0 };
    [collectionNode setTuningParameters:tuningParameters forRangeType:ASLayoutRangeTypeDisplay];
    [collectionNode setTuningParameters:tuningParameters forRangeType:ASLayoutRangeTypeFetchData];

    [self.view addSubview:collectionNode.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewDidLayoutSubviews
{
    collectionNode.frame = self.view.bounds;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5000;
}

-(ASCellNode *)collectionView:(ASCollectionView *)collectionView nodeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CellNode *node = [[CellNode alloc] init];
    node.text = [NSString stringWithFormat:@"%i", (int)indexPath.item];
    node.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
    return node;
}

-(ASSizeRange)collectionView:(ASCollectionView *)collectionView constrainedSizeForNodeAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = 30 + indexPath.item % 15;
    return ASSizeRangeMake(CGSizeMake(width, 30), CGSizeMake(width, 30));
}

@end

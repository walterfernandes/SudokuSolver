//
//  SudokuSlot.h
//  SudokuSolver
//
//  Created by walterfernandes on 17/04/14.
//  Copyright (c) 2014 walterfernandes. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kGameSize 9
#define MakePosition(i, j) (SudokuPosition){i, j}

typedef struct SudokuPosition{
    int i;
    int j;
} SudokuPosition;

@interface SudokuSlot : NSObject

@property (nonatomic, assign) int h;
@property (nonatomic, assign) int g;
@property (nonatomic, assign) int f;
@property (nonatomic, assign) SudokuPosition p;
@property (nonatomic, strong) NSArray *possibles;

@end

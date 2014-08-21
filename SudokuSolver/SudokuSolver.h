//
//  SudokuSolver.h
//  SudokuSolver
//
//  Created by walterfernandes on 17/04/14.
//  Copyright (c) 2014 walterfernandes. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SudokuSolver : NSObject {
    int numTest;
    float totalTime;
    CFAbsoluteTime end;
    CFAbsoluteTime start;

}

-(BOOL)resolveGameInstace:(NSArray*)gameInstace;
-(void)printGameInstance:(NSArray*)gameInstance;

-(float)getTotalTime;
-(int)getNumTest;

@end

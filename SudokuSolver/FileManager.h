//
//  OpenFile.h
//  SudokuSolver
//
//  Created by walterfernandes on 17/04/14.
//  Copyright (c) 2014 walterfernandes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject

-(void)openFile:(NSString*)path readLine:(void(^)(NSString *line))lineCallback;

@end

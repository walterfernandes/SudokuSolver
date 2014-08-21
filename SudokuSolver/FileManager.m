//
//  OpenFile.m
//  SudokuSolver
//
//  Created by walterfernandes on 17/04/14.
//  Copyright (c) 2014 walterfernandes. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager

#pragma mark - Read file function

#define BUFFER_SIZE 1024

-(void)openFile:(NSString*)path readLine:(void(^)(NSString *line))lineCallback{
    NSInputStream *stream = [NSInputStream inputStreamWithFileAtPath:path];
    uint8_t buffer[BUFFER_SIZE];
    NSInteger len;
    NSMutableString *_line = [NSMutableString new];
    
    [stream open];
    
    while ((len = [stream read:buffer maxLength:BUFFER_SIZE]) > 0) {
        for (int i = 0; i < len; i++){
            if (buffer[i] != '\n'){
                [_line appendFormat:@"%c", buffer[i]];
            } else {
                lineCallback(_line);
                _line = [NSMutableString new];
            }
        }
    }
    
    [stream close];
    
    stream = nil;
    _line = nil;
    lineCallback = nil;
}

@end

//
//  main.m
//  SudokuSolver
//
//  Created by walterfernandes on 17/04/14.
//  Copyright (c) 2014 walterfernandes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SudokuSolver.h"
#import "FileManager.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        printf("\nHello, SudokuSolver!\n");
        
        FileManager *fm = [FileManager new];
        NSArray *instances = [[NSBundle mainBundle] pathsForResourcesOfType:@"txt" inDirectory:@""];
        
        for (NSString *filePath in instances){
            
            NSMutableArray *game = [NSMutableArray new];
            
            [fm openFile:filePath readLine:^(NSString *line){
                NSMutableArray *arrayLinhe = [NSMutableArray new];
                
                for (NSString* item in [line componentsSeparatedByString:@" "])
                    [arrayLinhe addObject:[NSNumber numberWithInt:[item intValue]]];
                
                [game addObject:arrayLinhe];
            }];
            
            printf("\n---------------------------------------------------------------------\n");
            NSString *fileName = [[filePath lastPathComponent] stringByDeletingPathExtension];
            printf("Instância: %s\n", [fileName cStringUsingEncoding:NSUTF8StringEncoding]);
            
            SudokuSolver *solver = [SudokuSolver new];
            
            if ([solver resolveGameInstace:game])
                [solver printGameInstance:game];
            
            printf("%d nós gerados, %d tentativas, tempo:%2.5f \n", [solver getNumTest], [solver getNumTest], [solver getTotalTime]);


        }
        
    }

        
    return 0;
}


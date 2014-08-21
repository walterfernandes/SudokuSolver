//
//  SudokuSolver.m
//  SudokuSolver
//
//  Created by walterfernandes on 17/04/14.
//  Copyright (c) 2014 walterfernandes. All rights reserved.
//

#import "SudokuSolver.h"
#import "SudokuSlot.h"

@implementation SudokuSolver

-(id)init{
    if ((self = [super init])){
        end = CFAbsoluteTimeGetCurrent();
        start = CFAbsoluteTimeGetCurrent();
        totalTime = 0.0f;
    }
    
    return self;
}

-(void)printGameInstance:(NSArray*)gameInstance {
    
    printf("\n|");
    for (int j = 0; j < kGameSize; j++) {
        printf("----");
        if (j%3 == 2)
            printf("|");
    }
    printf("\n|");
    
    for (int i = 0; i < kGameSize; i++){
        for (int j = 0; j < kGameSize; j++){
            printf(" %2d ", [gameInstance[i][j] intValue]);
            if (j%3 == 2)
                printf("|");
        }
        
        printf("\n|");
        if (i%3 == 2){
            for (int j = 0; j < kGameSize; j++) {
                printf("----");
                if (j%3 == 2)
                    printf("|");
            }
            if (i < (kGameSize-1))
                printf("\n|");
        }
    }
    printf("\n");
}

-(NSArray*)getAllSlots:(NSArray*)gameInstace{
    NSMutableArray *slots = [[NSMutableArray alloc] initWithCapacity:kGameSize^2];
    
    for (int x = 0; x < kGameSize; x++){
        for (int y = 0; y < kGameSize; y++){
            if ([gameInstace[x][y] intValue] == 0) {
                SudokuSlot *slot = [SudokuSlot new];
                slot.p = MakePosition(x, y);
                slot.f = [self getFieldScore:slot.p forGame:gameInstace];
                slot.possibles = [self getPossibles:slot.p forGameInstace:gameInstace];
                [slots addObject:slot];
            }
        }
    }

    return slots;
}

-(SudokuSlot*)getFirstSlots:(NSArray*)gameInstace{
    for (int i = 0; i < kGameSize; i++){
        for (int j = 0; j < kGameSize; j++){
            if ([gameInstace[i][j] intValue] == 0) {
                SudokuSlot *slot = [SudokuSlot new];
                slot.p = MakePosition(i, j);
                slot.f = [self getFieldScore:slot.p forGame:gameInstace];
                slot.possibles = [self getPossibles:slot.p forGameInstace:gameInstace];
                return slot;
            }
        }
    }
    return nil;
}

-(BOOL)isFinishGame:(NSArray*)gameInstace{
    BOOL line[kGameSize];
    BOOL column[kGameSize];
    BOOL square[kGameSize];
    
    //verifica repetição nas linhas e colunas
    for (int i = 0; i < kGameSize; i++){
        
        //reseta vetor de controle
        for (int x = 0; x < kGameSize; x++)
            line[x] = NO, column[x] = NO;
        
        for (int j = 0; j < kGameSize; j++){
            int l = [gameInstace[i][j] intValue] - 1;
            int c = [gameInstace[j][i] intValue] - 1;
            
            if ([gameInstace[i][j] intValue] == 0 || line[l] || column[c]) return NO;
            
            line[l] = YES;
            column[c] = YES;
            
        }
    }
    
    //verifica repetição no quadrante
    for (int k = 0; k < kGameSize; k++){
        
        ///reseta vetor de controle
        for (int x = 0; x < kGameSize; x++)
            square[x] = NO;
        
        for (int i = 0; i < kGameSize/3; i++){
            for (int j = 0; j < kGameSize/3; j++){
                int l = ([gameInstace[i + k%3*3][j + k%3*3] intValue] - 1);
                
                if (square[l]) return NO;
                
                square[l] = YES;
            }
        }
    }
    
    return YES;
}

-(int)getFieldScore:(SudokuPosition)p forGame:(NSArray*)gameInstance
{
    int fieldScore = 0;
    for( int k = 0; k < 9; k++ )
    {
        if( ( k != p.i && gameInstance[k][p.j] == gameInstance[p.i][p.j] ) ||
           ( k != p.j && gameInstance[p.i][k] == gameInstance[p.i][p.j] ) )
            ++fieldScore;
    }
    int sq_dim = kGameSize / 3;
    int row = p.i / sq_dim;
    int col = p.j / sq_dim;
    int row_from, row_to, col_from, col_to;
    
    row_from = row*sq_dim;
    row_to = row_from + sq_dim - 1;
    col_from = col*sq_dim;
    col_to = col_from + sq_dim - 1;
    for( int k = row_from; k <= row_to; k++ )
        for ( int l = col_from; l <= col_to; l++ )
            if( k != p.i && l != p.j && gameInstance[k][l] == gameInstance[p.i][p.j])
                ++fieldScore;
    
    return fieldScore;
}

-(NSArray*)getPossibles:(SudokuPosition)p forGameInstace:(NSArray*)gameInstance{
    NSMutableArray *possibles = [NSMutableArray arrayWithArray:@[@(1), @(2), @(3), @(4), @(5), @(6), @(7), @(8), @(9)]];
    
    for (int i = 0; i < kGameSize; i++){
        [possibles removeObject:gameInstance[p.i][i]];
        [possibles removeObject:gameInstance[i][p.j]];
    }
    
    
    int sq_dim = kGameSize / 3;
    int row = p.i / sq_dim;
    int col = p.j / sq_dim;
    int row_from, row_to, col_from, col_to;
    
    row_from = row*sq_dim;
    row_to = row_from + sq_dim - 1;
    col_from = col*sq_dim;
    col_to = col_from + sq_dim - 1;
    for( int k = row_from; k <= row_to; k++ )
        for ( int l = col_from; l <= col_to; l++ )
             [possibles removeObject:gameInstance[k][l]];
    
    return possibles;
}


-(NSMutableArray*)copyGameInstance:(NSArray*)gameInstance{
    NSMutableArray *copy = [NSMutableArray new];
    
    for (NSArray *line in gameInstance){
        NSMutableArray *lineCopy =  [NSMutableArray new];
        
        for (NSNumber *value in line)
            [lineCopy addObject:[value copy]];
        
        [copy addObject:lineCopy];
    }
    
    return copy;
}


-(BOOL)resolveGameInstace:(NSArray*)gameInstace{
    
    numTest++;

    totalTime = end - start;
    end = CFAbsoluteTimeGetCurrent();
    
    if ([self isFinishGame:gameInstace])
        return YES;
    else {
        SudokuSlot *slot = [self getFirstSlots:gameInstace];
        if (slot)
            for (NSNumber *value in slot.possibles){
                NSMutableArray *newGameInstace = [self copyGameInstance:gameInstace];
                newGameInstace[slot.p.i][slot.p.j] = value;
                if ([self resolveGameInstace:newGameInstace])
                    return YES;
            }
        
        return NO;
    }
}

-(float)getTotalTime{
    return totalTime;
}

-(int)getNumTest{
    return numTest;
}

@end

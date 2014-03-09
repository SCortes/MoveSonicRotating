//
//  MyScene.h
//  MoveSonicOverTheScreen
//

//  Copyright (c) 2014 Sergio. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyScene : SKScene

@property(strong, nonatomic) SKSpriteNode * sonic;

@property(strong, nonatomic) SKTexture *sonicSheet;
@property(strong, nonatomic) NSDictionary * coordenadas;

@end

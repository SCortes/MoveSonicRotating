//
//  MyScene.m
//  MoveSonicOverTheScreen
//
//  Created by Sergio on 09/03/14.
//  Copyright (c) 2014 Sergio. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene
@synthesize sonic, sonicSheet, coordenadas;

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        
        
        
    
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        if(sonic==nil){
            sonicSheet = [SKTexture textureWithImageNamed:@"SuperSonic2.gif"];
            NSString *path = [[NSBundle mainBundle] bundlePath];
            NSString *plistName = @"Lista_Sprites.plist";
            NSString *finalPath = [path stringByAppendingPathComponent:plistName];
            coordenadas = [NSDictionary dictionaryWithContentsOfFile:finalPath];
            NSArray * animacion = [[NSArray alloc] initWithArray:[self loadFramesFromSpriteSheet:sonicSheet WithBaseFileName:@"sonic_fly" WithNumberOfFrames:4 WithCoordenadas:coordenadas]];
           
            sonic = [SKSpriteNode spriteNodeWithTexture:animacion[1]];
            
            [sonic runAction:
                [SKAction repeatActionForever:[SKAction animateWithTextures:animacion
                                                               timePerFrame:0.2]]];
            
            sonic.position = [touch locationInNode:self];
            sonic.anchorPoint = CGPointMake(0, 0);
            sonic.name = @"sonic";
            [self addChild:sonic];

            
        }else if(sonic != (SKSpriteNode *)[self nodeAtPoint:[touch locationInNode:self]]){
            [self moveSonicTo:[touch locationInNode:self]];
        }
    
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        if(![sonic actionForKey:@"mover"])
        {
            if(sonic == (SKSpriteNode *)[self nodeAtPoint:[touch
                                                           locationInNode:self]])
            {
                sonic.position = [touch locationInNode:self];
            } }
    }
}

-(void)moveSonicTo:(CGPoint)location
{
    [sonic removeActionForKey:@"mover"];
    float base=0;
    CGFloat distancia = sqrtf((location.x-sonic.position.x)*(location.x-
                                                             sonic.position.x)+(location.y-sonic.position.y)*(location.y-sonic.position.y));
    if (sonic.position.x > location.x && sonic.position.y <= location.y) {
        base = M_PI; }
    else if (sonic.position.x > location.x && sonic.position.y > location.y)
    {
        base = 3*M_PI/2;
    }
    else if (sonic.position.x <= location.x && sonic.position.y > location.y)
    {
        base = 2*M_PI;
    }
    float angulo = asinf( fabsf(location.y-sonic.position.y)/distancia);
    if(base !=0){
        angulo = base - angulo;
    }
    SKAction *giroInicio = [SKAction rotateToAngle:angulo
                                          duration:angulo/20
                                   shortestUnitArc:YES];
    
    SKAction *mover = [SKAction moveTo:location
                              duration:distancia/200];
    
    SKAction *giroFin = [SKAction rotateToAngle:0
                                       duration:angulo/20
                                shortestUnitArc:YES];
    
    [sonic runAction:[SKAction sequence:@[[SKAction
                                           group:@[giroInicio,mover]],giroFin]] withKey:@"mover"];
}

-(NSArray *)loadFramesFromSpriteSheet:(SKTexture *)textureSpriteSheet
                     WithBaseFileName: (NSString *)baseFileName WithNumberOfFrames: (int)
numberOfFrames WithCoordenadas: (NSDictionary *)coordenadasSpriteSheet
{
    NSMutableArray *frames = [NSMutableArray arrayWithCapacity:numberOfFrames
                              +1];
    for(int i = 1; i<=numberOfFrames;i++)
    {
        NSDictionary *coordenadasSprite = [coordenadasSpriteSheet objectForKey:
                                           [NSString stringWithFormat:@"%@%d", baseFileName, i]];
        NSString *x = [coordenadasSprite objectForKey:@"x"];
        NSString *y = [coordenadasSprite objectForKey:@"y"];
        NSString *width = [coordenadasSprite objectForKey:@"width"];
        NSString *height = [coordenadasSprite objectForKey:@"height"];
        SKTexture *texture = [SKTexture textureWithRect:
                              CGRectMake((CGFloat)[x floatValue]/
                                         textureSpriteSheet.size.width,
                                         (textureSpriteSheet.size.height-(CGFloat)[y floatValue]-((CGFloat)[height floatValue]))/textureSpriteSheet.size.height,(CGFloat)[width floatValue]/textureSpriteSheet.size.width,(CGFloat)[height floatValue]/
                                         textureSpriteSheet.size.height)
                                              inTexture:textureSpriteSheet];
        [frames addObject:texture];
    }
    return frames;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end

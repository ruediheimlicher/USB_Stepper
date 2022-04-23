//
//  rElement.m
//  USB_Stepper
//
//  Created by Ruedi Heimlicher on 20.September.11.
//  Copyright 2011 Skype. All rights reserved.
//

#import "rElement.h"


@implementation rElement 

- (id)init
{
    self = [super init];
    if (self) 
    {
        // Initialization code here.
    }
    
    return self;
}

- (NSPoint)Startpunkt
{
   return Startpunkt;
}
- (NSPoint)Endpunkt
{
   return Endpunkt;
}
- (NSArray*)ElementdatenArray
{
   return ElementdatenArray;
}

- (int)ElementSichern
{
   int erfolg=0;
   NSLog(@"ElementSichern");
   BOOL ElementDa=NO;
   BOOL istOrdner;
   NSError* error=0;
   NSFileManager *Filemanager = [NSFileManager defaultManager];
   NSString* LibPfad=[NSHomeDirectory() stringByAppendingFormat:@"%@%@%@",@"/Documents",@"/CNCDaten",@"/ElementLib"];
   ElementDa= ([Filemanager fileExistsAtPath:LibPfad isDirectory:&istOrdner]&&istOrdner);
   NSLog(@"ElementSichern:    LibPfad: %@",LibPfad );	
   if (ElementDa)
   {
      ;
   }
   else
   {
      BOOL OrdnerOK=[Filemanager createDirectoryAtPath:LibPfad withIntermediateDirectories:NO  attributes:NULL error:&error];
      //Datenordner ist noch leer
      
   }


   return erfolg;
}

- (rElement*)ElementHolen:(NSString*)LibName
{
   int erfolg=0;
   rElement* LibElement;
   NSLog(@"ElementHolen");
   BOOL istOrdner;
   NSFileManager *Filemanager = [NSFileManager defaultManager];
   NSString* LibPfad=[NSHomeDirectory() stringByAppendingFormat:@"%@%@",@"/Documents",@"/CNCDaten",@"/ElementLib"];
   erfolg= ([Filemanager fileExistsAtPath:LibPfad isDirectory:&istOrdner]&&istOrdner);
   NSLog(@"Elementholen:   LibPfad: %@",LibPfad);	
   if (erfolg)
   {
      
      //NSLog(@"Elementholen: tempPListDic: %@",[tempPListDic description]);
      
      NSString* PListPfad;
      //NSLog(@"\n\n");
      LibPfad=[LibPfad stringByAppendingPathComponent:LibName];
      NSLog(@"Elementholen: LibPfad: %@ ",LibPfad);
      if ([Filemanager fileExistsAtPath:LibPfad])
      {
         LibElement=[NSDictionary dictionaryWithContentsOfFile:LibPfad];

      }
      
   }// erfolg
   /*
    - (void)readPList
    {
    BOOL USBDatenDa=NO;
    BOOL istOrdner;
    NSFileManager *Filemanager = [NSFileManager defaultManager];
    NSString* USBPfad=[[NSHomeDirectory() stringByAppendingFormat:@"%@%@",@"/Documents",@"/CNCDaten"]retain];
    USBDatenDa= ([Filemanager fileExistsAtPath:USBPfad isDirectory:&istOrdner]&&istOrdner);
    //NSLog(@"mountedVolume:    USBPfad: %@",USBPfad);	
    if (USBDatenDa)
    {
    
    //NSLog(@"awake: tempPListDic: %@",[tempPListDic description]);
    
    NSString* PListName=@"CNC.plist";
    NSString* PListPfad;
    //NSLog(@"\n\n");
    PListPfad=[USBPfad stringByAppendingPathComponent:PListName];
    NSLog(@"awake: PListPfad: %@ ",PListPfad);
    if (PListPfad)		
    {
    NSMutableDictionary* tempPListDic;//=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
    if ([Filemanager fileExistsAtPath:PListPfad])
    {
    tempPListDic=[NSMutableDictionary dictionaryWithContentsOfFile:PListPfad];
    //NSLog(@"awake: tempPListDic: %@",[tempPListDic description]);
    
    if ([tempPListDic objectForKey:@"koordinatentabelle"])
    {
    NSArray* PListKoordTabelle=[tempPListDic objectForKey:@"koordinatentabelle"];
    //NSLog(@"awake: PListKoordTabelle: %@",[PListKoordTabelle description]);
    }
    }
    
    }
    //	NSLog(@"PListOK: %d",PListOK);
    
    }//USBDatenDa
    }

    */
   return LibElement;
}


- (void)dealloc
{
    //[super dealloc];
}

@end

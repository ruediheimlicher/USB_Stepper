//
//  rAVRController.m
//  USBInterface
//
//  Created by Sysadmin on 12.02.08.
//  Copyright 2008 Ruedi Heimlicher. All rights reserved.
//

#import "USBWindowController.h"
extern int usbstatus;

/*
node insert_right(node list, int data)
{
   node *new_node = (node) malloc(sizeof(struct list_node));
   new_node->data = data;
   new_node->next = list->next;
   list->next     = new_node;
   return new_node;
}
*/


@implementation IOWarriorWindowController(rAVRController)



- (IBAction)showAVR:(id)sender
{

//NSLog(@"AVR showAVR");
 //	[self Alert:@"showAVR start init"];
	if (!AVR)
	  {
	  //[self Alert:@"showAVR vor init"];
		//NSLog(@"showAVR");
		AVR=[[rAVR alloc]init];
		//[self Alert:@"showAVR nach init"];
	  }
	  //[self Alert:@"showAVR nach init"];
//	NSMutableArray* 
//	if ([AVR window]) ;
	
//	[self Alert:@"showAVR window da"];
   
   /*
   
   NSAlert *alert = [[NSAlert alloc] init];
   alert.messageText = @"Invalid data format";
   alert.informativeText = @"Please only use hex values between 00 and FF.";
   // [alert runModal];
   [alert beginSheetModalForWindow:self->window completionHandler:^(NSModalResponse returnCode) {
      if (returnCode == NSAlertSecondButtonReturn) {
         NSLog(@"Delete was cancelled!");
         return;
      }
      
      NSLog(@"This project was deleted!");
   }];
   */

	[AVR showWindow:NULL];
	
	// [self Alert:@"showAVR nach showWindow"];

}



- (IBAction)openProfil:(id)sender
{
NSLog(@"AVRController neues Profil");

}


- (IBAction)save:(id)sender
{
   NSLog(@"AVRController save");
   [AVR saveStepperDic:sender];
}


#pragma mark SPI
/* ********************************************** */
/* *** SPI  ************************************* */
/* ********************************************** */
/*
Bsp von http://forum.codemercs.com/viewtopic.php?f=2&t=1220&sid=ebd97b20e20ea96e8fa27497e58900ab
IntPtr devHandle;
byte[] rep = new byte[8];
byte[] srep = new byte[64];

private void button4_Click(object sender, EventArgs e)
{
    // SPI aktivieren 
    srep[0] = 0x08; // ID für SPI
    srep[1] = 0x01; // SPI enable
    srep[2] = 0x00; // MSB first, CPOL=0, CPHA=0
    srep[3] = 0x77; // 200 kHz
    iowkit.IowKitWrite(devHandle, 1, srep, (uint)srep.Length);

    // Daten senden 
    srep[0] = 0x09; // ID für SPI-Data
    srep[1] = 0x09; // 9 Bytes
    srep[2] = 0x00; // kein DRDY, /SS nach der Übertragung nicht mehr aktiv
    srep[3] = 0x0E; // Instruction-Byte und 8 Byte Registerdaten
    srep[4] = 0x00;
    srep[5] = 0x00;
    srep[6] = 0x00;
    srep[7] = 0x00;
    srep[8] = 0x0F;
    srep[9] = 0x00;
    srep[10] = 0x00;
    srep[11] = 0x00;
    iowkit.IowKitWrite(devHandle, 1, srep, (uint)srep.Length);

    // SPI deaktivieren 
    srep[0] = 0x08; // ID für SPI
    srep[1] = 0x00; // SPI disable
    iowkit.IowKitWrite(devHandle, 1, srep, (uint)srep.Length);

    // IO-Update 
    rep[1]  |= 0x08; // IO-Update-Pin an Port 0.3
    iowkit.IowKitWrite(devHandle, 0, rep, (uint)rep.Length);
    Thread.Sleep(10);
    rep[1] &= ^0x08;
    iowkit.IowKitWrite(devHandle, 0, rep, (uint)rep.Length);
}

*/
 
/* ********************************************** */
/* *** SPI END ********************************** */
/* ********************************************** */
#pragma mark TWI
/* ********************************************** */
/* *** I2C Begin ******************************** */
/* ********************************************** */

//



- (void)WriteSchnittdatenArrayReportAktion:(NSNotification*)note
{
	NSLog(@"WriteSchnittdatenArrayReportAktion");
 //NSLog(@"WriteSchnittdatenArrayReportAktion note: %@",[[note userInfo]objectForKey:@"schnittdatenarray"]);
	if ([[note userInfo]objectForKey:@"schnittdatenarray"])
	{
	//	[SchnittDatenArray setArray:[[note userInfo]objectForKey:@"schnittdatenarray"]];
		
		Stepperposition=0;
		[self writeCNCAbschnitt];
		
	}


}




- (void)USBAktion:(NSNotification*)note
{
   //NSLog(@"USBAktion usbstatus: %d",usbstatus);
   if ([[note userInfo]objectForKey:@"usb"])
   {
      switch ([[[note userInfo]objectForKey:@"usb"]intValue]) 
      {
         case NEUTASTE:
         case USBTASTE:
         {
            //NSLog(@"wait USB");
            [self performSelector:@selector (USBOpen) withObject:NULL afterDelay:2];

         }break;
         case ANDERESEITEANFAHREN:
         case OBERKANTEANFAHREN:
         case HOMETASTE:
            
         {
            [self USBOpen];
            if (usbstatus==0)
            {
               /*
               NSAlert *Warnung = [[NSAlert alloc] init];
               //[Warnung addButtonWithTitle:@"Einstecken und einschalten"];
               [Warnung addButtonWithTitle:@"Zurück"];
               //	[Warnung addButtonWithTitle:@""];
               //[Warnung addButtonWithTitle:@"Abbrechen"];
               [Warnung setMessageText:[NSString stringWithFormat:@"%@",@"USB ist nicht aktiv."]];
               
               NSString* s1=@"";
               NSString* s2=@"";
               NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
               [Warnung setInformativeText:InformationString];
               [Warnung setAlertStyle:NSWarningAlertStyle];
               
               int antwort=[Warnung runModal];
                */
            }
         }  break;
         case USBREMOVED:
         {
            NSLog(@"USB removed");
            [AVR setUSB_Device_Status:0];

         }break;
         default:
            break;
      }
      
      

   } 
}
/*
- (int)USBOpen
{
   
   int  r;
   
   r = rawhid_open(1, 0x16C0, 0x0480, 0xFFAB, 0x0200);
   if (r <= 0) 
   {
      NSLog(@"USBAktion: no rawhid device found");
      [AVR setUSB_Device_Status:0];
   }
   else
   {
      NSLog(@"USBAktion: found rawhid device %d",usbstatus);
      [AVR setUSB_Device_Status:1];
   }
   usbstatus=r;
   

   return r;
}
*/
/*******************************************************************/
// CNC
/*******************************************************************/
- (void)USB_SchnittdatenAktion:(NSNotification*)note
{
   //NSLog(@"USB_SchnittdatenAktion usbstatus: %d usb_present: %d",usbstatus,usb_present());
   int antwort=0;
   int delayok=0;
   
   /*
    int usb_da=usb_present();
    //NSLog(@"usb_da: %d",usb_da);
    
    const char* manu = get_manu();
    //fprintf(stderr,"manu: %s\n",manu);
    NSString* Manu = [NSString stringWithUTF8String:manu];
    
    const char* prod = get_prod();
    //fprintf(stderr,"prod: %s\n",prod);
    NSString* Prod = [NSString stringWithUTF8String:prod];
    //NSLog(@"Manu: %@ Prod: %@",Manu, Prod);
    */
   if (usbstatus == 0)
   {
      NSAlert *Warnung = [[NSAlert alloc] init];
      [Warnung addButtonWithTitle:@"Einstecken und einschalten"];
      [Warnung addButtonWithTitle:@"Zurück"];
      //   [Warnung addButtonWithTitle:@""];
      //[Warnung addButtonWithTitle:@"Abbrechen"];
      [Warnung setMessageText:[NSString stringWithFormat:@"%@",@"CNC Schnitt starten"]];
      
      NSString* s1=@"USB_SchnittdatenAktion: USB ist noch nicht eingesteckt.";
      NSString* s2=@"";
      NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
      [Warnung setInformativeText:InformationString];
      [Warnung setAlertStyle:NSAlertStyleWarning];
      
      antwort=[Warnung runModal];
      [AVR DC_ON:0];
      [AVR setStepperstrom:0];
      
      // return;
      // NSLog(@"antwort: %d",antwort);
      switch (antwort)
      {
         case NSAlertFirstButtonReturn: // Einschalten
         {
            [self USBOpen];
            /*
             int  r;
             
             r = rawhid_open(1, 0x16C0, 0x0480, 0xFFAB, 0x0200);
             if (r <= 0) 
             {
             NSLog(@"USBAktion: no rawhid device found");
             [AVR setUSB_Device_Status:0];
             return;
             }
             else
             {
             
             NSLog(@"USBAktion: found rawhid device %d",usbstatus);
             [AVR setUSB_Device_Status:1];
             }
             usbstatus=r;
             */
         }break;
            
         case NSAlertSecondButtonReturn: // Ignorieren
         {
            return;
         }break;
            
         case NSAlertThirdButtonReturn: // Abbrechen
         {
            return;
         }break;
      }
      
   }
   [SchnittDatenArray setArray:[NSArray array]];
   //NSLog(@"USB_SchnittdatenAktion SchnittDatenArray vor: %@",[SchnittDatenArray description]);
   //NSLog(@"USB_SchnittdatenAktion SchnittDatenArray Stepperposition: %d",Stepperposition);
   //NSLog(@"USB_SchnittdatenAktion note: %@",[[note userInfo]description]);
   pwm = 0;
   
   if ([[note userInfo]objectForKey:@"pwm"])
   {
      pwm = [[[note userInfo]objectForKey:@"pwm"]intValue];
      //NSLog(@"USB_SchnittdatenAktion pwm: %d",pwm);
   }
   
   
   if ([[note userInfo]objectForKey:@"schnittdatenarray"])
   {
      
      int home = 0;
      if ([[note userInfo]objectForKey:@"home"])
      {
         home = [[[note userInfo]objectForKey:@"home"]intValue];
         
      }
      
      //NSLog(@"USB_SchnittdatenAktion Object 0 aus SchnittDatenArray aus note: %@",[[[[note userInfo]objectForKey:@"schnittdatenarray"]objectAtIndex:0] description]);
      
      [SchnittDatenArray setArray:[[note userInfo]objectForKey:@"schnittdatenarray"]];
      //NSLog(@"USB_SchnittdatenAktion SchnittDatenArray: %@",[SchnittDatenArray description]);
      
      //NSLog(@"USB_SchnittdatenAktion SchnittDatenArray %@",[[SchnittDatenArray objectAtIndex:0] description]);
      //NSLog(@"USB_SchnittdatenAktion SchnittDatenArray: %@",[SchnittDatenArray description]);
      
      Stepperposition=0; // Startposition im Schnittdatenarray
      [AVR setBusy:1];
      
      
      [self writeCNCAbschnitt];
      //NSLog(@"readUSB Start Timer");
      
      // home ist 1 wenn homebutton gedrückt ist
      NSMutableDictionary* timerDic =[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:home],@"home", nil];
      
      
      if (readTimer)
      {
         if ([readTimer isValid])
         {
            NSLog(@"USB_SchnittdatenAktion laufender timer inval");
            [readTimer invalidate];
            
         }
         readTimer = NULL;
         
      }
      
      readTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
                    
                                                    target:self 
                                                  selector:@selector(readUSB:) 
                                                  userInfo:timerDic repeats:YES];
      
   }
   // Kopfzeile fuer readUSB
   //   fprintf(stderr,"dauer2 bis vor switch:\tdauer3 bis nach switch:\tdauer4 vor writeCNCAbschnitt:\tdauer5 nach writeCNCAbschnitt:\tdauer6 nach if endindex:\tdauer7 nach notific:\ttotal:\n");
   
   // Kopfzeile fuer writeCNCAbschnitt
   //fprintf(stderr,"dauer1 vor scanner-loop:\tdauer2 nach scanner-loop:\tdauer3 vor rawhid_send:\tdauer4 nach rawhid_send:\tdauer6:\tdauer7:\ttotal:\n");
   
}


- (void)SlaveResetAktion:(NSNotification*)note

{
   //NSLog(@"***");
   //NSLog(@"SlaveResetAktion");
   
   char*      sendbuffer;
   sendbuffer=malloc(32);
   int i;
   for (i=0;i<32;i++)
   {
      sendbuffer[i] = 0;
   }
//   NSMutableDictionary* timerDic =[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1],@"reset", nil];

   /*
   readTimer = [[NSTimer scheduledTimerWithTimeInterval:0.1
                                                 target:self 
                                               selector:@selector(readUSB:) 
                                               userInfo:timerDic repeats:YES]retain];
*/
   sendbuffer[16] = 0xF1;
   sendbuffer[20] = 0x00;
//   int senderfolg= rawhid_send(0, sendbuffer, 32, 50);

   free(sendbuffer);
   
   [HomeAnschlagSet removeAllIndexes];

}

- (void)writeCNCAbschnitt
{
   //NSLog(@"writeCNCAbschnitt Start Stepperposition: %d count: %d",Stepperposition,[SchnittDatenArray count]);
   //NSLog(@"writeCNCAbschnitt SchnittDatenArray anz: %d\n SchnittDatenArray: %@",[SchnittDatenArray count],[SchnittDatenArray description]);
   
   /*
    double dauer0 = 0;
    double dauer1 = 0;
    double dauer2 = 0;
    double dauer3 = 0;
    double dauer4 = 0;
    double dauer5 = 0;
    double dauer6 = 0;
    double dauer7 = 0;
    double dauer8 = 0;
    */
   
   
   if (Stepperposition < [SchnittDatenArray count])
   {   
      NSDate* dateA=[NSDate date];
      //dauer1 = [dateA timeIntervalSinceNow]*1000;
      // HALT
      //if ([AVR halt_status])
      
      if (halt_status)
      {
         NSLog(@"writeCNCAbschnitt HALT");
         [AVR setBusy:0];
         [self DC_Aktion:NULL];
         
         if (readTimer)
         {
            if ([readTimer isValid])
            {
               NSLog(@"writeCNCAbschnitt HALT timer inval");
               [readTimer invalidate];
            }
            readTimer = NULL;
            
         }
         
      }
      else 
      {
         char*      sendbuffer;
         sendbuffer=malloc(32);
         //
         int i;
         
         //        pwm = [AVR pwm];
         
         // sendbuffer mit Daten von Schnittdatenarray an pos Stepperposition fuellen
         NSMutableArray* tempSchnittdatenArray=(NSMutableArray*)[SchnittDatenArray objectAtIndex:Stepperposition];
         if (Stepperposition > 34)
         {
         //NSLog(@"writeCNCAbschnitt tempSchnittdatenArray: %@",[tempSchnittdatenArray description]);
         }
         
         [tempSchnittdatenArray replaceObjectAtIndex:20 withObject:[NSNumber numberWithInt:[AVR pwm]]];
         
         NSScanner *theScanner;
         unsigned     value;
         //NSLog(@"writeCNCAbschnitt tempSchnittdatenArray count: %d",[tempSchnittdatenArray count]);
         //NSLog(@"tempSchnittdatenArray object 20: %d",[[tempSchnittdatenArray objectAtIndex:20]intValue]);
         //NSLog(@"loop start");
         //NSDate *anfang = [NSDate date];
         //dauer1 = [dateA timeIntervalSinceNow]*1000;
         for (i=0;i<[tempSchnittdatenArray count];i++)
         {
            int tempWert=[[tempSchnittdatenArray objectAtIndex:i]intValue];
            //fprintf(stderr,"%d\t",tempWert);
            NSString*  tempHexString=[NSString stringWithFormat:@"%x",tempWert];
            theScanner = [NSScanner scannerWithString:tempHexString];
            if ([theScanner scanHexInt:&value])
            {
               sendbuffer[i] = (char)value;
            }
            else
            {
               NSAlert *alert = [[NSAlert alloc] init];
               [alert setMessageText:@"Invalid data format"];
               [alert setInformativeText:@"Please only use hex values between 00 and FF."];
               [alert addButtonWithTitle:@"OK"];
               // [alert addButtonWithTitle:@"Cancel"];
               [alert setAlertStyle:NSAlertStyleWarning];
               
               
               
               [alert beginSheetModalForWindow:self->window completionHandler:^(NSModalResponse returnCode) {
                  if (returnCode == NSAlertSecondButtonReturn) {
                     NSLog(@"Umnumerieren erfolglos!");
                     return;
                  }
                  
                  NSLog(@"Invalid data format");
                  return;
               }];
               
               
               //  NSRunAlertPanel (@"Invalid data format", @"Please only use hex values between 00 and FF.", @"OK", nil, nil);
               //free (sendbuffer);
               return;
            }
            
            //sendbuffer[i]=(char)[[tempSchnittdatenArray objectAtIndex:i]UTF8String];
         }
         
         //dauer2 = [dateA timeIntervalSinceNow]*1000;
         //double delta = [anfang timeIntervalSinceNow]*1000;
         //NSLog(@"delta: %f ms",delta);
         
         fprintf(stderr,"\n");
         
         //sendbuffer[20] = pwm;
         //NSLog(@"writeCNCAbschnitt ********   code: %d  position: %d",sendbuffer[16],sendbuffer[17]);
         
         //NSLog(@"writeCNCAbschnitt  Stepperposition: %d  pwm: %d",Stepperposition,sendbuffer[20]);                 
         int senderfolg= rawhid_send(0, sendbuffer, 32, 50);
         
         
         //dauer4 = [dateA timeIntervalSinceNow]*1000;
         //         int senderfolg= rawhid_send(0, newsendbuffer, 32, 50);
         
         //NSLog(@"writeCNCAbschnitt senderfolg: %X",senderfolg);
         //NSLog(@"writeCNCAbschnitt End Stepperposition: %d ",Stepperposition);
         
         Stepperposition++;
         
         free (sendbuffer);
      } // else
   }
   else
   {
      NSLog(@"writeCNCAbschnitt >count\n*\n\n");
      //NSLog(@"writeCNCAbschnitt timer inval");
      [AVR setBusy:0];
      [self DC_Aktion:NULL];
      
      if (readTimer)
      {
         if ([readTimer isValid])
         {
            //NSLog(@"writeCNCAbschnitt timer inval");
            [readTimer invalidate];
         }
         readTimer = NULL;
         
      }
      
      
   }
   
   /*
    fprintf(stderr,"%f\t", dauer1*-1);
    fprintf(stderr,"%f\t", dauer2*-1);
    fprintf(stderr,"%f\t", dauer3*-1);
    fprintf(stderr,"%f\t", dauer4*-1);
    fprintf(stderr,"%f\t", dauer5*-1);
    fprintf(stderr,"%f\t", dauer6*-1);
    fprintf(stderr,"%f\t", dauer7*-1);
    fprintf(stderr,"%f\n", dauer8*-1);
    */
}

- (void)stopTimer
{
   if (readTimer)
   {
      if ([readTimer isValid])
      {
         //NSLog(@"stopTimer timer inval");
         [readTimer invalidate];
         
      }
      readTimer = NULL;
      [AVR setBusy:0];
      [AVR DC_ON:0];
      [self DC_Aktion:NULL];
      
   }

}

- (void)readUSB:(NSTimer*) inTimer
{
   char        buffer[32]={};
   int          result = 0;
   NSData*      dataRead;
   int         reportSize=32;
   
   /*
    double dauer0 = 0;
    double dauer1 = 0;
    double dauer2 = 0;
    double dauer3 = 0;
    double dauer4 = 0;
    double dauer5 = 0;
    double dauer6 = 0;
    double dauer7 = 0;
    double dauer8 = 0;
    */
   
   if (Stepperposition ==0)//< [SchnittDatenArray count])
   {
      NSLog(@"readUSB Stepperposition = 0");
      [self stopTimer];
      return;
   }
   //NSLog(@"readUSB A");
   
   
   result = rawhid_recv(0, buffer, 32, 50);
   
   
   //fprintf(stderr,"readUSB rawhid_recv: %d\n",result);
   dataRead = [NSData dataWithBytes:buffer length:reportSize];
   
   //NSLog(@"ignoreDuplicates: %d",ignoreDuplicates);
   //NSLog(@"lastValueRead: %@",[lastValueRead description]);
   
   //NSLog(@"dataRead: %@",[dataRead description]);
   if ([dataRead isEqualTo:lastValueRead])
   {
      //NSLog(@"readUSB Daten identisch");
   }
   else
   {
      //NSLog(@"dataRead: %@",[dataRead description]);
      [self setLastValueRead:dataRead];
      int abschnittcode=(UInt8)buffer[0];     // code fuer Art des Pakets
     NSLog(@"readUSB abschnittcode0: %d\thex: \t%02X\n",abschnittcode,abschnittcode);
 /*
      for (int i=0; i<23;i++)
      {
         //fprintf(stderr, "i: %d  %d ",i,(buffer[i] & 0xFF));
         fprintf(stderr,"%u\t",(UInt8)buffer[i]);
         //NSLog(@"i: %d char: %x data: %d",i,(buffer[i] & 0xFF),[[NSNumber numberWithInt:(UInt8)buffer[i]]intValue]);
      }
      fprintf(stderr,"\n");
  */
      if (abschnittcode==0)
      {
         //NSLog(@"readUSB abschnittcode = 0");
         
         return;
      }
  //   fprintf(stderr, "readUSB abschnittcode0:\t%02X\n",abschnittcode);
      if (abschnittcode==0xBA)
      {
         NSLog(@"readUSB BA");
      }
      NSDate* dateA=[NSDate date];
      int home=0;
      
      if ([inTimer isValid])
      {
         if([[inTimer userInfo]objectForKey:@"home"])
         {
            home = [[[inTimer userInfo]objectForKey:@"home"] intValue];
            //NSLog(@"readUSB                home aus timer: %d",home);
         }
      }
      
      
      int i=0;
      
      for (i=0; i<10;i++)
      {
         //NSLog(@"i: %d char: %x data: %d",i,(buffer[i] & 0xFF),[[NSNumber numberWithInt:(UInt8)buffer[i]]intValue]);
      }
      
      
      //NSLog(@"**");
      //NSNumber* curr_num=[NSNumber numberWithInt:(UInt8)buffer[1]];
      //NSLog(@"**   AbschnittCounter: %@",curr_num);
      
      //int abschnittcode=(UInt8)buffer[0];     // code fuer Art des Pakets
      
      
      
      //NSLog(@"**read_USB   buffer 0: %02X motor: %d",(UInt8)buffer[0],(UInt8)buffer[21]);
      
      //       if (abschnittcode >= 0xA0) // Code fuer Fertig: AD
      {
         // verschoben von oben 
         NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
         
         NSNumber* Abschnittnummer=[NSNumber numberWithInt:(UInt8)buffer[5]];
         NSLog(@"**readUSB   buffer 5 inposition: %d",(UInt8)buffer[5]);
         
         [NotificationDic setObject:Abschnittnummer forKey:@"inposition"];
         
         NSNumber* ladePosition=[NSNumber numberWithInt:(UInt8)buffer[8]];
         //NSLog(@"**   ladePosition NSNumber: %d",[ladePosition intValue]);
         NSLog(@"**readUSB   buffer 6 outposition: %d",(UInt8)buffer[8]);
         [NotificationDic setObject:ladePosition forKey:@"outposition"];
         
         
         uint8_t intervallH = (UInt8)buffer[14];
         [NotificationDic setObject:[NSNumber numberWithInt:intervallH] forKey:@"intervallh"];
         uint8_t intervallL = (UInt8)buffer[15];
         [NotificationDic setObject:[NSNumber numberWithInt:intervallL] forKey:@"intervalll"];
         
             
         [NotificationDic setObject:[NSNumber numberWithInt:Stepperposition] forKey:@"stepperposition"];
         
         // cncstatus abfragen
         //NSNumber* cncstatus=[NSNumber numberWithInt:(UInt8)buffer[8]];
         [NotificationDic setObject:[NSNumber numberWithInt:mausistdown] forKey:@"mausistdown"];
         // end verschieben
         
         /*
          Array:
          
          0    schritteax lb
          1    schritteax hb
          2    schritteay lb
          3    schritteay hb
          
          4    delayax lb
          5    delayax hb
          6    delayay lb
          7    delayay hb
          
          8    schrittebx lb
          9    schrittebx hb
          10   schritteby lb
          11   schritteby hb
          
          12   delaybx lb
          13   delaybx hb
          14   delayby lb
          15   delayby hb
          
          16   code
          17   position // first, last, ...
          18   indexh
          19   indexl
          
          20   pwm
          
          21   motorstatus: relevanter Motor fuer Abschnitt
          
          */
         NSMutableIndexSet* AnschlagSet = [NSMutableIndexSet indexSet]; // Index fuer zu loeschende Daten im Schnittdatenarray
         // Index fuer zu loeschende Daten im Schnittdatenarray
         switch (abschnittcode)
         {
               /*
                case 0xAF:
                {
                NSLog(@"readUSB  AF next ");
                }break;
                */
            case 0xE1: // Antwort auf Mouseup 0xE0 HALT
            {
               NSLog(@"readUSB  mouseup ");
               [SchnittDatenArray removeAllObjects];
               
               [AVR setBusy:0];
               
               //[self DC_Aktion:NULL]; // auskopmmentoiert: DC nicht abstellen bei Pfeilaktionen
               if (readTimer)
               {
                  if ([readTimer isValid])
                  {
                     //NSLog(@"readUSB  mouseup timer inval");
                     
                     
                     [readTimer invalidate];
                  }
                  readTimer = NULL;
                  
               }
               Stepperposition=0;
               
            }break;
               
            case 0xEA: // home
            {
               NSLog(@"readUSB  home gemeldet");
            }break;
               
               // Anschlag first
            case 0xA5:   
            {
               NSLog(@"Anschlag A0");
               [AnschlagSet addIndex:0];// schritteax lb
               [AnschlagSet addIndex:1];// schritteax hb
               [AnschlagSet addIndex:4];// delayax lb
               [AnschlagSet addIndex:5];// delayax hb
               
            }break;
               
            case 0xA6:   
            {
               NSLog(@"Anschlag B0");
               [AnschlagSet addIndex:2];// schritteay lb
               [AnschlagSet addIndex:3];// schritteay hb
               [AnschlagSet addIndex:6];// delayay lb
               [AnschlagSet addIndex:7];// delayay hb
               
            }break;
               
            case 0xA7:   
            {
               NSLog(@"Anschlag C0");
               [AnschlagSet addIndex:8];// schrittebx lb
               [AnschlagSet addIndex:9];// schrittebx hb
               [AnschlagSet addIndex:12];// delaybx lb
               [AnschlagSet addIndex:13];// delaybx hb
            }break;
               
            case 0xA8:   
            {
               NSLog(@"Anschlag D0");
               [AnschlagSet addIndex:10];// schritteby lb
               [AnschlagSet addIndex:11];// schritteby hb
               [AnschlagSet addIndex:14];// delayby lb
               [AnschlagSet addIndex:15];// delayby hb
            }break;
               
               
               // Anschlag home first
               
            case 0xB5:
            {
               NSLog(@"Anschlag A home first");
               [HomeAnschlagSet addIndex:0xB5];
            }break;
               
            case 0xB6:
            {
               NSLog(@"Anschlag B home first");
               [HomeAnschlagSet addIndex:0xB6];
            }break;
               
            case 0xB7:
            {
               NSLog(@"Anschlag C home first");
               [HomeAnschlagSet addIndex:0xB7];
            }break;
               
            case 0xB8:
            {
               NSLog(@"Anschlag D home first");
               [HomeAnschlagSet addIndex:0xB8];
            }break;
               
               
               
               // Anschlag Second   
            case 0xC5:
            {
               NSLog(@"Anschlag A home  second");
               
            }break;
               
            case 0xC6:
            {
               NSLog(@"Anschlag B home  second");
            }break;
               
            case 0xC7:
            {
               NSLog(@"Anschlag C home  second");
            }break;
               
            case 0xC8:
            {
               NSLog(@"Anschlag D home  second");
            }break;
               
               
               // Letzter Abschnitt   
               
            case 0xD0:
            {
               NSLog(@"letzter Abschnitt");
               [NotificationDic setObject:[NSNumber numberWithInt:abschnittcode] forKey:@"abschnittcode"];
               NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
               [nc postNotificationName:@"usbread" object:self userInfo:NotificationDic];
               return;
            }break;
  
            case 0xD1:
            {
               NSLog(@"first paket ok");
               [AVR setBusy:0];
            }break;

            case 0xF2:
            {
               NSLog(@"reset");
            }break;
               
               
         }// switch abschnittcode
         
         //dauer3 = [dateA timeIntervalSinceNow]*1000;
         //NSLog(@"readUSB dauer bis nach switch: %f ms", dauer);
         
         if ([AnschlagSet count])
         {
            for(i=Stepperposition-1;i<[SchnittDatenArray count];i++)
            {
               NSMutableArray* tempZeilenArray = [SchnittDatenArray objectAtIndex:i];
               //NSLog(@"i: %d tempZeilenArray : %@",i,[tempZeilenArray description]);
               int k=0;
               
               for (k=0;k<[tempZeilenArray count];k++)
               {
                  
                  if ([AnschlagSet containsIndex:k]) // Anschlag-Daten sollen null gesetzt werden
                  {
                     [tempZeilenArray replaceObjectAtIndex:k  withObject:[NSNumber numberWithInt:0]];
                  }
               }
               
               if (i==[SchnittDatenArray count]-1)
               {
                  // NSLog(@"tempZeilenArray nach : %@",[tempZeilenArray description]);
               }
               
            }
         }        
         
         
         // if ((abschnittcode==0xAD)&& mausistdown==2)
         
         if ( mausistdown==2)
         {
            NSLog(@"mausistdown==2");
            Stepperposition=0;
         }
         
         NSMutableIndexSet* EndIndexSet=[NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0xAA,4)]; // Datenreihe ist fertig, kein Anschlag
         [EndIndexSet addIndexesInRange:NSMakeRange(0xA5,4)];
         
         NSMutableIndexSet* HomeIndexSet=[NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0xB5,4)]; // Datenreihe ist fertig, kein Anschlag
         
         // [EndIndexSet addIndexesInRange:NSMakeRange(0xB5,4)];
         
         if ([EndIndexSet containsIndex:abschnittcode])
         {            
            //NSLog(@"readUSB End Abschnitt timer inval");
            
            [self DC_Aktion:NULL];
            
            [AVR setBusy:0];
            [self stopTimer];
         }
         else 
         {
            if ([HomeIndexSet containsIndex:abschnittcode])
            {
               
               //           NSLog(@"readUSB: home ist %d",home);
               //           NSLog(@"readUSB: HomeAnschlagSet count: %d",[HomeAnschlagSet count]);
               //if (home == 1)
               if ([HomeAnschlagSet count]== 1)
               {
                  [[inTimer userInfo]setObject:[NSNumber numberWithInt:2]forKey:@"home"];
                  
               }
               else if ([HomeAnschlagSet count]==4)
               {
                  [AVR setBusy:0];
                  [self DC_Aktion:NULL];
                  
                  [self stopTimer];
                  
                  // [HomeAnschlagSet removeAllIndexes];
                  
               }
               else if (home == 2)
               {
                  [[inTimer userInfo]setObject:[NSNumber numberWithInt:3]forKey:@"home"]; 
                  [AVR setBusy:0];
                  [self DC_Aktion:NULL];
                  
                  [self stopTimer];
                  
               }
            }
            
            else
            {
               //dauer4 = [dateA timeIntervalSinceNow]*1000;
               //NSLog(@"readUSB dauer vor writeCNCAbschnitt: %f ms", dauer);
               
               //NSLog(@"writeCNCAbschnitt abschnittcode: %X",abschnittcode);
           //    NSLog(@"readUSB writeCNCAbschnitt");
               
               
               [self writeCNCAbschnitt];
               
               
               //dauer5 = [dateA timeIntervalSinceNow]*1000;
               //NSLog(@"readUSB dauer nach writeCNCAbschnitt: %f ms", dauer);
               
            }
         }
         
         //dauer6 = [dateA timeIntervalSinceNow]*1000;
         
         [NotificationDic setObject:HomeAnschlagSet forKey:@"homeanschlagset"];
         [NotificationDic setObject:[NSNumber numberWithInt:home] forKey:@"home"];
         [NotificationDic setObject:[NSNumber numberWithInt:abschnittcode] forKey:@"abschnittcode"];
         
        // NSLog(@"abschnittcode: %02X",abschnittcode);
         //NSLog(@"**   outposition  %d",[outPosition intValue]);
         //dauer7 = [dateA timeIntervalSinceNow]*1000;
         NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
         [nc postNotificationName:@"usbread" object:self userInfo:NotificationDic];
         
      }
      
      anzDaten++;
      
   }
   //free (buffer);
   //  NSDate* dateB=[NSDate date];
   // NSLog(@"diff: %f",[dateB timeIntervalSinceDate:dateA]);
} // readUSB

- (void)PfeilAktion:(NSNotification*)note
{
	//[self reportManDown:NULL];
	NSLog(@"\n\n\t************************\nAVRController PfeilAktion note: %@",[[note userInfo]description]);
   
   if ([[note userInfo]objectForKey:@"push"])
   {
      //pwm = [AVR pwm];
      mausistdown=[[[note userInfo]objectForKey:@"push"]intValue];
      
      if (mausistdown == 1) // mousedown
      {
         NSLog(@" ********************* AVRController  PfeilAktion mousedown=1 ");
         
   //   [AVR setBusy:1];
      }
     
      else if (mausistdown == 0) // mouseup
      {
         int cncbusy = [AVR busy];
         
          NSLog(@"PfeilAktion mouseup cncbusy: %d",cncbusy);
         pfeilaktion=1; // in writeCNCAbschnitt wird Datenserie beendet
         NSLog(@" ********************* AVRController PfeilAktion mouseup pwm: %d",pwm);
         char*      sendbuffer;
         sendbuffer=malloc(32);
         sendbuffer[16]=0xE6; // Stop fuer Pfeiltasten
   //      sendbuffer[16]=0xE0;// vorher, HALT
         sendbuffer[20]=pwm;
         int senderfolg= rawhid_send(0, sendbuffer, 32, 50);
         sendbuffer[16]=0x00;
         free(sendbuffer);
         [AVR setBusy:0];
         //NSLog(@"PfeilAktion mouseup Stepperposition: %d",Stepperposition);
      }
   }
   else
   {
      mausistdown=0;
   }
}

- (void)HaltAktion:(NSNotification*)note
{
	//[self reportManDown:NULL];
	NSLog(@"AVRController HaltAktion note: %@",[[note userInfo]description]);
   
   if ([[note userInfo]objectForKey:@"push"])
   {
      mausistdown=[[[note userInfo]objectForKey:@"push"]intValue];
      if (mausistdown == 0) // mouseup
      {
         NSMutableDictionary* timerDic =[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"home",[NSNumber numberWithInt:1],@"halt_status", nil];

         readTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 
                                                       target:self 
                                                     selector:@selector(readUSB:) 
                                                     userInfo:timerDic repeats:YES];

         pfeilaktion=1; // in writeCNCAbschnitt wird Datenserie beendet
         NSLog(@"HaltAktion mouseup start");
         char*      sendbuffer;
         sendbuffer=malloc(32);
         sendbuffer[16]=0xE0;
         sendbuffer[18]=0; // indexh, indexl ergibt abschnittnummer
         sendbuffer[19]=0;
         sendbuffer[20]=0; // pwm
         int senderfolg= rawhid_send(0, sendbuffer, 32, 50);
         sendbuffer[16]=0x00;
         free(sendbuffer);
         NSLog(@"HaltAktion senderfolg: %d",senderfolg);
         // NSLog(@"HaltAktion mouseup Stepperposition: %d",Stepperposition);
      
      }
   }
   else
   {
      mausistdown=0;
   }
}

- (void)MausAktion:(NSNotification*)note
{
   /*
   if ([[note userInfo]objectForKey:@"mausistdown"])
   {
      mausistdown =[[[note userInfo]objectForKey:@"mausistdown"]intValue];
      NSLog(@"AVRController MausAktion mausistdown: %d",mausistdown);
   }
    */
}


- (void)DC_Aktion:(NSNotification*)note
{
   pwm=0;
   if ([note userInfo]&&[[note userInfo]objectForKey:@"pwm"])
   {
      pwm =[[[note userInfo]objectForKey:@"pwm"]intValue];
      //NSLog(@"AVRController DC_Aktion pwm: %d",pwm);
   }
   //NSLog(@"AVRController DC_Aktion pwm: %d",pwm);
   char*      sendbuffer;
   
   sendbuffer=malloc(32);
   int i;
   for (i=0;i<32;i++)
   {
      sendbuffer[i] = 0;
   }
   
   
    // in 32:
   
    sendbuffer[20]=pwm;
    
   // code fuer Task angeben
   
   sendbuffer[16]=0xE2; // code fuer DC 
   
   
   int senderfolg= rawhid_send(0, sendbuffer, 32, 50);
   sendbuffer[0]=0x00;
   sendbuffer[20]=0;
   
    Stepperposition=1;
   free(sendbuffer);
   
}

- (void)StepperstromAktion:(NSNotification*)note
{
   int ein=0;
   if ([[note userInfo]objectForKey:@"ein"])
   {
      ein =[[[note userInfo]objectForKey:@"ein"]intValue];
      NSLog(@"StepperstromAktion ein: %d",ein);
   }
   char*      sendbuffer;
   
   sendbuffer=malloc(32);
   int i;
   for (i=0;i<32;i++)
   {
      sendbuffer[i] = 0;
   }
   sendbuffer[22]=ein; // STROM ON
   sendbuffer[20]=0; // PWM
   
   // code fuer Task angeben:
   sendbuffer[16]=0xE4; // code fuer Stepperstrom 
   
   int senderfolg= rawhid_send(0, sendbuffer, 32, 50);
   sendbuffer[16]=0x00;
   sendbuffer[22]=0;
   Stepperposition=1;
   free(sendbuffer);
    
}

/* nicht verwendet */
- (void)StepperstromEinschalten:(int)ein
{
   char*      sendbuffer;
   
   sendbuffer=malloc(32);
   int i;
   for (i=0;i<32;i++)
   {
      sendbuffer[i] = 0;
   }
   
   /*
    // in 32:
    if (ein)
    {
    sendbuffer[0]=0xE4; // code fuer Stepperstrom 
    }
    else
    {
    sendbuffer[0]=0xE5; // code fuer Stepperstrom 
    }

    */
   sendbuffer[22]=ein;
   sendbuffer[16]=0xE4; // code fuer Stepperstrom 
   int senderfolg= rawhid_send(0, sendbuffer, 32, 50);
   sendbuffer[16]=0x00;
   sendbuffer[22]=0;
   Stepperposition=1;
   free(sendbuffer);
   
}




- (IBAction)twiAVRTimerAktion:(NSTimer*)derTimer
{
	NSLog(@"\n********************    twiAVRTimerAktion  ResetI2C");
	//[self ResetI2C:NULL];
	[derTimer invalidate];

	}
- (IBAction)print:(id)sender
{
   [AVR reportPrint:sender];
}

- (void)applicationDidFinishLaunching:(NSNotification*)notification 
{ 
//[[self window] makeKeyAndOrderFront:self];
}

@end

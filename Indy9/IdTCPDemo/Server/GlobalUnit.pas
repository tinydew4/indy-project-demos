{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  110639: GlobalUnit.pas 
{
{   Rev 1.0    25/10/2004 23:14:14  ANeillans    Version: 9.0.17
{ Verified
}
unit GlobalUnit;

interface

type
  TCommBlock = record   // the Communication Block used in both parts (Server+Client)
                 Command,
                 MyUserName,                 // the sender of the message
                 Msg,                        // the message itself
                 ReceiverName: string[100];  // name of receiver
               end;

implementation

end.
 

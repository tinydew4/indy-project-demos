{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  110675: Main.pas 
{
{   Rev 1.0    25/10/2004 23:24:20  ANeillans    Version: 9.0.17
{ Verified
}
{-----------------------------------------------------------------------------
 Demo Name: Main
 Author:    <unknown - contact me to claim credit! - Allen O'Neill>
 Copyright: Indy Pit Crew
 Purpose:
 History:
-----------------------------------------------------------------------------
 Notes:

 Simple demo using the MappedPort component.

Verified:
  Indy 9:
    D7: 25th Oct 2004 Andy Neillans
}

unit Main;

interface

uses
  Windows, Messages, Graphics, Controls, Forms, Dialogs, StdCtrls,
  SysUtils, Classes, IdBaseComponent, IdComponent, IdTCPServer, IdMappedPortTCP;


type
  TForm1 = class(TForm)
    Memo1: TMemo;
    IdMappedPortTCP1 : TIdMappedPortTCP;
  private
  public
  end;

var
  Form1: TForm1;

implementation
{$R *.DFM}

end.

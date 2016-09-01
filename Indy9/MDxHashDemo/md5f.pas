{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  110725: md5f.pas 
{
{   Rev 1.0    25/10/2004 23:43:38  ANeillans    Version: 9.0.17
{ Verified
}
{-----------------------------------------------------------------------------
 Demo Name: md5f
 Author:    <unknown - please contact me to take credit! - Allen O'Neill>
 Copyright: Indy Pit Crew
 Purpose:
 History:
-----------------------------------------------------------------------------
 Notes:

 demonstrates using hash components

Verified:
  Indy 9:
    D7 : 25th Oct 2004 Andy Neillans
}


unit md5f;

interface

uses
  Windows, Messages, Graphics, Controls, Forms, Dialogs, StdCtrls,
  SysUtils, Classes;

type
  TForm1 = class(TForm)
    Memo2: TMemo;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure AddLines(MD, S, S2: String);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

Uses
  IdHash, IdHashMessageDigest;

procedure TForm1.AddLines(MD, S, S2: String);
Var
  S1 : String;
  I: Integer;
begin
  for i := 1 to Length(S) do begin
    S1 := S1 + Format('%02x', [Byte(S[i])]);
  end;
  while Pos(' ', S1) > 0 do S1[Pos(' ', S1)] := '0';
  Memo2.Lines.Add(MD + ' "' + S2 + '"= ' + S1);
  Memo2.Lines.Add('');
end;

procedure TForm1.FormShow(Sender: TObject);
Var
  Digest: T4x4LongWordRecord;
  S: String;
  i: Integer;
Const
  TestValues: array [0..5] of String = (
    '', 'a', 'message digest', 'abcdefghijklmnopqrstuvwxyz',
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789',
    '12345678901234567890123456789012345678901234567890123456789012345678901234567890');

begin
  Memo2.Lines.Clear;
  SetLength(S, 16);
  for i := 0 to 5 do with TIdHashMessageDigest2.Create do begin
    Digest := HashValue(TestValues[i]);
    Move(Digest, S[1], 16);
    AddLines('MD2', S, TestValues[i]);
    Free;
  end;

  Memo2.Lines.Add('---------------------------------');
  SetLength(S, 16);
  for i := 0 to 5 do with TIdHashMessageDigest4.Create do begin
    Digest := HashValue(TestValues[i]);
    Move(Digest, S[1], 16);
    AddLines('MD4', S, TestValues[i]);
    Free;
  end;

  Memo2.Lines.Add('---------------------------------');
  SetLength(S, 16);
  for i := 0 to 5 do with TIdHashMessageDigest5.Create do begin
    Digest := HashValue(TestValues[i]);
    Move(Digest, S[1], 16);
    AddLines('MD5', S, TestValues[i]);
    Free;
  end;
end;

end.

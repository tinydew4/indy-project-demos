{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  110633: main.pas 
{
{   Rev 1.0    25/10/2004 23:14:12  ANeillans    Version: 9.0.17
{ Verified
}
{-----------------------------------------------------------------------------
 Demo Name: Date/Time demo
 Author:    < unknown - contact me to take credit ! - Allen O'Neill >
 Copyright: Indy Pit Crew
 Purpose:
 History:
-----------------------------------------------------------------------------
 Notes:

 Demonstrates use of the DateTimeStamp component

Verified:
 Indy 9:
   D7: 25th Oct 2004 by Andy Neillans

}


unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IdDateTimeStamp, ExtCtrls, ComCtrls,
  IdBaseComponent;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    lblIsLeapYear: TLabel;
    GroupBox2: TGroupBox;
    txtYear: TEdit;
    Label2: TLabel;
    lblYear: TLabel;
    Label3: TLabel;
    lblDay: TLabel;
    Label4: TLabel;
    lblSeconds: TLabel;
    Label5: TLabel;
    lblMilliseconds: TLabel;
    Label6: TLabel;
    lblMonthNo: TLabel;
    lblMonthName: TLabel;
    Label7: TLabel;
    lblDayOfMonth: TLabel;
    Label8: TLabel;
    lblDayOfWeek: TLabel;
    lblDayOfWeekName: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Label9: TLabel;
    lblWeekNo: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    txtDay: TEdit;
    udDay: TUpDown;
    udYear: TUpDown;
    Label12: TLabel;
    Label13: TLabel;
    lblMinuteOfDay: TLabel;
    lblHourOf12Day: TLabel;
    Label14: TLabel;
    lblHourOf24Day: TLabel;
    udSecond: TUpDown;
    txtSecond: TEdit;
    Label15: TLabel;
    udMonth: TUpDown;
    udMinuteOfDay: TUpDown;
    udHourOf12Day: TUpDown;
    udMillisecond: TUpDown;
    udWeek: TUpDown;
    Label16: TLabel;
    lblMinuteOfHour: TLabel;
    GroupBox3: TGroupBox;
    Label17: TLabel;
    txtRFC822: TEdit;
    Label18: TLabel;
    txtISO8601: TEdit;
    cmdReset: TButton;
    cmdNow: TButton;
    IdDateTimeStamp1: TIdDateTimeStamp;
    Label19: TLabel;
    lblBeatOfDay: TLabel;
    Label20: TLabel;
    lblAsISO8601Calender: TLabel;
    lblAsISO8601Ordinal: TLabel;
    Label22: TLabel;
    lblAsISO8601Week: TLabel;
    Label24: TLabel;
    lblAsRFC822: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure txtYearExit(Sender: TObject);
    procedure txtDayExit(Sender: TObject);
    procedure txtDayChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure txtYearChange(Sender: TObject);
    procedure txtSecondChange(Sender: TObject);
    procedure txtSecondExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure cmdNowClick(Sender: TObject);
    procedure cmdResetClick(Sender: TObject);
    procedure udYearClick(Sender: TObject; Button: TUDBtnType);
    procedure udDayClick(Sender: TObject; Button: TUDBtnType);
    procedure udSecondClick(Sender: TObject; Button: TUDBtnType);
    procedure udWeekClick(Sender: TObject; Button: TUDBtnType);
    procedure udMonthClick(Sender: TObject; Button: TUDBtnType);
    procedure udMinuteOfDayClick(Sender: TObject; Button: TUDBtnType);
    procedure udHourOf12DayClick(Sender: TObject; Button: TUDBtnType);
    procedure udMillisecondClick(Sender: TObject; Button: TUDBtnType);
  private
    FirstTime, InChange : Boolean;
    procedure Calc;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses
  IdGlobal;

function IsNumericString(const AString : String) : Boolean;
var
  i, j : Integer;
begin
  i := 1;
  j := length(AString);
  result := True;
  while i <= j do begin
    if not IsNumeric(AString[i]) then begin
      result := False;
      break;
    end;
    Inc(i);
  end;
end;

procedure TForm1.Calc;
begin
  InChange := True;

  lblYear.Caption := IntToStr(IdDateTimeStamp1.Year);
  txtYear.Text := lblYear.Caption;
  // Hack due to limitation of TUpDown
  udYear.Position := IdDateTimeStamp1.Year div 5;
  if IdDateTimeStamp1.IsLeapYear then begin
    lblIsLeapYear.Caption := 'Yes';
  end else begin
    lblIsLeapYear.Caption := 'No';
  end;

  lblDay.Caption := IntToStr(IdDateTimeStamp1.Day);
  txtDay.Text := lblDay.Caption;
  udDay.Position := IdDateTimeStamp1.Day;
  lblDayOfMonth.Caption := IntToStr(IdDateTimeStamp1.DayOfMonth);
  lblDayOfWeek.Caption := IntToStr(IdDateTimeStamp1.DayOfWeek);
  lblDayOfWeekName.Caption := IdDateTimeStamp1.DayOfWeekName + ' / '
    + IdDateTimeStamp1.DayOfWeekShortName;

  lblWeekNo.Caption := IntToStr(IdDateTimeStamp1.WeekOfYear);
  udWeek.Position := IdDateTimeStamp1.WeekOfYear + 1;

  lblMonthNo.Caption := IntToStr(IdDateTimeStamp1.MonthOfYear);
  udMonth.Position := IdDateTimeStamp1.MonthOfYear + 1;
  lblMonthName.Caption := IdDateTimeStamp1.MonthName + ' / '
    + IdDateTimeStamp1.MonthShortName;

  lblSeconds.Caption := IntToStr(IdDateTimeStamp1.Second);
  txtSecond.Text := lblSeconds.Caption;
  // Hack due to limitations of TUpDown control
  udSecond.Position := (IdDateTimeStamp1.Second div 3) + 1;

  lblBeatOfDay.Caption := IntToStr(IdDateTimeStamp1.BeatOfDay);

  lblMinuteOfDay.Caption := IntToStr(IdDateTimeStamp1.MinuteOfDay);
  udMinuteOfDay.Position := IdDateTimeStamp1.MinuteOfDay + 1;
  lblHourOf12Day.Caption := IntToStr(IdDateTimeStamp1.HourOf12Day);
  udHourOf12Day.Position := IdDateTimeStamp1.HourOf12Day + 2;
  if IdDateTimeStamp1.IsMorning then begin
    lblHourOf12Day.Caption := lblHourOf12Day.Caption + ' (am)';
  end else begin
    lblHourOf12Day.Caption := lblHourOf12Day.Caption + ' (pm)';
  end;
  lblHourOf24Day.Caption := IntToStr(IdDateTimeStamp1.HourOf24Day);
  lblMinuteOfHour.Caption := IntToStr(IdDateTimeStamp1.MinuteOfHour);

  lblMilliseconds.Caption := IntToStr(IdDateTimeStamp1.Millisecond);
  udMillisecond.Position := IdDateTimeStamp1.Millisecond + 1;

  lblAsRFC822.Caption := IdDateTimeStamp1.GetAsRFC822;

  lblAsISO8601Calender.Caption := IDDateTimeStamp1.GetAsISO8601Calendar;
  lblAsISO8601Ordinal.Caption := IDDateTimeStamp1.GetAsISO8601Ordinal;
  lblAsISO8601Week.Caption := IDDateTimeStamp1.GetAsISO8601Week;

  InChange := False;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  If not IsNumericString(txtYear.Text) then begin
    exit;
  end;

  if not IsNumericString(txtDay.Text) then begin
    exit;
  end;

  Calc;
end;

procedure TForm1.txtYearExit(Sender: TObject);
begin
  if InChange then exit;

  InChange := True;
  if IsNumericString(txtYear.Text) then begin
    IdDateTimeStamp1.SetYear(StrToInt(txtYear.Text));
    Calc;
  end;
  InChange := False;
end;

procedure TForm1.txtDayExit(Sender: TObject);
begin
  if InChange then exit;

  InChange := True;
  if IsNumericString(txtDay.Text) then begin
    IdDateTimeStamp1.SetDay(StrToInt(txtDay.Text));
    Calc;
  end;
  InChange := False;
end;

procedure TForm1.txtDayChange(Sender: TObject);
begin
  if InChange then exit;

  txtDay.Text := Copy(txtDay.Text, 1, 5);
  InChange := True;
  if (IsNumericString(txtDay.Text)) and (txtDay.Text <> '') then begin
    IdDateTimeStamp1.SetDay(StrToInt(txtDay.Text));
    Calc;
  end;
  InChange := False;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  InChange := False;
  FirstTime := True;
  udSecond.Max := SmallInt(IdDateTimeStamp.IdSecondsInDay);
  Calc;
end;

procedure TForm1.txtYearChange(Sender: TObject);
begin
  if InChange then exit;

  // Quick hack to prevent Integer overflow
  txtYear.Text := Copy(txtYear.Text, 1, 5);

  InChange := True;
  if (IsNumericString(txtYear.Text)) and (txtYear.Text <> '') then begin
    IdDateTimeStamp1.SetYear(StrToInt(txtYear.Text));
    Calc;
  end;
  InChange := False;
end;

procedure TForm1.txtSecondChange(Sender: TObject);
begin
  if InChange then exit;

  txtSecond.Text := Copy(txtSecond.Text, 1, 5);
  InChange := True;
  if (IsNumericString(txtSecond.Text)) and (txtSecond.Text <> '') then begin
    IdDateTimeStamp1.SetSecond(StrToInt(txtSecond.Text));
    Calc;
  end;
  InChange := False;
end;

procedure TForm1.txtSecondExit(Sender: TObject);
begin
  if InChange then exit;

  InChange := True;
  if IsNumericString(txtSecond.Text) then begin
    udSecond.Position := StrToInt(txtSecond.Text);
  end else begin
    txtSecond.Text := IntToStr(udSecond.Position);
  end;
  Calc;
  InChange := False;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  if FirstTime then begin
    FirstTime := False;
    IdDateTimeStamp1.SetFromTDateTime(Now);
    Calc;
  end;
end;

procedure TForm1.cmdNowClick(Sender: TObject);
begin
  IdDateTimeStamp1.SetFromTDateTime(Now);
  Calc;
end;

procedure TForm1.cmdResetClick(Sender: TObject);
begin
  IdDateTimeStamp1.SetYear(1);
  IdDateTimeStamp1.SetDay(1);
  IdDateTimeStamp1.SetSecond(1);
  IdDateTimeStamp1.SetMillisecond(1);
  Calc;
end;

procedure TForm1.udYearClick(Sender: TObject; Button: TUDBtnType);
begin
  if InChange then exit;

  InChange := True;
  if Button = btNext then begin {Up}
    IdDateTimeStamp1.AddYears(1);
  end else if Button = btPrev then begin  {Down}
    IdDateTimeStamp1.SubtractYears(1);
  end;
  Calc;
  InChange := False;
end;

procedure TForm1.udDayClick(Sender: TObject; Button: TUDBtnType);
begin
  if InChange then exit;

  InChange := True;

  if Button = btNext then begin {Up}
    IdDateTimeStamp1.AddDays(1);
  end else if Button = btPrev then begin {Down}
    IdDateTimeStamp1.SubtractDays(1);
  end;
  Calc;
  InChange := False;
end;

procedure TForm1.udSecondClick(Sender: TObject; Button: TUDBtnType);
begin
  if InChange then exit;

  InChange := True;

  if Button = btNext then begin
    IdDateTimeStamp1.AddSeconds(1); {Up}
  end else if Button = btPrev then begin
    IdDateTimeStamp1.SubtractSeconds(1); {Down}
  end;
  Calc;
  InChange := False;
end;

procedure TForm1.udWeekClick(Sender: TObject; Button: TUDBtnType);
begin
  if InChange then exit;

  InChange := True;

  if Button = btNext then begin  {Up}
    IdDateTimeStamp1.AddWeeks(1);
  end else if Button = btPrev then begin  {Down}
    IdDateTimeStamp1.SubtractWeeks(1);
  end;
  Calc;
  InChange := False;
end;

procedure TForm1.udMonthClick(Sender: TObject; Button: TUDBtnType);
begin
  if InChange then exit;

  InChange := True;

  if Button = btNext then begin  {Up}
    IdDateTimeStamp1.AddMonths(1);
  end else if Button = btPrev then begin  {Down}
    IdDateTimeStamp1.SubtractMonths(1);
  end;
  Calc;
  InChange := False;
end;

procedure TForm1.udMinuteOfDayClick(Sender: TObject; Button: TUDBtnType);
begin
  if InChange then exit;

  InChange := True;

  if Button = btNext then begin {Up}
    IdDateTimeStamp1.AddMinutes(1);
  end else if Button = btPrev then begin {Down}
    IdDateTimeStamp1.SubtractMinutes(1);
  end;
  Calc;
  InChange := False;
end;

procedure TForm1.udHourOf12DayClick(Sender: TObject; Button: TUDBtnType);
begin
  if InChange then exit;

  InChange := True;

  if Button = btNext then begin  {Up}
    IdDateTimeStamp1.AddHours(1);
  end else if Button = btPrev then begin {Down}
    IdDateTimeStamp1.SubtractHours(1);
  end;
  Calc;
  InChange := False;
end;

procedure TForm1.udMillisecondClick(Sender: TObject; Button: TUDBtnType);
begin
  if InChange then exit;

  InChange := True;

  if Button = btNext then begin {Up}
    IdDateTimeStamp1.AddMilliseconds(1);
  end else begin             {Down}
    IdDateTimeStamp1.SubtractMilliseconds(1);
  end;
  Calc;
  InChange := False;
end;

end.

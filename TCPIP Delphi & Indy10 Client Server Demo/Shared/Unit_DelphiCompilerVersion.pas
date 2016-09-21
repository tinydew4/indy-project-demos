{*******************************************************}
{                                                       }
{       get delphi compiler information                 }
{                                                       }
{       Copyright (C) 2011 BDLM                         }
{                                                       }
{*******************************************************}

unit Unit_DelphiCompilerVersion;


//  Compiler 	      CompilerVersion 	Defined Symbol
//  Delphi    XE2 	  23 	          VER230
//  Delphi    XE 	    22 	          VER220
//  Delphi    2010 	  21 	          VER210
//  Delphi    2009 	  20 	           VER200
//  Delphi    2007 	  18.5 	         VER185
//  Delphi    2006 	   18 	         VER180
//  Delphi    2005 	  17 	           VER170
//  Delphi    8 	    16 	           VER160
//  Delphi    7 	    15 	           VER150
//  Delphi    6     	14 	           VER140
//  Delphi    5     	13 	           VER130
//  Delphi    4     	12 	           VER120
//  Delphi    3     	10 	           VER100
//  Delphi    2     	9 	           VER90
//  Delphi    1     	8 	           VER80



interface

        ///    simple test function to detect the used delphi version
        function DelphiCompilerVersion  : String;
        ///    code running in x64 mode ???
        function Isx64Code : boolean;

implementation


{-------------------------------------------------------------------------------
  Procedure: DelphiCompilerVersion
  Author:    BdlM
  DateTime:  2011.09.04
  Arguments: None
  Result:    String
-------------------------------------------------------------------------------}
function DelphiCompilerVersion  : String;
begin

 {$IfDef VER80}
    result := 'DELPHI1';
 {$endif}

 {$IfDef VER90}
    result := 'DELPHI2';
 {$endif}


 {$IfDef VER100}
    result := 'DELPHI3';
  {$endif}


 {$IfDef VER120}
    result := 'DELPHI4';
  {$endif}


 {$IfDef VER130}
    result := 'DELPHI5';
 {$endif}


 {$IfDef VER140}
    result := 'DELPHI6';
 {$endif}


 {$IfDef VER150}
    result := 'DELPHI7';
 {$endif}


 {$IfDef VER160}
    result := 'DELPHI8';
 {$endif}

 {$IfDef VER170}
    result := 'DELPHI2005';
 {$endif}


 {$IfDef VER180}
    result := 'DELPHI2006-2007';
 {$endif}


 {$IfDef VER185}
    result := 'DELPHI2007';
 {$endif}


 {$IfDef VER200}
    result := 'DELPHI2009';
 {$endif}

 {$IfDef VER210}
    result := 'DELPHI2010';
 {$endif}

 {$IfDef VER220}
    result := 'DELPHIXE';
{$endif}

 {$IfDef VER230}
    result := 'DELPHIXE2';
{$endif}

 {$IfDef LAZARUS}
    result := 'LAZARUS / FREE PASCAL ';
{$endif}

end;

{-------------------------------------------------------------------------------
  Procedure: Isx64Code
  Author:    BdlM
  DateTime:  2011.09.04
  Arguments: None
  Result:    boolean
-------------------------------------------------------------------------------}

function Isx64Code : boolean;
begin

    if sizeof(Pointer)=8 then
       begin
        result := true;
       end
       else
       begin
        result := false;
       end;

end;


end.

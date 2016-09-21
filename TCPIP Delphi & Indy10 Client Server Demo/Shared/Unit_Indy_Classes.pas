unit Unit_Indy_Classes;
{ *******************************************************************************
  *
  *
  *    #      #     #     # ####     #     #      #     #######
  *    #      ##    #     #     #     #   #       #     #     #
  *    #      # #   #     #     #      # #        #     #     #
  *    #      #  #  #     #     #       #         #     #     #
  *    #      #   # #     #    #        #         #     #     #
  *    #      #    ##     #####         #         #     #######
  *
  *
  ******************************************************************************* }

interface

///
/// some very basic record type definitions
///
/// Version    2012 - 02 - 29   by BDLM
///
///

uses IdTCPServer, IdThreadSafe, IdCmdTCPServer, StdCtrls, IDGlobal,
  IDSocketHandle, IdStream,  Graphics,
  SysUtils;

type



  ///	<summary>
  ///	  a very basic comand record .....
  ///	</summary>
  ///	<remarks>
  ///	  Idea : implement all commands here
  ///	</remarks>
  TINDYCMD = record
    CMD_CLASS: Integer;
    CMD_VALUE: String[200];
    CMD_TIMESTAMP: TDateTime;
  end;


  ///	<summary>
  ///	  another record for demonstration issues
  ///	</summary>
  ///	<remarks>
  ///	  exchange more information with the server / client using this record
  ///	</remarks>
  TMyRecord = record
    Details: string[255];
    FileName: string[255];
    FileDate: TDateTime;
    FileSize: Integer;
    Recordsize: Integer;
  end;

type


   TMyRECORDThreadSafeRecord = class(TIdThreadSafe)
          value   : TMyRecord;
  end;


  TINDYCMDThreadSafeRecord = class(TIdThreadSafe)
          value   : TINDYCMD;
  end;


    TBITMAPSafeRecord = class(TIdThreadSafe)
          value   : TBitmap;
  end;



implementation

end.

unit DelimitedStringList;

interface
uses Classes, SysUtils;
(* By }-=Loki=-{ lokiwashere@yahoo.co.nz
This is a way to have the functionality of the Delphi 7+ TStringList, within Delphi5*)
type
  TDelimitedStringList = class(TStringList)
  private
    fHasFinalDelimiter: Boolean;
    fQuotedTextFields: boolean;
    procedure SetDelimitedText( const s : string);
    function GetDelimitedText: string;
  public
    Delimiters: TStrings;
    Exclusions: TStrings;
    property DelimitedText: string read GetDelimitedText write SetDelimitedText;
    property HasFinalDelimiter: Boolean read fHasFinalDelimiter write fHasFinalDelimiter default False;
    property QuotedTextFields: boolean read fQuotedTextFields write fQuotedTextFields default True;
    procedure ImplyDelimitedText(s: string; FieldLengths: array of Integer);
    constructor Create;
    destructor Destroy; override;
  end;


implementation

constructor TDelimitedStringList.Create;
    begin
        inherited Create;
        Delimiters := TStringList.Create;
        Exclusions := TStringList.Create;
        QuotedTextFields := True;
    end;

destructor TDelimitedStringList.Destroy;
    begin
        Delimiters.Clear;
        Delimiters.Free;
        Exclusions.Clear;
        Exclusions.Free;
        inherited Destroy;
    end;

function TDelimitedStringList.GetDelimitedText: string;
    var
        i : integer;
        quotedtextchar: string;
    begin
        result := '';
        if fQuotedTextFields then
          QuotedTextChar := '"'
        else
          QuotedTextChar := '';
        for i := 0 to pred( count ) do
          if i < pred( count ) then
          result := result + QuotedTextChar + strings[i] + QuotedTextChar + Delimiters[0]
        else
          result := result + QuotedTextChar + strings[i] + QuotedTextChar;
        if HasFinalDelimiter then
          Result := Result + Delimiters[0];
    end;

procedure TDelimitedStringList.ImplyDelimitedText(s: string;
  FieldLengths: array of Integer);
    var
        i, j: integer;
    begin
        Try
            j := 0;
            for i := 0 to Pred(Length(FieldLengths)) do
            begin
                System.Insert(Delimiters[0], S, j + FieldLengths[i] + 1);
                j := j + FieldLengths[i] + Length(Delimiters[0]);  //length of delimiter
            end;
            if ( (not HasFinalDelimiter) and (j = Length(S)) and (Length(S) >0) ) then
              System.Delete(S, Length(S), Length(Delimiters[0]));
        except
            on Exception do ;
        end;
        DelimitedText := s;
    end;

procedure TDelimitedStringList.SetDelimitedText( const s : string);
    var
        OneField: string;
        i, k: integer;
        FoundExclusion: Boolean;
        FoundDelimiter: Boolean;
        DelimString: string;
        inquotes: boolean;
    begin
        clear;                       
        i := 1;
        OneField := '';
        inquotes := false;
        while i <= length( s ) do
        begin
            FoundExclusion := False;
            FoundDelimiter := False;
            for k := 0 to pred(Exclusions.Count) do
            begin
                if not FoundExclusion then
                begin
                    DelimString := Exclusions[k];
                    if Pos(DelimString, Copy(S, i, Length(DelimString)) )= 1 then
                      FoundExclusion := True;
                end;
            end;
            if not FoundExclusion then
            begin
                if ( (fQuotedTextFields) and (OneField = '') and
                  (s[i] = '"') ) then
                begin
                    InQuotes := True;
                end
                else if ( (InQuotes) and (s[i] = '"') ) then
                begin
                    if length(S) > i then
                    begin
                        if s[i+1] = '"' then
                        begin
                            inc(i); // skip the first quote, but adds the 2nd to the field
                        end
                        else
                          InQuotes := False;
                    end
                    else
                    InQuotes := False
                end
                else if not InQuotes then
                begin
                    for k := 0 to pred(Delimiters.Count) do
                    begin
                        if not FoundDelimiter then
                        begin
                            DelimString := Delimiters[k];
                            if Pos(DelimString, Copy(S, i, Length(DelimString)) )= 1 then
                          FoundDelimiter := True;
                        end;
                    end;
                end;
            end;

            if FoundExclusion then
            begin
                OneField := OneField + DelimString;
                Inc(i, Length(DelimString));

            end
            else if FoundDelimiter then
            begin
//# Note - remove the quotes if present
//                if fQuotedTextFields then
                begin
                    if length(OneField) > 1 then
                    begin
                        if ( (OneField[1] = '"') and (OneField[Length(OneField)] = '"') ) then
                        begin
                            system.delete(OneField, 1, 1);
                            system.delete(OneField, length(OneField), 1);
                        end;
                    end;
                end;

                Add( OneField );
                OneField := '';
                Inc(i, Length(DelimString));
            end
            else
            begin
                OneField := OneField + s[i];
                inc( i );
            end;
        end;
        if OneField <> '' then
        begin
//# Note - remove the quotes if present
//            if fQuotedTextFields then
            begin
                if length(OneField) > 1 then
                begin
                    if ( (OneField[1] = '"') and (OneField[Length(OneField)] = '"') ) then
                    begin
                        system.delete(OneField, 1, 1);
                        system.delete(OneField, length(OneField), 1);
                    end;
                end;
            end;
            Add( OneField );
        end;
    // for pick strings, if the last character is a delimiter
    // then the last field is an empty string
        FoundDelimiter := False;
        FoundExclusion := False;

        for k := 0 to pred(Exclusions.Count) do
        begin
            if not FoundExclusion then
            begin
                DelimString := Exclusions[k];
                if Pos(DelimString, Copy(S, i, Length(DelimString)) )= 1 then
                  FoundExclusion := True;
            end;
        end;
        if not FoundExclusion then
        begin
            for k := 0 to pred(Delimiters.Count) do
            begin
                if not FoundDelimiter then
                begin
                    DelimString := Delimiters[k];
                    try
                        if Pos(DelimString, Copy(S, (Length(S) - Length(Delimstring)) + 1, Length(DelimString)) ) > 0 then
                          FoundDelimiter := True;
                    except
                        on Exception do ;
                    end;
                end;
            end;
        end;

        if FoundDelimiter then
        begin
            if not HasFinalDelimiter then
              Add( '' );  // indicates a null field so add one.
        end;
    end;

end.

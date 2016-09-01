{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  101131: DNS_R.dpr 
{
{   Rev 1.0    2004/6/25 ¤U¤È 05:59:26  DChang    Version: 1.0
{ First provide of simple DNS resolver.
{ If can be applied in any program which needs to resolve domain name.
}
program DNS_R;

uses
  Forms,
  DNSR_Main in 'DNSR_Main.pas' {DNS_Main};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TDNS_Main, DNS_Main);
  Application.Run;
end.

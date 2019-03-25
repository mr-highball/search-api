unit main;

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, search.types;

type

  { TMainForm }

  TMainForm = class(TForm)
  private

  public
    procedure TestPagination;
    procedure TestAPI;
  end;

var
  MainForm: TMainForm;

implementation
uses
  ezthreads;
{$R *.lfm}

{ TMainForm }

procedure TMainForm.TestAPI;
var
  LAPI:ISearchAPI;
begin
  LAPI.Result.Thread
    .Settings.UpdateMaxRuntime(2000).Thread
    .Events;
  Await(LAPI.Result.Thread);
end;

procedure TMainForm.TestPagination;
var
  LPage:IPaginated;
  LError:String;
begin
  if poNext in LPage.SupportedOperations then
  begin
    if LPage.Next(LError) then
      ShowMessage('an error occurred:' + LError);
  end;
end;

end.


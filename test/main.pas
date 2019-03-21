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
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

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


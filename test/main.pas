{ search-api

  Copyright (c) 2019 mr-highball

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to
  deal in the Software without restriction, including without limitation the
  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
  sell copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
  IN THE SOFTWARE.
}
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
  LCount: Integer;
begin
  //create the api
  //todo...

  //check to make sure we have a valid api
  if not Assigned(LAPI) then
    raise Exception.Create('search api has not been initialized');

  //setup and initialize desired settings for the api, then
  //await it's completion
  Await(
    LAPI
      .Settings
        .Query
          .Add('test')
          .Add('picture')
          .Parent
        .Parent
      .Result
        .Thread
  );

  //after awaiting the completion of the search check
  //to see if this was successful
  if LAPI.Result.Success then
  begin
    LCount:=LAPI.Result.Collection.Count;
    ShowMessage(IntToStr(LCount) + ' results were found');
  end
  //otherwise throw the exception that was recorded
  else
    raise Exception.Create(LAPI.Result.LastError);
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


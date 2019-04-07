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
unit search.result;

{$mode delphi}

interface

uses
  Classes, SysUtils, search.types, ezthreads;

type

  { TSearchResultImpl }
  (*
    base class for ISearchResult
  *)
  TSearchResultImpl = class(TInterfacedObject,ISearchResult)
  public
    type
      TSuccessMethod = function(Out Error:String):Boolean of object;
  strict private
    FParent: ISearchAPI;
    FThread: IEZThread;
    FCollection: TResourceCollection;
    FSuccess: TSuccessMethod;
  strict protected
    function GetCollection: TResourceCollection;
    function GetLastError: String;
    function GetParent: ISearchAPI;
    function GetSuccess: Boolean;
    function GetThread: IEZThread;
  public
    //--------------------------------------------------------------------------
    //properties
    //--------------------------------------------------------------------------
    property Collection : TResourceCollection read GetCollection;
    property Success : Boolean read GetSuccess;
    property LastError : String read GetLastError;
    property Thread : IEZThread read GetThread;
    property Parent : ISearchAPI read GetParent;

    //--------------------------------------------------------------------------
    //methods
    //--------------------------------------------------------------------------
    constructor Create(Const AParent:ISearchAPI;
      Const AThread:IEZThread;
      Const ASuccess:TSuccessMethod);virtual;overload;
    destructor destroy; override;
  end;

implementation

{ TSearchResultImpl }

function TSearchResultImpl.GetCollection: TResourceCollection;
begin
  Result:=FCollection;
end;

function TSearchResultImpl.GetLastError: String;
begin
  Result:='';

  //call to the success method to return the error
  if Assigned(FSuccess) then
    FSuccess(Result);
end;

function TSearchResultImpl.GetParent: ISearchAPI;
begin
  Result:=FParent;
end;

function TSearchResultImpl.GetSuccess: Boolean;
var
  LError:String;
begin
  Result:=False;

  //call to the success if we have one
  if Assigned(FSuccess) then
    Result:=FSuccess(LError);
end;

function TSearchResultImpl.GetThread: IEZThread;
begin
   Result:=FThread;
end;

constructor TSearchResultImpl.Create(const AParent: ISearchAPI;
  Const AThread:IEZThread;Const ASuccess:TSuccessMethod);
begin
  FParent:=AParent;
  FThread:=AThread;
  FCollection:=TResourceCollection.Create;
  FSuccess:=ASuccess;
end;

destructor TSearchResultImpl.destroy;
begin
  FParent:=nil;
  FThread:=nil;
  FCollection.Free;
  inherited destroy;
end;

end.


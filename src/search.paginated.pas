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
unit search.paginated;

{$mode delphi}

interface

uses
  Classes, SysUtils, search.types;

type

  { TPaginatedImpl }
  (*
    base class for IPaginated
  *)
  TPaginatedImpl = class(TInterfacedObject,IPaginated)
  strict private
    FOperations: TPaginationOperations;
    function GetOperations: TPaginationOperations;
  strict protected
    //children will need to override these
    function DoBack(out Error: String): Boolean;virtual;abstract;
    function DoNext(out Error: String): Boolean; overload;virtual;abstract;
  public
    //--------------------------------------------------------------------------
    //properties
    //--------------------------------------------------------------------------
    property SupportedOperations : TPaginationOperations read GetOperations;

    //--------------------------------------------------------------------------
    //methods
    //--------------------------------------------------------------------------
    function Back(out Error: String): Boolean; overload;
    function Back: Boolean; overload;

    function Next(out Error: String): Boolean; overload;
    function Next: Boolean; overload;

    constructor Create(Const ASupportedOperations:TPaginationOperations);virtual;
  end;

implementation

{ TPaginatedImpl }

function TPaginatedImpl.GetOperations: TPaginationOperations;
begin
  Result:=FOperations;
end;

function TPaginatedImpl.Back(out Error: String): Boolean;
begin
  Result:=DoBack(Error);
end;

function TPaginatedImpl.Back: Boolean;
var
  LError:String;
begin
  Result:=DoBack(LError);
end;

function TPaginatedImpl.Next(out Error: String): Boolean;
begin
  Result:=DoNext(Error);
end;

function TPaginatedImpl.Next: Boolean;
var
  LError:String;
begin
  Result:=DoNext(LError);
end;

constructor TPaginatedImpl.Create(
  const ASupportedOperations: TPaginationOperations);
begin
  FOperations:=ASupportedOperations;
end;

end.


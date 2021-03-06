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
unit search.query;

{$mode delphi}

interface

uses
  Classes, SysUtils, search.types;

type

  { TQueryImpl }
  (*
    base implementation of IQuery
  *)
  TQueryImpl = class(TInterfacedObject,IQuery)
  strict private
    FCollection: TQueryCollection;
    FParent: ISearchSettings;
  strict protected
    function GetCollection: TQueryCollection;
    function GetOperations: TQueryOperations;
    function GetParent: ISearchSettings;

    //children override
    function DoGetSupportedOperations: TQueryOperations;virtual;abstract;
  public
    //--------------------------------------------------------------------------
    //properties
    //--------------------------------------------------------------------------
    property Collection : TQueryCollection read GetCollection;
    property SupportedOperations : TQueryOperations read GetOperations;
    property Parent : ISearchSettings read GetParent;

    //--------------------------------------------------------------------------
    //methods
    //--------------------------------------------------------------------------
    function Add(const AQuery: String;
      const AOperation: TQueryOperation=qoAnd): IQuery;
    function Clear: IQuery;

    constructor Create(Const AParent: ISearchSettings);virtual;overload;
    destructor destroy; override;
  end;

implementation


{ TQueryImpl }

function TQueryImpl.Add(const AQuery: String;
  const AOperation: TQueryOperation): IQuery;
var
  LTerm: TQueryTerm;
begin
  //initialize return and the query term
  Result:=Self as IQuery;
  LTerm.Text:=AQuery;
  LTerm.Operation:=AOperation;

  //we can exit if the term already exists
  if FCollection.IndexOf(LTerm) > 0 then
    Exit;

  //add the term
  FCollection.Add(LTerm);
end;

function TQueryImpl.Clear: IQuery;
begin
  Result:=Self as IQuery;
  FCollection.Clear;
end;

constructor TQueryImpl.Create(Const AParent: ISearchSettings);
begin
  FCollection:=TQueryCollection.Create;
  FParent:=AParent;
end;

destructor TQueryImpl.destroy;
begin
  FCollection.Free;
  FParent:=nil;
  inherited destroy;
end;

function TQueryImpl.GetCollection: TQueryCollection;
begin
  Result:=FCollection;
end;

function TQueryImpl.GetOperations: TQueryOperations;
begin
  Result:=DoGetSupportedOperations;
end;

function TQueryImpl.GetParent: ISearchSettings;
begin
  Result:=FParent;
end;


end.


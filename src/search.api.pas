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
unit search.api;

{$mode delphi}

interface

uses
  Classes, SysUtils, search.types;

type

  { TSearchAPIImpl }
  (*
    base implementation for ISearchAPI
  *)
  TSearchAPIImpl = class(TInterfacedObject,ISearchAPI)
  strict private
    FSettings: ISearchSettings;
    FResSettings: IResourceSettings;
  strict protected
    function GetPage: IPaginated;
    function GetResourceSettings: IResourceSettings;
    function GetResult: ISearchResult;
    function GetSettings: ISearchSettings;

    //children override
    function DoGetPage: IPaginated;virtual;abstract;
    function DoGetResourceSettings: IResourceSettings;virtual;abstract;
    function DoGetResult: ISearchResult;virtual;abstract;
    function DoGetSettings: ISearchSettings;virtual;abstract;
    function DoGetEmptyResourceSettings: IResourceSettings;virtual;abstract;
    function DoGetEmptySearchSettings: ISearchSettings;virtual;abstract;
    procedure DoSearch;virtual;abstract;
  public
    //--------------------------------------------------------------------------
    //properties
    //--------------------------------------------------------------------------
    property Page : IPaginated read GetPage;
    property Settings : ISearchSettings read GetSettings;
    property ResourceSettings : IResourceSettings read GetResourceSettings;
    property Result : ISearchResult read GetResult;

    //--------------------------------------------------------------------------
    //methods
    //--------------------------------------------------------------------------
    function EmptyResourceSettings: IResourceSettings;
    function EmptySettings: ISearchSettings;
    function Search: ISearchAPI;

    constructor Create;virtual;overload;
    destructor destroy; override;
  end;

implementation

{ TSearchAPIImpl }

function TSearchAPIImpl.EmptyResourceSettings: IResourceSettings;
begin
  FResSettings:=nil;
  FResSettings:=DoGetEmptyResourceSettings;
  Result:=FResSettings;
end;

function TSearchAPIImpl.EmptySettings: ISearchSettings;
begin
  FSettings:=nil;
  FSettings:=DoGetEmptySearchSettings;
  Result:=FSettings;
end;

function TSearchAPIImpl.GetPage: IPaginated;
begin
  Result:=DoGetPage;
end;

function TSearchAPIImpl.GetResourceSettings: IResourceSettings;
begin
  Result:=FResSettings;
end;

function TSearchAPIImpl.GetResult: ISearchResult;
begin
  Result:=DoGetResult;
end;

function TSearchAPIImpl.GetSettings: ISearchSettings;
begin
  Result:=FSettings;
end;

function TSearchAPIImpl.Search: ISearchAPI;
begin
  Result:=Self as ISearchAPI;
  DoSearch;
end;

constructor TSearchAPIImpl.Create;
begin
  EmptySettings;
  EmptyResourceSettings;
end;

destructor TSearchAPIImpl.destroy;
begin
  FSettings:=nil;
  FResSettings:=nil;
  inherited destroy;
end;

end.


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
unit search.resourcesettings;

{$mode delphi}

interface

uses
  Classes, SysUtils, search.types;

type

  { TResourceSettingsImpl }
  (*
    base implementation for IResourceSettings
  *)
  TResourceSettingsImpl = class(TInterfacedObject,IResourceSettings)
  strict private
    FParent: ISearchAPI;
    FReqRes: TRequestedResources;
  strict protected
    function GetCategories: TResourceCategories;
    function GetDocs: TDocumentTypes;
    function GetBinaries: TBinaryTypes;
    function GetParent: ISearchAPI;
    function GetURIs: TURITypes;
    function GetReqResources: TRequestedResources;
    procedure SetReqResources(Const AValue: TRequestedResources);

    //children override
    function DoGetCategories: TResourceCategories;virtual;abstract;
    function DoGetDocs: TDocumentTypes;virtual;abstract;
    function DoGetBinaries: TBinaryTypes;virtual;abstract;
    function DoGetURIs: TURITypes;virtual;abstract;
  public
    //--------------------------------------------------------------------------
    //properties
    //--------------------------------------------------------------------------
    property SupportedCategories : TResourceCategories read GetCategories;
    property SupportedURIs : TURITypes read GetURIs;
    property SupportedBinaries : TBinaryTypes read GetBinaries;
    property SupportedDocuments : TDocumentTypes read GetDocs;
    property RequestedResources : TRequestedResources read GetReqResources write SetReqResources;
    property Parent : ISearchAPI read GetParent;

    //--------------------------------------------------------------------------
    //methods
    //--------------------------------------------------------------------------
    function Categories(Const ACategories : TResourceCategories) : IResourceSettings;
    function URIs(Const AURIs : TURITypes) : IResourceSettings;
    function Binaries(Const ABinaries : TBinaryTypes) : IResourceSettings;
    function Documents(Const ADocuments : TDocumentTypes) : IResourceSettings;

    constructor Create(Const AParent: ISearchAPI);virtual;overload;
    destructor destroy; override;
  end;

implementation

{ TResourceSettingsImpl }

function TResourceSettingsImpl.GetCategories: TResourceCategories;
begin
  Result:=DoGetCategories;
end;

function TResourceSettingsImpl.GetDocs: TDocumentTypes;
begin
  Result:=DoGetDocs;
end;

function TResourceSettingsImpl.GetBinaries: TBinaryTypes;
begin
  Result:=DoGetBinaries
end;

function TResourceSettingsImpl.GetParent: ISearchAPI;
begin
  Result:=FParent;
end;

function TResourceSettingsImpl.GetURIs: TURITypes;
begin
  Result:=DoGetURIs
end;

function TResourceSettingsImpl.GetReqResources: TRequestedResources;
begin
  Result:=FReqRes;
end;

procedure TResourceSettingsImpl.SetReqResources(
  const AValue: TRequestedResources);
begin
  FReqRes:=AValue;
end;

function TResourceSettingsImpl.Categories(
  const ACategories: TResourceCategories): IResourceSettings;
begin
  FReqRes.Categories:=ACategories;
end;

function TResourceSettingsImpl.URIs(const AURIs: TURITypes): IResourceSettings;
begin
  FReqRes.URIs:=AURIs;
end;

function TResourceSettingsImpl.Binaries(
  const ABinaries: TBinaryTypes): IResourceSettings;
begin
  FReqRes.Binaries:=ABinaries;
end;

function TResourceSettingsImpl.Documents(const ADocuments: TDocumentTypes): IResourceSettings;
begin
  FReqRes.Documents:=ADocuments;
end;

constructor TResourceSettingsImpl.Create(const AParent: ISearchAPI);
begin
  FParent:=AParent;
end;

destructor TResourceSettingsImpl.destroy;
begin
  FParent:=nil;
  inherited destroy;
end;

end.


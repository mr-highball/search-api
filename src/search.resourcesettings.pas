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
  strict protected
    function GetCategories: TResourceCategories;
    function GetDocs: TDocumentTypes;
    function GetMedia: TBinaryTypes;
    function GetParent: ISearchAPI;
    function GetURIs: TURITypes;

    //children override
    function DoGetCategories: TResourceCategories;virtual;abstract;
    function DoGetDocs: TDocumentTypes;virtual;abstract;
    function DoGetMedia: TBinaryTypes;virtual;abstract;
    function DoGetURIs: TURITypes;virtual;abstract;
  public
    //--------------------------------------------------------------------------
    //properties
    //--------------------------------------------------------------------------
    property SupportedCategories : TResourceCategories read GetCategories;
    property SupportedURIs : TURITypes read GetURIs;
    property SupportedMedia : TBinaryTypes read GetMedia;
    property SupportedDocuments : TDocumentTypes read GetDocs;
    property Parent : ISearchAPI read GetParent;

    //--------------------------------------------------------------------------
    //methods
    //--------------------------------------------------------------------------
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

function TResourceSettingsImpl.GetMedia: TBinaryTypes;
begin
  Result:=DoGetMedia
end;

function TResourceSettingsImpl.GetParent: ISearchAPI;
begin
  Result:=FParent;
end;

function TResourceSettingsImpl.GetURIs: TURITypes;
begin
  Result:=DoGetURIs
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


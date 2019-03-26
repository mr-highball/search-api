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
unit search.resource;

{$mode delphi}

interface

uses
  Classes, SysUtils, search.types;

type

  { TResourceImpl }
  (*
    base class for IResource
  *)
  TResourceImpl = class(TInterfacedObject,IResource)
  strict protected
    (*
      making the note here that I would prefer this to be a strict private method
      for naming consistency of protected methods.
      however, due to the change noted here:
        http://wiki.freepascal.org/User_Changes_Trunk#Visibility_of_methods_implementing_interface_methods
      these should be protected
    *)
    function GetCategory: TResourceCategory;

    //children override
    function DoGetCategory: TResourceCategory;virtual;abstract;
  public
    //--------------------------------------------------------------------------
    //properties
    //--------------------------------------------------------------------------
    property Category : TResourceCategory read GetCategory;

    constructor Create;virtual;overload;
  end;

  { TURIResourceImpl }
  (*
    base class for IURIResource
  *)
  TURIResourceImpl = class(TResourceImpl,IURIResource)
  strict private
    FURI: String;
  strict protected
    function GetURI: String;
    function GetURIType: TURIType;
    procedure SetURI(const AValue: String);

    //children override
    function DoGetCategory: TResourceCategory; override;
    function DoGetURIType: TURIType;virtual;abstract;
  public
    //--------------------------------------------------------------------------
    //properties
    //--------------------------------------------------------------------------
    property URIType : TURIType read GetURIType;
    property URI : String read GetURI write SetURI;
  end;

  { TBinaryResourceImpl }
  (*
    base class for IBinaryResource
  *)
  TBinaryResourceImpl = class(TURIResourceImpl,IBinaryResource)
  strict private
    FData: TBytes;
  strict protected
    function GetBinaryType: TBinaryType;
    function GetData: TBytes;
    procedure SetData(const AValue: TBytes);

    //children will need override these
    function DoGetURIType: TURIType; override;
    function DoGetBinaryType: TBinaryType;virtual;abstract;
  public
    //--------------------------------------------------------------------------
    //properties
    //--------------------------------------------------------------------------
    property BinaryType : TBinaryType read GetBinaryType;
    property Data : TBytes read GetData;
  end;

  { TDocumentResourceImpl }
  (*
    base class for IDocumentResource
  *)
  TDocumentResourceImpl = class(TURIResourceImpl,IDocumentResource)
  strict private
  strict protected
  public
  end;

  { TCustomResourceImpl }
  (*
    base class for any custom resources
  *)
  TCustomResourceImpl = class(TResourceImpl)
  strict private
  strict protected
    function DoGetCategory: TResourceCategory; override;
  public
  end;

implementation

{ TCustomResourceImpl }

function TCustomResourceImpl.DoGetCategory: TResourceCategory;
begin
  Result:=rcCustom;
end;

{ TBinaryResourceImpl }

function TBinaryResourceImpl.GetBinaryType: TBinaryType;
begin
  Result:=DoGetBinaryType;
end;

function TBinaryResourceImpl.GetData: TBytes;
begin
 Result:=FData;
end;

procedure TBinaryResourceImpl.SetData(const AValue: TBytes);
begin
  FData:=AValue;
end;

function TBinaryResourceImpl.DoGetURIType: TURIType;
begin
  //base class returns custom just to implement this
  Result:=utCustom;
end;

{ TURIResourceImpl }

function TURIResourceImpl.DoGetCategory: TResourceCategory;
begin
  //we are uri category
  Result:=rcURI;
end;

function TURIResourceImpl.GetURI: String;
begin
  Result:=FURI;
end;

function TURIResourceImpl.GetURIType: TURIType;
begin
  Result:=DoGetURIType;
end;

procedure TURIResourceImpl.SetURI(const AValue: String);
begin
  FURI:=AValue;
end;

{ TResourceImpl }

function TResourceImpl.GetCategory: TResourceCategory;
begin
  Result:=DoGetCategory;
end;

constructor TResourceImpl.Create;
begin
  //nothing in base
end;

end.


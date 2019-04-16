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
unit search.duckduckgo;

{$mode delphi}

interface

uses
  Classes, SysUtils, search.types;

type

  { IDDGSearchSettings }
  (*
    duckduckgo specific search settings
  *)
  IDDGSearchSettings = interface(ISearchSettings)
    ['{4EEC3C41-AFD2-4B7B-AA19-460836C4BA87}']
    //--------------------------------------------------------------------------
    //property methods
    //--------------------------------------------------------------------------


    //--------------------------------------------------------------------------
    //properties
    //--------------------------------------------------------------------------
    { TODO -ohighball : add things such as the query params
                        and adult filtering etc...}
  end;

  { IDDGSearchAPI }
  (*
    duckduckgo search api
  *)
  IDDGSearchAPI = interface(ISearchAPI)
    ['{308FE97B-5141-4E23-B47A-3CB0FA8D7553}']
    //--------------------------------------------------------------------------
    //property methods
    //--------------------------------------------------------------------------
    function GetDDGSettings: IDDGSearchSettings;

    //--------------------------------------------------------------------------
    //properties
    //--------------------------------------------------------------------------
    property DDGSettings : IDDGSearchSettings read GetDDGSettings;
  end;
implementation

end.


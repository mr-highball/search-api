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
unit search.types;

{$mode delphi}

interface

uses
  Classes, SysUtils, fgl, ezthreads;

type

  (*
    this enum defines the operations supported by an IPaginated
  *)
  TPaginationOperation = (poNone, poNext, poBack);

  TPaginationOperations = set of TPaginationOperation;

  { IPaginated }
  (*
    this interface defines a contract for objects who are paginated
    and have the ability to move forward and backwards in their resultset
  *)
  IPaginated = interface
    ['{721E1834-5DC8-4067-90EE-CC11B34D485C}']
    //--------------------------------------------------------------------------
    //property methods
    //--------------------------------------------------------------------------
    function GetOperations: TPaginationOperations;

    //--------------------------------------------------------------------------
    //properties
    //--------------------------------------------------------------------------
    (*
      operations supported by the search api.
      note: most cases search apis will be uni-directional (forward) because
      results of the prior search request will be stored (unless manually cleared)
    *)
    property SupportedOperations : TPaginationOperations read GetOperations;

    //--------------------------------------------------------------------------
    //methods
    //--------------------------------------------------------------------------
    (*
      moves to the next page in the result set
    *)
    function Next(Out Error:String):Boolean;overload;
    function Next:Boolean;overload;

    (*
      moves to the previous page in the result set
    *)
    function Back(Out Error:String):Boolean;overload;
    function Back:Boolean;overload;
  end;

  (*
    broad categories for different types of resources an ISearchAPI can return
  *)
  TResourceCategory = (rcURI, rcBinary, rcDocument, rcCustom);

  TResourceCategories = set of TResourceCategory;

  (*
    subtype for rcURI category
  *)
  TURIType = (utHttp, utHttps, utFile, utFolder, utEmail, utCustom);
  TURITypes = set of TURIType;

  (*
    subtype for the rcBinary category
  *)
  TBinaryType = (btImage, btVideo, btMusic, btFile, btCustom);
  TBinaryTypes = set of TBinaryType;

  (*
    subtype for rcDocument category
  *)
  TDocumentType = (dtWebPage, dtNews, dtShop, dtCustom);
  TDocumentTypes = set of TDocumentType;

  { IResource }
  (*
    base resource interface
  *)
  IResource = interface
    ['{647310C6-59E4-4712-99ED-32DAD7058FC9}']
    //--------------------------------------------------------------------------
    //property methods
    //--------------------------------------------------------------------------
    function GetCategory: TResourceCategory;

    //--------------------------------------------------------------------------
    //properties
    //--------------------------------------------------------------------------
    (*
      broad resource category
    *)
    property Category : TResourceCategory read GetCategory;
  end;

  { IURIResource }
  (*
    specialized resource for URI
  *)
  IURIResource = interface(IResource)
    ['{3A023D88-821A-4231-BE6F-2A11AE9A2A9B}']
    //--------------------------------------------------------------------------
    //property methods
    //--------------------------------------------------------------------------
    function GetURIType: TURIType;
    procedure SetURI(Const AValue: String);
    function GetURI: String;

    //--------------------------------------------------------------------------
    //properties
    //--------------------------------------------------------------------------
    (*
      type for this uri
    *)
    property URIType : TURIType read GetURIType;

    (*
      uri string for this resource
    *)
    property URI : String read GetURI write SetURI;
  end;

  { IBinaryResource }
  (*
    specialized resource for binary content
  *)
  IBinaryResource = interface(IURIResource)
    ['{0513D7C5-D68A-411A-97D3-C8B205E4BE17}']
    //--------------------------------------------------------------------------
    //property methods
    //--------------------------------------------------------------------------
    function GetBinaryType: TBinaryType;
    function GetData: TBytes;
    procedure SetData(Const AValue: TBytes);

    //--------------------------------------------------------------------------
    //properties
    //--------------------------------------------------------------------------
    (*
      current type of the binary data
    *)
    property BinaryType : TBinaryType read GetBinaryType;

    (*
      binary data for this resource
    *)
    property Data : TBytes read GetData write SetData;
  end;

  { TODO -ohighball : maybe add a binary resource which supports chunking?
                      this would allow for playing back buffered media without
                      having to download the entire content}

  (*
    specialized resource for document category.
    note: currently this is the same as an IURIResource, so
          for further specialized content, a new interface would need
          to be created (for example, PDF's could be an IPDFResource)
  *)
  IDocumentResource = interface(IURIResource)
    ['{BFF4836F-BDEA-4E6B-BC4C-BB6593BA7F3A}']
  end;

  (*
    custom resource types will need to inherit from this interface.
    this may not be used, since most cases should fall into the above
    categories, but stubbed out just in case
  *)
  ICustomResource = interface(IResource)
    ['{5B4C48A7-DC3E-4ECA-9899-4CC4EB7F0CD3}']
  end;

  (*
    collection to store resources
  *)
  TResourceCollection = TFPGInterfacedObjectList<IResource>;

  //forward
  ISearchAPI = interface;

  { ISearchResult }
  (*
    interface that stores resources in a collection as well
    as the worker thread which can be used to for events and settings
    or to be used for await
  *)
  ISearchResult = interface
    ['{361100FB-CA87-42E4-B073-EEE038048B82}']
    //--------------------------------------------------------------------------
    //property methods
    //--------------------------------------------------------------------------
    function GetCollection: TResourceCollection;
    function GetLastError: String;
    function GetParent: ISearchAPI;
    function GetSuccess: Boolean;
    function GetThread: IEZThread;

    //--------------------------------------------------------------------------
    //properties
    //--------------------------------------------------------------------------
    (*
      contains the resources that the search provided
    *)
    property Collection : TResourceCollection read GetCollection;

    (*
      used to check if the search was succesfull
    *)
    property Success : Boolean read GetSuccess;

    (*
      if the search failed for some reason (check success property)
      this will be populated with the reason
    *)
    property LastError : String read GetLastError;

    (*
      internal worker thread used by this result.
      can be used for await, or prior to search for settings and events
    *)
    property Thread : IEZThread read GetThread;

    (*
      parent search api this result belongs to
    *)
    property Parent : ISearchAPI read GetParent;
  end;

  TQueryOperation = (qoAnd, qoNot);
  TQueryOperations = set of TQueryOperation;

  { TQueryTerm }
  (*
    represents a single part of a query and the type of operation to apply
  *)
  TQueryTerm = record
  strict private
    FOperation: TQueryOperation;
    FText: String;
  public
    property Text : String read FText write FText;
    property Operation : TQueryOperation read FOperation write FOperation;
    class operator Equal(Const A,B:TQueryTerm):Boolean;
  end;

  (*
    collection of query terms
  *)
  TQueryCollection = TFPGList<TQueryTerm>;

  //forward
  ISearchSettings = interface;

  { IQuery }
  (*
    interface which stores query terms in a collection
  *)
  IQuery = interface
    ['{2BADF6D5-AE9E-4E4D-AE97-FCF863E5F4F8}']
    //--------------------------------------------------------------------------
    //property methods
    //--------------------------------------------------------------------------
    function GetCollection: TQueryCollection;
    function GetOperations: TQueryOperations;
    function GetParent: ISearchSettings;

    //--------------------------------------------------------------------------
    //properties
    //--------------------------------------------------------------------------
    property Collection : TQueryCollection read GetCollection;

    (*
      operations supported by the current search api
    *)
    property SupportedOperations : TQueryOperations read GetOperations;

    (*
      the parent ISearchSettings we belong to
    *)
    property Parent : ISearchSettings read GetParent;

    //--------------------------------------------------------------------------
    //methods
    //--------------------------------------------------------------------------
    (*
      shorthand for Collection.Clear
    *)
    function Clear : IQuery;

    (*
      adds a query term to the collection
    *)
    function Add(Const AQuery : String;
      Const AOperation : TQueryOperation = qoAnd) : IQuery;
  end;

  { ISearchSettings }
  (*
    specific settings for a ISearchAPI
  *)
  ISearchSettings = interface
    ['{B6BC6B6B-54AA-442F-A74E-104A6F6F730F}']
    //--------------------------------------------------------------------------
    //property methods
    //--------------------------------------------------------------------------
    function GetQuery: IQuery;
    function GetParent: ISearchAPI;

    //--------------------------------------------------------------------------
    //properties
    //--------------------------------------------------------------------------
    (*
      query used for searching
    *)
    property Query : IQuery read GetQuery;

    (*
      parent search api these settings belong to
    *)
    property Parent : ISearchAPI read GetParent;
  end;

  { TRequestedResources }
  (*
    record for storing which resources the caller wants to search for
  *)
  TRequestedResources = record
  strict private
    FBins: TBinaryTypes;
    FCategories: TResourceCategories;
    FDocs: TDocumentTypes;
    FURIs: TURITypes;
  public
    property Categories : TResourceCategories read FCategories write FCategories;
    property URIs : TURITypes read FURIs write FURIs;
    property Binaries : TBinaryTypes read FBins write FBins;
    property Documents : TDocumentTypes read FDocs write FDocs;
  end;

  { IResourceSettings }
  (*
    contains properties related to what resources are to be searched for
  *)
  IResourceSettings = interface
    ['{A3AC0556-7D00-4D73-A096-D709013583FE}']
    //--------------------------------------------------------------------------
    //property methods
    //--------------------------------------------------------------------------
    function GetCategories: TResourceCategories;
    function GetDocs: TDocumentTypes;
    function GetBinaries: TBinaryTypes;
    function GetParent: ISearchAPI;
    function GetReqResources: TRequestedResources;
    function GetURIs: TURITypes;
    procedure SetReqResources(Const AValue: TRequestedResources);

    //--------------------------------------------------------------------------
    //properties
    //--------------------------------------------------------------------------
    (*
      the broad resource categories supported by a search api instance
    *)
    property SupportedCategories : TResourceCategories read GetCategories;

    (*
      what URI schemes are supported
    *)
    property SupportedURIs : TURITypes read GetURIs;

    (*
      what media types are supported
    *)
    property SupportedBinaries : TBinaryTypes read GetBinaries;

    (*
      what document types are supported
    *)
    property SupportedDocuments : TDocumentTypes read GetDocs;

    (*
      the type of resources the caller wants to search for
    *)
    property RequestedResources : TRequestedResources read GetReqResources write SetReqResources;

    (*
      parent search api these settings belong to
    *)
    property Parent : ISearchAPI read GetParent;

    //--------------------------------------------------------------------------
    //methods
    //--------------------------------------------------------------------------
    (*
      which categories to search for
    *)
    function Categories(Const ACategories : TResourceCategories) : IResourceSettings;

    (*
      which uri types to search for
    *)
    function URIs(Const AURIs : TURITypes) : IResourceSettings;

    (*
      which binary types to search for
    *)
    function Binaries(Const ABinaries : TBinaryTypes) : IResourceSettings;

    (*
      which document types to search for
    *)
    function Documents(Const ADocuments : TDocumentTypes) : IResourceSettings;
  end;

  { ISearchAPI }
  (*
    main interface for performing searches
  *)
  ISearchAPI = interface
    ['{6D906CA4-E27A-48B6-8BFF-27B0FED71FC0}']
    //--------------------------------------------------------------------------
    //property methods
    //--------------------------------------------------------------------------
    function GetPage: IPaginated;
    function GetResourceSettings: IResourceSettings;
    function GetResult: ISearchResult;
    function GetSettings: ISearchSettings;

    //--------------------------------------------------------------------------
    //properties
    //--------------------------------------------------------------------------
    (*
      used for controlling paging
    *)
    property Page : IPaginated read GetPage;

    (*
      settings specific to the type of search api
    *)
    property Settings : ISearchSettings read GetSettings;

    (*
      provides insight into what types of resources are supported by
      this particular search api instance
    *)
    property ResourceSettings : IResourceSettings read GetResourceSettings;

    (*
      stores the result when a search is performed, or a page is flipped
    *)
    property Result : ISearchResult read GetResult;

    //--------------------------------------------------------------------------
    //methods
    //--------------------------------------------------------------------------

    (*
      clears the current settings to default values and allows
      caller to adjust/update values (alternative to using settings properties)
    *)
    function EmptySettings : ISearchSettings;
    function EmptyResourceSettings : IResourceSettings;

    (*
      begins the search with the current settings. to check status of
      the search, ISearchAPI.Result can be inspected, and to block until
      completion, this can be done:

        //ezthreads needs to be in the uses section
        Await(ISearchAPI.Result.Thread);
    *)
    function Search : ISearchResult;
  end;

  (*
    collection to store search api's
  *)
  TSearchCollection = TFPGInterfacedObjectList<ISearchAPI>;

  { TODO -ohighball : need to spec out a factor and register method for
                      implementation classes to call. consider
                      a method for passing in search category/subtype
                      and return a search collection of backends that
                      meet the criteria}

implementation

{ TQueryTerm }

class operator TQueryTerm.Equal(const A, B: TQueryTerm): Boolean;
begin
  Result:=(A.Operation = B.Operation) and (A.Text.Equals(B.Text));
end;

end.


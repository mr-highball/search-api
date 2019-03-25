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
  TBinaryType = (btImage, btVideo, btMusic, btCustom);
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
    function GetLazyLoad: Boolean;
    procedure SetLazyLoad(Const AValue: Boolean);

    //--------------------------------------------------------------------------
    //properties
    //--------------------------------------------------------------------------
    (*
      current type of the binary data
    *)
    property BinaryType : TBinaryType read GetBinaryType;

    (*
      when true, binary data will not be fetched until requested
    *)
    property LazyLoad : Boolean read GetLazyLoad write SetLazyLoad;

    (*
      binary data for this resource
    *)
    property Data : TBytes read GetData;

    //--------------------------------------------------------------------------
    //methods
    //--------------------------------------------------------------------------
    (*
      fetches the binary data. alternatively the data property can be
      used to read the bytes
    *)
    function Fetch(Out Buffer : TBytes;Out Error : String) : Boolean;overload;
    function Fetch(Out Buffer : TBytes) : Boolean;overload;
    function Fetch(Out Error : String) : Boolean;overload;
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

    //--------------------------------------------------------------------------
    //properties
    //--------------------------------------------------------------------------
    //property Query? query operator pair - AND / NOT / ETC... ?
  end;

  { IResourceSettings }

  IResourceSettings = interface
    ['{A3AC0556-7D00-4D73-A096-D709013583FE}']
    //--------------------------------------------------------------------------
    //property methods
    //--------------------------------------------------------------------------
    function GetCategories: TResourceCategories;
    function GetDocs: TDocumentTypes;
    function GetMedia: TBinaryTypes;
    function GetURIs: TURITypes;

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
    property SupportedMedia : TBinaryTypes read GetMedia;

    (*
      what document types are supported
    *)
    property SupportedDocuments : TDocumentTypes read GetDocs;
  end;

  { ISearchAPI }

  ISearchAPI = interface
    ['{6D906CA4-E27A-48B6-8BFF-27B0FED71FC0}']
    //--------------------------------------------------------------------------
    //property methods
    //--------------------------------------------------------------------------
    function GetPage: IPaginated;
    function GetResourceSettings: IResourceSettings;
    function GetResult: ISearchResult;
    function GetSettings: ISearchSettings;
    procedure SetSettings(Const AValue: ISearchSettings);

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
    property Settings : ISearchSettings read GetSettings write SetSettings;

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
  end;

implementation

end.


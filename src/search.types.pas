unit search.types;

{$mode delphi}

interface

uses
  Classes, SysUtils, Generics.Collections;

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
  TResourceCategory = (rcURI, rcBinary, rcDocument);

  TResourceCategories = set of TResourceCategory;

  (*
    subtype for rcURI category
  *)
  TURIType = (utHttp, utHttps, utFile, utFolder, utEmail, utCustom);
  TURITypes = set of TURIType;

  (*
    subtype for the rcMedia category
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
    property URIType : TURIType read GetURIType;
    property URI : String read GetURI write SetURI;
  end;

  { IBinaryResource }

  IBinaryResource = interface(IURIResource)
    ['{0513D7C5-D68A-411A-97D3-C8B205E4BE17}']
    //--------------------------------------------------------------------------
    //property methods
    //--------------------------------------------------------------------------
    function GetBinaryType: TBinaryType;
    function GetMaxChunkSize: Cardinal;
    function GetMinChunkSize: Cardinal;
    function GetSupportChunk: Boolean;

    //--------------------------------------------------------------------------
    //properties
    //--------------------------------------------------------------------------
    property BinaryType : TBinaryType read GetBinaryType;
    property SupportsChunking : Boolean read GetSupportChunk;
    property MinChunkSize : Cardinal read GetMinChunkSize;
    property MaxChunkSize : Cardinal read GetMaxChunkSize;

    //--------------------------------------------------------------------------
    //methods
    //--------------------------------------------------------------------------
    function Fetch(Out Buffer : TBytes;Out ChunkNumber : Integer;
      Out Finished : Boolean;Out Error : String;
      Const AChunkSize : Cardinal = 0) : Boolean;overload;
    function Fetch(Out Buffer : TBytes;Out ChunkNumber : Integer;
      Out Finished : Boolean) : Boolean;overload;
  end;

  { ISearchSettings }
  (*
    specific settings for a ISearchAPI
  *)
  ISearchSettings = interface
    ['{B6BC6B6B-54AA-442F-A74E-104A6F6F730F}']
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
    property SupportedCategories : TResourceCategories read GetCategories;
    property SupportedURIs : TURITypes read GetURIs;
    property SupportedMedia : TBinaryTypes read GetMedia;
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
    function GetSettings: ISearchSettings;
    procedure SetSettings(Const AValue: ISearchSettings);

    //--------------------------------------------------------------------------
    //properties
    //--------------------------------------------------------------------------
    property Page : IPaginated read GetPage;
    property Settings : ISearchSettings read GetSettings write SetSettings;
    property ResourceSettings : IResourceSettings read GetResourceSettings;

    //--------------------------------------------------------------------------
    //methods
    //--------------------------------------------------------------------------
  end;

implementation

end.


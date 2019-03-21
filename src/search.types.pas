unit search.types;

{$mode delphi}

interface

uses
  Classes, SysUtils;

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
    //property methods
    function GetOperations: TPaginationOperations;

    //properties
    property SupportedOperations : TPaginationOperations read GetOperations;

    //methods
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

implementation

end.


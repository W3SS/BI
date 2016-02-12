{*********************************************}
{  TeeBI Software Library                     }
{  Search Data                                }
{  Copyright (c) 2015-2016 by Steema Software }
{  All Rights Reserved                        }
{*********************************************}
unit BI.Data.Search;

interface

uses
  System.Classes, System.Threading,
  BI.Data, BI.Arrays, BI.DataSource;

// TDataSearch returns a copy of the Source data with rows that match
// content as text of one field or all fields.

type
  TSearchFinished=reference to procedure(const AIndex:TCursorIndex);
  TSearchProgress=reference to procedure(var Stop:Boolean);

  TDataSearchPart=(Anywhere, AtStart, AtEnd, Exact);

  TSearchHits=record
  public
    Enabled : Boolean;
    Items : Array of TDataArray;

    procedure Append(const AItem:TDataItem; const ARow:TInteger); inline;
    function Count:TInteger;
    function Exists(const ARow:TInteger; const AData:TDataItem):Boolean;
    procedure Find(const AIndex:TInteger; out ARow:TInteger; out AData:TDataItem);
  end;

  TDataSearch=record
  private
    FStop : Boolean;

    FOnFinished : TSearchFinished;
    FOnProgress : TSearchProgress;

    Task : ITask;

    function AsString(const AItem:TDataItem; const AIndex:TInteger):String;
    function DoFind(const AText:String):TCursorIndex;
  public
    CaseSensitive : Boolean;  // Default: False (ignore upper or lower case)

    DateTimeFormat,
    FloatFormat : String;   // For datetime and float data items

    TextPart : TDataSearchPart;  // Match search at start, end, anywhere or exact

    // Stores all "hits" after doing a search
    Hits : TSearchHits;

    Items  : TDataItem;

    // Data to search
    Source : TDataItem;

    // Do search using a background thread
    procedure BackgroundFind(const AText:String);

    // Search and return the array of row indices that have matches
    function Find(const AText:String):TCursorIndex;

    // Cancel and reset search if background thread is running
    procedure Stop;

    property OnFinished:TSearchFinished read FOnFinished write FOnFinished;
    property OnProgress:TSearchProgress read FOnProgress write FOnProgress;
  end;

implementation
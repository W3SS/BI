unit Unit_Histogram_Text;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  BI.FMX.Grid, BI.Data, BI.Summary;

type
  TFormHistogramText = class(TForm)
    BIGrid1: TBIGrid;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }

    Demo : TDataItem;
  public
    { Public declarations }
  end;

var
  FormHistogramText: TFormHistogramText;

implementation

{$R *.fmx}

uses
  BI.Persist, BI.DataSource;

procedure TFormHistogramText.FormCreate(Sender: TObject);
var Summary : TSummary;
    ByName : TGroupBy;
begin
  Demo:=TStore.Load('SQLite_Demo');

  Summary:=TSummary.Create;
  Summary.AddMeasure(Demo['"Order Details"']['Quantity'],TAggregate.Sum);

  ByName:=Summary.AddGroupBy(Demo['Customers']['CompanyName']);
  ByName.Layout:=TGroupByLayout.Rows;

  ByName.Histogram.Active:=True;

  BIGrid1.Data:=TDataItem.Create(Summary);
end;

end.

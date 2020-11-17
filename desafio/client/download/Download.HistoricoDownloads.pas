unit Download.HistoricoDownloads;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Rtti,
  FMX.Grid.Style, FMX.StdCtrls, FMX.Controls.Presentation, FMX.ScrollBox,
  FMX.Grid, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Api.Client,
  Data.FireDACJSONReflect, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Fmx.Bind.Grid,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope, FireDAC.Stan.StorageJSON,
  FireDAC.Stan.StorageBin;

type
  THistoricoDownload = class(TForm)
    grdHistoricoDownlaod: TGrid;
    FDMemTableHostiricoDownloads: TFDMemTable;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    FDMemTableHostiricoDownloadsURL: TStringField;
    FDMemTableHostiricoDownloadsDATAINICIO: TDateField;
    FDMemTableHostiricoDownloadsDATAFIM: TDateField;
    FDMemTableHostiricoDownloadsCODIGO: TFMTBCDField;
    procedure FormCreate(Sender: TObject);
    procedure FDMemTableHostiricoDownloadsCODIGOGetText(Sender: TField;
      var Text: string; DisplayText: Boolean);
  private
    FApiClient: TDataSnapClientModule;
  public
    procedure GerarHistorico();
  end;

var
  HistoricoDownload: THistoricoDownload;

implementation

{$R *.fmx}

{ THistoricoDownload }

procedure THistoricoDownload.GerarHistorico;
begin
  var LApiDownload := FApiClient.DownloadServerModuleClient;
  var LDatS := LApiDownload.DownloadHistory();
  FDMemTableHostiricoDownloads.Active := false;
  FDMemTableHostiricoDownloads.AppendData(TFDJSONDataSetsReader.GetListValue(LDatS, 0));
  FDMemTableHostiricoDownloads.Active := true;
end;

procedure THistoricoDownload.FDMemTableHostiricoDownloadsCODIGOGetText(
  Sender: TField; var Text: string; DisplayText: Boolean);
begin
  Text := Sender.AsInteger.ToString();
end;

procedure THistoricoDownload.FormCreate(Sender: TObject);
begin
  FApiClient := TDataSnapClientModule.Create(Self)
end;

end.

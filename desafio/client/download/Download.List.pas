unit Download.List;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Model.Download, Download;

type
  TDownloadList = class(TDataModule)
    FDMemDownloadsCorrents: TFDMemTable;
    FDMemDownloadsCorrentsURL: TStringField;
    FDMemDownloadsCorrentsDT_INICIO: TDateTimeField;
    FDMemDownloadsCorrentsDT_FIM: TDateTimeField;
    FDMemDownloadsCorrentsPROGRESSO: TLargeintField;
    FDMemDownloadsCorrentsTOKEN: TGuidField;
    FDMemDownloadsCorrentsSTATUS: TIntegerField;
    FDMemDownloadsCorrentsCODIGO: TIntegerField;
    procedure DataModuleCreate(Sender: TObject);
    procedure FDMemDownloadsCorrentsNewRecord(DataSet: TDataSet);
    procedure FDMemDownloadsCorrentsPROGRESSOGetText(Sender: TField;
      var Text: string; DisplayText: Boolean);
    procedure FDMemDownloadsCorrentsSTATUSGetText(Sender: TField;
      var Text: string; DisplayText: Boolean);
    procedure FDMemDownloadsCorrentsDT_FIMGetText(Sender: TField;
      var Text: string; DisplayText: Boolean);
    procedure FDMemDownloadsCorrentsIDGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private
    { Private declarations }
  public
    procedure Add(const AToken: TDownloadToken; const ADownloadModel: TDownloadModel);
    procedure Step(const AToken: TDownloadToken;
      const AProgress: TDownloadProgress; const ADownloadModel: TDownloadModel);
    procedure Terminated(const AToken: TDownloadToken; const ADownloadStatus: TDownloadStatus;
      const AProgress: TDownloadProgress; const ADownloadModel: TDownloadModel);
    procedure Error(const AToken: TDownloadToken; const AErrorMessage: string);
  end;

var
  DownloadList: TDownloadList;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}


{ TDownloadList }

procedure TDownloadList.Add(const AToken: TDownloadToken;
  const ADownloadModel: TDownloadModel);
begin
  FDMemDownloadsCorrents.Append();
  FDMemDownloadsCorrentsTOKEN.AsString := AToken;
  FDMemDownloadsCorrentsCODIGO.AsInteger := ADownloadModel.Id;
  FDMemDownloadsCorrentsSTATUS.AsInteger := Ord(TDownloadStatus.dsStarted);
  FDMemDownloadsCorrentsURL.AsString := ADownloadModel.Url;
  FDMemDownloadsCorrentsDT_INICIO.AsDateTime := ADownloadModel.DtInicio;
  FDMemDownloadsCorrentsDT_FIM.AsDateTime := ADownloadModel.DtFim;
  FDMemDownloadsCorrents.Post();
end;

procedure TDownloadList.Terminated(const AToken: TDownloadToken;
  const ADownloadStatus: TDownloadStatus; const AProgress: TDownloadProgress;
  const ADownloadModel: TDownloadModel);
begin
  if FDMemDownloadsCorrents.Locate('TOKEN', AToken, []) then begin
    FDMemDownloadsCorrents.Edit();
    FDMemDownloadsCorrentsPROGRESSO.AsInteger := AProgress.Percentage;
    FDMemDownloadsCorrentsDT_FIM.AsDateTime := ADownloadModel.DtFim;
    FDMemDownloadsCorrentsSTATUS.AsInteger := Ord(ADownloadStatus);
    FDMemDownloadsCorrents.Post();
  end;
end;

procedure TDownloadList.DataModuleCreate(Sender: TObject);
begin
  FDMemDownloadsCorrents.Open();
end;

procedure TDownloadList.Error(const AToken: TDownloadToken;
  const AErrorMessage: string);
begin
  if FDMemDownloadsCorrents.Locate('TOKEN', AToken, []) then begin
    FDMemDownloadsCorrents.Edit();
    FDMemDownloadsCorrentsSTATUS.AsInteger := Ord(TDownloadStatus.dsError);
    if (AErrorMessage.Length > 0) then
      FDMemDownloadsCorrentsURL.AsString := AErrorMessage;
    FDMemDownloadsCorrents.Post();
  end;
end;

procedure TDownloadList.FDMemDownloadsCorrentsDT_FIMGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  if (Sender.AsDateTime = MinDateTime) then
    Text := EmptyStr
  else
    Text := Sender.AsString;
end;

procedure TDownloadList.FDMemDownloadsCorrentsIDGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  Text := Sender.AsInteger.ToString();
end;

procedure TDownloadList.FDMemDownloadsCorrentsNewRecord(DataSet: TDataSet);
begin
  FDMemDownloadsCorrentsSTATUS.AsInteger := Ord(TDownloadStatus.dsNone);
end;

procedure TDownloadList.FDMemDownloadsCorrentsPROGRESSOGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  Text := Sender.AsInteger.ToString() + '%';
end;

procedure TDownloadList.FDMemDownloadsCorrentsSTATUSGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  case TDownloadStatus(Sender.AsInteger) of
    dsNone: Text := 'Aguardando';
    dsStarted: Text := 'Iniciado';
    dsDownloading: Text := 'Em andamento';
    dsCompleted: Text := 'Concluído';
    dsInterrupted: Text := 'Cancelado';
    dsError: Text := 'Erro';
  end;
end;

procedure TDownloadList.Step(const AToken: TDownloadToken;
  const AProgress: TDownloadProgress; const ADownloadModel: TDownloadModel);
begin
  if FDMemDownloadsCorrents.Locate('TOKEN', AToken, []) then begin
    FDMemDownloadsCorrents.Edit();
    FDMemDownloadsCorrentsPROGRESSO.AsInteger := AProgress.Percentage;
    FDMemDownloadsCorrentsSTATUS.AsInteger := Ord(TDownloadStatus.dsDownloading);
    FDMemDownloadsCorrents.Post();
  end;
end;

end.

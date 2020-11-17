unit Download.Files;

interface

uses
  System.SysUtils, System.Classes, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent;

type
  TDownloadStep = reference to procedure(const ALength: Int64;
    const APercentage: Integer; const AIsInterrupted: boolean = false;
    const AErrorMessage: string = '');

  TDownloadFiles = class(TDataModule)
    NetHTTPRequest1: TNetHTTPRequest;
    NetHTTPClient1: TNetHTTPClient;
    procedure NetHTTPRequest1ReceiveData(const Sender: TObject; AContentLength,
      AReadCount: Int64; var AAbort: Boolean);
    procedure NetHTTPRequest1RequestCompleted(const Sender: TObject;
      const AResponse: IHTTPResponse);
    procedure NetHTTPRequest1RequestError(const Sender: TObject;
      const AError: string);
    procedure DataModuleCreate(Sender: TObject);
  private
    FInterrupted: boolean;
    FDownloadStep: TDownloadStep;
    FLastPercentage: integer;
  public
    { Public declarations }
    procedure GetFile(const AUrl: string; const ADownloadStep: TDownloadStep);
    property Interrupted: boolean read FInterrupted write FInterrupted;
  end;

var
  DownloadFiles: TDownloadFiles;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDownloadFiles.DataModuleCreate(Sender: TObject);
begin
  FLastPercentage := 0;
end;

procedure TDownloadFiles.GetFile(const AUrl: string;
  const ADownloadStep: TDownloadStep);
begin
  FDownloadStep := ADownloadStep;
  NetHTTPRequest1.Get(AUrl);
end;

procedure TDownloadFiles.NetHTTPRequest1ReceiveData(const Sender: TObject;
  AContentLength, AReadCount: Int64; var AAbort: Boolean);
var
  LPercentageDownloaded: Extended;
begin
  if ( AContentLength > 0) then begin
    LPercentageDownloaded :=  (AReadCount / AContentLength) * 100;
    if Assigned(FDownloadStep) and (FLastPercentage + 1 < Trunc(LPercentageDownloaded)) then begin
      FDownloadStep(AContentLength, Trunc(LPercentageDownloaded));
      FLastPercentage := Trunc(LPercentageDownloaded);
    end;
  end; //else o servidor não forneceu o tamanho do arquivo

  AAbort := FInterrupted;
end;

procedure TDownloadFiles.NetHTTPRequest1RequestCompleted(const Sender: TObject;
  const AResponse: IHTTPResponse);
begin
  if Assigned(FDownloadStep) then begin
    if FInterrupted then
      FDownloadStep(AResponse.ContentLength, FLastPercentage, FInterrupted)
    else
      FDownloadStep(AResponse.ContentLength, 100, FInterrupted);
  end;
end;

procedure TDownloadFiles.NetHTTPRequest1RequestError(const Sender: TObject;
  const AError: string);
begin
  if Assigned(FDownloadStep) then begin
    FDownloadStep(0, 0, FInterrupted, AError);
  end;
end;

end.

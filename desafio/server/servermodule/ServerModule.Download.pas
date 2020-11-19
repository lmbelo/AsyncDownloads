unit ServerModule.Download;

interface

uses
  System.SysUtils, System.Classes, Datasnap.DSServer, 
  Datasnap.DSAuth, Datasnap.DSProviderDataModuleAdapter,
  DataBase.Repository.Download, Data.FireDACJSONReflect;

type
  TDownloadServerModule = class(TDSServerModule)
    procedure DSServerModuleCreate(Sender: TObject);
  private
    FRepository: TDownloadRepository;
  public
    function Download(const AUrl: string; const ADtInicio: TDateTime): integer;
    procedure StopDownload(const AId: integer; const ADtFim: TDateTime);
    function DownloadHistory(): TFDJSONDataSets;
  end;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDownloadServerModule.DSServerModuleCreate(Sender: TObject);
begin
  FRepository := TDownloadRepository.Create(Self);
end;

function TDownloadServerModule.DownloadHistory: TFDJSONDataSets;
begin
  Result := TFDJSONDataSets.Create();
  try
    TFDJSONDataSetsWriter.ListAdd(Result, FRepository.DownloadHistory());
  except
    on E: Exception do begin
      FreeAndNil(Result);
      raise;
    end;
  end;
end;

function TDownloadServerModule.Download(const AUrl: string;
  const ADtInicio: TDateTime): integer;
begin
  if (AUrl.Length > 600) then
    raise Exception.Create('O tamanho da URL não pode exceder 600 caracteres');
  Result := FRepository.NewDownload(AUrl, ADtInicio);
end;

procedure TDownloadServerModule.StopDownload(const AId: integer;
  const ADtFim: TDateTime);
begin
  FRepository.StopDownload(AId, Now());
end;

end.


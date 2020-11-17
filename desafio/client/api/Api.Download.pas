// 
// Created by the DataSnap proxy generator.
// 16/11/2020 15:22:43
// 

unit Api.Download;

interface

uses System.JSON, Datasnap.DSProxyRest, Datasnap.DSClientRest, Data.DBXCommon, Data.DBXClient, Data.DBXDataSnap, Data.DBXJSON, Datasnap.DSProxy, System.Classes, System.SysUtils, Data.DB, Data.SqlExpr, Data.DBXDBReaders, Data.DBXCDSReaders, Data.FireDACJSONReflect, Data.DBXJSONReflect;

type

  IDSRestCachedTFDJSONDataSets = interface;

  TDownloadServerModuleClient = class(TDSAdminRestClient)
  private
    FDSServerModuleCreateCommand: TDSRestCommand;
    FDownloadCommand: TDSRestCommand;
    FStopDownloadCommand: TDSRestCommand;
    FDownloadHistoryCommand: TDSRestCommand;
    FDownloadHistoryCommand_Cache: TDSRestCommand;
  public
    constructor Create(ARestConnection: TDSRestConnection); overload;
    constructor Create(ARestConnection: TDSRestConnection; AInstanceOwner: Boolean); overload;
    destructor Destroy; override;
    procedure DSServerModuleCreate(Sender: TObject);
    function Download(AUrl: string; ADtInicio: TDateTime; const ARequestFilter: string = ''): Integer;
    procedure StopDownload(AId: Integer; ADtFim: TDateTime);
    function DownloadHistory(const ARequestFilter: string = ''): TFDJSONDataSets;
    function DownloadHistory_Cache(const ARequestFilter: string = ''): IDSRestCachedTFDJSONDataSets;
  end;

  IDSRestCachedTFDJSONDataSets = interface(IDSRestCachedObject<TFDJSONDataSets>)
  end;

  TDSRestCachedTFDJSONDataSets = class(TDSRestCachedObject<TFDJSONDataSets>, IDSRestCachedTFDJSONDataSets, IDSRestCachedCommand)
  end;

const
  TDownloadServerModule_DSServerModuleCreate: array [0..0] of TDSRestParameterMetaData =
  (
    (Name: 'Sender'; Direction: 1; DBXType: 37; TypeName: 'TObject')
  );

  TDownloadServerModule_Download: array [0..2] of TDSRestParameterMetaData =
  (
    (Name: 'AUrl'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'ADtInicio'; Direction: 1; DBXType: 11; TypeName: 'TDateTime'),
    (Name: ''; Direction: 4; DBXType: 6; TypeName: 'Integer')
  );

  TDownloadServerModule_StopDownload: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'AId'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: 'ADtFim'; Direction: 1; DBXType: 11; TypeName: 'TDateTime')
  );

  TDownloadServerModule_DownloadHistory: array [0..0] of TDSRestParameterMetaData =
  (
    (Name: ''; Direction: 4; DBXType: 37; TypeName: 'TFDJSONDataSets')
  );

  TDownloadServerModule_DownloadHistory_Cache: array [0..0] of TDSRestParameterMetaData =
  (
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'String')
  );

implementation

procedure TDownloadServerModuleClient.DSServerModuleCreate(Sender: TObject);
begin
  if FDSServerModuleCreateCommand = nil then
  begin
    FDSServerModuleCreateCommand := FConnection.CreateCommand;
    FDSServerModuleCreateCommand.RequestType := 'POST';
    FDSServerModuleCreateCommand.Text := 'TDownloadServerModule."DSServerModuleCreate"';
    FDSServerModuleCreateCommand.Prepare(TDownloadServerModule_DSServerModuleCreate);
  end;
  if not Assigned(Sender) then
    FDSServerModuleCreateCommand.Parameters[0].Value.SetNull
  else
  begin
    FMarshal := TDSRestCommand(FDSServerModuleCreateCommand.Parameters[0].ConnectionHandler).GetJSONMarshaler;
    try
      FDSServerModuleCreateCommand.Parameters[0].Value.SetJSONValue(FMarshal.Marshal(Sender), True);
      if FInstanceOwner then
        Sender.Free
    finally
      FreeAndNil(FMarshal)
    end
    end;
  FDSServerModuleCreateCommand.Execute;
end;

function TDownloadServerModuleClient.Download(AUrl: string; ADtInicio: TDateTime; const ARequestFilter: string): Integer;
begin
  if FDownloadCommand = nil then
  begin
    FDownloadCommand := FConnection.CreateCommand;
    FDownloadCommand.RequestType := 'GET';
    FDownloadCommand.Text := 'TDownloadServerModule.Download';
    FDownloadCommand.Prepare(TDownloadServerModule_Download);
  end;
  FDownloadCommand.Parameters[0].Value.SetWideString(AUrl);
  FDownloadCommand.Parameters[1].Value.AsDateTime := ADtInicio;
  FDownloadCommand.Execute(ARequestFilter);
  Result := FDownloadCommand.Parameters[2].Value.GetInt32;
end;

procedure TDownloadServerModuleClient.StopDownload(AId: Integer; ADtFim: TDateTime);
begin
  if FStopDownloadCommand = nil then
  begin
    FStopDownloadCommand := FConnection.CreateCommand;
    FStopDownloadCommand.RequestType := 'GET';
    FStopDownloadCommand.Text := 'TDownloadServerModule.StopDownload';
    FStopDownloadCommand.Prepare(TDownloadServerModule_StopDownload);
  end;
  FStopDownloadCommand.Parameters[0].Value.SetInt32(AId);
  FStopDownloadCommand.Parameters[1].Value.AsDateTime := ADtFim;
  FStopDownloadCommand.Execute;
end;

function TDownloadServerModuleClient.DownloadHistory(const ARequestFilter: string): TFDJSONDataSets;
begin
  if FDownloadHistoryCommand = nil then
  begin
    FDownloadHistoryCommand := FConnection.CreateCommand;
    FDownloadHistoryCommand.RequestType := 'GET';
    FDownloadHistoryCommand.Text := 'TDownloadServerModule.DownloadHistory';
    FDownloadHistoryCommand.Prepare(TDownloadServerModule_DownloadHistory);
  end;
  FDownloadHistoryCommand.Execute(ARequestFilter);
  if not FDownloadHistoryCommand.Parameters[0].Value.IsNull then
  begin
    FUnMarshal := TDSRestCommand(FDownloadHistoryCommand.Parameters[0].ConnectionHandler).GetJSONUnMarshaler;
    try
      Result := TFDJSONDataSets(FUnMarshal.UnMarshal(FDownloadHistoryCommand.Parameters[0].Value.GetJSONValue(True)));
      if FInstanceOwner then
        FDownloadHistoryCommand.FreeOnExecute(Result);
    finally
      FreeAndNil(FUnMarshal)
    end
  end
  else
    Result := nil;
end;

function TDownloadServerModuleClient.DownloadHistory_Cache(const ARequestFilter: string): IDSRestCachedTFDJSONDataSets;
begin
  if FDownloadHistoryCommand_Cache = nil then
  begin
    FDownloadHistoryCommand_Cache := FConnection.CreateCommand;
    FDownloadHistoryCommand_Cache.RequestType := 'GET';
    FDownloadHistoryCommand_Cache.Text := 'TDownloadServerModule.DownloadHistory';
    FDownloadHistoryCommand_Cache.Prepare(TDownloadServerModule_DownloadHistory_Cache);
  end;
  FDownloadHistoryCommand_Cache.ExecuteCache(ARequestFilter);
  Result := TDSRestCachedTFDJSONDataSets.Create(FDownloadHistoryCommand_Cache.Parameters[0].Value.GetString);
end;

constructor TDownloadServerModuleClient.Create(ARestConnection: TDSRestConnection);
begin
  inherited Create(ARestConnection);
end;

constructor TDownloadServerModuleClient.Create(ARestConnection: TDSRestConnection; AInstanceOwner: Boolean);
begin
  inherited Create(ARestConnection, AInstanceOwner);
end;

destructor TDownloadServerModuleClient.Destroy;
begin
  FDSServerModuleCreateCommand.DisposeOf;
  FDownloadCommand.DisposeOf;
  FStopDownloadCommand.DisposeOf;
  FDownloadHistoryCommand.DisposeOf;
  FDownloadHistoryCommand_Cache.DisposeOf;
  inherited;
end;

end.

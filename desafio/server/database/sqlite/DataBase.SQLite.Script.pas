unit DataBase.SQLite.Script;

interface

uses
  FireDAC.Comp.Client, System.SysUtils, DataBase.SQLite.Common;

type
  //Decorator patter
  TSQLiteScript = class abstract(TInterfacedObject, ISQLiteScript)
  public
    procedure Execute(const AConnection: TFDConnection); virtual; abstract;
  end;

  TSQLiteScriptCreateDataBase = class(TSQLiteScript)
  public
    procedure Execute(const AConnection: TFDConnection); override;
  end;

  TSQLiteScriptCreateTableLogDownload = class(TSQLiteScript)
  private
    FScript: ISQLiteScript;
  public
    constructor Create(const AScript: ISQLiteScript);

    procedure Execute(const AConnection: TFDConnection); override;
  end;

implementation

uses
  System.IOUtils, DataBase.SQLite.ConnectionDefinition;

{ TSQLLiteScripts }

procedure TSQLiteScriptCreateDataBase.Execute(const AConnection: TFDConnection);
begin
  var LDataBasePath := TConnectionDefinition.GetDataBasePath();
  var LDir := TPath.GetDirectoryName(LDataBasePath);
  if not TDirectory.Exists(LDir) then
    TDirectory.CreateDirectory(LDir);

  AConnection.Connected := true; //Cria o banco de dados automaticamente
end;

{ TSQLiteScriptCreateTableLogDownload }

constructor TSQLiteScriptCreateTableLogDownload.Create(
  const AScript: ISQLiteScript);
begin
  FScript := AScript;
end;

procedure TSQLiteScriptCreateTableLogDownload.Execute(const AConnection: TFDConnection);
const
  SQL_CREATE_TABLE =
    'CREATE TABLE IF NOT EXISTS LOGDOWNLOAD(     '
  + '  CODIGO NUMBER(22,0) PRIMARY KEY,          '
  + '  URL VARCHAR(600) NOT NULL,                '
  + '  DATAINICIO DATE NOT NULL,                 '
  + '  DATAFIM DATE);                            ';
begin
  FScript.Execute(AConnection);

  AConnection.ExecSQL(SQL_CREATE_TABLE);
end;

end.

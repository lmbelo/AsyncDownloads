unit DataBase.Repository.Download;

interface

uses
  System.SysUtils, System.Classes, DataBase.Repository, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.ConsoleUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TDownloadRepository = class(TRepository)
  private
    { Private declarations }
  public
    function NewDownload(const AUrl: string; const ADtInicio: TDateTime): integer;
    procedure StopDownload(const AId: integer; const ADtFim: TDateTime);
    function DownloadHistory(): TFDAdaptedDataSet;
  end;

var
  DownloadRepository: TDownloadRepository;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

{ TDownloadRepository }

function TDownloadRepository.DownloadHistory: TFDAdaptedDataSet;
begin
  SQLQuery.Open('SELECT * FROM LOGDOWNLOAD');
  Result := SQLQuery;
end;

function TDownloadRepository.NewDownload(const AUrl: string;
  const ADtInicio: TDateTime): integer;
const
  SQL_INSERT = 'INSERT INTO LOGDOWNLOAD        '
             + '  (CODIGO, URL, DATAINICIO)    '
             + 'VALUES                         '
             + '  (:CODIGO, :URL, :DATAINICIO) ';
begin
  SQLConn.StartTransaction();
  try
    Result := SQLConn.ExecSQLScalar('SELECT IFNULL(MAX(CODIGO), 0) + 1 FROM LOGDOWNLOAD');
    SQLQuery.ExecSQL(SQL_INSERT, [Result, AUrl, ADtInicio]);
    SQLConn.Commit();
  except
    on E: Exception do begin
      SQLConn.Rollback();
      raise;
    end;
  end;
end;

procedure TDownloadRepository.StopDownload(const AId: integer;
  const ADtFim: TDateTime);
begin
  SQLQuery.ExecSQL('UPDATE LOGDOWNLOAD       '
                 + '   SET DATAFIM = :DATAFIM'
                 + ' WHERE CODIGO = :CODIGO  ', [ADtFim, AId]);
end;

end.

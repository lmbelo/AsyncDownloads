unit DataBase.SQLite.ConnectionDefinition;

interface

uses
  System.Classes, FireDAC.Comp.Client, System.SysUtils;

type
  //A keyword "sealed" impossibilita a extensão da classe via herança
  TConnectionDefinition = class sealed
  public
    const
      DATABASE_NAME_SQLITE = 'DESAFIO';
      CONNECTION_DEF_NAME_SQL_LITE = 'SQLite_Pooled';
  public
    //Adicionar a diretiva "static" elimina a passagem do parâmetro "Self"
    //ao registrador EAX (REGISTER calling convention)
    class procedure DefineSQLiteConDef(const AManager: TFDCustomManager); static;
    class function GetDataBasePath(): string; static;
  end;

implementation

uses
  System.IOUtils;

{ TConnectionDefinition }

class function TConnectionDefinition.GetDataBasePath: string;
begin
  Result := TPath.Combine(
    TPath.Combine(TPath.Combine(TPath.GetDocumentsPath(), 'Desafio'), 'Database'),
    TPath.ChangeExtension(DATABASE_NAME_SQLITE, '.s3db'));
end;

class procedure TConnectionDefinition.DefineSQLiteConDef(const AManager: TFDCustomManager);
begin
  //Parâmetro "SELF" não disponível ao utilizar a diretiva "static"
  //Isso faz com que o method não seja um "Method Pointer" e sim um "Procedure Pointer"
  //Method Pointer são armazenados em uma estrutura TMethod,
  //onde o campo "Code" possui o ponteiro para o "Procedure Pointer"
  //e o campo "Data" possui o ponteiro para a uma instância da classe
  var LParams := TStringList.Create();
  try
    LParams.Add(String.Format('Database=%s', [TConnectionDefinition.GetDataBasePath()]));
    LParams.Add('LockingMode=Normal'); //Habilita acesso compartilhado ao DB
    LParams.Add('Synchronous=Full'); //Deixa dados comitados visíveis em outras transações - protege o DB contra perda de dados
    LParams.Add('JournalMode=WAL'); //Oferece melhor concorrência: http://www.sqlite.org/draft/wal.html
    LParams.Add('Pooled=True'); //Mantem um pool de conexões - escalável
    LParams.Add('BusyTimeout=50000'); //Aumenta de espera antes de gerar o erro de "Lock Wait Time"
    AManager.AddConnectionDef(TConnectionDefinition.CONNECTION_DEF_NAME_SQL_LITE, 'SQLite', LParams);
  finally
    LParams.Free();
  end;
end;

end.

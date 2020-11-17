unit DataBase.SQLite;

interface

uses
  DataBase.SQLite.Script;

type
  TSQLite = class sealed
  public
    class procedure Make(); static;
  end;

implementation

uses
  DataBase.SQLite.ConnectionDefinition,
  FireDAC.Comp.Client, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.Phys.SQLiteDef, FireDAC.Stan.Intf,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDac.Stan.Def, FireDac.Stan.Pool,
  FireDac.Stan.Async, FireDAC.FMXUI.Wait, FireDAC.Stan.StorageJSON,
  FireDAC.Stan.StorageBin, DataBase.SQLite.Common;

{ TSQLite }

class procedure TSQLite.Make;
var
  LScript: ISQLiteScript;
begin
  TConnectionDefinition.DefineSQLiteConDef(FDManager); //Utiliza o FDManager singleton

  //Executa os scripts para criação do bd e criação da tabela
  LScript := TSQLiteScriptCreateDataBase.Create();
  LScript := TSQLiteScriptCreateTableLogDownload.Create(LScript);
  var LConnection := TFDConnection.Create(nil);
  try
    LConnection.ConnectionDefName := TConnectionDefinition.CONNECTION_DEF_NAME_SQL_LITE;
    LScript.Execute(LConnection);
  finally
    LConnection.Free();
  end;
end;

end.

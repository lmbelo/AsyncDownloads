unit Download.Subscriber;

interface

uses
  System.Generics.Collections;

type
  IObserver<T> = interface
    ['{85577972-C62C-4B66-A93C-B6DD94F57631}']
    procedure Notify(const ANotification: T);
  end;

  ISubject<T> = interface
    ['{D70F27A3-7EFF-457C-A29E-95AF7197727A}']
    procedure RegisterObserver(const AObserver: IObserver<T>);
    procedure UnRegisterObserver(const AObserver: IObserver<T>);
    procedure NotifyObservers(const AValue: T);
  end;

  TObservable<T> = class(TInterfacedObject, ISubject<T>)
  private
    FObservers: TList<IObserver<T>>;
  public
    constructor Create();
    destructor Destroy(); override;

    //ISubject implementation
    procedure RegisterObserver(const AObserver: IObserver<T>);
    procedure UnRegisterObserver(const AObserver: IObserver<T>);
    procedure NotifyObservers(const AValue: T);
  end;

implementation

{ TObservable<T> }

constructor TObservable<T>.Create;
begin
  FObservers := TList<IObserver<T>>.Create();
end;

destructor TObservable<T>.Destroy;
begin
  FObservers.Free();
  inherited;
end;

procedure TObservable<T>.NotifyObservers(const AValue: T);
var
  I: Integer;
begin
  TMonitor.Enter(Self);
  try
    for I := 0 to FObservers.Count - 1 do
      FObservers[I].Notify(AValue);
  finally
    TMonitor.Exit(Self);
  end;
end;

procedure TObservable<T>.RegisterObserver(const AObserver: IObserver<T>);
begin
  TMonitor.Enter(Self);
  try
    FObservers.Add(AObserver);
  finally
    TMonitor.Exit(Self);
  end;
end;

procedure TObservable<T>.UnRegisterObserver(const AObserver: IObserver<T>);
begin
  TMonitor.Enter(Self);
  try
    FObservers.Remove(AObserver);
  finally
    TMonitor.Exit(Self);
  end;
end;

end.

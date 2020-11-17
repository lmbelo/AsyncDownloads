unit MainForm;

interface

uses
  System.SysUtils, System.Types, System.Classes, System.Variants, Data.DB,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  Datasnap.DSClientRest, System.Rtti, FMX.Grid.Style, FMX.Edit, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Grid, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope, Download.Manager,
  Download.Subscriber, Download, Download.List, Model.Download,
  System.Threading, FireDAC.Comp.DataSet, FMX.Menus, System.Actions,
  FMX.ActnList, FMX.ListBox, FMX.Layouts, Download.HistoricoDownloads;

type
  TDownloadForm = class(TForm, Download.Subscriber.IObserver<TDownloadNotification>)
    ToolBar1: TToolBar;
    Button1: TButton;
    Grid1: TGrid;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    btnOptions: TButton;
    lbMenu: TListBox;
    ListBoxHeader1: TListBoxHeader;
    lbiExibirMensagem: TListBoxItem;
    lbiPararDownload: TListBoxItem;
    lblOpcoesDownload: TLabel;
    ListBoxGroupHeader1: TListBoxGroupHeader;
    lbiHistoricoDownloas: TListBoxItem;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnOptionsClick(Sender: TObject);
    procedure lbiPararDownloadClick(Sender: TObject);
    procedure lbiExibirMensagemClick(Sender: TObject);
    procedure lbMenuExit(Sender: TObject);
    procedure lbiHistoricoDownloasClick(Sender: TObject);
  private
    FDownloading: TDownloadList;
    FDownloadManager: TDownloadManager;
    //IObserver implementation
    procedure Notify(const ANotification: TDownloadNotification);
  private
    function TryInterruptAll(): boolean;
  public
    { Public declarations }
  end;

var
  DownloadForm: TDownloadForm;

implementation

uses
  System.UITypes, FMX.DialogService;

{$R *.fmx}

procedure TDownloadForm.btnOptionsClick(Sender: TObject);
begin
  lbMenu.Visible := not lbMenu.Visible;
  if lbMenu.Visible then begin
    lbiExibirMensagem.Enabled := not FDownloading.FDMemDownloadsCorrents.IsEmpty and (Grid1.Selected >= 0);
    lbiPararDownload.Enabled := not FDownloading.FDMemDownloadsCorrents.IsEmpty and (Grid1.Selected >= 0);
    lbMenu.ApplyStyleLookup();
    lbMenu.RealignContent();
    lbMenu.SetFocus();
  end;
end;

procedure TDownloadForm.Button1Click(Sender: TObject);
begin
  TDialogService.InputQuery('Informe a URL para download', ['URL'],[''],
    procedure(const AResult: TModalResult; const AValues: array of string) begin
      if (AResult = mrOk) then begin
        var LDownload := FDownloadManager.StartDownload(AValues[0],
          procedure(const ASubject: ISubject<TDownloadNotification>) begin
            //Registra um observer
            ASubject.RegisterObserver(Self);
          end);

        //LDownload.Interrupt(); //Pode ser que interrompa antes mesmo de começar
      end;
    end);
end;

procedure TDownloadForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  //Não compatível com TDialogService assíncrono
  if FDownloadManager.HasPendingDownload() then begin
    CanClose := TryInterruptAll();
  end else
    CanClose := true;
end;

procedure TDownloadForm.FormCreate(Sender: TObject);
begin
  FDownloadManager := TDownloadManager.Create();
  FDownloading := TDownloadList.Create(Self);
  BindSourceDB1.DataSet := FDownloading.FDMemDownloadsCorrents;
  lbMenu.Visible := false;
end;

procedure TDownloadForm.FormDestroy(Sender: TObject);
begin
  FDownloadManager.Free();
end;

procedure TDownloadForm.lbiExibirMensagemClick(Sender: TObject);
begin
  var LDatS := FDownloading.FDMemDownloadsCorrents;
  TThread.Synchronize(nil, procedure() begin
    LDatS.DisableControls();
    try
      if not LDatS.IsEmpty then begin
        ShowMessage(Format('Progresso atual: %d%s', [LDatS.FieldByName('PROGRESSO').AsInteger, '%']));
        lbMenu.Visible := false;
      end;
    finally
      LDatS.EnableControls();
    end;
  end);
end;

procedure TDownloadForm.lbiHistoricoDownloasClick(Sender: TObject);
begin
  var LForm := THistoricoDownload.Create(nil);
  try
    LForm.GerarHistorico();
    LForm.ShowModal();
  finally
    LForm.Free();
  end;
end;

procedure TDownloadForm.lbiPararDownloadClick(Sender: TObject);
begin
  var LDatS := FDownloading.FDMemDownloadsCorrents;
  TThread.Synchronize(nil, procedure() begin
    LDatS.DisableControls();
    try
      if not LDatS.IsEmpty then begin
        FDownloadManager.InterruptDownload(LDatS.FieldByName('TOKEN').AsString);
        lbMenu.Visible := false;
      end;
    finally
      LDatS.EnableControls();
    end;
  end);
end;

procedure TDownloadForm.lbMenuExit(Sender: TObject);
begin
  lbMenu.Visible := false;
end;

procedure TDownloadForm.Notify(const ANotification: TDownloadNotification);
begin
  TThread.Synchronize(nil, procedure() begin
    FDownloading.FDMemDownloadsCorrents.DisableControls;
    try
      var LBookmark := FDownloading.FDMemDownloadsCorrents.Bookmark;
      try
        case ANotification.Download.Status of
          TDownloadStatus.dsStarted: begin
            FDownloading.Add(ANotification.Download.Token, ANotification.Data);
          end;
          TDownloadStatus.dsDownloading: begin
            FDownloading.Step(ANotification.Download.Token,
              ANotification.Progress, ANotification.Data);
          end;
          TDownloadStatus.dsCompleted: begin
            FDownloading.Terminated(ANotification.Download.Token,
              ANotification.Download.Status, ANotification.Progress,
              ANotification.Data);
          end;
          TDownloadStatus.dsInterrupted: begin
            FDownloading.Terminated(ANotification.Download.Token,
              ANotification.Download.Status,
              ANotification.Progress, ANotification.Data);
          end;
          TDownloadStatus.dsError: begin
            var LErrorMessage := EmptyStr;
            var LFatalException := ANotification.Download.FatalException;
            if Assigned(ANotification.Download.FatalException) then
              LErrorMessage := LFatalException.Message;
            FDownloading.Error(ANotification.Download.Token, LErrorMessage);
            if LErrorMessage.Length > 0 then
              ShowMessage(LErrorMessage);
          end;
        end;
      finally
        FDownloading.FDMemDownloadsCorrents.Bookmark := LBookmark;
      end;
    finally
      FDownloading.FDMemDownloadsCorrents.EnableControls;
    end;
  end);
end;

function TDownloadForm.TryInterruptAll: boolean;
var
  LResult: boolean;
begin
  LResult := false;
  TDialogService.MessageDialog('Existem downloads pendentes. Deseja cancelar?',
    TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
    TMsgDlgBtn.mbNo, - 1, procedure(const AResult: TModalResult) begin
      if (AResult = mrYes) then begin
        var LInterrupted := FDownloadManager.InterruptAll();
        TDialogService.ShowMessage('Os downloads estão sendo interrompidos.'
                                 + 'Aguarde um momento...');
        if LInterrupted.Value then
          LResult := true
        else
          TDialogService.ShowMessage('Tente fechar a aplicação novamente.');
      end;
    end);
  Result := LResult;
end;

end.

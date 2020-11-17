object DownloadList: TDownloadList
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 228
  Width = 393
  object FDMemDownloadsCorrents: TFDMemTable
    OnNewRecord = FDMemDownloadsCorrentsNewRecord
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 184
    Top = 72
    object FDMemDownloadsCorrentsCODIGO: TIntegerField
      DisplayLabel = 'C'#243'digo'
      FieldName = 'CODIGO'
      Visible = False
    end
    object FDMemDownloadsCorrentsSTATUS: TIntegerField
      Alignment = taCenter
      DisplayLabel = 'Status'
      DisplayWidth = 16
      FieldName = 'STATUS'
      OnGetText = FDMemDownloadsCorrentsSTATUSGetText
    end
    object FDMemDownloadsCorrentsURL: TStringField
      DisplayLabel = 'Url'
      DisplayWidth = 53
      FieldName = 'URL'
      Size = 254
    end
    object FDMemDownloadsCorrentsDT_INICIO: TDateTimeField
      DisplayLabel = 'In'#237'cio'
      FieldName = 'DT_INICIO'
    end
    object FDMemDownloadsCorrentsDT_FIM: TDateTimeField
      DisplayLabel = 'Fim'
      FieldName = 'DT_FIM'
      OnGetText = FDMemDownloadsCorrentsDT_FIMGetText
    end
    object FDMemDownloadsCorrentsPROGRESSO: TLargeintField
      Alignment = taCenter
      DisplayLabel = 'Progresso'
      FieldName = 'PROGRESSO'
      OnGetText = FDMemDownloadsCorrentsPROGRESSOGetText
    end
    object FDMemDownloadsCorrentsTOKEN: TGuidField
      FieldName = 'TOKEN'
      Visible = False
      Size = 38
    end
  end
end

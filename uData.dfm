object dmData: TdmData
  OldCreateOrder = False
  Height = 365
  Width = 499
  object connection: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=SQLNCLI11.1;Integrated Security=SSPI;Persist Security I' +
      'nfo=False;User ID="";Initial Catalog=PR_SISTEMAS;Data Source=(lo' +
      'cal);Initial File Name="";Server SPN=DESKTOP-4ONCG9R\bruno'
    LoginPrompt = False
    Provider = 'SQLNCLI11.1'
    Left = 51
    Top = 16
  end
  object qPessoas: TADOQuery
    Connection = connection
    Parameters = <>
    Left = 51
    Top = 96
  end
  object qEndereco: TADOQuery
    Connection = connection
    Parameters = <>
    Left = 243
    Top = 96
  end
  object dsPessoas: TDataSource
    DataSet = qPessoas
    Left = 51
    Top = 152
  end
  object dsEnderecos: TDataSource
    DataSet = qEndereco
    Left = 243
    Top = 152
  end
  object dstPessoas: TDataSource
    DataSet = qqPessoas
    Left = 115
    Top = 152
  end
  object qqPessoas: TADOQuery
    Connection = connection
    Parameters = <>
    Left = 115
    Top = 96
  end
  object dsqEndereco: TDataSource
    DataSet = qqEndereco
    Left = 315
    Top = 152
  end
  object qqEndereco: TADOQuery
    Connection = connection
    Parameters = <>
    Left = 315
    Top = 96
  end
end

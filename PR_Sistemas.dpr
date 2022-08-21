program PR_Sistemas;

uses
  Vcl.Forms,
  uPrincipal in 'uPrincipal.pas' {frmPrincipal},
  uCadEndereco in 'uCadEndereco.pas' {frmCadEndereco},
  uData in 'uData.pas' {dmData: TDataModule},
  ConsultaCEP in 'ConsultaCEP.pas',
  ViaCEP.Core in 'src\ViaCEP.Core.pas',
  ViaCEP.Intf in 'src\ViaCEP.Intf.pas',
  ViaCEP.Model in 'src\ViaCEP.Model.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TfrmCadEndereco, frmCadEndereco);
  Application.CreateForm(TdmData, dmData);
  Application.Run;

end.

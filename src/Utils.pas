unit Utils;

interface



///-----------------------------------------------------
uses ViaCEP.Core, ViaCEP.INtF, ViaCEP.Model;

type
  TUtils = class
  private
  {private declarations}
  public
    {public declarations}
  end;
implementation

function verificaCEP(_Cep: string): boolean;
var
  ViaCEP: IViaCEP;
  CEP: TViaCEPClass;
begin
  result := true;
  ViaCEP := TViaCEP.Create;
  if (not(ViaCEP.Validate(_Cep))) then
  begin
    result := false;
    exit;
  end;

  CEP := ViaCEP.Get(_Cep);
  if not Assigned(CEP) then
  begin
    result := false;
    exit;
  end;

  if CEP.Localidade = '' then
  begin
    result:=false;
    exit;
  end;

  result:=true;

end;

end.

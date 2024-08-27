unit AlephPropertyEditor;

interface

uses
  System.Classes, DesignIntf, DesignEditors, AlephLayout;

type
  TAlephWidthHeightPropertyEditor = class(TPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

implementation

uses
  System.SysUtils, Vcl.Dialogs;

{ TAlephWidthHeightPropertyEditor }

function TAlephWidthHeightPropertyEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

procedure TAlephWidthHeightPropertyEditor.Edit;
var
  NewValue: Integer;
begin
  NewValue := StrToIntDef(InputBox('Enter Width/Height Percent',
                                  'Enter new percentage:',
                                  IntToStr(GetOrdValue)),
                         GetOrdValue);
  if NewValue <> GetOrdValue then
    SetOrdValue(NewValue);
end;

end.


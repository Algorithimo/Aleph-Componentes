unit GlobalFontSizeManagerPropertyEditor;

interface

uses
  System.Classes, System.SysUtils, DesignIntf, DesignEditors, GlobalFontSizeManager, FMX.Forms, TypInfo;

type
  TGlobalFontSizeManagerPropertyEditor = class(TPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
  end;

implementation

uses
  GlobalFontSizeManagerEditor;

{ TGlobalFontSizeManagerPropertyEditor }

function TGlobalFontSizeManagerPropertyEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paRevertable, paMultiSelect];
end;

procedure TGlobalFontSizeManagerPropertyEditor.Edit;
var
  EditorForm: TGlobalFontSizeManagerEditorForm;
  Comp: TGlobalFontSizeManager;
begin
  Comp := TGlobalFontSizeManager(GetComponent(0));
  EditorForm := TGlobalFontSizeManagerEditorForm.Create(nil);
  try
    EditorForm.LoadSettings(Comp);
    if EditorForm.ShowModal = 1 then
    begin
      EditorForm.SaveSettings(Comp);
      Modified;
    end;
  finally
    EditorForm.Free;
  end;
end;

function TGlobalFontSizeManagerPropertyEditor.GetValue: string;
var
  PropInfo: PPropInfo;
begin
  PropInfo := GetPropInfo;
  if PropInfo^.PropType^.Kind = tkFloat then
    Result := FloatToStr(GetFloatValue)
  else
    Result := IntToStr(GetOrdValue);
end;

procedure TGlobalFontSizeManagerPropertyEditor.SetValue(const Value: string);
var
  PropInfo: PPropInfo;
  FloatValue: Single;
  IntValue: Integer;
begin
  PropInfo := GetPropInfo;
  if PropInfo^.PropType^.Kind = tkFloat then
  begin
    if TryStrToFloat(Value, FloatValue) then
      SetFloatValue(FloatValue)
    else
      raise EConvertError.CreateFmt('"%s" is not a valid float value', [Value]);
  end
  else
  begin
    if TryStrToInt(Value, IntValue) then
      SetOrdValue(IntValue)
    else
      raise EConvertError.CreateFmt('"%s" is not a valid integer value', [Value]);
  end;
end;

end.

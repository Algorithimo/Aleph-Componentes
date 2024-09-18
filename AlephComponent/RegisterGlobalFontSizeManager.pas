unit RegisterGlobalFontSizeManager;

interface

uses
  System.Classes, DesignIntf, DesignEditors, GlobalFontSizeManager,
  GlobalFontSizeManagerComponentEditor, GlobalFontSizeManagerPropertyEditor;

procedure Register;

implementation

procedure Register;
begin
  // Registrar o componente TGlobalFontSizeManager na aba Aleph
  RegisterComponents('Aleph', [TGlobalFontSizeManager]);

  // Registrar o editor de componente para habilitar o duplo clique
  RegisterComponentEditor(TGlobalFontSizeManager, TGlobalFontSizeManagerComponentEditor);

  // Registrar editores de propriedade para as propriedades específicas
  RegisterPropertyEditor(TypeInfo(Single), TGlobalFontSizeManager, 'FontPercentage', TGlobalFontSizeManagerPropertyEditor);
  RegisterPropertyEditor(TypeInfo(Integer), TGlobalFontSizeManager, 'MinFontSize', TGlobalFontSizeManagerPropertyEditor);
end;

end.


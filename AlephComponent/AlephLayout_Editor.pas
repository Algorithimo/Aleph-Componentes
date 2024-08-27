unit AlephLayout_Editor;

interface

uses
  System.Classes, DesignIntf, DesignEditors, AlephLayout, AlephPropertyEditor;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Aleph', [TAlephLayout]);
  RegisterPropertyEditor(TypeInfo(Integer), TAlephLayout, 'PWidth', TAlephWidthHeightPropertyEditor);
  RegisterPropertyEditor(TypeInfo(Integer), TAlephLayout, 'PHeight', TAlephWidthHeightPropertyEditor);
end;

end.


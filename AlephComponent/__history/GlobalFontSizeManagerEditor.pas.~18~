unit GlobalFontSizeManagerEditor;

interface

uses
  System.Classes,System.SysUtils, FMX.Forms, FMX.Controls, FMX.StdCtrls, FMX.Edit, GlobalFontSizeManager,
  FMX.Types, FMX.Controls.Presentation;

type
  TGlobalFontSizeManagerEditorForm = class(TForm)
    EditMinFontSize: TEdit;
    EditFontPercentage: TEdit;
    ButtonOk: TButton;
    ButtonCancel: TButton;
    procedure ButtonOkClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
  private
    FComponent: TGlobalFontSizeManager;
  public
    procedure LoadSettings(AComponent: TGlobalFontSizeManager);
    procedure SaveSettings(AComponent: TGlobalFontSizeManager);
    property Component: TGlobalFontSizeManager read FComponent write FComponent;
  end;

implementation

{$R *.fmx}

procedure TGlobalFontSizeManagerEditorForm.ButtonOkClick(Sender: TObject);
begin
  ModalResult := 1;
end;

procedure TGlobalFontSizeManagerEditorForm.ButtonCancelClick(Sender: TObject);
begin
  ModalResult := 2;
end;

procedure TGlobalFontSizeManagerEditorForm.LoadSettings(AComponent: TGlobalFontSizeManager);
begin
  FComponent := AComponent;
  EditFontPercentage.Text := FloatToStr(AComponent.GetFontPercentage);
  EditMinFontSize.Text := IntToStr(AComponent.GetMinFontSize);
end;

procedure TGlobalFontSizeManagerEditorForm.SaveSettings(AComponent: TGlobalFontSizeManager);
begin
  AComponent.SetFontPercentage(StrToInt(EditFontPercentage.Text));
  AComponent.SetMinFontSize(StrToInt(EditMinFontSize.Text));
end;

end.


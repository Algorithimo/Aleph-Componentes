unit GlobalFontSizeManagerEditor;

interface

uses
  System.Classes, System.SysUtils, FMX.Forms, FMX.Controls, FMX.StdCtrls, FMX.Edit, FMX.Types,FMX.Dialogs, GlobalFontSizeManager;

type
  TGlobalFontSizeManagerEditorForm = class(TForm)
    FontBaseEdit: TEdit;
    FontPercentageEdit: TEdit;
    FormWidthEdit: TEdit;
    MinFontSizeEdit: TEdit;
    OKButton: TButton;
    CancelButton: TButton;
    procedure OKButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
  private
    FGlobalFontSizeManager: TGlobalFontSizeManager;
  public
    procedure SetFontSizeManager(AFontSizeManager: TGlobalFontSizeManager);
  end;

implementation

{$R *.fmx}

procedure TGlobalFontSizeManagerEditorForm.OKButtonClick(Sender: TObject);
begin
  FGlobalFontSizeManager.FontBase := StrToIntDef(FontBaseEdit.Text, FGlobalFontSizeManager.FontBase);
  FGlobalFontSizeManager.FontPercentage := StrToIntDef(FontPercentageEdit.Text, FGlobalFontSizeManager.FontPercentage);
  FGlobalFontSizeManager.FormWidth := StrToIntDef(FormWidthEdit.Text, FGlobalFontSizeManager.FormWidth);
  FGlobalFontSizeManager.MinFontSize := StrToIntDef(MinFontSizeEdit.Text, FGlobalFontSizeManager.MinFontSize);
  ModalResult := 1;
end;

procedure TGlobalFontSizeManagerEditorForm.CancelButtonClick(Sender: TObject);
begin
  ModalResult := 2;
end;

procedure TGlobalFontSizeManagerEditorForm.SetFontSizeManager(AFontSizeManager: TGlobalFontSizeManager);
begin
  FGlobalFontSizeManager := AFontSizeManager;
  FontBaseEdit.Text := IntToStr(FGlobalFontSizeManager.FontBase);
  FontPercentageEdit.Text := IntToStr(FGlobalFontSizeManager.FontPercentage);
  FormWidthEdit.Text := IntToStr(FGlobalFontSizeManager.FormWidth);
  MinFontSizeEdit.Text := IntToStr(FGlobalFontSizeManager.MinFontSize);
end;

end.


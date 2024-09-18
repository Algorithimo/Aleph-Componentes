unit GlobalFontSizeManager;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections,System.Math,FMX.Forms , AlephRem, AlephREmFont;

type
  IGlobalFontSizeAware = interface
    ['{E3CF647C-7D56-446A-8089-F641C8F0106B}'] // Substitua por um GUID real
    procedure UpdateFontSize;
  end;

  TGlobalFontSizeManager = class(TComponent)
  private
    FFontBase: TFontBase;
    FRemFontSize: TREmFontSize;
    FMinFontSize: Integer;
    FFontPercentage: Single;
    FComponents: TList<IGlobalFontSizeAware>;
    FForm: TForm;
    function GetFontBase: Integer;
    procedure SetFontBase(const Value: Integer);
    function GetRemFontSize: TREmFontSize;
    procedure SetRemFontSize(const Value: TREmFontSize);
    function GetFontSize: Integer;
    procedure SetFontSize(const Value: Integer);
    procedure SetForm(const Value: TForm);
    //function CalculateFontSize(AControlWidth: Integer): Integer;
  public
    function GetFontPercentage: Single;
    procedure SetFontPercentage(const Value: Single);
    function GetMinFontSize: Integer;
    procedure SetMinFontSize(const Value: Integer);

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure RegisterComponent(AComponent: IGlobalFontSizeAware);
    procedure UnregisterComponent(AComponent: IGlobalFontSizeAware);
    procedure UpdateAllFontSizes;
    procedure CalculateAndUpdateFontSize;
  published
    property FontBase: Integer read GetFontBase write SetFontBase;
    property RemFontSize: TREmFontSize read GetRemFontSize write SetRemFontSize;
    property FontPercentage: Single read GetFontPercentage write SetFontPercentage;
    property MinFontSize: Integer read GetMinFontSize write SetMinFontSize;
    property Form: TForm read FForm write SetForm;
  end;

implementation

{ TGlobalFontSizeManager }

constructor TGlobalFontSizeManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFontBase := TFontBase.Create(12);  // Valor padr�o inicial
  FRemFontSize := TREmFontSize.Create(12); // Valor padr�o inicial
  FFontPercentage := 1.0;  // Percentual padr�o
  FMinFontSize := 10;      // Tamanho m�nimo padr�o
  FComponents := TList<IGlobalFontSizeAware>.Create;
  if AOwner is TForm then
    FForm := TForm(AOwner);
end;

destructor TGlobalFontSizeManager.Destroy;
begin
  FFontBase.Free;
  FRemFontSize.Free;
  FComponents.Free;
  inherited;
end;

function TGlobalFontSizeManager.GetFontBase: Integer;
begin
  Result := FFontBase.FontBase;
end;

function TGlobalFontSizeManager.GetFontPercentage: Single;
begin
  Result := FFontPercentage;
end;

procedure TGlobalFontSizeManager.SetFontBase(const Value: Integer);
begin
  if Assigned(FFontBase) then
    begin
      FFontBase.FontBase := Value;
      FRemFontSize.FontSize := Value;
      UpdateAllFontSizes;
    end;
end;

function TGlobalFontSizeManager.GetFontSize: Integer;
begin
  Result := FRemFontSize.FontSize;
end;

function TGlobalFontSizeManager.GetMinFontSize: Integer;
begin
  Result := FMinFontSize;
end;

function TGlobalFontSizeManager.GetRemFontSize: TREmFontSize;
begin
  Result := FRemFontSize;     //Verificar depois
end;

procedure TGlobalFontSizeManager.CalculateAndUpdateFontSize;
var
  NewFontSize: Integer;
begin
  if Assigned(FForm) then
  begin
    NewFontSize := Max(Round(FForm.ClientWidth * FFontPercentage / 100), FMinFontSize);
    SetFontBase(NewFontSize);
  end;
end;

//function TGlobalFontSizeManager.CalculateFontSize(AControlWidth: Integer): Integer;
//begin
//  Result := Max(Round(AControlWidth * FFontPercentage / 100), FMinFontSize);
//  SetFontBase(Result);
//end;

procedure TGlobalFontSizeManager.RegisterComponent(AComponent: IGlobalFontSizeAware);
begin
  if not FComponents.Contains(AComponent) then
    FComponents.Add(AComponent);
end;

procedure TGlobalFontSizeManager.UnregisterComponent(AComponent: IGlobalFontSizeAware);
begin
  FComponents.Remove(AComponent);
end;

procedure TGlobalFontSizeManager.UpdateAllFontSizes;
var
  Component: IGlobalFontSizeAware;
begin
  for Component in FComponents do
    Component.UpdateFontSize;
end;

procedure TGlobalFontSizeManager.SetFontSize(const Value: Integer);
begin
  if Assigned(FRemFontSize) then
    FRemFontSize.FontSize := Value;
end;

procedure TGlobalFontSizeManager.SetForm(const Value: TForm);
begin
  if FForm <> Value then
  begin
    if Assigned(FForm) then
      RemoveFreeNotification(FForm);
    FForm := Value;
    if Assigned(FForm) then
    begin
      FreeNotification(FForm);
      CalculateAndUpdateFontSize;
    end;
  end;
end;

procedure TGlobalFontSizeManager.SetFontPercentage(const Value: Single);
begin
  if FFontPercentage <> Value then
  begin
    FFontPercentage := Value;
    CalculateAndUpdateFontSize;
  end
end;

procedure TGlobalFontSizeManager.SetMinFontSize(const Value: Integer);
begin
  FMinFontSize := Value;
end;

procedure TGlobalFontSizeManager.SetRemFontSize(const Value: TREmFontSize);
begin
    if Assigned(FRemFontSize) then
    begin
      FRemFontSize.Assign(Value);
      FFontBase.FontBase := Value.FontSize;
      UpdateAllFontSizes;
    end;
end;

//function TGlobalFontSizeManager.CalculateFontSize(AControlWidth: Integer): Integer;
//var
//  CalculatedSize: Integer;
//begin
//  // Calcula o tamanho da fonte baseado na largura do controle e o percentual
//  CalculatedSize := Round(AControlWidth * FFontPercentage / 100);
//
//  // Verifica se o tamanho da fonte calculado � menor que o tamanho m�nimo
//  if CalculatedSize < FMinFontSize then
//    CalculatedSize := FMinFontSize;
//
//  Result := CalculatedSize;
//end;

end.


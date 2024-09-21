unit AutoHeightEdit;

interface

uses
  System.SysUtils, System.Classes, FMX.Controls, FMX.Edit;

type
  TAlephCustomEdit = class(FMX.Edit.TEdit)
  private
    FAutoHeight: Boolean;
    FInAutoHeight: Boolean;
    procedure SetAutoHeight(const Value: Boolean);
    procedure AdjustHeight;
    procedure HandleChangeTracking(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property AutoHeight: Boolean read FAutoHeight write SetAutoHeight;
  end;

procedure Register;

implementation

uses
  FMX.Types, FMX.Graphics;

procedure Register;
begin
  RegisterComponents('Aleph', [TAlephCustomEdit]);
end;

{ TCustomEdit }

constructor TAlephCustomEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAutoHeight := True;  // Inicializa o AutoHeight como habilitado
  FInAutoHeight := False;
  // Associa o evento OnChangeTracking para detectar mudanças de texto
  OnChangeTracking := HandleChangeTracking;
end;

destructor TAlephCustomEdit.Destroy;
begin
  OnChangeTracking := nil;
  inherited Destroy;
end;

procedure TAlephCustomEdit.SetAutoHeight(const Value: Boolean);
begin
  if FAutoHeight <> Value then
  begin
    FAutoHeight := Value;
    if FAutoHeight then
      AdjustHeight;
  end;
end;

procedure TAlephCustomEdit.HandleChangeTracking(Sender: TObject);
begin
  // Quando o texto muda, ajusta a altura se AutoHeight estiver habilitado
  if FAutoHeight then
    AdjustHeight;
end;

procedure TAlephCustomEdit.AdjustHeight;
var
  TextHeight: Single;
begin
  if FInAutoHeight or not FAutoHeight then
    Exit;

  FInAutoHeight := True;
  try
    // Calcula a altura do texto com base na fonte e no conteúdo
    TextHeight := Canvas.TextHeight(Text);

    // Ajusta a altura do TEdit com base no tamanho do texto
    Height := TextHeight + 10;  // Adiciona um padding para garantir que o texto caiba confortavelmente
  finally
    FInAutoHeight := False;
  end;
end;

end.


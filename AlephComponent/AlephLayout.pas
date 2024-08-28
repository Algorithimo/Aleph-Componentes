unit AlephLayout;

interface

uses
  System.SysUtils,
  System.Classes,
  FMX.Layouts,
  FMX.Types,
  FMX.Controls,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.Objects,
  FMX.Forms,
  System.Generics.Collections,
  AlephTipos,
  AlephFlexbox;

type
  TAlephLayout = class(TLayout)
  private
    FAlephTipo: TAlephTipo;
    FFlexboxContainer: TFlexContainer;
    procedure AdjustSize(Sender: TObject);
    procedure FormResizeHandler(Sender: TObject);
    class procedure GlobalFormResizeHandler(Sender: TObject); static;
    function GetTipo: TAlephTipo;
    procedure SetTipo(const Value: TAlephTipo);
    procedure ApplyFlexboxLayout;
  protected
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property AlephPercentage: TAlephTipo read GetTipo write SetTipo;
    property FlexboxContainer: TFlexContainer read FFlexboxContainer write FFlexboxContainer;
  end;

procedure Register;

implementation

procedure Register;
begin
  // Registrar os componentes na paleta de componentes da IDE
  RegisterComponents('Aleph', [TAlephLayout]);
end;

var
  AlephLayouts: TList<TAlephLayout>;

procedure RegisterAlephLayout(ALayout: TAlephLayout);
begin
  if not Assigned(AlephLayouts) then
    AlephLayouts := TList<TAlephLayout>.Create;
  AlephLayouts.Add(ALayout);
end;

procedure UnregisterAlephLayout(ALayout: TAlephLayout);
begin
  if Assigned(AlephLayouts) then
    AlephLayouts.Remove(ALayout);
end;

function TAlephLayout.GetTipo: TAlephTipo;
begin
  Result := FAlephTipo;
end;

class procedure TAlephLayout.GlobalFormResizeHandler(Sender: TObject);
var
  i: Integer;
begin
  if Assigned(AlephLayouts) then
  begin
    for i := 0 to AlephLayouts.Count - 1 do
    begin
      AlephLayouts[i].AdjustSize(Sender);
      AlephLayouts[i].ApplyFlexboxLayout;
    end;
  end;
end;

procedure TAlephLayout.Resize;
begin
  inherited;
  FAlephTipo.Resize;
end;

procedure TAlephLayout.SetTipo(const Value: TAlephTipo);
begin
  FAlephTipo.Assign(Value);
  AdjustSize(nil);
end;

{ TAlephLayout }

procedure TAlephLayout.AdjustSize(Sender: TObject);
begin
  FAlephTipo.AdjustSize;
end;

procedure TAlephLayout.ApplyFlexboxLayout;
begin
  if Assigned(FFlexboxContainer) then
  begin
    FFlexboxContainer.Width := Self.Width;
    FFlexboxContainer.Height := Self.Height;
    FFlexboxContainer.CalculateLayout;
  end;
end;

constructor TAlephLayout.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAlephTipo := TAlephTipo.Create(Self);
  FFlexboxContainer := TFlexContainer.Create(Self);
  FFlexboxContainer.Parent := Self;
  if AOwner is TForm then
  begin
    TForm(AOwner).OnResize := FormResizeHandler;
    // Registra o evento de redimensionamento global
  end;
  RegisterAlephLayout(Self); // Registra o componente na lista
end;

destructor TAlephLayout.Destroy;
begin
  FreeAndNil(AlephLayouts);
  FreeAndNil(FAlephTipo);
  FreeAndNil(FFlexboxContainer);
  UnregisterAlephLayout(Self);
  inherited Destroy;
end;

procedure TAlephLayout.FormResizeHandler(Sender: TObject);
begin
  GlobalFormResizeHandler(Sender);
end;

end.


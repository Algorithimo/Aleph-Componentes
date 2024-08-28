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
    procedure ApplyFlexboxLayout(Sender: TObject);
    procedure FormResizeHandler(Sender: TObject);
    class procedure GlobalFormResizeHandler(Sender: TObject); static;
    function GetTipo: TAlephTipo;
    function GetFlexboxContainer: TFlexContainer;
    procedure SetTipo(const Value: TAlephTipo);
    procedure SetFlexboxContainer(const Value: TFlexContainer);
  protected
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property AlephPercentage: TAlephTipo read GetTipo write SetTipo;
    property FlexboxContainer: TFlexContainer read GetFlexboxContainer write SetFlexboxContainer;
  end;

procedure Register;

implementation

var
  AlephLayouts: TList<TAlephLayout>;

procedure Register;
begin
  // Registrar os componentes na paleta de componentes da IDE
  RegisterComponents('Aleph', [TAlephLayout]);
end;

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

function TAlephLayout.GetFlexboxContainer: TFlexContainer;
begin
  Result := FFlexboxContainer;
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
      AlephLayouts[i].ApplyFlexboxLayout(sender);
    end;
  end;
end;

procedure TAlephLayout.Resize;
begin
  inherited;
  if Assigned(FAlephTipo) then
    FAlephTipo.Resize;
end;

procedure TAlephLayout.SetFlexboxContainer(const Value: TFlexContainer);
begin
  if Assigned(FFlexboxContainer) then
    FFlexboxContainer.Assign(Value);
  AdjustSize(nil);
end;

procedure TAlephLayout.SetTipo(const Value: TAlephTipo);
begin
  if Assigned(FAlephTipo) then
    FAlephTipo.Assign(Value);
  AdjustSize(nil);
end;

procedure TAlephLayout.AdjustSize(Sender: TObject);
begin
  if Assigned(FAlephTipo) then
    FAlephTipo.AdjustSize;
end;

procedure TAlephLayout.ApplyFlexboxLayout(Sender: TObject);
begin
  if Assigned(FFlexboxContainer) then
  begin
    FFlexboxContainer.CalculateLayout;
  end;
end;

constructor TAlephLayout.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAlephTipo := TAlephTipo.Create(Self);
  FFlexboxContainer := TFlexContainer.Create(self);
  if AOwner is TForm then
  begin
    TForm(AOwner).OnResize := FormResizeHandler;
    // Registra o evento de redimensionamento global
  end;
  RegisterAlephLayout(Self); // Registra o componente na lista
end;

destructor TAlephLayout.Destroy;
begin
  if Assigned(AlephLayouts) then
  begin
    UnregisterAlephLayout(Self);
    if AlephLayouts.Count = 0 then
      FreeAndNil(AlephLayouts); // Liberar a lista se estiver vazia
  end;
  FreeAndNil(FAlephTipo);
  FreeAndNil(FFlexboxContainer); // Libera a referÍncia ao FlexContainer
  inherited Destroy;
end;

procedure TAlephLayout.FormResizeHandler(Sender: TObject);
begin
  GlobalFormResizeHandler(Sender);
end;

end.


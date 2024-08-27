unit LayoutPlus;

interface

uses
  System.SysUtils,
  System.Classes,
  FMX.Types,
  FMX.Controls,
  FMX.Layouts,
  Builder_Impl,
  ConcreteBuilder_Impl;

type
  TLayoutPlus = class(TComponent)
  public
    constructor Create(AOwner: TComponent); override;
  private
    FBuilder: IBuilder;
    procedure SetBuilder(const Value: IBuilder);
  published
    property Builder: IBuilder read FBuilder write SetBuilder;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Aleph', [TLayoutPlus]);
end;

{ TLayoutPlus }

constructor TLayoutPlus.Create(AOwner: TComponent);
begin
  inherited;
  FBuilder := TConcreteBuilder.Create;
end;

procedure TLayoutPlus.SetBuilder(const Value: IBuilder);
begin
  FBuilder := Value;
end;

end.

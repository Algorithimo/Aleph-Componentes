unit ConcreteBuilder_Impl;

interface

uses
  System.Generics.Collections,
  System.SysUtils,
  System.Classes,
  Builder_Impl,
  Layout_Impl;

type
  TConcreteBuilder = class(TInterfacedObject, IBuilder)
  private
     LayoutImplement: TList<TLayoutImplement>;
  public
    constructor Create(ARect: TLayoutImplement); override;
    destructor Destroy; override;
  end;

implementation

{ TConcreteBuilder }

constructor TConcreteBuilder.Create(ARect: TLayoutImplement);
var
  i: Integer;
begin
  inherited Create;
  if not Assigned(LayoutImplement) then
    LayoutImplement := TList<TLayoutImplement>.Create;
  LayoutImplement.Add(ARect);
  if Assigned(LayoutImplement) then
  begin
    for i := 0 to LayoutImplement.Count - 1 do
    begin
      LayoutImplement[i].AdjustSize(nil);
    end;
  end;
end;

destructor TConcreteBuilder.Destroy;
begin

  inherited;
end;

end.

unit ResizeManager;

interface

uses
  System.Classes,
  Fmx.Forms,
  System.Generics.Collections;

type
  IResizable = interface
    [ '{888720A6-8410-4D74-B289-433A4295A57B}' ]
    procedure ResizeComponent( Sender : TObject );
  end;

  IResizeCorner = interface
    [ '{B2466241-40D0-4F46-8D9C-22C6B4F54589}' ]
    procedure ResizeCorner( Sender : TObject );
    procedure ResizeSquareMode( Sender : TObject );
  end;

  IFontSizeAdjustable = interface
    [ '{8ECDAC3C-D868-41B9-9A4D-4DC982179DEE}' ]
    procedure CalculatePercentage( Sender : TObject );
  end;

  TResizeManager = class
    private
      FResizableComponents : TList< IResizable >;
      FFontSizeAdjustableComponents : TList< IFontSizeAdjustable >;
      FResizeCorner : TList< IResizeCorner >;

    public
      constructor Create;
      destructor Destroy; override;
      procedure FormResizeHandler( Sender : TObject; AAfterHandler: TNotifyEvent = nil );
      procedure RegisterComponent( AComponent : IResizable );
      procedure UnregisterComponent( AComponent : IResizable );
      procedure RegisterFontSizeComponent( AComponent : IFontSizeAdjustable );
      procedure UnregisterFontSizeComponent( AComponent : IFontSizeAdjustable );
      procedure RegisterCornerComponent( AComponent : IResizeCorner );
      procedure UnregisterCornerComponent( AComponent : IResizeCorner );
      class function GetInstance : TResizeManager;
  end;

function GlobalResizeManager : TResizeManager;

implementation

var
  FResizeManager : TResizeManager = nil;

function GlobalResizeManager : TResizeManager;
  begin
    Result := TResizeManager.GetInstance;
  end;

{ TResizeManager }

constructor TResizeManager.Create;
  begin
    inherited;
    FResizableComponents := TList< IResizable >.Create;
    FFontSizeAdjustableComponents := TList< IFontSizeAdjustable >.Create;
    FResizeCorner := TList< IResizeCorner >.Create;
  end;

destructor TResizeManager.Destroy;
  begin
    FResizableComponents.Free;
    FFontSizeAdjustableComponents.Free;
    FResizeCorner.Free;
    inherited;
  end;

procedure TResizeManager.FormResizeHandler( Sender : TObject; AAfterHandler: TNotifyEvent = nil );
  var
    Component : IResizable;
    FontComponent : IFontSizeAdjustable;
    CornerComponent : IResizeCorner;
  begin
    for Component in FResizableComponents do
      Component.ResizeComponent( Sender );

    for FontComponent in FFontSizeAdjustableComponents do
      FontComponent.CalculatePercentage( Sender );

    for CornerComponent in FResizeCorner do
      CornerComponent.ResizeCorner( Sender );

    // Chame o handler adicional, se fornecido
    if Assigned(AAfterHandler) then
      AAfterHandler(Sender);
  end;

class function TResizeManager.GetInstance : TResizeManager;
  begin
    if FResizeManager = nil
    then
      FResizeManager := TResizeManager.Create;
    Result := FResizeManager;
  end;

procedure TResizeManager.RegisterComponent( AComponent : IResizable );
  begin
    if not FResizableComponents.Contains( AComponent )
    then
      FResizableComponents.Add( AComponent );
  end;

procedure TResizeManager.UnregisterComponent( AComponent : IResizable );
  begin
    FResizableComponents.Remove( AComponent );
  end;

procedure TResizeManager.RegisterFontSizeComponent
  ( AComponent : IFontSizeAdjustable );
  begin
    if not FFontSizeAdjustableComponents.Contains( AComponent )
    then
      FFontSizeAdjustableComponents.Add( AComponent );
  end;

procedure TResizeManager.UnregisterFontSizeComponent
  ( AComponent : IFontSizeAdjustable );
  begin
    FFontSizeAdjustableComponents.Remove( AComponent );
  end;

procedure TResizeManager.RegisterCornerComponent( AComponent : IResizeCorner );
  begin
    if not FResizeCorner.Contains( AComponent )
    then
      FResizeCorner.Add( AComponent );
  end;

procedure TResizeManager.UnregisterCornerComponent
  ( AComponent : IResizeCorner );
  begin
    FResizeCorner.Remove( AComponent );
  end;

initialization

finalization

FResizeManager.Free;

end.

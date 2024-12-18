unit AlephCornerButton;

interface

uses
  System.SysUtils,
  System.Classes,
  FMX.Types,
  FMX.Controls,
  FMX.Controls.Presentation,
  FMX.Forms,
  System.Generics.Collections,
  FMX.StdCtrls,
  FMX.Objects,
  AlephRem,
  AlephTipos,
  AlephREmFont,
  GlobalFontSizeManager,
  ResizeManager;

type
  TAlephCornerButton = class( TCornerButton, IRemFontSize, IGlobalFontSizeAware,
    IFontSizeAdjustable, IResizable, IResizeCorner )
    private
      FAlephTipo : TAlephTipo;
      FRemMargins : TREmMargins;
      FRemFontSize : TREmFontSize;
      FGlobalFontSizeManager : TGlobalFontSizeManager;
      FOldOnResize : TNotifyEvent;
      FPRadius : double;
      FSquareMode : Boolean;
      function GetTipo : TAlephTipo;
      procedure SetTipo( const Value : TAlephTipo );

      function GetRemMargins : TREmMargins;
      procedure SetRemMargins( const Value : TREmMargins );
      function GetTextRem : TREmFontSize;
      procedure SetTextRem( const Value : TREmFontSize );
      procedure SetGlobalFontSizeManager( const Value
        : TGlobalFontSizeManager );
      procedure ResizeCorner( Sender : TObject );
      procedure SetPRadius( const Value : double );
      procedure ResizeSquareMode( Sender : TObject );
      procedure SetSquareMode( const Value : Boolean );
      procedure DoFormResize( Sender : TObject );
    protected
      procedure ResizeComponent( Sender : TObject );
      procedure CalculatePercentage( Sender : TObject );
      procedure ResizeFont( Sender : TObject );
      procedure Resize; override;
      procedure Notification(
        AComponent : TComponent;
        Operation  : TOperation ); override;
    public
      constructor Create( AOwner : TComponent ); override;
      destructor Destroy; override;
      procedure UpdateFontSize( NewBaseSize : Integer );
    published
      property AlephPercentage : TAlephTipo
        read GetTipo
        write SetTipo;
      property MarginsRem : TREmMargins
        read GetRemMargins
        write SetRemMargins;
      property TextRem : TREmFontSize
        read GetTextRem
        write SetTextRem;
      property GlobalFontSizeManager : TGlobalFontSizeManager
        read FGlobalFontSizeManager
        write SetGlobalFontSizeManager;
      property PRadius : double
        read FPRadius
        write SetPRadius;
      Property SquareMode : Boolean
        Read FSquareMode
        write SetSquareMode;
  end;

procedure Register;

implementation

uses
  Math;

procedure Register;
  begin
    RegisterComponents( 'Aleph', [ TAlephCornerButton ] );
  end;

{ TAlephCornerButton }

procedure TAlephCornerButton.ResizeComponent( Sender : TObject );
  begin
    if Assigned( FAlephTipo )
    then
      FAlephTipo.ResizeComponent( Sender );
  end;

procedure TAlephCornerButton.ResizeCorner( Sender : TObject );
  var
    PercentageHeight : double;
  begin

    PercentageHeight := RoundTo( Width * FPRadius / 100, - 1 );
    if ( csDesigning in ComponentState ) or not ( csLoading in ComponentState )
    then
    begin
      BeginUpdate;
      try
        Self.XRadius := Round( PercentageHeight );
        Self.YRadius := Round( PercentageHeight );
      finally
        EndUpdate;
      end;
    end;
  end;

procedure TAlephCornerButton.ResizeSquareMode( Sender : TObject );
  begin
    if not FSquareMode
    then
      Exit;

    if ( csDesigning in ComponentState ) or not ( csLoading in ComponentState )
    then
    begin
      BeginUpdate;
      try
        if ( Align = TAlignLayout.Left ) or ( Align = TAlignLayout.Right )
        then
          Self.Width := Self.Height;
        if ( Align = TAlignLayout.Top ) or ( Align = TAlignLayout.Bottom )
        then
          Self.Height := Self.Width;
      finally
        EndUpdate;
      end;
    end;
  end;

procedure TAlephCornerButton.CalculatePercentage( Sender : TObject );
  begin
    if Assigned( FGlobalFontSizeManager )
    then
      FGlobalFontSizeManager.CalculatePercentage( Sender );
  end;

constructor TAlephCornerButton.Create( AOwner : TComponent );
  begin
    inherited Create( AOwner );
    PRadius := 0;
    FAlephTipo := TAlephTipo.Create( Self );
    FRemMargins := TREmMargins.Create( Self );
    FRemFontSize := TREmFontSize.Create( Self );
    GlobalResizeManager.RegisterComponent( Self );
    GlobalResizeManager.RegisterFontSizeComponent( Self );
    // RegisterAlephLayout(Self);
    if AOwner is TForm
    then
    begin
      // Guarda o handler original do form
      FOldOnResize := TForm( AOwner ).OnResize;
      // Define o novo handler
      TForm( AOwner ).OnResize := DoFormResize;
    end;
  end;

destructor TAlephCornerButton.Destroy;
  begin
    if Assigned( FGlobalFontSizeManager )
    then
      FGlobalFontSizeManager.UnregisterComponent( Self );
    GlobalResizeManager.UnregisterComponent( Self );
    GlobalResizeManager.UnregisterFontSizeComponent( Self );
    FreeAndNil( FRemMargins );
    FreeAndNil( FRemFontSize );
    FreeAndNil( FAlephTipo );
    inherited;
  end;

procedure TAlephCornerButton.DoFormResize( Sender : TObject );
  begin
    if Assigned( FOldOnResize )
    then
      FOldOnResize( Sender );
    GlobalResizeManager.FormResizeHandler( Sender );
  end;

function TAlephCornerButton.GetRemMargins : TREmMargins;
  begin
    Result := FRemMargins;
  end;

function TAlephCornerButton.GetTextRem : TREmFontSize;
  begin
    Result := FRemFontSize;
  end;

function TAlephCornerButton.GetTipo : TAlephTipo;
  begin
    Result := FAlephTipo;
  end;

procedure TAlephCornerButton.Resize;
  begin
    inherited;
    if Assigned( FAlephTipo )
    then
      FAlephTipo.Resize;
  end;

procedure TAlephCornerButton.ResizeFont( Sender : TObject );
  begin
    if Assigned( FRemFontSize )
    then
      TextSettings.Font.Size := FRemFontSize.ToPixels;
  end;

procedure TAlephCornerButton.SetRemMargins( const Value : TREmMargins );
  begin
    if Assigned( FRemMargins )
    then
      FRemMargins.Assign( Value );
  end;

procedure TAlephCornerButton.SetSquareMode( const Value : Boolean );
  begin
    if FSquareMode <> Value
    then
    begin
      FSquareMode := Value;
      if FSquareMode
      then
        ResizeSquareMode( nil );
    end;
  end;

procedure TAlephCornerButton.SetTextRem( const Value : TREmFontSize );
  begin
    if Assigned( FRemFontSize )
    then
      FRemFontSize.Assign( Value );
  end;

procedure TAlephCornerButton.SetTipo( const Value : TAlephTipo );
  begin
    if Assigned( FAlephTipo )
    then
      FAlephTipo.Assign( Value );
    ResizeCorner( nil );
  end;

procedure TAlephCornerButton.SetGlobalFontSizeManager
  ( const Value : TGlobalFontSizeManager );
  begin
    if FGlobalFontSizeManager <> Value
    then
    begin
      if Assigned( FGlobalFontSizeManager )
      then
      begin
        FGlobalFontSizeManager.UnregisterComponent( Self );
        RemoveFreeNotification( FGlobalFontSizeManager );
      end;
      FGlobalFontSizeManager := Value;
      if Assigned( FGlobalFontSizeManager )
      then
      begin
        FGlobalFontSizeManager.RegisterComponent( Self );
        FGlobalFontSizeManager.FreeNotification( Self );
        UpdateFontSize( FGlobalFontSizeManager.BaseSize );
      end;
    end;
  end;

procedure TAlephCornerButton.SetPRadius( const Value : double );
  begin
    if FPRadius <> Value
    then
      FPRadius := Value;
    ResizeCorner( nil );
  end;

procedure TAlephCornerButton.UpdateFontSize( NewBaseSize : Integer );
  begin
    if Assigned( FRemFontSize )
    then
    begin
      FRemFontSize.FontSize := NewBaseSize;
      ResizeFont( Self );
    end;
    if Assigned( FRemMargins )
    then
    begin
      FRemMargins.AMarginBase.FontBase := NewBaseSize;
      ResizeFont( Self );
    end;
  end;

procedure TAlephCornerButton.Notification(
  AComponent : TComponent;
  Operation  : TOperation );
  begin
    inherited;
    if ( Operation = opRemove ) and ( AComponent = FGlobalFontSizeManager )
    then
    begin
      FGlobalFontSizeManager := nil;
    end;
  end;

end.

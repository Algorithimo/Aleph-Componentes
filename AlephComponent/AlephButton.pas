unit AlephButton;

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
  TAlephButton = class( TButton, IRemFontSize, IGlobalFontSizeAware,
    IFontSizeAdjustable, IResizable )
    private
      FAlephTipo : TAlephTipo;
      FRemMargins : TREmMargins;
      FRemFontSize : TREmFontSize;
      FGlobalFontSizeManager : TGlobalFontSizeManager;
      FOldOnResize : TNotifyEvent;
      function GetTipo : TAlephTipo;
      procedure SetTipo( const Value : TAlephTipo );

      function GetRemMargins : TREmMargins;
      procedure SetRemMargins( const Value : TREmMargins );
      function GetTextRem : TREmFontSize;
      procedure SetTextRem( const Value : TREmFontSize );
      procedure SetGlobalFontSizeManager( const Value
        : TGlobalFontSizeManager );
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
  end;

procedure Register;

implementation

procedure Register;
  begin
    RegisterComponents( 'Aleph', [ TAlephButton ] );
  end;

{ TAlephButton }

procedure TAlephButton.ResizeComponent( Sender : TObject );
  begin
    if Assigned( FAlephTipo )
    then
      FAlephTipo.ResizeComponent( Sender );
  end;

procedure TAlephButton.CalculatePercentage( Sender : TObject );
  begin
    if Assigned( FGlobalFontSizeManager )
    then
      FGlobalFontSizeManager.CalculatePercentage( Sender );
  end;

constructor TAlephButton.Create( AOwner : TComponent );
  begin
    inherited Create( AOwner );
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

destructor TAlephButton.Destroy;
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

procedure TAlephButton.DoFormResize( Sender : TObject );
  begin
    if Assigned( FOldOnResize )
    then
      FOldOnResize( Sender );
    GlobalResizeManager.FormResizeHandler( Sender );
  end;

function TAlephButton.GetRemMargins : TREmMargins;
  begin
    Result := FRemMargins;
  end;

function TAlephButton.GetTextRem : TREmFontSize;
  begin
    Result := FRemFontSize;
  end;

function TAlephButton.GetTipo : TAlephTipo;
  begin
    Result := FAlephTipo;
  end;

procedure TAlephButton.Resize;
  begin
    inherited;
    if Assigned( FAlephTipo )
    then
      FAlephTipo.Resize;
  end;

procedure TAlephButton.ResizeFont( Sender : TObject );
  begin
    if Assigned( FRemFontSize )
    then
      TextSettings.Font.Size := FRemFontSize.ToPixels;
  end;

procedure TAlephButton.SetRemMargins( const Value : TREmMargins );
  begin
    if Assigned( FRemMargins )
    then
      FRemMargins.Assign( Value );
  end;

procedure TAlephButton.SetTextRem( const Value : TREmFontSize );
  begin
    if Assigned( FRemFontSize )
    then
      FRemFontSize.Assign( Value );
  end;

procedure TAlephButton.SetTipo( const Value : TAlephTipo );
  begin
    if Assigned( FAlephTipo )
    then
      FAlephTipo.Assign( Value );
    ResizeComponent( nil );
  end;

procedure TAlephButton.SetGlobalFontSizeManager( const Value
  : TGlobalFontSizeManager );
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

procedure TAlephButton.UpdateFontSize( NewBaseSize : Integer );
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

procedure TAlephButton.Notification(
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

unit AlephListBox;

interface

{$SCOPEDENUMS ON}

uses
  System.Classes, System.Types, System.UITypes, System.SysUtils, System.Rtti, System.Generics.Collections,
  System.ImageList, FMX.Types, FMX.ActnList, FMX.StdCtrls, FMX.Layouts, FMX.Objects, FMX.Pickers, FMX.Controls,
  FMX.Graphics, FMX.ListBox.Selection, FMX.ImgList,  AlephRem, AlephTipos, AlephREmFont, GlobalFontSizeManager, ResizeManager;

type
  TAlephCustomListBox = class;
  TAlephCustomComboBox = class;
  TAlephListBoxItemData = class;
  TAlephListBoxItemStyleDefaults = class;
  TAlephListBoxSelector = class;

{ TAlephListBoxItem }

  TAlephListBoxItem = class(TTextControl, IGlyph, IRemFontSize, IGlobalFontSizeAware, IFontSizeAdjustable, IResizable)
  private type
    TBackgroundShape = (SeparatorBottom, Sharp, RoundTop, RoundBottom, RoundAll);
  private
    FAlephTipo: TAlephTipo;
    FRemMargins: TREmMargins;
    FRemFontSize: TREmFontSize;
    FGlobalFontSizeManager: TGlobalFontSizeManager;
    FAutoHeight: Boolean;
    FInAutoHeight: Boolean;

    FIsChecked: Boolean;
    FCheck: TCheckBox;
    FIsSelected: Boolean;
    FIsSelectable: Boolean;
    FData: TObject;
    FItemData: TAlephListBoxItemData;
    FBitmap: TBitmap;
    FIcon: TImage;
    FOldIconVisible: Boolean;
    FOldCheckAlign: TAlignLayout;
    FGlyph: TGlyph;
    FBackgroundShape: TBackgroundShape;
    FImageLink: TGlyphImageLink;
    {Aleph lista box}
    function GetTipo: TAlephTipo;
    procedure SetTipo(const Value: TAlephTipo);
    function GetRemMargins: TREmMargins;
    procedure SetRemMargins(const Value: TREmMargins);
    function GetTextRem: TREmFontSize;
    procedure SetTextRem(const Value: TREmFontSize);
    procedure SetGlobalFontSizeManager(const Value: TGlobalFontSizeManager);
    procedure AdjustHeight(Sender: TObject);
    procedure SetAutoHeight(const Value: Boolean);
    procedure SetPadding(const Value: TBounds);

    procedure SetIsChecked(const Value: Boolean);
    procedure DoCheckClick(Sender: TObject);
    procedure InitCheckBox(Visible: Boolean);
    procedure UpdateCheck;
    procedure SetIsSelected(const Value: Boolean);
    procedure SetSelectable(const Value: Boolean);
    function GetImages: TCustomImageList;
    procedure SetImages(const Value: TCustomImageList);
    { IGlyph }
    function GetImageIndex: TImageIndex;
    procedure SetImageIndex(const Value: TImageIndex);
    function GetImageList: TBaseImageList; inline;
    procedure SetImageList(const Value: TBaseImageList);
    function IGlyph.GetImages = GetImageList;
    procedure IGlyph.SetImages = SetImageList;
    procedure SetItemData(const Value: TAlephListBoxItemData);
  protected

    procedure ResizeComponent(Sender: TObject);
    procedure CalculatePercentage(Sender: TObject);
    procedure ResizeFont(Sender: TObject);
    procedure Resize; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Loaded; override;

    procedure ChangeOrder; override;
    function ListBox: TAlephCustomListBox;
    function ComboBox: TAlephCustomComboBox;
    function GetDefaultSize: TSizeF; override;
    procedure ApplyStyle; override;
    procedure FreeStyle; override;
    function EnterChildren(AObject: IControl): Boolean; override;
    procedure DragOver(const Data: TDragObject; const Point: TPointF; var Operation: TDragOperation); override;
    procedure DragEnd; override;
    procedure Paint; override;
    function GetHeight: Single; override;
    function GetWidth: Single;  override;
    procedure SetHeight(const Value: Single); override;
    function DoSetSize(const ASize: TControlSize; const NewPlatformDefault: Boolean; ANewWidth, ANewHeight: Single;
      var ALastWidth, ALastHeight: Single): Boolean; override;
    procedure SelectBackground(const Shape: TBackgroundShape);
    procedure OnBitmapChanged(Sender: TObject);
    function StyledSettingsStored: Boolean; override;
    property Align;
    property RotationAngle;
    property RotationCenter;
    function GetTextSettingsClass: TTextSettingsInfo.TCustomTextSettingsClass; override;
    function GetDefaultStyleLookupName: string; override;
    function DoGetDefaultStyleLookupName(const Defaults: TAlephListBoxItemStyleDefaults): string; virtual;
    /// <summary> Should be called when you change an instance or reference to instance of <b>TBaseImageList</b> or the
    /// <b>ImageIndex</b> property
    /// <para>See also <b>FMX.ActnList.IGlyph</b></para></summary>
    procedure ImagesChanged; virtual;
    /// <summary> Determines whether the <b>ImageIndex</b> property needs to be stored in the fmx-file</summary>
    /// <returns> <c>True</c> if the <b>ImageIndex</b> property needs to be stored in the fmx-file</returns>
    function ImageIndexStored: Boolean; virtual;
    procedure SetVisible(const Value: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Data: TObject read FData write FData;
    function GetParentComponent: TComponent; override;
    procedure ApplyTriggerEffect(const AInstance: TFmxObject; const ATrigger: string); override;
    /// <summary>Used internally to modify Selected state of an item</summary>
    procedure SetIsSelectedInternal(const Value: Boolean; const UserChange: Boolean);
    property Font;
    property TextAlign;
    property WordWrap;
    ///<summary> The list of images. Can be <c>nil</c>. <para>See also <b>FMX.ActnList.IGlyph</b></para></summary>
    property Images: TCustomImageList read GetImages;

    procedure UpdateFontSize(NewBaseSize: Integer);
  published

    property AlephPercentage: TAlephTipo read GetTipo write SetTipo;
    property AutoHeight: Boolean read FAutoHeight write SetAutoHeight;
    property MarginsRem: TREmMargins read GetRemMargins write SetRemMargins;
    property TextRem: TREmFontSize read GetTextRem write SetTextRem;
    property GlobalFontSizeManager: TGlobalFontSizeManager read FGlobalFontSizeManager write SetGlobalFontSizeManager;

    property AutoTranslate default True;
    property ClipChildren;
    property ClipParent;
    property Cursor;
    property DragMode;
    property EnableDragHighlight;
    property Selectable: Boolean read FIsSelectable write SetSelectable default True;
    property TextSettings;
    property StyledSettings;
    property Locked;
    property Height;
    property HelpContext;
    property HelpKeyword;
    property HelpType;
    property HitTest default False;
    property IsChecked: Boolean read FIsChecked write SetIsChecked default False;
    property IsSelected: Boolean read FIsSelected write SetIsSelected default False;
    property ItemData: TAlephListBoxItemData read FItemData write SetItemData;
    ///<summary> Zero based index of an image. The default is <c>-1</c>.
    ///<para> See also <b>FMX.ActnList.IGlyph</b></para></summary>
    ///<remarks> If non-existing index is specified, an image is not drawn and no exception is raised</remarks>
    property ImageIndex: TImageIndex read GetImageIndex write SetImageIndex stored ImageIndexStored;
    property Padding;
    property Opacity;
    property Margins;
    property PopupMenu;
    property Position;
    property Scale;
    property Size;
    property StyleLookup;
    property TabOrder;
    property TabStop;
    property Text;
    property Width;
    property Visible;
    property ParentShowHint;
    {events}
    property OnApplyStyleLookup;
    {Drag and Drop events}
    property OnDragEnter;
    property OnDragLeave;
    property OnDragOver;
    property OnDragDrop;
    property OnDragEnd;
    {Mouse events}
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnClick;
    property OnPainting;
    property OnPaint;
    property OnResize;
    property OnResized;
  end;

  { TAlephListBoxItemData }

  TAlephListBoxItemData = class(TPersistent)
  public type
    TAccessory = (aNone=0, aMore=1, aDetail=2, aCheckmark=3);
  strict private
  const
    StyleSelectorMore =      'accessorymore.Visible';
    StyleSelectorDetail =    'accessorydetail.Visible';
    StyleSelectorCheckmark = 'accessorycheckmark.Visible';
  private
    [Weak] FItem: TAlephListBoxItem;
    FAccessory: TAccessory;
    procedure SetText(const Text: String);
    function GetText: String;
    procedure SetDetail(const Detail: String);
    function GetDetail: String;
    procedure SetBitmap(const Bitmap: TBitmap);
    function GetBitmap: TBitmap;
    function GetAccessory: TAccessory;
    procedure SetAccessory(const Accessory: TAccessory);
  public
    constructor Create(const HostItem: TAlephListBoxItem);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure Disappear;
  published
    property Text: string read GetText write SetText stored false;
    property Detail: string read GetDetail write SetDetail;
    property Accessory: TAccessory read GetAccessory write SetAccessory default TAccessory.aNone;
    property Bitmap: TBitmap read GetBitmap write SetBitmap;
  end;

{ TAlephCustomListBox }

  TListStyle = (Vertical, Horizontal);

  TListGroupingKind = (Plain, Grouped);

  TOnCompareListBoxItemEvent = procedure(Item1, Item2: TAlephListBoxItem; var Result: Integer) of object;
  TOnListBoxDragChange = procedure(SourceItem, DestItem: TAlephListBoxItem; var Allow: Boolean) of object;

  TAlephListBoxItemStyleDefaults = class(TPersistent)
  strict private
    FItemStyle : string;
    FHeaderStyle : string;
    FFooterStyle : string;
    [Weak] FListBox: TAlephCustomListBox;
  private
    function GetItemStyle: string;
    procedure SetItemStyle(const Value: string);
    function GetGroupHeaderStyle: string;
    procedure SetGroupHeaderStyle(const Value: string);
    function GetGroupFooterStyle: string;
    procedure SetGroupFooterStyle(const Value: string);
    procedure RefreshListBox;
    constructor Create(const ListBox: TAlephCustomListBox);
  public
    procedure Assign(Source: TPersistent); override;
    property ListBox: TAlephCustomListBox read FListBox;
  published
    property ItemStyle: string read GetItemStyle write SetItemStyle nodefault;
    property GroupHeaderStyle: string read GetGroupHeaderStyle write SetGroupHeaderStyle nodefault;
    property GroupFooterStyle: string read GetGroupFooterStyle write SetGroupFooterStyle nodefault;
  end;

  TMultiSelectStyle = (None, Default, Extended);

  TAlephCustomListBox = class(TScrollBox, IItemsContainer, IInflatableContent<TAlephListBoxItem>, ISearchResponder, IGlyph)
  private const
    UnfocusedSelectionOpacity = 0.7;
    ExtendedSelectionOpacity = 0.7;
  public type
    TStringsChangeOp = (Added, Deleted, Clear);
    TStringsChangedEvent = procedure(const S: String; const StringsEvent: TAlephCustomListBox.TStringsChangeOp) of object;
    TItemClickEvent = procedure(const Sender: TAlephCustomListBox; const Item: TAlephListBoxItem) of object;
  private type
    TListBoxStrings = class(TStrings)
    private
      [Weak] FListBox: TAlephCustomListBox;
      procedure ReadData(Reader: TReader);
      procedure WriteData(Writer: TWriter);
    protected
      procedure Put(Index: Integer; const S: string); override;
      function Get(Index: Integer): string; override;
      function GetCount: Integer; override;
      function GetObject(Index: Integer): TObject; override;
      procedure PutObject(Index: Integer; AObject: TObject); override;
      procedure SetUpdateState(Updating: Boolean); override;
      procedure DefineProperties(Filer: TFiler); override;
    public
      function Add(const S: string): Integer; override;
      procedure Clear; override;
      procedure Delete(Index: Integer); override;
      procedure Exchange(Index1, Index2: Integer); override;
      function IndexOf(const S: string): Integer; override;
      procedure Insert(Index: Integer; const S: string); override;
    end;

    TGroup = record
      First:  Integer;
      Length: Integer;
      constructor Create(const AFirst, ALength: Integer);
    end;

    TGroups = class(TList<TGroup>)
    public
      function FindGroup(const Index: Integer): Integer;
    end;

    /// <summary>
    ///   Visual display of the selection based on style controls. It makes copies of specified style object,
    ///   which represent selection for focused and unfocused states. And align styled selection in specified positions.
    /// </summary>
    TStyledSelection = class
    private
      FListBox: TAlephCustomListBox;
      FUnfocusedObjectsPool: TControlList;
      FFocusedObjectsPool: TControlList;
      FCurrentObjects: TControlList; // Reference
      FIsFocused: Boolean;
      { Style objects }
      FUnfocusedSelection: TControl;
      FFocusedSelection: TControl;
      procedure SetIsFocused(const Value: Boolean);
    private
      function CreateSelectionControl(const AIsFocused: Boolean): TControl;
    public
      constructor Create(const AListBox: TAlephCustomListBox);
      destructor Destroy; override;
      /// <summary>Aligns the style selection controls according to the passed areas.</summary>
      procedure Realign(const ASelectionRects: TList<TRectF>);
      /// <summary>Clear all style selection controls for focused and unfocused states.</summary>
      procedure ClearPools;
    public
      /// <summary>The reference on style object that is used to create controls for unfocused selection.</summary>
      property UnfocusedSelection: TControl read FUnfocusedSelection write FUnfocusedSelection;
      /// <summary>The reference on style object that is used to create controls for focused selection.</summary>
      property FocusedSelection: TControl read FFocusedSelection write FFocusedSelection;
      property IsFocused: Boolean read FIsFocused write SetIsFocused;
    end;

  strict private
    FBeingPainted: Boolean;
    FRealignRequested: Boolean;
    FUpdateGroupsRequested: Boolean;
    FToInflate: TList<TAlephListBoxItem>;
    FInflater: TContentInflater<TAlephListBoxItem>;
    FStringsChanged: TStringsChangedEvent;
    FOnItemClick: TItemClickEvent;
    [Weak] FItemDown: TAlephListBoxItem;
    FOnChange: TNotifyEvent;
    FShowCheckboxes: Boolean;
    FOnChangeCheck: TNotifyEvent;
    FSorted: Boolean;
    FOnCompare: TOnCompareListBoxItemEvent;
    FAlternatingRowBackground: Boolean;
    FAllowDrag: Boolean;
    FOnDragChange: TOnListBoxDragChange;
    FNoItemsContent: TContent;
    FHeaderCompartment: TContent;
    FFooterCompartment: TContent;
    FContentOverlay: TContent;
    FDefaultStyles: TAlephListBoxItemStyleDefaults;
    FGroups: TGroups;
    FGroupingKind: TListGroupingKind;
    FClickEnable: Boolean;
    FSelection: TControl;
    FExtendedSelection: TControl;
    FFocusedSelection: TControl;
    FSelector: TAlephListBoxSelector;
    FImageLink: TGlyphImageLink;
    [Weak] FImages: TCustomImageList;
    function GetInflatableItems: TList<TAlephListBoxItem>;
    procedure CalcSelectionRects(const SelRects: TList<TRectF>);
    procedure PerformInternalDrag;
    function GetImages: TCustomImageList;
    procedure SetImages(const Value: TCustomImageList);
    { IGlyph }
    function GetImageIndex: TImageIndex;
    procedure SetImageIndex(const Value: TImageIndex);
    function GetImageList: TBaseImageList; inline;
    procedure SetImageList(const Value: TBaseImageList);
    function IGlyph.GetImages = GetImageList;
    procedure IGlyph.SetImages = SetImageList;
  private
    FDragItem: TAlephListBoxItem;
    FFirstVisibleItem, FLastVisibleItem: Integer;
    FItems: TStrings;
    FColumns: Integer;
    FItemWidth: Single;
    FItemHeight: Single;
    FListStyle: TListStyle;
    FOddFill: TBrush;
    FContentInsets: TRectF;
    FSelectionObjects: TStyledSelection;
    procedure IgnoreString(Reader: TReader);
    procedure ReadMultiSelect(Reader: TReader);
    function GetCount: Integer;
    function GetSelected: TAlephListBoxItem;
    procedure SetColumns(const Value: Integer);
    procedure SetItemHeight(const Value: Single);
    procedure SetItemWidth(const Value: Single);
    procedure SetListStyle(const Value: TListStyle);
    procedure SetShowCheckboxes(const Value: Boolean);
    function GetListItem(Index: Integer): TAlephListBoxItem;
    procedure SetSorted(const Value: Boolean);
    procedure SetAlternatingRowBackground(const Value: Boolean);
    procedure SetItems(const Value: TStrings);
    procedure SetMultiSelectStyle(const Value: TMultiSelectStyle);
    function GetMultiSelectStyle: TMultiSelectStyle;
    procedure SetAllowDrag(const Value: Boolean);
    function GetMultiSelect: Boolean;
    procedure SetMultiSelect(const Value: Boolean);
    { IItemsContainer }
    function IItemsContainer.GetItemsCount = GetCount;
    function GetItem(const AIndex: Integer): TFmxObject;
    function GetFilterPredicate: TPredicate<string>;
    procedure SetFilterPredicate(const Predicate: TPredicate<string>);
    procedure SetItemDown(const Value: TAlephListBoxItem);
    function ItemsStored: Boolean;
  protected
    procedure DefineProperties(Filer: TFiler); override;
    function GetData: TValue; override;
    procedure SetData(const Value: TValue); override;
    function CanObserve(const ID: Integer): Boolean; override;
    procedure DoChangeCheck(const Item: TAlephListBoxItem); dynamic;
    function CompareItems(const Item1, Item2: TAlephListBoxItem): Integer; virtual;
    procedure DoChange; dynamic;
    procedure SortItems; virtual;
    /// <summary>Set active selection to item with given index.</summary>
    procedure SetItemIndex(const Value: Integer); virtual;
    /// <summary>Return index of currently selected Item</summary>
    function GetItemIndex: Integer; virtual;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Single); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Single); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Single); override;
    procedure MouseClick(Button: TMouseButton; Shift: TShiftState; X, Y: Single); override;
    procedure KeyDown(var Key: Word; var KeyChar: System.WideChar; Shift: TShiftState); override;
    procedure DragOver(const Data: TDragObject; const Point: TPointF; var Operation: TDragOperation); override;
    procedure DragDrop(const Data: TDragObject; const Point: TPointF); override;
    function GetDefaultSize: TSizeF; override;
    procedure ApplyStyle; override;
    procedure FreeStyle; override;
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure DoAddObject(const AObject: TFmxObject); override;
    procedure DoInsertObject(Index: Integer; const AObject: TFmxObject); override;
    procedure DoRemoveObject(const AObject: TFmxObject); override;
    function GetBorderHeight: Single;
    function CreateScrollContent: TScrollContent; override;
    function DoCalcContentBounds: TRectF; override;
    procedure DoEndUpdate; override;
    /// <summary> Should be called when you change an instance or reference to instance of <b>TBaseImageList</b> or the
    /// <b>ImageIndex</b> property
    /// <para>See also <b>FMX.ActnList.IGlyph</b></para></summary>
    procedure ImagesChanged; virtual;
    procedure Loaded; override;
    procedure DoContentPaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
    procedure Painting; override;
    procedure AfterPaint; override;
    procedure ViewportPositionChange(const OldViewportPosition, NewViewportPosition: TPointF;
      const ContentSizeChanged: Boolean); override;
    procedure DoUpdateAniCalculations(const AAniCalculations: TScrollCalculations); override;
    function IsAddToContent(const AObject: TFmxObject): Boolean; override;
    procedure ContentAddObject(const AObject: TFmxObject); override;
    procedure ContentInsertObject(Index: Integer; const AObject: TFmxObject); override;
    procedure ContentBeforeRemoveObject(AObject: TFmxObject); override;
    procedure ContentRemoveObject(const AObject: TFmxObject); override;
    function IsOpaque: Boolean; override;
    procedure UpdateVisibleItems;
    procedure UpdateSelection;
    procedure UpdateGroups;
    procedure RealUpdateGroups; virtual;
    procedure UpdateStickyHeader;
    procedure SetGroupingKind(const Value: TListGroupingKind);
    procedure DoRealign; override;
    procedure DispatchStringsChangeEvent(const S: String; const Op: TStringsChangeOp);
    procedure Show; override;
    property CanFocus default True;
    property CanParentFocus;
    property Selection: TControl read FSelection;
    procedure Notification(AComponent: TComponent;  Operation: TOperation); override;
    /// <summary>Property getter FirstSelectedItem</summary>
    function GetFirstSelect: TAlephListBoxItem;
    property AllowDrag: Boolean read FAllowDrag write SetAllowDrag default False;
    property AlternatingRowBackground: Boolean read FAlternatingRowBackground write SetAlternatingRowBackground default False;
    property Columns: Integer read FColumns write SetColumns default 1;
    property ItemWidth: Single read FItemWidth write SetItemWidth;
    property ItemHeight: Single read FItemHeight write SetItemHeight;
    property ListStyle: TListStyle read FListStyle write SetListStyle
      default TListStyle.Vertical;
    property MultiSelectStyle: TMultiSelectStyle read GetMultiSelectStyle write SetMultiSelectStyle default TMultiSelectStyle.None;
    property Sorted: Boolean read FSorted write SetSorted default False;
    property ShowCheckboxes: Boolean read FShowCheckboxes write SetShowCheckboxes default False;
    /// <summary>First item in the selection or nil if nothing is selected</summary>
    property FirstSelectedItem: TAlephListBoxItem read GetFirstSelect;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnChangeCheck: TNotifyEvent read FOnChangeCheck write FOnChangeCheck;
    property OnCompare: TOnCompareListBoxItemEvent read FOnCompare write FOnCompare;
    property OnDragChange: TOnListBoxDragChange read FOnDragChange write FOnDragChange;
    property OnStringsChanged: TStringsChangedEvent read FStringsChanged write FStringsChanged;
    /// <summary>Current selection controller. Selector is chosen by MultiSelectStyle property.</summary>
    property SelectionController: TAlephListBoxSelector read FSelector;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure Clear; virtual;
    function DragChange(const SourceItem, DestItem: TAlephListBoxItem): Boolean; dynamic;
    procedure SelectAll;
    procedure ClearSelection;
    procedure SelectRange(const Item1, Item2: TAlephListBoxItem);
    ///<summary>Scroll the view to make Item visible</summary>
    procedure ScrollToItem(const Item: TAlephListBoxItem);
    function FirstSelectedItemFrom(const Item: TAlephListBoxItem): TAlephListBoxItem;
    function LastSelectedItemFrom(const Item: TAlephListBoxItem): TAlephListBoxItem;
    function ItemByPoint(const X, Y: Single): TAlephListBoxItem;
    function ItemByIndex(const Idx: Integer): TAlephListBoxItem;
    procedure ItemsExchange(Item1, Item2: TAlephListBoxItem);
    procedure Sort(Compare: TFmxObjectSortCompare); override;
    procedure NotifyInflated;
    property BorderHeight: Single read GetBorderHeight;
    property Count: Integer read GetCount;
    property Selected: TAlephListBoxItem read GetSelected;
    property Items: TStrings read FItems write SetItems stored ItemsStored;
    property ItemDown: TAlephListBoxItem read FItemDown write SetItemDown;
    ///<summary> The list of images. Can be <c>nil</c>. <para>See also <b>FMX.ActnList.IGlyph</b></para></summary>
    property Images: TCustomImageList read GetImages write SetImages;
    property ListItems[Index: Integer]: TAlephListBoxItem read GetListItem;
    property ItemIndex: Integer read GetItemIndex write SetItemIndex default -1;
    property GroupingKind: TListGroupingKind read FGroupingKind write SetGroupingKind default TListGroupingKind.Plain;
    property FilterPredicate: TPredicate<string> read GetFilterPredicate write SetFilterPredicate stored False;
    property MultiSelect: Boolean read GetMultiSelect write SetMultiSelect; // deprecated - use MultiSelectStyle
    property DefaultItemStyles: TAlephListBoxItemStyleDefaults read FDefaultStyles write FDefaultStyles;
    property OnItemClick: TItemClickEvent read FOnItemClick write FOnItemClick;
  end;

{ TAlephListBox }

  TAlephListBox = class(TAlephCustomListBox)
  published
    property Align;
    property AllowDrag;
    property AlternatingRowBackground;
    property Anchors;
    property CanFocus;
    property CanParentFocus;
    property ClipChildren;
    property ClipParent;
    property Columns;
    property Cursor;
    property DisableFocusEffect;
    property DragMode;
    property EnableDragHighlight;
    property Enabled;
    property Locked;
    property Height;
    property HitTest;
    property Hint;
    property ItemIndex;
    property ItemHeight;
    property Items;
    property ItemWidth;
    property Images;
    property DefaultItemStyles;
    property GroupingKind;
    property ListStyle;
    property Padding;
    property MultiSelectStyle;
    property Opacity;
    property Margins;
    property PopupMenu;
    property Position;
    property RotationAngle;
    property RotationCenter;
    property Scale;
    property Size;
    property ShowCheckboxes;
    property Sorted;
    property StyleLookup;
    property TabOrder;
    property TabStop;
    property Visible;
    property Width;
    property ParentShowHint;
    property ShowHint;

    {events}
    property OnApplyStyleLookup;
    property OnChange;
    property OnChangeCheck;
    property OnCompare;
    {Drag and Drop events}
    property OnDragChange;
    property OnDragEnter;
    property OnDragLeave;
    property OnDragOver;
    property OnDragDrop;
    property OnDragEnd;
    {Keyboard events}
    property OnKeyDown;
    property OnKeyUp;
    {Mouse events}
    property OnCanFocus;
    property OnItemClick;

    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseEnter;
    property OnMouseLeave;

    property OnPainting;
    property OnPaint;
    property OnResize;
    property OnResized;
  end;

  { InicioAlephListBoxHeader }
  TAlephListBoxHeader = class(TToolBar, IListBoxHeaderTrait)
  protected
    function GetDefaultStyleLookupName: string; override;
  public
  end;

  TListBoxSeparatorItem = class(TAlephListBoxItem)
  public
    /// <summary>Gets default style for Group Header, which is used if TAlephListBox.DefaultItemStyles.GroupHeaderStyle
    ///  is empty</summary>
    function GetDefaultGroupHeaderStyle: string;
  end;

  TAlephListBoxGroupHeader = class(TListBoxSeparatorItem)
  strict private
    [Weak] FCloneRef: TAlephListBoxGroupHeader;
  protected
    function DoGetDefaultStyleLookupName(const Defaults: TAlephListBoxItemStyleDefaults): string; override;
    procedure DoTextChanged; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    /// <summary>Reference to sticky TAlephListBoxGroupHeader clone in Plain grouping mode</summary>
    property CloneRef: TAlephListBoxGroupHeader read FCloneRef write FCloneRef;
  end;

  TListBoxGroupFooter = class(TListBoxSeparatorItem)
  protected
    function DoGetDefaultStyleLookupName(const Defaults: TAlephListBoxItemStyleDefaults): string; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  /// <summary>Base class for selection controllers. Selection controllers handle various types of selection.
  ///  Normally TAlephListBox.MultiSelectStyle property selects one of the three predefined ones:
  ///  TSingleSelectionController, TMutiselectSelectionController, TExtendedSelectionController
  ///  </summary>
  TAlephListBoxSelector = class abstract
  public type
    /// <summary>Keyboard selection action: Move (arrow keys) or Toggle (space)</summary>
    TKeyAction = (Move, Toggle);
  strict protected
    /// <summary>Reference to TAlephListBox that hosts this controller</summary>
    [Weak] FListBox: TAlephCustomListBox;
    /// <summary>Index of currently selected item, -1 if none</summary>
    FCurrent: Integer;
    /// <summary>Index of first selected item, -1 if none</summary>
    FFirst: Integer;
    /// <summary>Timer used for DelayedMouseDown</summary>
    FSelectionTimer: TTimer;
    /// <summary>Item that's going to be acted upon if DelayedMouseDown is employed</summary>
    FSelectionTimerTarget: TAlephListBoxItem;
    /// <summary>Flag used to prevent sending change notification</summary>
    FInternalChange: Boolean;
    /// <summary>True during mouse selection</summary>
    FMouseSelectActive: Boolean;
  protected
    /// <summary>Create a new instance of TSelectionController</summary>
    constructor Create(const ListBox: TAlephCustomListBox); virtual;
    /// <summary>Getter for MutliSelectStyle</summary>
    function GetMultiSelectStyle: TMultiSelectStyle; virtual; abstract;
    /// <summary>Make host TAlephListBox update selection visuals</summary>
    procedure UpdateSelection;
    /// <summary>Initiate a delayed mouse down action</summary>
    procedure DelayedMouseDown(const ItemDown: TAlephListBoxItem; const Shift: TShiftState);
    /// <summary>Abort delayed mouse down action, if any</summary>
    procedure AbortDelayed;
    function GetMouseSelectActive: Boolean;
    procedure SetMouseSelectActive(const Value: Boolean); virtual;
  public
    destructor Destroy; override;
    /// <summary>Get first item index, -1 if none</summary>
    function GetFirst: Integer;
    /// <summary>Get current item index, -1 if none</summary>
    function GetCurrent: Integer;
    /// <summary>Get current TAlephListBoxItem, nil if none selected</summary>
    function GetCurrentItem: TAlephListBoxItem;
    /// <summary>Clear selection</summary>
    procedure ClearSelection;
    /// <summary>Attempt to copy selection from another selector</summary>
    procedure CopySelection(const Other: TAlephListBoxSelector); virtual; abstract;
    /// <summary>Select everything</summary>
    procedure SelectAll;
    /// <summary>Select range between TListBoxItems Item1 and Item2</summary>
    function SelectRange(const Item1, Item2: TAlephListBoxItem): Boolean;
    /// <summary>Mark TAlephListBoxItem Item as Selected if Value is True, as not selected if Value is False.
    /// No notification. Return true if Item.Selected has been changed.</summary>
    function SetSelected(const Item: TAlephListBoxItem; const Value: Boolean): Boolean;
    /// <summary>Set item with index Index as current. Return True if the value of Current has been changed.</summary>
    function SetCurrent(const Index: Integer): Boolean;
    /// <summary>Used to notify this TSelectionController when item state was changed externally. See DoItemStateChanged.</summary>
    procedure ItemStateChanged(const Item: TAlephListBoxItem; const UserChange: Boolean);
    /// <summary>Start mouse selection</summary>
    procedure MouseSelectStart(const Item: TAlephListBoxItem; const Button: TMouseButton; const Shift: TShiftState); virtual;
    /// <summary>Handle mouse move during selection</summary>
    procedure MouseSelectMove(const Item: TAlephListBoxItem; const Shift: TShiftState); virtual;
    /// <summary>Before mouse selection is finished</summary>
    procedure MouseSelectFinishing(const Item: TAlephListBoxItem; const Button: TMouseButton; const Shift: TShiftState); virtual;
    /// <summary>Finish mouse selection</summary>
    procedure MouseSelectFinish(const Item: TAlephListBoxItem; const Button: TMouseButton; const Shift: TShiftState); virtual;
    /// <summary>Select using keyboard, e.g. by pressing space. KeyAction is one of: Move or Toggle</summary>
    procedure KeyboardSelect(const KeyAction: TKeyAction; const Shift: TShiftState; const Item: TAlephListBoxItem); virtual;
    /// <summary>Invoked when item index is set programmatically by user</summary>
    procedure UserSetIndex(const Index: Integer); virtual;
    /// <summary>Dispatch change notification</summary>
    procedure Change;
    /// <summary>MouseSelectStart implementation</summary>
    procedure DoMouseSelectStart(const Item: TAlephListBoxItem; const Shift: TShiftState); virtual; abstract;
    /// <summary>MouseSelectMove implementation</summary>
    procedure DoMouseSelectMove(const Item: TAlephListBoxItem; const Shift: TShiftState); virtual; abstract;
    /// <summary>MouseSelectFinishing implementation</summary>
    procedure DoMouseSelectFinishing(const Item: TAlephListBoxItem; const Shift: TShiftState); virtual;
    /// <summary>MouseSelectFinish implementation</summary>
    procedure DoMouseSelectFinish(const Item: TAlephListBoxItem; const Shift: TShiftState); virtual; abstract;
    /// <summary>KeyboardSelect implementation</summary>
    procedure DoKeyboardSelect(const KeyAction: TKeyAction; const Shift: TShiftState; const Item: TAlephListBoxItem); virtual; abstract;
    /// <summary>UserSetIndex implementation</summary>
    procedure DoUserSetIndex(const Index: Integer); virtual; abstract;
    /// <summary>ItemStateChanged implementation</summary>
    procedure DoItemStateChanged(const Item: TAlephListBoxItem; const UserChange: Boolean); virtual;
    /// <summary>MultiSelectStyle that this selection controller implements</summary>
    property MultiSelectStyle: TMultiSelectStyle read GetMultiSelectStyle;
    /// <summary>True during mouse selection</summary>
    property MouseSelectActive: Boolean read GetMouseSelectActive write SetMouseSelectActive;
  end;

  TListBoxSelectorClass = class of TAlephListBoxSelector;

  /// <summary>A factory to create and register selectors based on multi-
  /// selection styles.</summary>
  TListBoxSelectorFactory = class
  private
    class var FSelectors: array[TMultiSelectStyle] of TListBoxSelectorClass;
  public
    /// <summary>Create TAlephListBoxSelector for ListBox based on MultiSelectStyle</summary>
    class function CreateSelector(const ListBox: TAlephCustomListBox; const MultiSelectStyle: TMultiSelectStyle): TAlephListBoxSelector;
    /// <summary>Register a selector that handles given MultiSelectStyle. Used during framework initialization</summary>
    class procedure RegisterSelector(MultiSelectStyle: TMultiSelectStyle; Selector: TListBoxSelectorClass);
  end;

  { TComboListBox }

  TComboListBox = class(TAlephCustomListBox, IContent)
  protected
    [Weak] FComboBox: TAlephCustomComboBox;
    FInKeyDown: Boolean;
    procedure KeyDown(var Key: Word; var KeyChar: System.WideChar; Shift: TShiftState); override;
    function GetObservers: TObservers; override;
    function GetDefaultStyleLookupName: string; override;
    procedure IContent.Changed = ContentChanged;
    procedure ContentChanged; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Single); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Single); override;
  end;

{ TAlephCustomComboBox }

  TAlephCustomComboBox = class(TStyledControl, IItemsContainer, IGlyph)
  private
    FDropDownCount: Integer;
    FDroppedDown: Boolean;
    FIsPressed: Boolean;
    FOldItemIndex: Integer;
    FItemWidth: Single;
    FOnChange: TNotifyEvent;
    FOnClosePopup: TNotifyEvent;
    FOnPopup: TNotifyEvent;
    FImageLink: TGlyphImageLink;
    FDropDownKind: TDropDownKind;
    FPopup: TPopup;
    FListBox: TComboListBox;
    FItemIndex: Integer;
    FListPicker: TCustomListPicker;
    [Weak] FImages: TCustomImageList;
    FItemsChanged: Boolean;
    procedure SetItemIndex(const Value: Integer);
    function GetItemIndex: Integer;
    function GetCount: Integer;
    procedure SetListBoxResource(const Value: string);
    function GetListBoxResource: string;
    function GetItemHeight: Single;
    procedure SetItemHeight(const Value: Single);
    procedure SetItemWidth(const Value: Single);
    function GetPlacement: TPlacement;
    function GetPlacementRectangle: TBounds;
    procedure SetPlacement(const Value: TPlacement);
    procedure SetPlacementRectangle(const Value: TBounds);
    procedure UpdateCurrentItem;
    function GetItems: TStrings;
    function GetListItem(Index: Integer): TAlephListBoxItem;
    function GetSelected: TAlephListBoxItem;
    procedure SetItems(const Value: TStrings);
    function GetImages: TCustomImageList;
    procedure SetImages(const Value: TCustomImageList);
    { IGlyph }
    function GetImageIndex: TImageIndex;
    procedure SetImageIndex(const Value: TImageIndex);
    function GetImageList: TBaseImageList; inline;
    procedure SetImageList(const Value: TBaseImageList);
    function IGlyph.GetImages = GetImageList;
    procedure IGlyph.SetImages = SetImageList;
    { IItemContainer }
    function GetItemsCount: Integer;
    function GetItem(const AIndex: Integer): TFmxObject;
    function UseNativePicker: Boolean;
    function ItemsStored: Boolean;
    procedure HandleStringsChanged(const S: string; const Op: TAlephCustomListBox.TStringsChangeOp);
  protected
    procedure DefineProperties(Filer: TFiler); override;
    procedure DoOnValueChangedFromDropDownList(Sender: TObject; const AValueIndex: Integer);
    procedure DoChange; dynamic;
    procedure DoPopup(Sender: TObject);
    procedure DoClosePopup(Sender: TObject);
    procedure DoClosePicker(Sender: TObject);
    function CreateListBox: TComboListBox; virtual;
    function CanObserve(const ID: Integer): Boolean; override;
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    function GetDefaultSize: TSizeF; override;
    procedure ApplyStyle; override;
    procedure DoRealign;
    procedure DoContentPaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF); virtual;
    procedure DoExit; override;
    procedure DoAddObject(const AObject: TFmxObject); override;
    procedure DoInsertObject(Index: Integer; const AObject: TFmxObject); override;
    procedure DoRemoveObject(const AObject: TFmxObject); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Single); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X: Single; Y: Single); override;
    procedure MouseWheel(Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean); override;
    procedure KeyDown(var Key: Word; var KeyChar: System.WideChar; Shift: TShiftState); override;
    procedure Loaded; override;
    /// <summary>Initialization of List Picker</summary>
    procedure InitPicker(AListPicker: TCustomListPicker); virtual;
    /// <summary>Recalculates popup size based on items</summary>
    procedure RecalculatePopupSize; virtual;
    /// <summary> Should be called when you change an instance or reference to instance of <b>TBaseImageList</b> or the
    /// <b>ImageIndex</b> property
    /// <para>See also <b>FMX.ActnList.IGlyph</b></para></summary>
    procedure ImagesChanged; virtual;
    property Popup: TPopup read FPopup;
    property CanFocus default True;
    property CanParentFocus;
    property ItemHeight: Single read GetItemHeight write SetItemHeight;
    property ItemWidth: Single read FItemWidth write SetItemWidth;
    property DropDownCount: Integer read FDropDownCount write FDropDownCount default 8;
    property Placement: TPlacement read GetPlacement write SetPlacement default TPlacement.Bottom;
    property PlacementRectangle: TBounds read GetPlacementRectangle write SetPlacementRectangle;
    property DropDownKind: TDropDownKind read FDropDownKind write FDropDownKind default TDropDownKind.Native;
    property ListBoxResource: string read GetListBoxResource write SetListBoxResource;
    property Picker: TCustomListPicker read FListPicker;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnClosePopup: TNotifyEvent read FOnClosePopup write FOnClosePopup;
    property OnPopup: TNotifyEvent read FOnPopup write FOnPopup;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetNewScene(AScene: IScene); override;
    procedure Clear; virtual;
    procedure DropDown; virtual;
    procedure Sort(Compare: TFmxObjectSortCompare); override;
    property ListBox: TComboListBox read FListBox;
    property Count: Integer read GetCount;
    property Selected: TAlephListBoxItem read GetSelected;
    property Items: TStrings read GetItems write SetItems stored ItemsStored;
    ///<summary> The list of images. Can be <c>nil</c>. <para>See also <b>FMX.ActnList.IGlyph</b></para></summary>
    property Images: TCustomImageList read GetImages write SetImages;
    property ListItems[Index: Integer]: TAlephListBoxItem read GetListItem;
    property ItemIndex: Integer read GetItemIndex write SetItemIndex;
    property DroppedDown: Boolean read FDroppedDown;
    property IsPressed: Boolean read FIsPressed;
  end;

{ TAlephComboBox }

  TAlephComboBox = class(TAlephCustomComboBox)
  public
    property PlacementRectangle;
  published
    property Align;
    property Anchors;
    property CanFocus;
    property CanParentFocus;
    property ClipChildren;
    property ClipParent;
    property Cursor;
    property DisableFocusEffect;
    property DragMode;
    property DropDownCount;
    property EnableDragHighlight;
    property Enabled;
    property Locked;
    property Height;
    property HelpContext;
    property HelpKeyword;
    property HelpType;
    property Hint;
    property HitTest;
    property Items;
    property Images;
    property ItemIndex default -1;
    property ItemWidth;
    property ItemHeight;
    property ListBoxResource;
    property Padding;
    property DropDownKind;
    property Opacity;
    property Margins;
    property Placement;
    property PopupMenu;
    property Position;
    property RotationAngle;
    property RotationCenter;
    property Scale;
    property Size;
    property StyleLookup;
    property TabOrder;
    property TabStop;
    property TouchTargetExpansion;
    property Visible;
    property Width;
    property ParentShowHint;
    property ShowHint;

    {events}
    property OnApplyStyleLookup;
    property OnChange;
    property OnClosePopup;
    property OnPopup;
    {Drag and Drop events}
    property OnDragEnter;
    property OnDragLeave;
    property OnDragOver;
    property OnDragDrop;
    property OnDragEnd;
    {Keyboard events}
    property OnKeyDown;
    property OnKeyUp;
    {Mouse events}
    property OnCanFocus;
    property OnClick;
    property OnDblClick;

    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseEnter;
    property OnMouseLeave;

    property OnPainting;
    property OnPaint;
    property OnResize;
    property OnResized;
  end;

  TAlephMetropolisUIListBoxItem = class(TAlephListBoxItem)
  private
    FImage: TImage;
    FText: TLayout;
    FTextPanel: TPanel;

    FTitle: TLabel;
    FSubTitle: TLabel;
    FDescription: TLabel;
    FIconSize: Integer;

    procedure SkipIconSize(Reader: TReader);
    procedure SkipAlign(Reader: TReader);
  protected
    procedure SetIcon(const Bitmap: TBitmap); virtual;
    function GetIcon : TBitmap; virtual;
    procedure SetTitle(const Title: String); virtual;
    function GetTitle: String; virtual;
    procedure SetSubTitle(const SubTitle: String); virtual;
    function GetSubTitle: String; virtual;
    procedure SetDescription(const Description: String); virtual;
    function GetDescription: String; virtual;
    procedure SetIconSize(Value: Integer); virtual;

    procedure SetParent(const AParent: TFmxObject); override;
    procedure ApplyStyle; override;
    procedure FreeStyle; override;
    procedure OnBitmapChanged(Sender: TObject);
    procedure Resize; override;
    procedure DoRealign;
    procedure DefineProperties(Filer: TFiler); override;
    function GetDefaultStyleLookupName: string; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property IconSize: Integer read FIconSize write SetIconSize;
 published
    property Title: String read GetTitle write SetTitle nodefault;
    property SubTitle: String read GetSubTitle write SetSubTitle nodefault;
    property Description: String read GetDescription write SetDescription nodefault;
    property Icon: TBitmap read GetIcon write SetIcon;
    property Padding;
    property Margins;
  end;

implementation

uses
  {$IFDEF MACOS}Macapi.CoreFoundation, {$ENDIF} System.Character,
  System.Math, System.Generics.Defaults, System.Math.Vectors, System.TypInfo, FMX.Consts, FMX.BehaviorManager,
  FMX.Forms, FMX.Utils, FMX.Platform;

type
  TOpenObject = class(TControl);

  TListBoxContent = class(TScrollContent)
  strict private
    [Weak] FListBox: TAlephCustomListBox;
    FFilterPredicate: TPredicate<string>;
    FClipOffset: Single;
  protected
    function GetClipRect: TRectF; override;
    function GetFirstVisibleObjectIndex: Integer; override;
    function GetLastVisibleObjectIndex: Integer; override;
    procedure DoRealign; override;
    procedure SetFilterPredicate(const Filter: TPredicate<string>);
    function CreateChildrenList(const Children: TFmxObjectList): TFmxChildrenList; override;
    procedure PaintChildren; override;
  public
    constructor Create(AOwner: TComponent); override;
    constructor CreateContent(const AOwner: TComponent; const ListBox: TAlephCustomListBox);
    destructor Destroy; override;
    property Filter: TPredicate<string> read FFilterPredicate write SetFilterPredicate;
    property ClipOffset: Single read FClipOffset write FClipOffset;
  end;

  TFilteredChildrenList = class(TFmxChildrenList)
  strict private
    FFilteredChildren: TFmxObjectList;
    [Weak] FBaseChildren: TFmxObjectList;
  protected
    function DoGetEnumerator: TEnumerator<TFmxObject>; override;
    function GetChildCount: Integer; override;
    function GetChild(AIndex: Integer): TFmxObject; override;
    function IndexOf(const Obj: TFmxObject): Integer; override;
    procedure ApplyFilter(const Filter: TPredicate<string>);
    constructor Create(const Children: TFmxObjectList);
    destructor Destroy; override;
  end;

{ TAlephListBoxItem }

constructor TAlephListBoxItem.Create(AOwner: TComponent);
begin
  inherited;
  FImageLink := TGlyphImageLink.Create(Self);
  TextAlign := TTextAlign.Leading;
  AutoTranslate := True;
  Text := '';
  HitTest := False;
  FIsSelectable := True;
  FBitmap := TBitmap.Create(0,0);
  FBitmap.OnChange := OnBitmapChanged;
  FItemData := TAlephListBoxItemData.Create(Self);
  StyledSettings := StyledSettings + [TStyledSetting.Other];
  SetAcceptsControls(True);
  PrefixStyle := TPrefixStyle.NoPrefix;

  {CreateAlephListBoxItem}
  FAutoHeight := False;  // Inicializa o AutoHeight como habilitado
  FInAutoHeight := False;
  FAlephTipo := TAlephTipo.Create(Self);
  FRemMargins := TREmMargins.Create(Self);
  FRemFontSize := TREmFontSize.Create(Self);
  GlobalResizeManager.RegisterComponent(Self);
  GlobalResizeManager.RegisterFontSizeComponent(Self);
  if AOwner is TForm then
  begin
    TForm(AOwner).OnResize := GlobalResizeManager.FormResizeHandler;
    // Registra o evento de redimensionamento global
  end;
end;

destructor TAlephListBoxItem.Destroy;
begin
  FreeAndNil(FItemData);
  FreeAndNil(FBitmap);
  FreeAndNil(FImageLink);

  {DestroyAlephListBoxItem}
  if Assigned(FGlobalFontSizeManager) then
    FGlobalFontSizeManager.UnregisterComponent(Self);
  GlobalResizeManager.UnregisterComponent(Self);
  GlobalResizeManager.UnregisterFontSizeComponent(Self);
  FreeAndNil(FRemMargins);
  FreeAndNil(FRemFontSize);
  FreeAndNil(FAlephTipo);
  inherited;
end;

type
  TListBoxItemSettings = class (TTextSettingsInfo.TCustomTextSettings)
  public
    constructor Create(const AOwner: TPersistent); override;
  published
    property Font;
    property FontColor;
    property HorzAlign;
    property WordWrap default False;
  end;

{ ProceduresTAlephListBoxItem }

procedure TAlephListBoxItem.ResizeComponent(Sender: TObject);
begin
  if Assigned(FAlephTipo) then
    FAlephTipo.ResizeComponent(sender);
end;

procedure TAlephListBoxItem.AdjustHeight;
var
  NewHeight: Single;
begin
  if not FAutoHeight then
    Exit;
  NewHeight := TextSettings.Font.Size + Padding.Top + Padding.Bottom;
  if (csDesigning in ComponentState) or not (csLoading in ComponentState) then
  begin
    BeginUpdate;
    try
      Height := Round(NewHeight);
    finally
      EndUpdate;
    end;
  end;
end;


procedure TAlephListBoxItem.CalculatePercentage(Sender: TObject);
begin
  if Assigned(FGlobalFontSizeManager) then
    FGlobalFontSizeManager.CalculatePercentage(sender);
end;


procedure TAlephListBoxItem.SetPadding(const Value: TBounds);
begin
  inherited Padding := Value;
  if FAutoHeight then
    AdjustHeight(nil);
end;

function TAlephListBoxItem.GetRemMargins: TREmMargins;
begin
  Result := FRemMargins;
end;

function TAlephListBoxItem.GetTextRem: TREmFontSize;
begin
  Result := FRemFontSize;
end;

function TAlephListBoxItem.GetTipo: TAlephTipo;
begin
  Result := FAlephTipo;
end;

procedure TAlephListBoxItem.Loaded;
begin
  inherited;
  if FAutoHeight then
    AdjustHeight(nil);
end;

procedure TAlephListBoxItem.Resize;
begin
  inherited;
  if Assigned(FAlephTipo) then
      FAlephTipo.Resize;
end;

procedure TAlephListBoxItem.ResizeFont(Sender: TObject);
begin
  if Assigned(FRemFontSize) then
    TextSettings.Font.Size := FRemFontSize.ToPixels;
  if FAutoHeight then
    AdjustHeight(nil);
end;

procedure TAlephListBoxItem.SetRemMargins(const Value: TREmMargins);
begin
  if Assigned(FRemMargins) then
    FRemMargins.Assign(Value);
end;

procedure TAlephListBoxItem.SetTextRem(const Value: TREmFontSize);
begin
  if Assigned(FRemFontSize) then
    FRemFontSize.Assign(Value);
end;

procedure TAlephListBoxItem.SetTipo(const Value: TAlephTipo);
begin
  if Assigned(FAlephTipo) then
    FAlephTipo.Assign(Value);
  ResizeComponent(nil);
end;

procedure TAlephListBoxItem.SetAutoHeight(const Value: Boolean);
begin
  FAutoHeight := Value;
end;

procedure TAlephListBoxItem.SetGlobalFontSizeManager(const Value: TGlobalFontSizeManager);
begin
  if FGlobalFontSizeManager <> Value then
  begin
    if Assigned(FGlobalFontSizeManager) then
    begin
      FGlobalFontSizeManager.UnregisterComponent(Self);
      RemoveFreeNotification(FGlobalFontSizeManager);
    end;
    FGlobalFontSizeManager := Value;
    if Assigned(FGlobalFontSizeManager) then
    begin
      FGlobalFontSizeManager.RegisterComponent(Self);
      FGlobalFontSizeManager.FreeNotification(Self);
      UpdateFontSize(FGlobalFontSizeManager.BaseSize);
    end;
  end;
end;

procedure TAlephListBoxItem.UpdateFontSize(NewBaseSize: Integer);
begin
  if Assigned(FRemFontSize) then
  begin
    FRemFontSize.FontSize := NewBaseSize;
    ResizeFont(Self);
  end;
  if Assigned(FRemMargins) then
  begin
    FRemMargins.AMarginBase.FontBase := NewBaseSize;
    ResizeFont(Self);
  end;
end;

procedure TAlephListBoxItem.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FGlobalFontSizeManager) then
  begin
    FGlobalFontSizeManager := nil;
  end;
end;

{ TListBoxItemSettings }

constructor TListBoxItemSettings.Create(const AOwner: TPersistent);
begin
  inherited;
  WordWrap := False;
end;

function TAlephListBoxItem.GetTextSettingsClass: TTextSettingsInfo.TCustomTextSettingsClass;
begin
  Result := TListBoxItemSettings;
end;

function TAlephListBoxItem.GetWidth: Single;
begin
  // Regardless of PlatformDefault setting, the width is set by the parent control
  Result := FSize.Width;
end;

procedure TAlephListBoxItem.ApplyStyle;
var
  LListBox : TAlephCustomListBox;
  Dimensions: TRectF;
begin
  Dimensions := BoundsRect;
  inherited;
  LListBox := ListBox;

  if (LListBox <> nil) and LListBox.ShowCheckboxes then
    InitCheckBox(True);
  if FCheck <> nil then
    FOldCheckAlign := FCheck.Align;

  FindStyleResource<TGlyph>('glyphstyle', FGlyph);

  if FindStyleResource<TImage>('icon', FIcon) then
    FOldIconVisible := FIcon.Visible;

  StartTriggerAnimation(Self, 'IsSelected');
  ApplyTriggerEffect(Self, 'IsSelected');

  ImagesChanged;
  // Make the listbox recalculate item positions if size changed
  if (LListBox <> nil) and (Dimensions.Size <> BoundsRect.Size) then
    LListBox.Realign;
end;

procedure TAlephListBoxItem.FreeStyle;
begin
  inherited;
  if FCheck <> nil then
  begin
    FCheck.OnChange := nil;
    FCheck.Align := FOldCheckAlign;
    FCheck.Visible := False;
    FCheck.IsChecked := False;
    FCheck := nil;
  end;
  if FIcon <> nil then
  begin
    FIcon.Visible := FOldIconVisible;
    FIcon := nil;
  end;
  if FGlyph <> nil then
  begin
    FGlyph.ImageIndex := -1;
    FGlyph.Images := nil;
    FGlyph := nil;
  end;
  FItemData.Disappear;
end;

procedure TAlephListBoxItem.DoCheckClick(Sender: TObject);
var
  LListBox : TAlephCustomListBox;
begin
  if FCheck <> nil then
    FIsChecked := FCheck.IsChecked;
  LListBox := ListBox ;
  if LListBox <> nil then
  begin
    LListBox.SetFocus;
    LListBox.ItemIndex := Index;
    LListBox.DoChangeCheck(Self);
  end;
end;

function TAlephListBoxItem.DoSetSize(const ASize: TControlSize; const NewPlatformDefault: Boolean; ANewWidth,
  ANewHeight: Single; var ALastWidth, ALastHeight: Single): Boolean;
var
  NewSize: TSizeF;
  SavedPlatformDefault: Boolean;
  DefaultHeight: Single;
begin
  DefaultHeight := GetDefaultSize.Height;
  NewSize.Width := System.Math.Max(0, ANewWidth);
  NewSize.Height := System.Math.Max(0, ANewHeight);
  Result := not SameValue(NewSize.Width, ASize.Width, TEpsilon.Position) or
    not SameValue(NewSize.Height, ASize.Height, TEpsilon.Position);
  if Result then
    Repaint;
  ALastWidth := ASize.Width;
  ALastHeight := ASize.Height;
  SavedPlatformDefault := ASize.PlatformDefault;
  ASize.SetSizeWithoutNotification(NewSize);
  if SavedPlatformDefault and SameValue(DefaultHeight, ASize.Height, TEpsilon.Position) then
    ASize.SetPlatformDefaultWithoutNotification(SavedPlatformDefault)
  else
    ASize.SetPlatformDefaultWithoutNotification(NewPlatformDefault);
end;

procedure TAlephListBoxItem.ApplyTriggerEffect(const AInstance: TFmxObject;
  const ATrigger: string);
begin
end;

procedure TAlephListBoxItem.ChangeOrder;
var
  LListBox : TAlephCustomListBox;
begin
  inherited;
  LListBox := ListBox;
  if LListBox <> nil then
  begin
    LListBox.UpdateGroups;
    LListBox.RealignContent;
  end;
end;

function TAlephListBoxItem.ComboBox: TAlephCustomComboBox;
begin
  TFmxObjectHelper.FindNearestParentOfClass<TAlephCustomComboBox>(Self, Result);
end;

function TAlephListBoxItem.ListBox: TAlephCustomListBox;
var
  ResultObject: TFmxObject;
begin
  TFmxObjectHelper.FindParent(Self, function (AObject: TFmxObject): Boolean
    begin
      Result := (AObject is TAlephCustomListBox) or (AObject is TAlephCustomComboBox);
    end, ResultObject);
  if ResultObject = nil then
    Result := nil
  else if ResultObject is TAlephCustomComboBox then
    Result := TAlephCustomComboBox(ResultObject).FListBox
  else
    Result := ResultObject as TAlephCustomListBox;
end;

procedure TAlephListBoxItem.OnBitmapChanged(Sender: TObject);
begin
  ImagesChanged;
end;

procedure TAlephListBoxItem.Paint;
var
  R: TRectF;
begin
  if (csDesigning in ComponentState) and not Locked and not FInPaintTo then
  begin
    R := LocalRect;
    InflateRect(R, -0.5, -0.5);
    Canvas.DrawDashRect(R, 0, 0, AllCorners, AbsoluteOpacity, $A0909090);
  end;
end;

function TAlephListBoxItem.GetDefaultSize: TSizeF;

  function FindControlDefaultSize(const AComponentKind: TComponentKind; var ASize: TSizeF): Boolean;
  var
    Context: TFmxObject;
    MetricsService: IFMXDefaultMetricsService;
    DeviceInfo: IDeviceBehavior;
  begin
    if TBehaviorServices.Current.SupportsBehaviorService(IDeviceBehavior, DeviceInfo, Self) then
    begin
      Result := True;
      case DeviceInfo.GetOSPlatform(Self) of
        TOSPlatform.Windows:
          ASize := TSizeF.Create(19, 19);
        TOSPlatform.OSX:
          ASize := TSizeF.Create(19, 19);
        TOSPlatform.iOS:
          ASize := TSizeF.Create(44, 44);
        TOSPlatform.Android:
          ASize := TSizeF.Create(44, 44);
        TOSPlatform.Linux:
          ASize := TSizeF.Create(19, 19);
      end;
    end
    else
    begin
      if Owner is TFmxObject then
        Context := TFmxObject(Owner)
      else if Parent <> nil then
        Context := Parent
      else
        Context := nil;
      Result := TBehaviorServices.Current.SupportsBehaviorService(IFMXDefaultMetricsService, MetricsService, Context)
        and MetricsService.SupportsDefaultSize(AComponentKind)
        or SupportsPlatformService(IFMXDefaultMetricsService, MetricsService)
        and MetricsService.SupportsDefaultSize(AComponentKind);
      if Result then
        ASize := MetricsService.GetDefaultSize(AComponentKind);
    end;
  end;

begin
  if not FindControlDefaultSize(TComponentKind.ListBoxItem, Result) then
    Result := TSizeF.Create(19, 19);
end;

function TAlephListBoxItem.GetHeight: Single;
begin
  Result := FSize.Height;
end;

function TAlephListBoxItem.GetParentComponent: TComponent;
var
  LComboBox : TAlephCustomComboBox;
  LListBox : TAlephCustomListBox;
begin
  LComboBox := ComboBox;
  if LComboBox <> nil then
    Result := LComboBox
  else
  begin
    LListBox := ListBox;
    if LListBox <> nil then
      Result := LListBox
    else
      Result := inherited GetParentComponent;
  end;
end;

function TAlephListBoxItem.EnterChildren(AObject: IControl): Boolean;
var
  LListBox : TAlephCustomListBox;
begin
  Result := inherited EnterChildren(AObject);
  LListBox := ListBox;
  if LListBox <> nil then
  begin
    if LListBox.MultiSelectStyle = TMultiSelectStyle.Default then
      LListBox.ClearSelection;
    LListBox.ItemIndex := Index;
    Result := True;
  end;
end;

procedure TAlephListBoxItem.InitCheckBox(Visible: Boolean);
begin
  if FindStyleResource<TCheckBox>('check', FCheck) then
  begin
    FCheck.IsChecked := IsChecked;
    FCheck.OnChange := DoCheckClick;
    FCheck.Visible := Visible;
  end;
end;

procedure TAlephListBoxItem.UpdateCheck;
var
  LListBox : TAlephCustomListBox ;
  Item: TAlephListBoxItem;
begin
  LListBox := ListBox;

  if LListBox.ShowCheckBoxes and (FCheck = nil) then
    InitCheckBox(True);

  if (LListBox <> nil) and (FCheck <> nil) then
    FCheck.Visible := LListBox.ShowCheckboxes;
  for Item in TControlsFilter<TAlephListBoxItem>.Filter(Controls) do
    Item.UpdateCheck;
end;

function TAlephListBoxItem.GetDefaultStyleLookupName: string;
var
  LListBox: TAlephCustomListBox;
  Defaults: TAlephListBoxItemStyleDefaults;
begin
  Defaults := nil;
  LListBox := ListBox;
  if LListBox <> nil then
    Defaults := LListBox.DefaultItemStyles;

  Result := DoGetDefaultStyleLookupName(Defaults);
  if Result.IsEmpty then
    Result := inherited;
end;

function TAlephListBoxItem.DoGetDefaultStyleLookupName(const Defaults: TAlephListBoxItemStyleDefaults): string;
begin
  if Defaults <> nil then
    Result := Defaults.ItemStyle;
end;

procedure TAlephListBoxItem.SelectBackground(const Shape: TBackgroundShape);
begin
  StylesData['background_separatorbottom.Visible'] := TValue.From<Boolean>(Shape = TBackgroundShape.SeparatorBottom);
  StylesData['background_sharp.Visible'] := TValue.From<Boolean>(Shape = TBackgroundShape.Sharp);
  StylesData['background_roundtop.Visible'] := TValue.From<Boolean>(Shape = TBackgroundShape.RoundTop);
  StylesData['background_roundbottom.Visible'] := TValue.From<Boolean>(Shape = TBackgroundShape.RoundBottom);
  StylesData['background_roundall.Visible'] := TValue.From<Boolean>(Shape = TBackgroundShape.RoundAll);
  FBackgroundShape := Shape;
end;

procedure TAlephListBoxItem.SetHeight(const Value: Single);
var
  LListBox : TAlephCustomListBox;
begin
  inherited SetHeight(Value);
  LListBox := ListBox;
  if LListBox <> nil then
    LListBox.Realign;
end;

procedure TAlephListBoxItem.SetIsChecked(const Value: Boolean);
begin
  if FIsChecked <> Value then
  begin
    FIsChecked := Value;
    if FCheck <> nil then
      FCheck.IsChecked := FIsChecked;
  end;
end;

procedure TAlephListBoxItem.SetIsSelected(const Value: Boolean);
begin
  SetIsSelectedInternal(Value, True);
end;

procedure TAlephListBoxItem.SetIsSelectedInternal(const Value: Boolean; const UserChange: Boolean);
var
  LListBox: TAlephCustomListBox;
begin
  if (FIsSelected <> (Selectable and Value)) or UserChange then
  begin
    FIsSelected := Selectable and Value;
    StartTriggerAnimation(Self, 'IsSelected');
    LListBox := ListBox;
    if LListBox <> nil then
      LListBox.SelectionController.ItemStateChanged(Self, UserChange);
  end;
end;

procedure TAlephListBoxItem.SetItemData(const Value: TAlephListBoxItemData);
begin
  FItemData.Assign(Value);
end;

procedure TAlephListBoxItem.SetSelectable(const Value: Boolean);
var
  LListBox : TAlephCustomListBox;
begin
  if FIsSelectable <> Value then
  begin
    FIsSelectable := Value;
    LListBox := ListBox;
    if LListBox <> nil then
      LListBox.UpdateSelection;
  end;
end;

procedure TAlephListBoxItem.SetVisible(const Value: Boolean);
begin
  inherited;
  if IsSelected and not Value then
    SetIsSelectedInternal(False, False);
end;

function TAlephListBoxItem.StyledSettingsStored: Boolean;
begin
  Result := StyledSettings <> (DefaultStyledSettings + [TStyledSetting.Other]);
end;

procedure TAlephListBoxItem.DragEnd;
var
  LListBox : TAlephCustomListBox;
begin
  inherited;
  DragLeave;
  LListBox := ListBox;
  if (LListBox <> nil) and (LListBox.FDragItem <> nil) then
  begin
    LListBox.FDragItem.RemoveFreeNotify(LListBox);
    LListBox.FDragItem := nil;
  end;
end;

procedure TAlephListBoxItem.DragOver(const Data: TDragObject; const Point: TPointF; var Operation: TDragOperation);
begin
  inherited;
  if (Operation = TDragOperation.None) and (ListBox <> nil) and (ListBox.FDragItem = Self) then
    Operation := TDragOperation.Move;
end;

function TAlephListBoxItem.ImageIndexStored: Boolean;
begin
  Result := ActionClient or (ImageIndex <> -1);
end;

procedure TAlephListBoxItem.ImagesChanged;
var
  LParent: TControl;
  NeedRepaint: Boolean;
begin
  NeedRepaint := False;
  if FGlyph <> nil then
  begin
    FGlyph.ImageIndex := ImageIndex;
    FGlyph.Images := Images;
    if (FCheck <> nil) and (FCheck.Align = FGlyph.Align) then
    begin
      case FCheck.Align of
        TAlignLayout.Left: FCheck.Align := TAlignLayout.MostLeft;
        TAlignLayout.Right: FCheck.Align := TAlignLayout.MostRight;
      end;
    end;
    NeedRepaint := True;
  end;
  if FIcon <> nil then
  begin
    if ((FGlyph <> nil) and FGlyph.Visible) or FBitmap.IsEmpty then
    begin
      FIcon.Visible := False;
      FIcon.MultiResBitmap.Clear;
    end
    else
    begin
      FIcon.Bitmap := FBitmap;
      FIcon.Visible := True;
      FIcon.Repaint;
      FIcon.UpdateEffects;
    end;
    NeedRepaint := True;
  end;

  if NeedRepaint then
  begin
    LParent := ParentControl;
    while (LParent <> nil) and not (LParent is TPopup) do
      LParent := LParent.ParentControl;
    if (LParent <> nil) and (LParent.ParentControl is TAlephCustomComboBox) and
      (TAlephCustomComboBox(LParent.ParentControl).ItemIndex = Index) then
      LParent.ParentControl.Repaint;
  end;
end;

function TAlephListBoxItem.GetImageIndex: TImageIndex;
begin
  Result := FImageLink.ImageIndex
end;

procedure TAlephListBoxItem.SetImageIndex(const Value: TImageIndex);
begin
  FImageLink.ImageIndex := Value;
end;

function TAlephListBoxItem.GetImageList: TBaseImageList;
begin
  Result := GetImages;
end;

procedure TAlephListBoxItem.SetImageList(const Value: TBaseImageList);
begin
  // none
end;

function TAlephListBoxItem.GetImages: TCustomImageList;
begin
  if FImageLink.Images is TCustomImageList then
    Result := TCustomImageList(FImageLink.Images)
  else
    Result := nil;
end;

procedure TAlephListBoxItem.SetImages(const Value: TCustomImageList);
begin
  FImageLink.Images := Value;
end;

{ TListBoxContent }

constructor TListBoxContent.CreateContent(const AOwner: TComponent; const ListBox: TAlephCustomListBox);
begin
  FListBox := ListBox;
  Create(AOwner);
end;

function TListBoxContent.CreateChildrenList(const Children: TFmxObjectList): TFmxChildrenList;
begin
  Result := TFilteredChildrenList.Create(Children);
end;

constructor TListBoxContent.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TListBoxContent.Destroy;
begin
  inherited;
end;

procedure TListBoxContent.DoRealign;
begin
  if csDesigning in ComponentState then
  begin
    FListBox.Realign;
    FListBox.UpdateGroups;
  end;
end;

function TListBoxContent.GetClipRect: TRectF;
begin
  Result := inherited;
  if FClipOffset > 0 then
    Result.Top := Result.Top + FClipOffset;
end;

function TListBoxContent.GetFirstVisibleObjectIndex: Integer;
begin
  Result := FListBox.FFirstVisibleItem;
end;

function TListBoxContent.GetLastVisibleObjectIndex: Integer;
begin
  Result := FListBox.FLastVisibleItem;
end;

procedure TListBoxContent.PaintChildren;
begin
  inherited;
end;

procedure TListBoxContent.SetFilterPredicate(const Filter: TPredicate<string>);
begin
  FFilterPredicate := Filter;
  if Children <> nil then
    TFilteredChildrenList(Children).ApplyFilter(FFilterPredicate);
  ResetChildrenIndices;
  ChangeChildren;
end;

{ TAlephCustomListBox }

constructor TAlephCustomListBox.Create(AOwner: TComponent);
begin
  inherited;
  FImageLink := TGlyphImageLink.Create(Self);
  FDefaultStyles := TAlephListBoxItemStyleDefaults.Create(Self);

  FGroupingKind := TListGroupingKind.Plain;
  FDisableAlign := True;
  FNoItemsContent := TContent.Create(Self);
  FNoItemsContent.Parent := Self;
  FNoItemsContent.Stored := False;
  FNoItemsContent.Locked := True;
  FNoItemsContent.HitTest := False;
  FHeaderCompartment := TContent.Create(Self);
  FHeaderCompartment.Stored := False;
  FHeaderCompartment.Locked := True;
  FHeaderCompartment.Visible := False;
  FHeaderCompartment.Align := TAlignLayout.Top;
  FHeaderCompartment.Parent := Content.Parent;
  FFooterCompartment := TContent.Create(Self);
  FFooterCompartment.Stored := False;
  FFooterCompartment.Locked := True;
  FFooterCompartment.Visible := False;
  FFooterCompartment.Align := TAlignLayout.Bottom;
  FFooterCompartment.Parent := Content.Parent;

  FContentOverlay := TContent.Create(Self);
  FContentOverlay.Stored := False;
  FContentOverlay.Locked := True;
  FContentOverlay.Visible := True;
  FContentOverlay.Align := TAlignLayout.Client;
  FContentOverlay.HitTest := False;
  FContentOverlay.ClipChildren := True;
  FContentOverlay.Parent := Content.Parent;

  FDisableAlign := False;

  FGroups := TGroups.Create;
  FItems := TListBoxStrings.Create;
  TListBoxStrings(FItems).FListBox := Self;
  FOddFill := TBrush.Create(TBrushKind.Solid, $20000000);
  FColumns := 1;
  DisableFocusEffect := True;
  CanFocus := True;
  AutoCapture := True;
  MinClipWidth := 22;
  MinClipHeight := 22;
  SetAcceptsControls(True);
  MultiSelectStyle := TMultiSelectStyle.None;
  FToInflate := TList<TAlephListBoxItem>.Create;
  FInflater := TContentInflater<TAlephListBoxItem>.Create(Self);
  FSelectionObjects := TStyledSelection.Create(Self);
end;

function TAlephCustomListBox.CreateScrollContent: TScrollContent;
begin
  Result := TListBoxContent.CreateContent(Self, Self);
end;

procedure TAlephCustomListBox.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineProperty('DefaultItemStyle', IgnoreString, nil, False);
  Filer.DefineProperty('MultiSelect', ReadMultiSelect, nil, False);
end;

destructor TAlephCustomListBox.Destroy;
begin
  FStringsChanged := nil;
  FreeAndNil(FSelectionObjects);
  FreeAndNil(FOddFill);
  FreeAndNil(FItems);
  FreeAndNil(FGroups);
  FreeAndNil(FInflater);
  FreeAndNil(FToInflate);
  FreeAndNil(FDefaultStyles);
  FreeAndNil(FSelector);
  FreeAndNil(FImageLink);
  inherited;
end;

procedure TAlephCustomListBox.DispatchStringsChangeEvent(const S: String; const Op: TStringsChangeOp);
begin
  if Assigned(FStringsChanged) then
    FStringsChanged(S, Op);
end;

function TAlephCustomListBox.GetData: TValue;
begin
  if Selected <> nil then
    Result := Selected.Text
  else
    Result := '';
end;

function TAlephCustomListBox.GetDefaultSize: TSizeF;
begin
  Result := TSizeF.Create(200, 200);
end;

procedure TAlephCustomListBox.SetData(const Value: TValue);
begin
  if Selected <> nil then
    Selected.Text := Value.ToString;
end;

procedure TAlephCustomListBox.SetFilterPredicate(const Predicate: TPredicate<string>);
begin
  try
    BeginUpdate;
    ScrollBy(HScrollBarValue, VScrollBarValue);
    InvalidateContentSize;
    Self.ItemIndex := -1;
    TListBoxContent(Content).Filter := Predicate;
    UpdateGroups;
    RealignContent;
  finally
    EndUpdate;
  end;
end;

function TAlephCustomListBox.GetFilterPredicate: TPredicate<string>;
begin
  Result := TListBoxContent(Content).Filter;
end;

procedure TAlephCustomListBox.SetGroupingKind(const Value: TListGroupingKind);
  procedure UpdateHeaderStyles;
  var
    Item: TListBoxSeparatorItem;
  begin
    for Item in TControlsFilter<TListBoxSeparatorItem>.Filter(Content.Controls) do
      Item.Disappear;
  end;

begin
  if FGroupingKind <> Value then
  begin
    BeginUpdate;
    try
      FGroupingKind := Value;
      UpdateGroups;
      UpdateHeaderStyles;
      RealignContent;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TAlephCustomListBox.Assign(Source: TPersistent);
var
  I: Integer;
  Item: TAlephListBoxItem;
begin
  if Source is TStrings then
  begin
    BeginUpdate;
    try
      Clear;
      for I := 0 to TStrings(Source).Count - 1 do
      begin
        Item := TAlephListBoxItem.Create(Self);
        Item.Parent := Self;
        Item.Stored := False;
        Item.Text := TStrings(Source)[I];
      end;
    finally
      EndUpdate;
    end;
  end
  else
    inherited;
end;

procedure TAlephCustomListBox.ViewportPositionChange(const OldViewportPosition, NewViewportPosition: TPointF;
                                                const ContentSizeChanged: boolean);
begin
  inherited;
  SelectionController.AbortDelayed;
  UpdateVisibleItems;
  UpdateSelection;
  if ContentSizeChanged or (not SameValue(OldViewportPosition.Y, NewViewportPosition.Y, Epsilon)) then
    UpdateStickyHeader;
end;

procedure TAlephCustomListBox.DoUpdateAniCalculations(const AAniCalculations: TScrollCalculations);
begin
  inherited DoUpdateAniCalculations(AAniCalculations);
  if ListStyle = TListStyle.Vertical then
    AAniCalculations.TouchTracking := AAniCalculations.TouchTracking - [ttHorizontal]
  else
    AAniCalculations.TouchTracking := AAniCalculations.TouchTracking - [ttVertical];
end;

function CompareListItem(Item1, Item2: TFmxObject): Integer;
var
  LListBox : TAlephCustomListBox ;
begin
  if Item1 is TAlephListBoxItem then
    LListBox := TAlephListBoxItem(Item1).ListBox
  else
    LListBox := nil ;
  if (Item1 is TAlephListBoxItem) and (Item2 is TAlephListBoxItem) and (LListBox <> nil) then
    Result := LListBox.CompareItems(TAlephListBoxItem(Item1), TAlephListBoxItem(Item2))
  else
    Result := 0;
end;

procedure TAlephCustomListBox.Sort(Compare: TFmxObjectSortCompare);
var
  Item: TAlephListBoxItem;
begin
  Item := Selected;
  inherited Sort(Compare);
  SelectionController.SetSelected(Item, True);
  if Item <> nil then
    SelectionController.SetCurrent(Item.Index);
  if not (csLoading in ComponentState) then
    DoChange;
end;

procedure TAlephCustomListBox.SortItems;
begin
  if FSorted then
    Content.Sort(CompareListItem);
end;

procedure TAlephCustomListBox.DoContentPaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
var
  i: Integer;
  Item: TAlephListBoxItem;
  P: TPointF;
  R: TRectF;
begin
  if (Content <> nil) and (ContentLayout <> nil) then
  begin
    if FAlternatingRowBackground then
    begin
      for i := 0 to ((FLastVisibleItem - FFirstVisibleItem - 1) div Columns) do
      begin
        if Odd((FFirstVisibleItem div Columns ) + i) then
        begin
          if FFirstVisibleItem + (i * Columns) > Count - 1 then
            Item := ItemByIndex(Count - 1)
          else
            Item := ItemByIndex(FFirstVisibleItem + (i * Columns));
          P := TControl(Sender).ConvertLocalPointFrom(Item, TPointF.Zero);
          R := TRectF.Create(P, ContentLayout.Width, Item.Height);
          if not IntersectRect(R, ARect) then
            Continue;
          Canvas.FillRect(R, 0, 0, [], AbsoluteOpacity, FOddFill);
        end;
      end;
    end;
  end;
end;

procedure TAlephCustomListBox.ApplyStyle;

  procedure Inset(var R1: TRectF; const R2: TRectF);
  begin
    R1.Left := R1.Left + R2.Left;
    R1.Top := R1.Top + R2.Top;
    R1.Right := R1.Right + R2.Right;
    R1.Bottom := R1.Bottom + R2.Bottom;
  end;

  function CreateLayout(const Align: TAlignLayout; out Layout: TControl): Boolean;
  begin
    Result := False;
    if ContentLayout <> nil then
    begin
      Layout := TLayout.Create(Self);
      Layout.Parent := ContentLayout.Parent;
      Layout.Stored := False;
      Layout.Locked := True;
      Layout.Align := Align;
      Result := True;
    end;
  end;

var
  SelectionControl: TControl;
  LDisableAlign: Boolean;
  StyleObject: TFmxObject;
  T: TControl;
begin
  inherited;
  LDisableAlign := FDisableAlign;
  try
    FDisableAlign := True;
    if ContentLayout <> nil then
    begin
      ContentLayout.OnPainting := DoContentPaint;

      if ContentLayout.ParentControl <> nil then
      begin
        FContentInsets := ContentLayout.Padding.Rect;
        Inset(FContentInsets, ContentLayout.Margins.Rect);
        Inset(FContentInsets, ContentLayout.ParentControl.Padding.Rect);
        FContentOverlay.Margins.Rect := FContentInsets;
      end;
    end;
    if FindStyleResource<TControl>('selection', FSelection) then
    begin
      FSelectionObjects.UnfocusedSelection := FSelection;
      FSelection.Visible := False;
    end;
    if FindStyleResource<TControl>('focusedselection', FFocusedSelection) then
    begin
      FSelectionObjects.FocusedSelection := FFocusedSelection;
      FFocusedSelection.Visible := False;
    end;
    if (FFocusedSelection = nil) and FindAndCloneStyleResource<TControl>('selection', SelectionControl) then
    begin
      FFocusedSelection := SelectionControl;
      FFocusedSelection.Parent := FSelection.Parent;
      FFocusedSelection.Visible := False;
      FSelection.Opacity := UnfocusedSelectionOpacity;
      FSelectionObjects.FocusedSelection := FFocusedSelection;
    end;
    if FindStyleResource<TControl>('extendedselection', FExtendedSelection) then
      FExtendedSelection.Visible := False;
    if (FExtendedSelection = nil) and FindAndCloneStyleResource<TControl>('selection', SelectionControl) then
    begin
      FExtendedSelection := SelectionControl;
      FExtendedSelection.Parent := FSelection.Parent;
      FExtendedSelection.Opacity := ExtendedSelectionOpacity;
      FExtendedSelection.Visible := False;
    end;
    StyleObject := FindStyleResource('AlternatingRowBackground');
    if StyleObject is TBrushObject then
      FOddFill.Assign(TBrushObject(StyleObject).Brush);
    if StyleObject is TControl then
      TControl(StyleObject).Visible := False;

    if FindStyleResource<TControl>('header', T) or CreateLayout(TAlignLayout.Top, T) then
    begin
      FHeaderCompartment.TagObject := T;
      T.Height := FHeaderCompartment.Height;
      T.Visible := FHeaderCompartment.Visible;
      FHeaderCompartment.Margins.Rect := FContentOverlay.Margins.Rect;
    end;

    if FindStyleResource<TControl>('footer', T) or CreateLayout(TAlignLayout.Bottom, T) then
    begin
      FFooterCompartment.TagObject := T;
      T.Height := FFooterCompartment.Height;
      T.Visible := FFooterCompartment.Visible;
      FFooterCompartment.Margins.Rect := FContentOverlay.Margins.Rect;
    end;

    UpdateSelection;
    UpdateStickyHeader;
  finally
    FDisableAlign := LDisableAlign;
  end;
  Realign;
end;

procedure TAlephCustomListBox.FreeStyle;
begin
  inherited;
  FSelectionObjects.UnfocusedSelection := nil;
  FSelectionObjects.FocusedSelection := nil;
  FSelection := nil;
  FExtendedSelection := nil;
  FFocusedSelection := nil;
  if (FHeaderCompartment.TagObject is TLayout) and (TLayout(FHeaderCompartment.TagObject).Owner = Self) then
    TLayout(FHeaderCompartment.TagObject).DisposeOf;
  FHeaderCompartment.TagObject := nil;
  if (FFooterCompartment.TagObject is TLayout) and (TLayout(FFooterCompartment.TagObject).Owner = Self) then
    TLayout(FFooterCompartment.TagObject).DisposeOf;
  FFooterCompartment.TagObject := nil;
  BeginUpdate;
  try
    FSelectionObjects.ClearPools;
  finally
    EndUpdate;
  end;
end;

procedure TAlephCustomListBox.CalcSelectionRects(const SelRects: TList<TRectF>);
var
  JoinedRect: TRectF;
  P: TPointF;
  R: TRectF;
  I, J: Integer;
  Item: TAlephListBoxItem;
begin
  for I := FFirstVisibleItem to FLastVisibleItem - 1 do
  begin
    Item := ItemByIndex(I);
    if (Item <> nil) and Item.IsSelected then
    begin
      P := Item.LocalToAbsolute(TPointF.Zero);
      if Selection.ParentControl <> nil then
        P := Selection.ParentControl.AbsoluteToLocal(P);
      R := TRectF.Create(P, Item.Width, Item.Height);
      JoinedRect := TRectF.Empty;
      if (SelRects.Count > 0) and (I > 0) and ItemByIndex(I - 1).IsSelected then
        JoinedRect := UnionRect(R, SelRects[SelRects.Count - 1]);
      if (SelRects.Count > 0) and SameValue(JoinedRect.Height, R.Height, TEpsilon.Position) then
        SelRects[SelRects.Count - 1] := JoinedRect
      else
        SelRects.Add(R);
    end;
  end;
  I := 0;
  while I <= SelRects.Count - 2 do
  begin
    for J := I + 1 to SelRects.Count - 1 do
    begin
      if SameValue(SelRects[I].Left, SelRects[J].Left, TEpsilon.Position) and
        SameValue(SelRects[I].Right, SelRects[J].Right, TEpsilon.Position) and
        SameValue(SelRects[I].Bottom, SelRects[J].Top, TEpsilon.Position) then
      begin
        SelRects[I] := UnionRect(SelRects[I], SelRects[J]);
        SelRects.Delete(J);
        Dec(I);
        Break;
      end;
    end;
    Inc(I);
  end;
end;

procedure TAlephCustomListBox.UpdateSelection;
var
  P: TPointF;
  R: TRectF;
  Item: TAlephListBoxItem;
  SelRects: TList<TRectF>;
begin
  if (Selection = nil) or IsUpdating then
    Exit;

  // To avoid component deletion during loading
  if (Owner <> nil) and (csLoading in Owner.ComponentState) then
    Exit;

  BeginUpdate;
  try
    // calc rects
    SelRects := TList<TRectF>.Create;
    try
      CalcSelectionRects(SelRects);
      FSelectionObjects.Realign(SelRects);
    finally
      SelRects.Free;
    end;

    if (MultiSelectStyle = TMultiSelectStyle.Extended) and (0 <= ItemIndex) and (ItemIndex < Count) then
    begin
      Item := ItemByIndex(ItemIndex);
      P := Item.LocalToAbsolute(TPointF.Zero);
      if FExtendedSelection.ParentControl <> nil then
        P := FExtendedSelection.ParentControl.AbsoluteToLocal(P);
      R := TRectF.Create(P, Item.Width, Item.Height);
      FExtendedSelection.BoundsRect := R;
      FExtendedSelection.Visible := True;
      FExtendedSelection.BringToFront;
    end
    else
      FExtendedSelection.Visible := False;
  finally
    EndUpdate;
  end;
end;

function TAlephCustomListBox.CompareItems(const Item1, Item2: TAlephListBoxItem): Integer;
begin
  Result := CompareText(Item1.Text, Item2.Text);
  if Assigned(FOnCompare) then
    FOnCompare(Item1, Item2, Result);
end;

procedure TAlephCustomListBox.UpdateGroups;
begin
  FUpdateGroupsRequested := True;
end;

procedure TAlephCustomListBox.ReadMultiSelect(Reader: TReader);
var
  Value: Boolean;
begin
  Value := Reader.ReadBoolean;
  if Value then
    MultiSelectStyle := TMultiSelectStyle.Default
  else
    MultiSelectStyle := TMultiSelectStyle.None;
end;

procedure TAlephCustomListBox.RealUpdateGroups;
type
  TState = (GroupStart, InGroup, GroupEnd);
const
  NextState: array[TState] of TState = (TState.InGroup, TState.GroupEnd, TState.GroupStart);
var
  Item, GroupLast: TAlephListBoxItem;
  State: TState;
  Group: TGroup;
  Headers: Integer;

  procedure SelectBackground(const Item: TAlephListBoxItem; const Shape: TAlephListBoxItem.TBackgroundShape);
  begin
    if FGroupingKind = TListGroupingKind.Grouped then
      Item.SelectBackground(Shape)
    else
      Item.SelectBackground(TAlephListBoxItem.TBackgroundShape.SeparatorBottom)
  end;

  procedure EndGroup(const Item: TAlephListBoxItem; const GroupLength: Integer);
  begin
    if GroupLength = 1 then
      SelectBackground(Item, TAlephListBoxItem.TBackgroundShape.RoundAll)
    else
      SelectBackground(Item, TAlephListBoxItem.TBackgroundShape.RoundBottom);
  end;

begin
  if not FUpdateGroupsRequested then
    Exit;
  Group := TGroup.Create(0, 0);
  BeginUpdate;
  try
    Headers := 0;
    GroupLast := nil;
    State := Low(TState);
    FGroups.Clear;
    for Item in TControlsFilter<TAlephListBoxItem>.Filter(Content.Controls) do
    begin
      if not Item.Visible then
        Continue;
      if Item is TListBoxSeparatorItem then
      begin
        if State = TState.InGroup then
        begin
          EndGroup(GroupLast, Group.Length - Headers);
          FGroups.Add(Group);
        end;

        State := TState.GroupStart;
        Group := TGroup.Create(Item.Index, 1);
        Headers := 1;
        Continue;
      end;

      case State of
        TState.GroupStart:
          begin
            SelectBackground(Item, TAlephListBoxItem.TBackgroundShape.RoundTop);
            Inc(Group.Length);
            State := NextState[State];
          end;
        TState.InGroup:
          begin
            Inc(Group.Length);
            SelectBackground(Item, TAlephListBoxItem.TBackgroundShape.Sharp);
          end;
        TState.GroupEnd:
          begin
            Inc(Group.Length);
            EndGroup(GroupLast, Group.Length);
            FGroups.Add(Group);
            State := NextState[State];
          end;
      end;
      GroupLast := Item;
    end;

    if State = TState.InGroup then
    begin
      EndGroup(GroupLast, Group.Length - Headers);
      FGroups.Add(Group);
    end;

    FUpdateGroupsRequested := False;
  finally
    EndUpdate;
  end;
end;


procedure TAlephCustomListBox.ContentAddObject(const AObject: TFmxObject);
begin
  if not (AObject is TAlephListBoxItem) then
  begin
    if Supports(AObject, IListBoxHeaderTrait) then
    begin
      FHeaderCompartment.AddObject(AObject);
      Realign;
    end
    else
      FNoItemsContent.AddObject(AObject)
  end
  else
  begin
    UpdateGroups;
    if not TAlephListBoxItem(AObject).IsInflated then
      FToInflate.Add(TAlephListBoxItem(AObject));
    inherited;
    if not IsUpdating then
      UpdateVisibleItems;
  end;
end;

procedure TAlephCustomListBox.ContentInsertObject(Index: Integer; const AObject: TFmxObject);
begin
  if not (AObject is TAlephListBoxItem) then
  begin
    if Supports(AObject, IListBoxHeaderTrait) then
    begin
      FHeaderCompartment.AddObject(AObject);
      Realign;
    end
    else
      FNoItemsContent.InsertObject(Index, AObject)
  end
  else
  begin
    if ItemIndex >= Index then
      SelectionController.SetCurrent(ItemIndex + 1);
    UpdateGroups;
    if not TAlephListBoxItem(AObject).IsInflated then
      FToInflate.Add(TAlephListBoxItem(AObject));
    inherited;
    if not IsUpdating then
      UpdateVisibleItems;
  end;
end;

procedure TAlephCustomListBox.ContentBeforeRemoveObject(AObject: TFmxObject);
begin
  inherited;
  if AObject is TAlephListBoxItem then
  begin
    // TAlephListBoxItem.Index can be expensive so check ItemIndex before calling it
    if (ItemIndex > 0) and (ItemIndex > TAlephListBoxItem(AObject).Index) then
    begin
      SelectionController.SetCurrent(ItemIndex - 1);
      UpdateSelection;
    end;
    TAlephListBoxItem(AObject).IsSelected := False;
    FToInflate.Remove(TAlephListBoxItem(AObject));
  end;
end;

procedure TAlephCustomListBox.ContentRemoveObject(const AObject: TFmxObject);
begin
  inherited;
  if AObject is TAlephListBoxItem then
  begin
    UpdateGroups;
    if not IsUpdating then
      UpdateVisibleItems;
  end;
end;

function TAlephCustomListBox.GetInflatableItems: TList<TAlephListBoxItem>;
begin
  Result := FToInflate;
end;

function TAlephCustomListBox.GetBorderHeight: Single;
begin
  ApplyStyleLookup;
  if ContentLayout = nil then
    Result := 0
  else
    Result := Height - ConvertLocalPointFrom(ContentLayout, TPointF.Create(0, ContentLayout.Height)).Y +
              ConvertLocalPointFrom(ContentLayout, TPointF.Zero).Y;
end;

function TAlephCustomListBox.DoCalcContentBounds: TRectF;
  procedure Align(const Row: array of TAlephListBoxItem; const Count: Integer;
    const X0, Y0, XMul, YMul, ColWidth, RowHeight: Single);
  var
    I: Integer;
  begin
    for I := 0 to Count - 1 do
      Row[I].SetBounds(X0 + Row[I].Margins.Left + (I * XMul), Y0 + Row[I].Margins.Top  + (I * YMul),
        ColWidth  - Row[I].Margins.Left - Row[I].Margins.Right, RowHeight - Row[I].Margins.Bottom - Row[I].Margins.Top);
  end;

  function GetNewHeightForItem(const Item: TAlephListBoxItem): Single;
  begin
    if FItemHeight <> 0 then
      Result := FItemHeight
    else
      if Item.Size.PlatformDefault and (Item.AdjustType in [TAdjustType.None, TAdjustType.FixedWidth]) then
        Result := Item.GetDefaultSize.Height
      else
        Result := Item.Height;
  end;

var
  R: TRectF;
  J: Integer;
  RowHeight, ColWidth, CurY: Single;
  W, H: Single;
  LItem: TAlephListBoxItem;
  Row: array of TAlephListBoxItem;
  VisibleItems: TEnumerable<TAlephListBoxItem>;
begin
  Result := LocalRect;
  if (FUpdating > 0) or (ContentLayout = nil) then
    Exit;

  R := ContentLayout.LocalRect;
  { FContent }
  if Content <> nil then
  begin
    { Sort if needed }
    SortItems;
    { Set Selection }
    if (MultiSelectStyle = TMultiSelectStyle.None) and (Selected <> nil) then
      Selected.SetIsSelectedInternal(True, False);

    VisibleItems := TControlsFilter<TAlephListBoxItem>.Filter(Content.Controls, function(C: TAlephListBoxItem): Boolean
      begin
        Result := C.Visible;
      end);
    { Align }
    case FListStyle of
      TListStyle.Vertical:
        begin
          { find number of columns and their width }
          if FItemWidth <> 0 then
          begin
            FColumns := Max(1, Trunc(R.Width / FItemWidth));
            ColWidth := FItemWidth
          end
          else
            ColWidth := Trunc(R.Width / FColumns);

          CurY := 0;
          J := 0;
          RowHeight := 0;
          SetLength(Row, FColumns);
          for LItem in VisibleItems do
          begin
            H := GetNewHeightForItem(LItem);
            RowHeight := Max(RowHeight, H + LItem.Margins.Top + LItem.Margins.Bottom);
            Row[J] := LItem;
            Inc(J);
            if J = FColumns then
            begin
              Align(Row, J, 0, CurY, ColWidth, 0, ColWidth, RowHeight);
              CurY := CurY + RowHeight;
              J := 0;
              RowHeight := 0;
            end;
          end;
          if J > 0 then       // align the last row
          begin
            Align(Row, J, 0, CurY, ColWidth, 0, ColWidth, RowHeight);
            CurY := CurY + RowHeight;
          end;
          if CurY > 0 then
            R.Bottom := R.Top + CurY;
          if FItemWidth <> 0 then
            R.Right := R.Left + (FItemWidth * FColumns);
        end;
      TListStyle.Horizontal:
        begin
          { correct items size }
          if FItemHeight <> 0 then
          begin
            FColumns := Max(1, Trunc(R.Height / FItemHeight));
            RowHeight := FItemHeight
          end
          else
            RowHeight := (R.Bottom - R.Top) / FColumns;
          J := 0;
          ColWidth := 0;
          CurY := 0;
          SetLength(Row, FColumns);
          for LItem in VisibleItems do
          begin
            if FItemWidth <> 0 then
              W := FItemWidth
            else
              W := LItem.Width;
            ColWidth := Max(ColWidth, W + LItem.Margins.Left + LItem.Margins.Right);
            Row[J] := LItem;
            Inc(J);
            if J = FColumns then
            begin
              Align(Row, J, CurY, 0, 0, RowHeight, ColWidth, RowHeight);
              CurY := CurY + ColWidth;
              J := 0;
              ColWidth := 0;
            end;
          end;
          if J > 0 then
          begin
            Align(Row, J, CurY, 0, 0, RowHeight, ColWidth, RowHeight);
            CurY := CurY + ColWidth;
          end;

          if CurY > 0 then
            R.Right := R.Left + CurY;
          if FItemHeight <> 0 then
            R.Bottom := R.Top + (FItemHeight * FColumns);
        end;
    end;
  end;
  UpdateVisibleItems;
  UpdateSelection;
  UpdateStickyHeader;
  Result := R;
end;

procedure TAlephCustomListBox.UpdateVisibleItems;
var
  I, Mid, First, Last: Integer;
  R: TRectF;
  H: Single;
  OldFirstVisibleItem: Integer;
  OldLastVisibleItem: Integer;
begin
  OldFirstVisibleItem := Min(FFirstVisibleItem, Content.ControlsCount);
  OldLastVisibleItem := Min(FLastVisibleItem, Content.ControlsCount);

  FFirstVisibleItem := -1;
  FLastVisibleItem := -1;
  if (Content <> nil) and (Content.ControlsCount > 0) then
  begin
    { Calc dimension }
    First := 0;
    Last := Content.ControlsCount;

    while First < Last do
    begin
      Mid := First + (Last - First) div 2;
      if not ListItems[Mid].Visible then
        Break;
      R := ListItems[Mid].AbsoluteRect;
      if ContentLayout <> nil then
        R := ContentLayout.AbsoluteToLocal(R);
      if R.Bottom < 0 then
        First := Mid + 1
      else if R.Top >= ClientHeight then
        Last := Mid
      else
        Break;
    end;

    { Check each }
    for I := First to Last - 1 do
    begin
      if not ListItems[I].Visible then
        Continue;

      R := ListItems[I].AbsoluteRect;
      if ContentLayout <> nil then
        R := ContentLayout.AbsoluteToLocal(R);
      if ListStyle = TListStyle.Vertical then
      begin
        if (FFirstVisibleItem < 0) and (R.Bottom >= 0) then
          FFirstVisibleItem := I;
        if (FLastVisibleItem < 0) and (R.Top >= Height) then
        begin
          FLastVisibleItem := I;
          Break;
        end;
      end
      else
      begin
        if (FFirstVisibleItem < 0) and (R.Right >= 0) then
          FFirstVisibleItem := I;
        if (FLastVisibleItem < 0) and (R.Left >= Width) then
        begin
          FLastVisibleItem := I;
          Break;
        end;
      end;
    end;
    if FFirstVisibleItem < 0 then
      FFirstVisibleItem := First;
    if FLastVisibleItem < 0 then
      FLastVisibleItem := Last;
  end
  else
  begin
    FFirstVisibleItem := 0;
    FLastVisibleItem := 0;
  end;
  { Disappear invisible - need optimization }
  if (Content <> nil) and (Content.ControlsCount > 0) then
  begin
    if FFirstVisibleItem > OldLastVisibleItem then
      for I := OldFirstVisibleItem to OldLastVisibleItem - 1 do
        ListItems[I].Disappear;
    if FLastVisibleItem < OldFirstVisibleItem then
      for I := OldFirstVisibleItem to OldLastVisibleItem - 1 do
        ListItems[I].Disappear;
    if (FFirstVisibleItem >= OldFirstVisibleItem) and (FFirstVisibleItem < OldLastVisibleItem) then
      for I := OldFirstVisibleItem to FFirstVisibleItem - 1 do
        ListItems[I].Disappear;
    if (FLastVisibleItem >= OldFirstVisibleItem) and (FLastVisibleItem < OldLastVisibleItem) then
      for I := FLastVisibleItem to OldLastVisibleItem - 1 do
        ListItems[I].Disappear;
  end;

  TListBoxContent(Content).RecalcUpdateRect;
  { }
  H := Content.Height;
  if H = 0 then H := 1;
  FNoItemsContent.SetBounds(Content.Position.X, Content.Position.Y, Content.Width, H);
end;


procedure TAlephCustomListBox.UpdateStickyHeader;
var
  G: Integer;
  Header, HeaderClone, Item: TAlephListBoxItem;
  I: Integer;
  R, RH: TRectF;
begin
  if (FContentOverlay = nil) or (csDesigning in ComponentState) then
    Exit;

  if FGroupingKind = TListGroupingKind.Grouped then
  begin
    FContentOverlay.Visible := False;
    TListBoxContent(Content).ClipOffset := 0;
    Exit;
  end;

  // Ensure that groups are updated if there are pending changes
  RealUpdateGroups;

  G := FGroups.FindGroup(FFirstVisibleItem);
  HeaderClone := nil;

  if (G <> -1) and (FGroups[G].First <> -1) and (FGroups[G].Length > 0) then
  begin
    Header := ListItems[FGroups[G].First];
    if (Header <> nil) and (Header is TAlephListBoxGroupHeader) then
    begin
      if FContentOverlay.ChildrenCount > 0 then
        HeaderClone := TAlephListBoxItem(FContentOverlay.Children[0]);

      if (HeaderClone = nil) or (HeaderClone.Owner <> Header) then
      begin
        FContentOverlay.BeginUpdate;
        try
          FContentOverlay.DeleteChildren;
          HeaderClone := TAlephListBoxItem(Header.Clone(Header));
          TAlephListBoxGroupHeader(Header).CloneRef := TAlephListBoxGroupHeader(HeaderClone);
          HeaderClone.Locked := True;
          HeaderClone.Stored := False;
          HeaderClone.Text := Header.Text; // Clone ignores default values
          HeaderClone.Size.SetSizeWithoutNotification(Header.Size.Size);
          HeaderClone.Parent := FContentOverlay;
        finally
          FDisableAlign := True;
          FContentOverlay.EndUpdate;
          FDisableAlign := False;
        end
      end
      else
        HeaderClone.SetBounds(HeaderClone.Position.X, HeaderClone.Position.Y, Header.Width, Header.Height);
      HeaderClone.Position.Y := HeaderClone.Margins.Top;
      HeaderClone.Position.X := HeaderClone.Margins.Left;
    end
    else
      FContentOverlay.DeleteChildren;
  end;

  if HeaderClone <> nil then
  begin
    RH := HeaderClone.AbsoluteRect;

    for I := FFirstVisibleItem to FLastVisibleItem do
    begin
      Item := ListItems[I];
      if Item is TAlephListBoxGroupHeader then
      begin
        if HeaderClone.Owner <> Item then
        begin
          R := Item.AbsoluteRect;
          if R.Top - RH.Bottom < 0 then
          begin
            HeaderClone.Position.Y := R.Top - RH.Bottom;
            Break;
          end;
        end;
      end;
    end;
  end;
  if (HeaderClone <> nil) and (ViewportPosition.Y >= 0) then
  begin
    FContentOverlay.Visible := True;
    TListBoxContent(Content).ClipOffset := HeaderClone.BoundsRect.Bottom;
  end
  else
  begin
    FContentOverlay.Visible := False;
    TListBoxContent(Content).ClipOffset := 0;
  end;
end;

function TAlephCustomListBox.GetCount: Integer;
begin
  Result := Content.ControlsCount;
end;

function TAlephCustomListBox.ItemByIndex(const Idx: Integer): TAlephListBoxItem;
var
  Obj: TFmxObject;
begin
  if (Idx >= 0) and (Idx < Content.ControlsCount) then
  begin
    Obj := Content.Controls[Idx];
    Result := TAlephListBoxItem(Obj)
  end
  else
    Result := nil;
end;

function TAlephCustomListBox.ItemByPoint(const X, Y: Single): TAlephListBoxItem;
var
  I: Integer;
  P: TPointF;
  LItem: TAlephListBoxItem;
begin
  P := LocalToAbsolute(TPointF.Create(X, Y));
  for I := FFirstVisibleItem to FLastVisibleItem - 1 do
  begin
    LItem := ItemByIndex(I);
    if not LItem.Visible then
      Continue;
    if LItem.PointInObject(P.X, P.Y) then
      Exit(LItem);
  end;
  Result := nil;
end;

procedure TAlephCustomListBox.KeyDown(var Key: Word; var KeyChar: System.WideChar; Shift: TShiftState);
var
  I: Integer;
  LItemIndex: Integer;
  LChanged: Boolean;
begin
  LItemIndex := ItemIndex;
  if Observers.IsObserving(TObserverMapping.EditLinkID) then
    if (KeyChar > ' ') or (Key in [vkHome, vkEnd, vkUp, vkDown, vkRight, vkLeft]) then
      if TLinkObservers.EditLinkIsReadOnly(Observers) then
        Exit
      else
        if not TLinkObservers.EditLinkEdit(Observers) then
          Exit;
  inherited;
  if Count > 0 then
  begin
    if KeyChar <> #0 then
    begin
      if KeyChar = #32 then
      begin
        if (Selected <> nil) and ShowCheckboxes then
          Selected.IsChecked := not Selected.IsChecked
        else
          SelectionController.KeyboardSelect(TAlephListBoxSelector.TKeyAction.Toggle, Shift, ItemByIndex(ItemIndex));
      end
      else
        for I := 0 to Count - 1 do
          if (ItemByIndex(I).Text <> '') and (string(ItemByIndex(I).Text.Chars[0]).ToLower = string(KeyChar).ToLower) then
          begin
            LItemIndex := I;
            Break;
          end;
      KeyChar := #0;
    end;
    case Key of
      vkF8:
        if (ssShift in Shift) and (MultiSelectStyle <> TMultiSelectStyle.None) then
          if MultiSelectStyle = TMultiSelectStyle.Default then
            MultiSelectStyle := TMultiSelectStyle.Extended
          else
            MultiSelectStyle := TMultiSelectStyle.Default;
      vkHome:
        LItemIndex := 0;
      vkEnd:
        LItemIndex := Count - FColumns;
      vkUp:
        if ItemIndex > 0 then
        begin
          LItemIndex := LItemIndex - FColumns;
          if LItemIndex < 0 then
            LItemIndex := 0;
        end;
      vkDown:
        begin
          if LItemIndex < Count - 1 then
            LItemIndex := LItemIndex + FColumns;
          if LItemIndex > Count - 1 then
            LItemIndex := Count - 1;
        end;
      vkLeft:
        if LItemIndex > 0 then
          LItemIndex := ItemIndex - 1;
      vkRight:
        if LItemIndex < Count - 1 then
          LItemIndex := LItemIndex + 1;
      vkPrior:
        begin
          if LItemIndex > 0 then
            LItemIndex := LItemIndex - (FLastVisibleItem - FFirstVisibleItem);
          if LItemIndex < 0 then
            LItemIndex := 0;
        end;
      vkNext:
        begin
          if LItemIndex < Count - 1 then
            LItemIndex:= LItemIndex + (FLastVisibleItem - FFirstVisibleItem);
          if LItemIndex > Count - 1 then
            LItemIndex := Count - 1;
        end
    else
      Exit;
    end;
    LChanged := LItemIndex <> ItemIndex;
    if LChanged then
    begin
      TLinkObservers.PositionLinkPosChanging(Observers);

      SelectionController.KeyboardSelect(TAlephListBoxSelector.TKeyAction.Move, Shift, ItemByIndex(LItemIndex));
      UpdateSelection;
      ScrollToItem(ItemByIndex(LItemIndex));
    end;
    if LChanged then
      TLinkObservers.ListSelectionChanged(Observers);
    Key := 0;
  end;
end;

function TAlephCustomListBox.FirstSelectedItemFrom(const Item: TAlephListBoxItem): TAlephListBoxItem;
var
  I: Integer;
begin
  Result := Item;
  if MultiSelectStyle <> TMultiSelectStyle.None then
  begin
    for I := Item.Index downto 0 do
      if ItemByIndex(I).IsSelected then
        Result := ItemByIndex(I)
      else
        Break;
  end;
end;

function TAlephCustomListBox.LastSelectedItemFrom(const Item: TAlephListBoxItem): TAlephListBoxItem;
var
  I: Integer;
begin
  Result := Item;
  if MultiSelectStyle <> TMultiSelectStyle.None then
  begin
    for I := Item.Index to Count - 1 do
      if ItemByIndex(I).IsSelected then
        Result := ItemByIndex(I)
      else
        Break;
  end;
end;

procedure TAlephCustomListBox.Loaded;
begin
  inherited;
  ImagesChanged;
end;

function TAlephCustomListBox.GetFirstSelect: TAlephListBoxItem;
begin
  Result := ItemByIndex(FSelector.GetFirst);
end;

procedure TAlephCustomListBox.PerformInternalDrag;
var
  Screenshot: TBitmap;
begin
  Screenshot := ItemDown.MakeScreenshot;
  try
    AniCalculations.MouseLeave;
    Root.BeginInternalDrag(Selected, Screenshot);
  finally
    Screenshot.Free;
  end;
end;

procedure TAlephCustomListBox.MouseClick(Button: TMouseButton; Shift: TShiftState; X,
  Y: Single);
var
  P: TPointF;
begin
  inherited;
  if FClickEnable then
  begin
    if ItemDown <> nil then
    begin
      P := TPointF.Create(X, Y);
      P := ItemDown.ScreenToLocal(LocalToScreen(P));
      ItemDown.MouseClick(Button, Shift, P.X, P.Y);
    end;
  end;
end;

procedure TAlephCustomListBox.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Single);
var
  LItemIndex: Integer;
  P: TPointF;
  LItemDown: TAlephListBoxItem;
begin
  FClickEnable := (Button = TMouseButton.mbLeft) and (AniCalculations.LowVelocity or (AniCalculations.TouchTracking = []));
  LItemIndex := ItemIndex;
  if Observers.IsObserving(TObserverMapping.EditLinkID) then
    if not TLinkObservers.EditLinkEdit(Observers) then
      Exit;

  inherited;
  if not FClickEnable then
    Exit;

  ItemDown := ItemByPoint(X, Y);
  if ItemDown <> nil then
  begin
    LItemDown := ItemDown;
    if LItemDown.Index <> ItemIndex then
      TLinkObservers.PositionLinkPosChanging(Observers);
    P := LItemDown.ScreenToLocal(LocalToScreen(TPointF.Create(X, Y)));
    LItemDown.MouseDown(Button, Shift, P.X, P.Y);
    if Button = TMouseButton.mbLeft then
      if AllowDrag and (MultiSelectStyle = TMultiSelectstyle.None) and (LItemIndex = LItemDown.Index) then
        PerformInternalDrag
      else
        SelectionController.MouseSelectActive := True;
    SelectionController.MouseSelectStart(LItemDown, Button, Shift);
  end;

  if LItemIndex <> ItemIndex then
    TLinkObservers.ListSelectionChanged(Observers);
end;

procedure TAlephCustomListBox.MouseMove(Shift: TShiftState; X, Y: Single);
var
  Item: TAlephListBoxItem;
  LItemIndex: Integer;
  P: TPointF;
begin
  LItemIndex := ItemIndex;
  inherited;
  Item := ItemByPoint(X, Y);
  if Item <> nil then
  begin
    P := Item.ScreenToLocal(LocalToScreen(TPointF.Create(X, Y)));
    Item.MouseMove(Shift, P.X, P.Y);
    if SelectionController.MouseSelectActive then
    begin
      if Observers.IsObserving(TObserverMapping.EditLinkID) then
        if not TLinkObservers.EditLinkEdit(Observers) then
          Exit;
      TLinkObservers.PositionLinkPosChanging(Observers);
      SelectionController.MouseSelectMove(Item, Shift);
      if ItemIndex <> LItemIndex then
        TLinkObservers.ListSelectionChanged(Observers);
    end;
  end;
end;

procedure TAlephCustomListBox.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Single);
var
  Item: TAlephListBoxItem;
  P: TPointF;
begin
  inherited;
  try
    if (not AniCalculations.Moved) and FClickEnable then
    begin
      Item := ItemByPoint(X, Y);
      if (Item <> nil) and (Item = ItemDown) then
      begin
        if Item.Index <> ItemIndex then
          TLinkObservers.PositionLinkPosChanging(Observers);

        FSelector.MouseSelectFinishing(Item, Button, Shift);
        if Assigned(OnItemClick) then
        try
          OnItemClick(Self, Item);
        except
          on E: Exception do
            Application.HandleException(E);
        end;
        FSelector.MouseSelectFinish(Item, Button, Shift);
        TLinkObservers.ListSelectionChanged(Observers);

        P := Item.ScreenToLocal(LocalToScreen(TPointF.Create(X, Y)));
        Item.MouseUp(Button, Shift, P.X, P.Y);
      end;
    end;
  finally
    FClickEnable := False;
    SelectionController.MouseSelectActive := False;
    ItemDown := nil;
  end;
end;

procedure TAlephCustomListBox.NotifyInflated;
begin
  RealignContent;
  UpdateGroups;
  UpdateStickyHeader;
end;

procedure TAlephCustomListBox.Painting;
begin
  inherited;
  RealUpdateGroups;
  FBeingPainted := True;
  FRealignRequested := False;
end;

procedure TAlephCustomListBox.AfterPaint;
begin
  inherited;
  FBeingPainted := False;
  if FRealignRequested then
    Realign;
  FRealignRequested := False;
end;

function TAlephCustomListBox.CanObserve(const ID: Integer): Boolean;
begin
  Result := False;
  if ID = TObserverMapping.EditLinkID then
    Result := True
  else if ID = TObserverMapping.PositionLinkID then
    Result := True
  else if ID = TObserverMapping.ControlValueID then
    Result := True;
end;

function TAlephCustomListBox.GetSelected: TAlephListBoxItem;
begin
  Result := ItemByIndex(ItemIndex);
end;

procedure TAlephCustomListBox.ScrollToItem(const Item: TAlephListBoxItem);
begin
  if (Item <> nil) and (Content <> nil) and (ContentLayout <> nil) then
  begin
    if VScrollBar <> nil then
    begin
      if Content.Position.Y + Item.Position.Y + Item.Margins.Top + Item.Margins.Bottom + Item.Height >
        ContentLayout.Position.Y + ContentLayout.Height then
        VScrollBar.Value := VScrollBar.Value + (Content.Position.Y + Item.Position.Y + Item.Margins.Top +
          Item.Margins.Bottom + Item.Height - ContentLayout.Position.Y - ContentLayout.Height);
      if Content.Position.Y + Item.Position.Y < ContentLayout.Position.Y then
        VScrollBar.Value := VScrollBar.Value + Content.Position.Y + Item.Position.Y - ContentLayout.Position.Y;
    end;
    if HScrollBar <> nil then
    begin
      if Content.Position.X + Item.Position.X + Item.Margins.Left + Item.Margins.Right + Item.Width >
        ContentLayout.Position.X + ContentLayout.Width then
        HScrollBar.Value := HScrollBar.Value + (Content.Position.X + Item.Position.X + Item.Margins.Left +
          Item.Margins.Right + Item.Width - ContentLayout.Position.X - ContentLayout.Width);
      if Content.Position.X + Item.Position.X < 0 then
        HScrollBar.Value := HScrollBar.Value + Content.Position.X + Item.Position.X - ContentLayout.Position.X;
    end;
  end;
end;

procedure TAlephCustomListBox.SetItemIndex(const Value: Integer);

  function Loading: Boolean;
  begin
    Result := ([csLoading, csReading] * ComponentState <> []) or
      ((Owner <> nil) and ([csLoading, csReading] * Owner.ComponentState <> []))
  end;

var
  Item: TAlephListBoxItem;
begin
  if SelectionController.GetCurrent <> Value then
  begin
    BeginUpdate;
    try
      SelectionController.UserSetIndex(Value);
      Item := SelectionController.GetCurrentItem;
      if Loading then
        SelectionController.SetCurrent(Value);
      ScrollToItem(Item);
    finally
      EndUpdate;
    end;
    UpdateSelection;
    if (FUpdating = 0) and not Loading then
    begin
      Repaint;
      DoChange;
    end;
  end;
end;

function TAlephCustomListBox.GetItemIndex: Integer;
begin
  if SelectionController <> nil then
    Result := SelectionController.GetCurrent
  else
    Result := -1;
end;

procedure TAlephCustomListBox.SetItems(const Value: TStrings);
begin
  Items.Assign(Value);
end;

procedure TAlephCustomListBox.DoChangeCheck(const Item: TAlephListBoxItem);
begin
  if Assigned(FOnChangeCheck) then
    FOnChangeCheck(Item);
end;

procedure TAlephCustomListBox.DoChange;
begin
  if Assigned(FOnChange) then
    FOnChange(Selected);
end;

procedure TAlephCustomListBox.Clear;
begin
  BeginUpdate;
  try
    RealignContent;
    FToInflate.Clear;
    if Content <> nil then
      Content.DeleteChildren;
    FGroups.Clear;
    SelectionController.SetCurrent(-1);
  finally
    EndUpdate;
  end;
end;

procedure TAlephCustomListBox.SelectRange(const Item1, Item2: TAlephListBoxItem);
begin
  FSelector.SelectRange(Item1, Item2);
end;

procedure TAlephCustomListBox.ClearSelection;
begin
  FSelector.ClearSelection;
end;

procedure TAlephCustomListBox.SelectAll;
begin
  FSelector.SelectAll;
end;

procedure TAlephCustomListBox.DoEndUpdate;
begin
  inherited;
  UpdateVisibleItems;
end;

procedure TAlephCustomListBox.DoEnter;
begin
  inherited;
  FSelectionObjects.IsFocused := True;
  if Selected <> nil then
    UpdateSelection;
end;

procedure TAlephCustomListBox.DoExit;
begin
  inherited;
  FSelectionObjects.IsFocused := False;
  if Selected <> nil then
    UpdateSelection;
  if Observers.IsObserving(TObserverMapping.EditLinkID) then
    if TLinkObservers.EditLinkIsEditing(Observers) then
      TLinkObservers.EditLinkUpdate(Observers);
  if Observers.IsObserving(TObserverMapping.ControlValueID) then
    TLinkObservers.ControlValueUpdate(Observers);
end;

function TAlephCustomListBox.DragChange(const SourceItem, DestItem: TAlephListBoxItem): Boolean;
begin
  Result := (SourceItem <> nil) and (DestItem <> nil);
  if Assigned(FOnDragChange) then
    FOnDragChange(SourceItem, DestItem, Result);
end;

procedure TAlephCustomListBox.DragDrop(const Data: TDragObject; const Point: TPointF);
var
  Dest: TAlephListBoxItem;
  Source: TAlephListBoxItem;
begin
  inherited;
  if FDragItem <> nil then
  begin
    FDragItem.DragLeave;
    FDragItem.RemoveFreeNotify(Self);
    FDragItem := nil;
  end;
  Dest := ItemByPoint(Point.X, Point.Y);
  Source := TAlephListBoxItem(Data.Source);
  if (Dest <> nil) and DragChange(Source, Dest) then
  begin
    SelectionController.SetSelected(Dest, False);
    SelectionController.SetSelected(Source, False);
    Source.Index := Dest.Index;
    SelectionController.SetCurrent(Source.Index);
    SelectionController.SetSelected(Source, True);
  end;
end;

procedure TAlephCustomListBox.DragOver(const Data: TDragObject; const Point: TPointF; var Operation: TDragOperation);
var
  Obj: TAlephListBoxItem;
begin
  inherited;
  if not (Data.Source is TAlephListBoxItem) then
    Exit;

  if Operation = TDragOperation.None then
  begin
    Obj := ItemByPoint(Point.X, Point.Y);
    if Obj <> FDragItem then
    begin
      if FDragItem <> nil then
      begin
        FDragItem.DragLeave;
        FDragItem.RemoveFreeNotify(Self);
      end;
      FDragItem := Obj;
      if FDragItem <> nil then
      begin
        FDragItem.AddFreeNotify(Self);
        FDragItem.DragEnter(Data, Point);
        Operation := TDragOperation.Move;
      end
      else
        Operation := TDragOperation.None;
    end
    else
      Operation := TDragOperation.Move;

    if (FDragItem <> nil) and FDragItem.Equals(Data.Source) then
      Operation := TDragOperation.None;
  end;
end;

procedure TAlephCustomListBox.ItemsExchange(Item1, Item2: TAlephListBoxItem);
var
  Current: Integer;
  S1, S2: Boolean;
begin
  Current := -1;
  if SelectionController.GetCurrent = Item1.Index then
    Current := Item2.Index
  else if SelectionController.GetCurrent = Item2.Index then
    Current := Item1.Index;
  S1 := SelectionController.SetSelected(Item1, False);
  S2 := SelectionController.SetSelected(Item2, False);
  Content.Exchange(Item1, Item2);
  SelectionController.SetSelected(Item1, S1);
  SelectionController.SetSelected(Item2, S2);
  if Current >= 0 then
    SelectionController.SetCurrent(Current);
end;

procedure TAlephCustomListBox.DoAddObject(const AObject: TFmxObject);
begin
  if (Content <> nil) and (AObject is TAlephListBoxItem) then
  begin
    Content.AddObject(AObject);
    TAlephListBoxItem(AObject).SetImages(Images);
  end
  else
    inherited;
end;

procedure TAlephCustomListBox.DoInsertObject(Index: Integer; const AObject: TFmxObject);
begin
  if (Content <> nil) and (AObject is TAlephListBoxItem) then
  begin
    Content.InsertObject(Index, AObject);
    TAlephListBoxItem(AObject).SetImages(Images);
  end
  else
    inherited;
end;

procedure TAlephCustomListBox.IgnoreString(Reader: TReader);
begin
  Reader.ReadString;
end;

function TAlephCustomListBox.IsAddToContent(const AObject: TFmxObject): Boolean;
begin
  Result := inherited IsAddToContent(AObject) and (AObject <> FNoItemsContent)
    and (AObject <> FHeaderCompartment) and (AObject <> FFooterCompartment)
    and (AObject <> FContentOverlay);
end;

function TAlephCustomListBox.ItemsStored: Boolean;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    if ListItems[I].Stored then
      Exit(False);
  Result := True;
end;

function TAlephCustomListBox.IsOpaque: Boolean;
begin
  Result := True;
end;

procedure TAlephCustomListBox.DoRealign;
  procedure Relocate(const C: TControl; const HeadRect, FootRect: TRectF);
  begin
    case C.Align of
      TAlignLayout.Bottom:
        begin
          C.Parent := FFooterCompartment;
          FootRect.Height := FootRect.Height + C.BoundsRect.Height;
        end;
      TAlignLayout.Top:
        begin
          C.Parent := FHeaderCompartment;
          HeadRect.Height := HeadRect.Height + C.BoundsRect.Height;
        end;
    end;
  end;

var
  C, Layout: TControl;
  HeadRect, FootRect: TRectF;
  Inset: Single;
begin
  if FBeingPainted then
  begin
    FRealignRequested := True;
    Exit;
  end;

  if (csDesigning in ComponentState) and (FInflater <> nil) then
  begin
    FDisableAlign := True;
    try
      FInflater.Inflate(True);
    finally
      FDisableAlign := False;
    end;
  end;

  FDisableAlign := True;
  try
    UpdateSelection;
    HeadRect := TRectF.Empty;
    FootRect := TRectF.Empty;

    for C in FHeaderCompartment.Controls do
      if (C.Owner <> nil) and C.Visible then
        Relocate(C, HeadRect, FootRect);
    for C in FFooterCompartment.Controls do
      if (C.Owner <> nil) and C.Visible then
        Relocate(C, HeadRect, FootRect);

    FHeaderCompartment.Height := HeadRect.Height;
    FHeaderCompartment.Visible := HeadRect.Height > 0;
    FFooterCompartment.Height := FootRect.Height;
    FFooterCompartment.Visible := FootRect.Height > 0;

    // Glue compartments together
    Inset := IfThen(FHeaderCompartment.Visible, 0, FContentInsets.Top);
    FHeaderCompartment.Margins.Bottom := Inset;
    FContentOverlay.Margins.Top := Inset;
    Content.Margins.Top := Inset;

    FFooterCompartment.Margins.Top := 0;
    FContentOverlay.Margins.Bottom := 0;
    Content.Margins.Bottom := 0;

    Layout := TControl(FHeaderCompartment.TagObject);
    if Layout <> nil then
    begin
      Layout.Height := FHeaderCompartment.Height;
      Layout.Visible := FHeaderCompartment.Visible;
    end;
    Layout := TControl(FFooterCompartment.TagObject);
    if Layout <> nil then
    begin
      Layout.Height := FFooterCompartment.Height;
      Layout.Visible := FFooterCompartment.Visible;
    end;
  finally
    FDisableAlign := False;
  end;

  inherited;
end;

procedure TAlephCustomListBox.DoRemoveObject(const AObject: TFmxObject);
begin
  if (AObject is TAlephListBoxItem) and (TAlephListBoxItem(AObject).ListBox = Self) then
  begin
    TAlephListBoxItem(AObject).Parent := nil;
    if not (csDestroying in ComponentState) then
      TAlephListBoxItem(AObject).SetImages(nil);
  end
  else
    inherited;
end;

procedure TAlephCustomListBox.SetColumns(const Value: Integer);
begin
  if FColumns <> Value then
  begin
    FColumns := Value;
    if FColumns < 1 then
      FColumns := 1;
    RealignContent;
  end;
end;

procedure TAlephCustomListBox.SetAlternatingRowBackground(const Value: Boolean);
begin
  if FAlternatingRowBackground <> Value then
  begin
    FAlternatingRowBackground := Value;
    Repaint;
  end;
end;

procedure TAlephCustomListBox.SetMultiSelectStyle(const Value: TMultiSelectStyle);
var
  OldSelector: TAlephListBoxSelector;
  OldSelection: TArray<Boolean>;
  I: Integer;
begin
  SetLength(OldSelection, Count);
  for I := 0 to Length(OldSelection) - 1 do
    OldSelection[I] := ListItems[I].IsSelected;

  OldSelector := FSelector;
  FSelector := TListBoxSelectorFactory.CreateSelector(Self, Value);
  if OldSelector <> nil then
    FSelector.CopySelection(OldSelector);
  OldSelector.Free;
  UpdateSelection;

  for I := 0 to Length(OldSelection) - 1 do
    if ListItems[I].IsSelected <> OldSelection[I] then
    begin
      DoChange;
      Break;
    end;
end;

function TAlephCustomListBox.GetMultiSelectStyle: TMultiSelectStyle;
begin
  Result := FSelector.MultiSelectStyle;
end;

function TAlephCustomListBox.GetMultiSelect: Boolean;
begin
  Result := MultiSelectStyle <> TMultiSelectStyle.None;
end;

procedure TAlephCustomListBox.SetMultiSelect(const Value: Boolean);
begin
  if Value then
    MultiSelectStyle := TMultiSelectStyle.Default
  else
    MultiSelectStyle := TMultiSelectStyle.None;
end;

procedure TAlephCustomListBox.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
  begin
    if AComponent = FItemDown then
      FItemDown := nil;
  end;
end;

procedure TAlephCustomListBox.SetItemDown(const Value: TAlephListBoxItem);
begin
  if FItemDown <> Value then
  begin
    if FItemDown <> nil then
      TComponent(FItemDown).RemoveFreeNotification(self);
    FItemDown := Value;
    if FItemDown <> nil then
      TComponent(FItemDown).FreeNotification(self);
  end;
end;

procedure TAlephCustomListBox.SetItemHeight(const Value: Single);
begin
  if FItemHeight <> Value then
  begin
    FItemHeight := Value;
    RealignContent;
  end;
end;

procedure TAlephCustomListBox.SetItemWidth(const Value: Single);
begin
  if FItemWidth <> Value then
  begin
    FItemWidth := Value;
    RealignContent;
  end;
end;

procedure TAlephCustomListBox.SetListStyle(const Value: TListStyle);
begin
  if FListStyle <> Value then
  begin
    FListStyle := Value;
    UpdateAniCalculations;
    RealignContent;
  end;
end;

procedure TAlephCustomListBox.SetShowCheckboxes(const Value: Boolean);
var
  I: Integer;
begin
  if FShowCheckboxes <> Value then
  begin
    FShowCheckboxes := Value;
    BeginUpdate;
    try
      for I := 0 to Count - 1 do
        ItemByIndex(I).UpdateCheck;
    finally
      EndUpdate;
    end;
    Repaint;
  end;
end;

function TAlephCustomListBox.GetListItem(Index: Integer): TAlephListBoxItem;
begin
  Result := ItemByIndex(Index);
end;

procedure TAlephCustomListBox.SetSorted(const Value: Boolean);
begin
  if FSorted <> Value then
  begin
    FSorted := Value;
    SortItems;
    RealignContent;
  end;
end;

procedure TAlephCustomListBox.Show;
begin
  inherited;
  if Visible and HasEffect then
    ApplyStyleLookup;
end;

procedure TAlephCustomListBox.SetAllowDrag(const Value: Boolean);
begin
  if FAllowDrag <> Value then
  begin
    FAllowDrag := Value;
    if FAllowDrag then
      EnableDragHighlight := True;
  end;
end;

function TAlephCustomListBox.GetItem(const AIndex: Integer): TFmxObject;
begin
  Result := ItemByIndex(AIndex);
end;

{ TComboListBox }

constructor TComboListBox.Create(AOwner: TComponent);
begin
  inherited;
  MinClipWidth := 16;
  MinClipHeight := 14;
  if AOwner is TAlephCustomComboBox then
    FComboBox := TAlephCustomComboBox(AOwner);
end;

function TComboListBox.GetDefaultStyleLookupName: string;
begin
  Result := 'listboxstyle';
end;

function TComboListBox.GetObservers: TObservers;
begin
  if FComboBox <> nil then
    Result := FComboBox.Observers
  else
    Result := inherited;
end;

procedure TComboListBox.KeyDown(var Key: Word; var KeyChar: System.WideChar; Shift: TShiftState);
begin
  if not FInKeyDown then
  begin
    FInKeyDown := True;
    try
      if FComboBox <> nil then
        FComboBox.KeyDown(Key, KeyChar, Shift)
      else
        inherited;
    finally
      FInKeyDown := False;
    end;
  end;
end;

procedure TComboListBox.MouseMove(Shift: TShiftState; X, Y: Single);

  function IsItemVisibleInViewport(const AItem: TAlephListBoxItem): Boolean;
  var
    ItemRect: TRectF;
    ContentRect: TRectF;
  begin
    ItemRect := AItem.BoundsRect;
    ContentRect := Content.BoundsRect;
    Result := (Floor(ItemRect.Bottom + ContentRect.Top - Content.Margins.Top) > 0) and
              (Ceil(ItemRect.Top + ContentRect.Top - ClientHeight) <= 0)
  end;

var
  Item: TAlephListBoxItem;
  LItemIndex: Integer;
begin
  inherited;
  Item := ItemByPoint(X, Y);
  if (Item <> nil) and IsItemVisibleInViewport(Item) then
  begin
    if Selected = Item then
      Exit;
    if Observers.IsObserving(TObserverMapping.EditLinkID) then
      if TLinkObservers.EditLinkIsReadOnly(Observers) then
        Exit
      else
        if not TLinkObservers.EditLinkEdit(Observers) then
          Exit;
    TLinkObservers.PositionLinkPosChanging(Observers);
    LItemIndex := ItemIndex;
    if MultiSelectStyle <> TMultiSelectStyle.None then
    begin
      if MultiSelectStyle = TMultiSelectStyle.Default then
      begin
  {$IFDEF MACOS}
        if ssCommand in Shift then
  {$ELSE}
        if ssCtrl in Shift then
  {$ENDIF}
          Item.IsSelected := not Item.IsSelected
        else
          SelectRange(FirstSelectedItem, Item);
        ItemIndex := Item.Index;
      end;
    end
    else
      ItemIndex := Item.Index;
    if LItemIndex <> ItemIndex then
      TLinkObservers.ListSelectionChanged(Observers);
  end;
end;

procedure TComboListBox.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Single);
var
  LItem : TAlephListBoxItem;
  LItemIndex: Integer;
begin
  inherited;
  if (Parent is TPopup) and TPopup(Parent).IsOpen and (FComboBox <> nil) then
  begin
    LItemIndex := ItemIndex;
    if LocalRect.Contains(PointF(X, Y)) then
    begin
      LItem := ItemByPoint(X, Y) ;
      if LItem <> nil then
      begin
        if LItem.Index <> FComboBox.ItemIndex then
          TLinkObservers.PositionLinkPosChanging(Observers);
        if Observers.IsObserving(TObserverMapping.EditLinkID) then
        begin
          if TLinkObservers.EditLinkIsEditing(Observers) then
            FComboBox.ItemIndex := LItem.Index;
        end
        else
          FComboBox.ItemIndex := LItem.Index;
      end;
    end;
    TPopup(Parent).IsOpen := False;
    if LItemIndex <> ItemIndex then
    begin
      TLinkObservers.ListSelectionChanged(Observers);
    end;
  end;
end;

procedure TComboListBox.ContentChanged;
begin
end;

{ TAlephCustomComboBox }

constructor TAlephCustomComboBox.Create(AOwner: TComponent);
var
  PickerService: IFMXPickerService;
begin
  inherited;
  FImageLink := TGlyphImageLink.Create(Self);
  if TPlatformServices.Current.SupportsPlatformService(IFMXPickerService, PickerService) then
  begin
    FListPicker := PickerService.CreateListPicker;
    FListPicker.Parent := Self;
    FListPicker.OnValueChanged := DoOnValueChangedFromDropDownList;
    FListPicker.OnHide := DoClosePicker;
    FListPicker.OnShow := DoPopup;
  end;
  FDropDownKind := TDropDownKind.Custom;
  DropDownCount := 8;
  FItemWidth := 0;
  CanFocus := True;
  FDroppedDown := False;
  FPopup := TPopup.Create(Self);
  FPopup.StyleLookup := 'combopopupstyle';
  FPopup.PlacementTarget := Self;
  FPopup.Stored := False;
  FPopup.Parent := Self;
  FPopup.Locked := True;
  FPopup.DragWithParent := True;
  FPopup.OnClosePopup := DoClosePopup;
  FPopup.OnPopup := DoPopup;
  FListBox := CreateListBox;
  if FListBox = nil then
    raise EArgumentNilException.CreateFmt(SResultCanNotBeNil, ['CreateListBox']);
  FListBox.Parent := Popup;
  FListBox.Stored := False;
  FListBox.Align := TAlignLayout.Client;
  FListBox.ShowCheckboxes := False;
  FListBox.OnStringsChanged := HandleStringsChanged;
  FItemIndex := -1;
  FItemsChanged := True;
  SetAcceptsControls(False);
  Placement := TPlacement.Bottom;
  DropDownKind := TDropDownKind.Native;
end;

function TAlephCustomComboBox.CreateListBox: TComboListBox;
begin
  Result := TComboListBox.Create(Self);
end;

function TAlephCustomComboBox.CanObserve(const ID: Integer): Boolean;
begin
  Result := FListBox.CanObserve(ID);
end;

procedure TAlephCustomComboBox.ApplyStyle;
var
  Content: TControl;
begin
  inherited;
  if FindStyleResource<TControl>('Content', Content) then
  begin
    Content.OnPaint := DoContentPaint;
    UpdateCurrentItem;
  end;
end;

procedure TAlephCustomComboBox.DoRealign;
begin
  Self.Realign;
  if FDisableAlign then
    Exit;
  FDisableAlign := True;
  { FContent }
  if FPopup <> nil then
    FPopup.Width := Width;
  FDisableAlign := False;
end;

procedure TAlephCustomComboBox.DoRemoveObject(const AObject: TFmxObject);
begin
  if AObject is TAlephListBoxItem then
  begin
    FListBox.RemoveObject(AObject);
    FItemsChanged := True;
  end
  else
    inherited;
end;

procedure TAlephCustomComboBox.UpdateCurrentItem;
var
  Content: TControl;
  Item: TAlephListBoxItem;
  NewHeight: Single;
begin
  Item := FListBox.ItemByIndex(ItemIndex);
  if Item <> nil then
  begin
    if FindStyleResource<TControl>('Content', Content) then
    begin
      if Item.Height <> 0 then
        NewHeight := Item.Height
      else if ItemHeight = 0 then
        NewHeight := Content.Height
      else
        NewHeight := ItemHeight;
      Item.SetBounds(Item.Position.X, Item.Position.Y, Item.Width, NewHeight);
      Item.ApplyStyleLookup;
    end;
  end;
end;

procedure TAlephCustomComboBox.DoContentPaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
var
  LOpacity: Single;
  Item: TAlephListBoxItem;
  SaveSize: TPointF;
  SaveScene: IScene;
  SaveSelected: Boolean;
  SaveDisableAlign: Boolean;
begin
  Item := FListBox.ItemByIndex(ItemIndex);
  if Item <> nil then
  begin
    LOpacity := Item.FAbsoluteOpacity;
    SaveSize := TPointF.Create(Item.Width, Item.Height);
    SaveScene := Item.Scene;
    SaveSelected := Item.IsSelected;
    Item.SetNewScene(Scene);
    SaveDisableAlign := FListBox.FDisableAlign;
    try
      FListBox.FDisableAlign := True;
      TOpenObject(Item).Width := ARect.Width;
      TOpenObject(Item).FLastWidth := ARect.Width;
      TOpenObject(Item).Size.Height := ARect.Height;
      TOpenObject(Item).FLastHeight := ARect.Height;
      Item.ApplyStyleLookup;
      Item.FIsSelected := False;
      Item.StartTriggerAnimation(Item, 'IsSelected'); // to correct drawing
      Item.FAbsoluteOpacity := Opacity;
      Item.RecalcOpacity;
      Item.Realign;
      Item.PaintTo(Canvas, ARect, Sender as TFmxObject);
    finally
      Item.SetNewScene(SaveScene);
      Item.FAbsoluteOpacity := LOpacity;
      Item.FRecalcOpacity := False;
      Item.RecalcOpacity;
      // Do not assign directly to FHeight/FWidth, because
      // children sizes have to be updated after Realign
      Item.FIsSelected := SaveSelected;
      Item.StartTriggerAnimation(Item, 'IsSelected');
      Item.Size.Height := SaveSize.Y;
      Item.SetWidth(SaveSize.X);
      TOpenObject(Item).FLastWidth := SaveSize.X;
      TOpenObject(Item).FLastHeight := SaveSize.Y;
      Item.Realign;
      FListBox.FDisableAlign := SaveDisableAlign;
    end;
  end;
end;

procedure TAlephCustomComboBox.DoExit;
begin
  inherited;
  if Observers.IsObserving(TObserverMapping.EditLinkID) then
    if TLinkObservers.EditLinkIsEditing(Observers) then
      TLinkObservers.EditLinkUpdate(Observers);
  if Observers.IsObserving(TObserverMapping.ControlValueID) then
    TLinkObservers.ControlValueUpdate(Observers);
  if (FListPicker <> nil) and (TDropDownKind.Native = DropDownKind) and FListPicker.IsShown then
  begin
    FDroppedDown := False;
    FListPicker.Hide;
  end;
  if TDropDownKind.Custom = DropDownKind then
    FPopup.IsOpen := False;
  StartTriggerAnimation(Self, 'IsMouseOver');
end;

procedure TAlephCustomComboBox.DoInsertObject(Index: Integer; const AObject: TFmxObject);
begin
  if AObject is TAlephListBoxItem then
  begin
    FListBox.DoInsertObject(Index, AObject);
    FItemsChanged := True;
  end
  else
    inherited;
end;

procedure TAlephCustomComboBox.DoOnValueChangedFromDropDownList(Sender: TObject; const AValueIndex: Integer);
var
  LChanged: Boolean;
begin
  if Observers.IsObserving(TObserverMapping.EditLinkID) then
    if not TLinkObservers.EditLinkEdit(Observers) then
      Exit;
  LChanged := ItemIndex <> AValueIndex;
  if LChanged then
    TLinkObservers.PositionLinkPosChanging(Observers);
  ItemIndex := AValueIndex;
  if LChanged then
    TLinkObservers.ListSelectionChanged(Observers);
end;

procedure TAlephCustomComboBox.DoPopup(Sender: TObject);
begin
  if Assigned(FOnPopup) then
    FOnPopup(Self);
end;

function TAlephCustomComboBox.UseNativePicker: Boolean;
begin
  Result := (TDropDownKind.Native = DropDownKind) and (FListPicker <> nil);
end;

procedure TAlephCustomComboBox.DropDown;
begin
  if UseNativePicker then
  begin
    if FListPicker.IsShown then
    begin
      FDroppedDown := False;
      FListPicker.Hide;
    end
    else
    begin
      FOldItemIndex := ItemIndex;
      if Items.Count > 0 then
      begin
        FDroppedDown := True;
        InitPicker(FListPicker);
        FListPicker.Show;
      end;
    end;
  end
  else
  begin
    if not FPopup.IsOpen then
    begin
      FOldItemIndex := ItemIndex;
      if Items.Count > 0 then
      begin
        FDroppedDown := True;
        RecalculatePopupSize;
        if Selected <> nil then
          FListBox.ScrollToItem(FListBox.ListItems[ItemIndex])
        else
          FListBox.ViewportPosition := TPointF.Zero;
        FPopup.IsOpen := True;
        if FPopup.IsOpen then
          FListBox.SetFocus;
      end;
    end
    else
      FPopup.IsOpen := False;
  end;
end;

procedure TAlephCustomComboBox.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  inherited;
  if Button = TMouseButton.mbLeft then
  begin
    FIsPressed := True;
    StartTriggerAnimation(Self, 'IsPressed');
    DropDown;
  end;
end;

procedure TAlephCustomComboBox.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  inherited;
  if Button = TMouseButton.mbLeft then
  begin
    FIsPressed := False;
    StartTriggerAnimation(Self, 'IsPressed');
  end;
end;

procedure TAlephCustomComboBox.MouseWheel(Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
begin
  inherited;
  if WheelDelta < 0 then
  begin
    if ItemIndex < Count - 1 then
      ItemIndex := ItemIndex + 1
  end
  else
    if ItemIndex > 0 then
      ItemIndex := ItemIndex - 1;
  Handled := True;
end;

procedure TAlephCustomComboBox.RecalculatePopupSize;

  procedure UpdateItemBounds(Index: Integer);
  var
    Content: TControl;
    Item: TAlephListBoxItem;
    NewHeight: Single;
  begin
    Item := FListBox.ItemByIndex(Index);
    if (Item <> nil) and FindStyleResource<TControl>('Content', Content) then // do not localize
    begin
      if Item.Height <> 0 then
        NewHeight := Item.Height
      else if ItemHeight = 0 then
        NewHeight := Content.Height
      else
        NewHeight := ItemHeight;
      Item.SetBounds(Item.Position.X, Item.Position.Y, Item.Width, NewHeight);
      Item.ApplyStyleLookup;
    end;
  end;

  function CalculatePopupContentHeight: Single;
  var
    TotalHeight: Single;
    Num: Integer;
    I: Integer;
    Item: TAlephListBoxItem;
  begin
    TotalHeight := 0;
    Num := 0;
    for I := 0 to FListbox.Count - 1 do
    begin
      Item := FListbox.ListItems[I];
      if Item.Position.Y >= 0 then
      begin
        TotalHeight := TotalHeight + Item.Height;
        Inc(Num);
      end;
      if Num >= DropDownCount then
        Break;
    end;
    Result := TotalHeight;
  end;

var
  PopupContentHeight: Single;
  I: Integer;
begin
  // Resize list items to match the dimensions of the control
  for I := 0 to FListbox.Count - 1 do
    UpdateItemBounds(I);

  FPopup.ApplyStyleLookup;
  if Pressed or DoubleClick then
    FPopup.PreferedDisplayIndex := Screen.DisplayFromPoint(Screen.MousePos).Index
  else
    FPopup.PreferedDisplayIndex := -1;
  if SameValue(ItemWidth, 0, TEpsilon.Position) then
    FPopup.Width := Width
  else
    FPopup.Width := ItemWidth;

  if FListBox.ItemHeight > 0 then
    PopupContentHeight := Min(Count, DropDownCount) * FListBox.ItemHeight
  else
    PopupContentHeight := CalculatePopupContentHeight;
  FPopup.Height := FPopup.Padding.Top + PopupContentHeight + FListBox.BorderHeight + FPopup.Padding.Bottom;
end;

procedure TAlephCustomComboBox.KeyDown(var Key: Word; var KeyChar: System.WideChar; Shift: TShiftState);

  function TryFindMatchingItem(var AItemIndex: Integer): Boolean;
  var
    I: Integer;
    Item: TAlephListBoxItem;
  begin
    if KeyChar = #0 then
      Exit(False);

    for I := 0 to Count - 1 do
    begin
      Item := FListBox.ListItems[I];
      if not Item.Text.IsEmpty and (Item.Text.Chars[0].ToLower = KeyChar.ToLower) then
      begin
        AItemIndex := I;
        Exit(True);
      end;
    end;
    Result := False;
  end;

  function IsDropDownKey(const AKey: Word; const Shift: TShiftState): Boolean;
  begin
    Result := (Key = vkDown) and ([ssAlt, ssCtrl, ssShift, ssCommand] * Shift = [ssAlt]);
  end;

  function PrevItemIndex(const AItemIndex: Integer): Integer;
  begin
    Result := EnsureRange(AItemIndex - 1, 0, Count - 1)
  end;

  function NextItemIndex(const AItemIndex: Integer): Integer;
  begin
    Result := EnsureRange(AItemIndex + 1, 0, Count - 1);
  end;

var
  OldItemIndex: Integer;
  NewItemIndex: Integer;
begin
  if not FDroppedDown then
    OldItemIndex := ItemIndex
  else if DropDownKind = TDropDownKind.Native then
    OldItemIndex := FListPicker.ItemIndex
  else
    OldItemIndex := FListBox.ItemIndex;
  NewItemIndex := OldItemIndex;

  if Observers.IsObserving(TObserverMapping.EditLinkID) then
    if (KeyChar > ' ') or
      (Key in [vkHome, vkEnd, vkUp, vkDown, vkRight, vkLeft]) then
      if not TLinkObservers.EditLinkEdit(Observers) then
        Exit;
  inherited;

  if Count = 0 then
    Exit;

  if IsDropDownKey(Key, Shift) or (Key in [vkEscape, vkHome, vkEnd]) or ([ssAlt, ssCtrl, ssShift, ssCommand] * Shift = []) then
  begin
    if TryFindMatchingItem(NewItemIndex) then
      KeyChar := #0;

    case Key of
      vkHome:
        NewItemIndex := 0;
      vkEnd:
        NewItemIndex := Count - 1;
      vkUp, vkLeft:
        NewItemIndex := PrevItemIndex(NewItemIndex);
      vkRight:
        NewItemIndex := NextItemIndex(NewItemIndex);
      vkDown:
        if ssAlt in Shift then
          DropDown
        else
          NewItemIndex := NextItemIndex(NewItemIndex);
      vkPrior:
        NewItemIndex := EnsureRange(NewItemIndex - DropDownCount, 0, Count - 1);
      vkNext:
        NewItemIndex := EnsureRange(NewItemIndex + DropDownCount, 0, Count - 1);
      vkF4, vkReturn:
      begin
        // Before closing popup, we should update current value of ItemIndex
        if FDroppedDown then
          ItemIndex := NewItemIndex;
        DropDown;
      end;
      vkEscape:
        if (UseNativePicker and FListPicker.IsShown) or ((not UseNativePicker) and FPopup.IsOpen) then
        begin
          DropDown;
          if InRange(FOldItemIndex, 0, Count - 1) then
            NewItemIndex := FOldItemIndex
          else
            NewItemIndex := -1;
        end
        else
          Exit
    end;

    if NewItemIndex <> OldItemIndex then
    begin
      TLinkObservers.PositionLinkPosChanging(Observers);
      try
        if not FDroppedDown then
          ItemIndex := NewItemIndex
        else if DropDownKind = TDropDownKind.Native then
          FListPicker.ItemIndex := NewItemIndex
        else
          FListBox.ItemIndex := NewItemIndex;
      finally
        TLinkObservers.ListSelectionChanged(Observers);
      end;
    end;
    Key := 0;
  end;
end;

procedure TAlephCustomComboBox.DoChange;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TAlephCustomComboBox.DoClosePicker(Sender: TObject);
begin
  if not (csDestroying in ComponentState) then
  begin
    FDroppedDown := False;
    if Assigned(FOnClosePopup) then
      FOnClosePopup(Self);
  end;
end;

procedure TAlephCustomComboBox.DoClosePopup(Sender: TObject);
begin
  FDroppedDown := False;
  if Assigned(FOnClosePopup) then
    FOnClosePopup(Self);
end;

procedure TAlephCustomComboBox.Clear;
begin
  FListBox.Clear;
  FItemIndex := -1;
  Repaint;
end;

procedure TAlephCustomComboBox.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineProperty('UseSmallScrollBars', IgnoreBooleanValue, nil, False);
end;

destructor TAlephCustomComboBox.Destroy;
begin
  FreeAndNil(FImageLink);
  FreeAndNil(FListPicker);
  inherited;
end;

procedure TAlephCustomComboBox.DoAddObject(const AObject: TFmxObject);
begin
  if AObject is TAlephListBoxItem then
  begin
    FListBox.AddObject(AObject);
    FItemsChanged := True;
  end
  else
    inherited;
end;

function TAlephCustomComboBox.GetItemIndex: Integer;
begin
  Result := FItemIndex
end;

function TAlephCustomComboBox.GetCount: Integer;
begin
  Result := FListBox.Count
end;

function TAlephCustomComboBox.GetDefaultSize: TSizeF;
var
  MetricsService: IFMXDefaultMetricsService;
begin
  if (TBehaviorServices.Current.SupportsBehaviorService(IFMXDefaultMetricsService, MetricsService, Self)
    or SupportsPlatformService(IFMXDefaultMetricsService, MetricsService))
    and MetricsService.SupportsDefaultSize(TComponentKind.Edit) then
    Result := TSizeF.Create(MetricsService.GetDefaultSize(TComponentKind.Edit))
  else
    Result := TSizeF.Create(100, 22);
end;

procedure TAlephCustomComboBox.SetItemIndex(const Value: Integer);
var
  EffectiveValue: Integer;
begin
  FListBox.ItemIndex := Value;
  EffectiveValue := FListBox.ItemIndex;
  if FListPicker <> nil then
    FListPicker.ItemIndex := EffectiveValue;

  if FItemIndex <> EffectiveValue then
  begin
    FItemIndex := EffectiveValue;
    if not (csLoading in ComponentState) then
      DoChange;
    UpdateCurrentItem;
    if ResourceControl <> nil then
      ResourceControl.UpdateEffects;
  end;
  Repaint;
end;

procedure TAlephCustomComboBox.SetItems(const Value: TStrings);
begin
  FListBox.Items.Assign(Value);
end;

procedure TAlephCustomComboBox.SetItemWidth(const Value: Single);
begin
  FItemWidth := Max(0, Value);
  if UseNativePicker then
    FListPicker.ItemWidth := ItemWidth
  else
    FPopup.Width := ItemWidth;
end;

procedure TAlephCustomComboBox.GetChildren(Proc: TGetChildProc; Root: TComponent);
var
  I: Integer;
begin
  inherited;
  if FListBox.Count > 0 then
    for I := 0 to FListBox.Count - 1 do
      if FListBox.ListItems[I].Stored then
        Proc(TComponent(FListBox.ListItems[I]));
end;

function TAlephCustomComboBox.GetListBoxResource: string;
begin
  Result := FListBox.StyleLookup;
end;

function TAlephCustomComboBox.GetListItem(Index: Integer): TAlephListBoxItem;
begin
  Result := FListBox.ListItems[Index];
end;

function TAlephCustomComboBox.GetPlacement: TPlacement;
begin
  Result := FPopup.Placement;
end;

function TAlephCustomComboBox.GetPlacementRectangle: TBounds;
begin
  Result := FPopup.PlacementRectangle;
end;

function TAlephCustomComboBox.GetSelected: TAlephListBoxItem;
begin
  Result := FListBox.Selected;
end;

procedure TAlephCustomComboBox.HandleStringsChanged(const S: string; const Op: TAlephCustomListBox.TStringsChangeOp);
begin
  FItemsChanged := True;
  case Op of
    TAlephCustomListBox.TStringsChangeOp.Added:
      FListBox.ItemIndex := ItemIndex;
    TAlephCustomListBox.TStringsChangeOp.Deleted:
      ItemIndex := FListBox.ItemIndex;
    TAlephCustomListBox.TStringsChangeOp.Clear:
      ItemIndex := -1;
  end;
  UpdateCurrentItem;
end;

function TAlephCustomComboBox.ItemsStored: Boolean;
begin
  Result := FListBox.ItemsStored;
end;

procedure TAlephCustomComboBox.SetListBoxResource(const Value: string);
begin
  FListBox.StyleLookup := Value;
end;

procedure TAlephCustomComboBox.SetNewScene(AScene: IScene);
begin
  if (AScene <> nil) and FIsPressed then
  begin
    FIsPressed := False;
    StartTriggerAnimation(Self, 'IsPressed');
  end;
  inherited;
end;

procedure TAlephCustomComboBox.SetPlacement(const Value: TPlacement);
begin
  FPopup.Placement := Value;
end;

procedure TAlephCustomComboBox.SetPlacementRectangle(const Value: TBounds);
begin
  FPopup.PlacementRectangle := Value;
end;

procedure TAlephCustomComboBox.Sort(Compare: TFmxObjectSortCompare);
var
  Item: TAlephListBoxItem;
  obj: TFmxObject;
  I : Integer;
begin
  Item := nil;
  obj := GetItem(FListBox.ItemIndex);
  if obj is TAlephListBoxItem then
    Item := obj as TAlephListBoxItem;

  FListBox.Sort(Compare);

  // deselect all items if not MultiSelect
  if FListBox.MultiSelectStyle = TMultiSelectStyle.None then
  begin
    for I := 0 to FListBox.Count - 1 do
      if ListBox.ListItems[I] is TAlephListBoxItem then
        ListBox.ListItems[I].IsSelected := False;

    // and re-select the previous selected item
    if Item <> nil then
      Item.IsSelected := True;
  end;

  if not (csLoading in ComponentState) then
    DoChange;
end;

function TAlephCustomComboBox.GetItems: TStrings;
begin
  Result := FListBox.Items;
end;

function TAlephCustomComboBox.GetItemsCount: Integer;
begin
  Result := Count;
end;

function TAlephCustomComboBox.GetItem(const AIndex: Integer): TFmxObject;
begin
  Result := FListBox.ListItems[AIndex];
end;

function TAlephCustomComboBox.GetItemHeight: Single;
begin
  Result := FListBox.ItemHeight;
end;

procedure TAlephCustomComboBox.SetItemHeight(const Value: Single);
begin
  if FListBox.ItemHeight <> Value then
  begin
    FListBox.ItemHeight := Value;
    UpdateCurrentItem;
  end;
end;

procedure TAlephCustomComboBox.Loaded;
begin
  inherited;
  ImagesChanged;
end;

procedure TAlephCustomComboBox.ImagesChanged;
var
  I: Integer;
  LItem: TAlephListBoxItem;
begin
  if not (csLoading in ComponentState) and (FImageLink.Images <> FImages) then
  begin
    FImages := FImageLink.Images as TCustomImageList;
    FListBox.Images := FImages;
    for I := 0 to Count - 1 do
    begin
      LItem := GetListItem(I);
      if LItem <> nil then
        LItem.SetImages(FImages);
    end;
  end;
end;

procedure TAlephCustomComboBox.InitPicker(AListPicker: TCustomListPicker);

  function DefinePreferedDisplayIndex: Integer;
  begin
    if Pressed or DoubleClick then
      Result := Screen.DisplayFromPoint(Screen.MousePos).Index
    else
      Result := -1;
  end;

begin
  AListPicker.PreferedDisplayIndex := DefinePreferedDisplayIndex;
  if FItemsChanged then
  begin
    AListPicker.Values := Items;
    FItemsChanged := False;
  end;
  AListPicker.ItemIndex := ItemIndex;
  AListPicker.ItemWidth := ItemWidth;
  AListPicker.ItemHeight := ItemHeight;
  AListPicker.CountVisibleItems := DropDownCount;
end;

function TAlephCustomComboBox.GetImages: TCustomImageList;
begin
  if FImageLink.Images is TCustomImageList then
    Result := TCustomImageList(FImageLink.Images)
  else
    Result := FImages;
end;

procedure TAlephCustomComboBox.SetImages(const Value: TCustomImageList);
begin
  FImageLink.Images := Value
end;

function TAlephCustomComboBox.GetImageIndex: TImageIndex;
begin
  Result := -1;
end;

procedure TAlephCustomComboBox.SetImageIndex(const Value: TImageIndex);
begin
  // none
end;

function TAlephCustomComboBox.GetImageList: TBaseImageList;
begin
  Result := GetImages;
end;

procedure TAlephCustomComboBox.SetImageList(const Value: TBaseImageList);
begin
  ValidateInheritance(Value, TCustomImageList);
  SetImages(TCustomImageList(Value));
end;

{ TAlephCustomListBox.TListBoxStrings }

function TAlephCustomListBox.TListBoxStrings.Add(const S: string): Integer;
var
  Item: TAlephListBoxItem;
begin
  Item := TAlephListBoxItem.Create(FListBox);
  Item.BeginUpdate;
  try
    try
      Item.Text := S;
      Item.Stored := False;
      FListBox.AddObject(Item);
      Item.StyleLookup := FListBox.DefaultItemStyles.ItemStyle;
      FListBox.DispatchStringsChangeEvent(S, TAlephCustomListBox.TStringsChangeOp.Added);
    except
      Item.Free;
      raise;
    end;
  finally
    Item.EndUpdate;
  end;
  Result := Item.Index;
end;

procedure TAlephCustomListBox.TListBoxStrings.Clear;
begin
  if not (csDestroying in FListBox.ComponentState) then
    FListBox.Clear;
  FListBox.DispatchStringsChangeEvent(string.Empty, TAlephCustomListBox.TStringsChangeOp.Clear);
end;

procedure TAlephCustomListBox.TListBoxStrings.DefineProperties(Filer: TFiler);
  function DoWrite: Boolean;
  begin
    if Filer.Ancestor <> nil then
    begin
      Result := True;
      if Filer.Ancestor is TStrings then
        Result := not Equals(TStrings(Filer.Ancestor))
    end
    else
      Result := Count > 0;
  end;
begin
  Filer.DefineProperty('Strings', ReadData, WriteData, DoWrite);
end;

procedure TAlephCustomListBox.TListBoxStrings.ReadData(Reader: TReader);
var
  SavedIndex: Integer;
begin
  SavedIndex := FListBox.ItemIndex;
  Reader.ReadListBegin;
  BeginUpdate;
  try
    if FListBox.ItemsStored then
    begin
      Clear;
      while not Reader.EndOfList do
        Add(Reader.ReadString);
    end
    else
    begin
      while not Reader.EndOfList do
        Reader.ReadString;
    end;
  finally
    EndUpdate;
  end;
  Reader.ReadListEnd;
  FListBox.ItemIndex := SavedIndex;
end;

procedure TAlephCustomListBox.TListBoxStrings.WriteData(Writer: TWriter);
var
  I: Integer;
begin
  Writer.WriteListBegin;
  for I := 0 to Count - 1 do
    Writer.WriteString(Get(I));
  Writer.WriteListEnd;
end;

procedure TAlephCustomListBox.TListBoxStrings.Delete(Index: Integer);
var
  Item: TAlephListBoxItem;
  Text: string;
begin
  Item := FListBox.ListItems[Index];
  if Item <> nil then
  begin
    Text := Item.Text;
    if Item = FListBox.ItemDown then
      FListBox.ItemDown := nil;
    FListBox.RemoveObject(Item);
    Item.Free;
    FListBox.DispatchStringsChangeEvent(Text, TAlephCustomListBox.TStringsChangeOp.Deleted);
  end;
end;

procedure TAlephCustomListBox.TListBoxStrings.Exchange(Index1, Index2: Integer);
begin
  FListBox.Exchange(FListBox.ItemByIndex(Index1), FListBox.ItemByIndex(Index2));
end;

function TAlephCustomListBox.TListBoxStrings.Get(Index: Integer): string;
begin
  Result := FListBox.ListItems[Index].Text;
end;

function TAlephCustomListBox.TListBoxStrings.GetCount: Integer;
begin
  Result := FListBox.Count;
end;

function TAlephCustomListBox.TListBoxStrings.GetObject(Index: Integer): TObject;
begin
  Result := FListBox.ListItems[Index].Data;
end;

function TAlephCustomListBox.TListBoxStrings.IndexOf(const S: string): Integer;
var
  I: Integer;
begin
  for I := 0 to FListBox.Count - 1 do
    if SameText(FListBox.ListItems[I].Text, S) then
      Exit(I);
  Result := -1;
end;

procedure TAlephCustomListBox.TListBoxStrings.Insert(Index: Integer; const S: string);
var
  Item: TAlephListBoxItem;
begin
  Item := TAlephListBoxItem.Create(FListBox);
  Item.BeginUpdate;
  try
    try
      Item.Text := S;
      Item.Stored := False;
      FListBox.InsertObject(Index, Item);
      Item.StyleLookup := FListBox.DefaultItemStyles.ItemStyle;
      FListBox.DispatchStringsChangeEvent(S, TAlephCustomListBox.TStringsChangeOp.Added);
    except
      Item.Free;
      raise;
    end;
  finally
    Item.EndUpdate;
  end;
end;

procedure TAlephCustomListBox.TListBoxStrings.Put(Index: Integer; const S: string);
begin
  FListBox.ListItems[Index].Text := S;
end;

procedure TAlephCustomListBox.TListBoxStrings.PutObject(Index: Integer; AObject: TObject);
begin
  FListBox.ListItems[Index].Data := AObject;
end;

procedure TAlephCustomListBox.TListBoxStrings.SetUpdateState(Updating: Boolean);
begin
  if Updating then
    FListBox.BeginUpdate
  else
    FListBox.EndUpdate;
end;

procedure TAlephCustomListBox.ImagesChanged;
var
  I: Integer;
  LItem: TAlephListBoxItem;
begin
  if (not (csLoading in ComponentState)) and (FImageLink.Images <> FImages) then
  begin
    FImages := FImageLink.Images as TCustomImageList;
    for I := 0 to Count - 1 do
    begin
      LItem := ItemByIndex(I);
      if LItem <> nil then
        LItem.SetImages(FImages);
    end;
  end;
end;

function TAlephCustomListBox.GetImages: TCustomImageList;
begin
  if FImageLink.Images is TCustomImageList then
    Result := TCustomImageList(FImageLink.Images)
  else
    Result := FImages;
end;

procedure TAlephCustomListBox.SetImages(const Value: TCustomImageList);
begin
  FImageLink.Images := Value;
end;

function TAlephCustomListBox.GetImageIndex: TImageIndex;
begin
  Result := -1;
end;

procedure TAlephCustomListBox.SetImageIndex(const Value: TImageIndex);
begin
  // none
end;

function TAlephCustomListBox.GetImageList: TBaseImageList;
begin
  Result := GetImages;
end;

procedure TAlephCustomListBox.SetImageList(const Value: TBaseImageList);
begin
  ValidateInheritance(Value, TCustomImageList);
  SetImages(TCustomImageList(Value));
end;

{ TMetroListBoxItem }

procedure TAlephMetropolisUIListBoxItem.ApplyStyle;
var
  T: TControl;
begin
  inherited;
  T := TextObject;
  if T <> nil then
  begin
    FTitle.FontColor := TText(T).Color;
    FSubTitle.FontColor := TText(T).Color;
    FDescription.FontColor := TText(T).Color;
    TText(T).Visible := False;
  end;
end;

procedure TAlephMetropolisUIListBoxItem.FreeStyle;
begin
  if TextObject <> nil then
    TextObject.Visible := True;
  inherited;
end;

constructor TAlephMetropolisUIListBoxItem.Create(AOwner: TComponent);
begin
  inherited;

  Align := TAlignLayout.Fit;

  SetWidth(500);
  FIconSize := 128;
  Height := FIconSize;
  ClipChildren := True;

  FImage := TImage.Create(nil);
  FImage.Stored := False;
  FImage.Locked := True;
  FImage.Bitmap.OnChange := OnBitmapChanged;

  FText := TLayout.Create(nil);
  FText.Stored := False;
  FText.Locked := True;
  FTitle := TLabel.Create(nil);
  FTitle.Stored := False;
  FTitle.Locked := True;
  FSubTitle := TLabel.Create(nil);
  FSubTitle.Stored := False;
  FSubTitle.Locked := True;
  FDescription := TLabel.Create(nil);
  FDescription.Stored := False;
  FDescription.Locked := True;
  FDescription.Trimming := TTextTrimming.Word;

  FImage.Position.X := 0;
  FImage.Position.Y := 0;
  FImage.HitTest := False;
  FImage.Visible := False;
  FImage.Align := TAlignLayout.None;

  FText.Parent := Self;
  FImage.Parent := Self;

  FText.Padding.Left := 5;
  FText.Align := TAlignLayout.Client;

  FTextPanel := TPanel.Create(nil);
  FTextPanel.StyleLookup := 'flipviewpanel';
  FTextPanel.Align := TAlignLayout.Contents;
  FTextPanel.Parent := FText;
  FTextPanel.Visible := False;
  FTextPanel.Locked := True;
  FTextPanel.Stored := False;

  FTitle.Parent := FText;
  FTitle.Position.X := 0;
  FTitle.Position.Y := 0;
  FTitle.Height := 22;
  FTitle.AutoSize := True;
  FTitle.Align := TAlignLayout.Top;

  FTitle.TextAlign := TTextAlign.Leading;
  FTitle.VertTextAlign := TTextAlign.Trailing;
  FTitle.Trimming := TTextTrimming.Word;
  FTitle.WordWrap := False;
  FTitle.Text := 'Item Title';
  FTitle.HitTest := False;

  FSubTitle.Parent := FText;
  FSubTitle.Position.X := 0;
  FSubTitle.Position.Y := FTitle.AbsoluteRect.Bottom + 1;
  FSubTitle.Height := 22;
  FSubTitle.TextAlign := TTextAlign.Leading;
  FSubTitle.VertTextAlign := TTextAlign.Trailing;
  FSubTitle.Align := TAlignLayout.Top;
  FSubTitle.Trimming := TTextTrimming.Word;
  FSubTitle.AutoSize := True;
  FSubTitle.WordWrap := True;

  FSubTitle.Text := 'Item SubTitle';
  FSubTitle.HitTest := False;

  FDescription.Parent := FText;
  FDescription.Position.X := 0;
  FDescription.Position.Y := FSubTitle.AbsoluteRect.Bottom + 1;

  FDescription.TextAlign := TTextAlign.Leading;
  FDescription.VertTextAlign := TTextAlign.Leading;
  FDescription.Align := TAlignLayout.Client;
  FDescription.Text := 'Long description';
  FDescription.HitTest := False;

  SetAcceptsControls(True);
  SetIconSize(FIconSize);

  FText.BringToFront;
  FTitle.StyleLookup := 'griditemtitlelabel';
  FSubTitle.StyleLookup := 'griditemsubtitlelabel';
  FDescription.StyleLookup := 'griditemtitlelabel';
  FTextPanel.StyleLookup := 'gridpanel';
end;

procedure TAlephMetropolisUIListBoxItem.DefineProperties(Filer: TFiler);
begin
  Filer.DefineProperty('IconSize', SkipIconSize, nil, False);
  Filer.DefineProperty('Align', SkipAlign, nil, False);
end;

destructor TAlephMetropolisUIListBoxItem.Destroy;
begin
  inherited;
end;

procedure TAlephMetropolisUIListBoxItem.DoRealign;
var
  Scale : Single;
begin
  Self.Realign;

  if (FImage.Align <> TAlignLayout.None)
    or (FImage.Bitmap.Height = 0)
    or (FImage.Bitmap.Width = 0) then
    Exit;

  if Width > Height then
  begin
    Scale := Width / FImage.Bitmap.Width;
  end
  else begin
    Scale := Height / FImage.Bitmap.Height;
  end;

  FImage.SetBounds(0, 0, FImage.Bitmap.Width*Scale, FImage.Bitmap.Height*Scale);
end;

procedure TAlephMetropolisUIListBoxItem.Resize;
begin
  if (FImage = nil) or (FText = nil) then
    Exit;

  if Width < 2*Height then
  begin
    // it's a square
    FImage.Align := TAlignLayout.None;
    FImage.WrapMode := TImageWrapMode.Stretch;
    FText.Align := TAlignLayout.Bottom;
    FTextPanel.Visible := True;
    FTextPanel.Enabled := False;
    FTextPanel.Align := TAlignLayout.Contents;
    FText.Height := Height * 0.4;
    Realign;
  end
  else begin
    // it's a rectangle
    FImage.Align := TAlignLayout.FitLeft;
    FImage.WrapMode := TImageWrapMode.Fit;
    FText.Align := TAlignLayout.Client;
    FTextPanel.Visible := False;
    Realign;
  end;

  inherited;
end;

function TAlephMetropolisUIListBoxItem.GetDefaultStyleLookupName: string;
begin
  Result := 'collectionlistboxitem';
end;

function TAlephMetropolisUIListBoxItem.GetDescription: String;
begin
  Result := FDescription.Text;
end;

function TAlephMetropolisUIListBoxItem.GetIcon: TBitmap;
begin
  Result := FImage.Bitmap;
end;

function TAlephMetropolisUIListBoxItem.GetSubTitle: String;
begin
  Result := FSubTitle.Text;
end;

function TAlephMetropolisUIListBoxItem.GetTitle: String;
begin
  Result := FTitle.Text;
end;

procedure TAlephMetropolisUIListBoxItem.OnBitmapChanged(Sender: TObject);
begin
  if FImage.Bitmap.Width > 0 then
    FImage.Visible := True
  else
    FImage.Visible := False;

  FImage.Repaint;
  FImage.UpdateEffects;
end;

procedure TAlephMetropolisUIListBoxItem.SetIcon(const Bitmap: TBitmap);
var
  W, H : Integer;
begin
  W := Round(FImage.Width);
  H := Round(FImage.Height);
  FImage.Bitmap := Bitmap;
  FImage.Bitmap.SetSize(W, H);
  FImage.Visible := True;
  Realign;
end;

procedure TAlephMetropolisUIListBoxItem.SetIconSize(Value: Integer);
begin
  FIconSize := Value;

  Height := Value;

  FImage.Width := FIconSize;
  FImage.Height := FIconSize;

  FText.Position.X := FIconSize + FText.Padding.Left;
  FText.Position.Y := 0;
  FText.Width := Width - FText.Position.X - FText.Padding.Left;
  FText.Height := Value;

  Realign;
end;

procedure TAlephMetropolisUIListBoxItem.SetParent(const AParent: TFmxObject);
var
  X : Single;
begin
  inherited;
  X := FText.Position.X;
  FText.Anchors := [TAnchorKind.akLeft, TAnchorKind.akRight];
  FText.Position.X := X;
  if AParent is TControl then
    FText.Width := TControl(AParent).Width - X;
  if AParent is TAlephListBox then
    FText.Width := TAlephListBox(AParent).ClientWidth - X;
end;

procedure TAlephMetropolisUIListBoxItem.SetDescription(const Description: String);
begin
  FDescription.Text := Description;
end;

procedure TAlephMetropolisUIListBoxItem.SetSubTitle(const SubTitle: String);
begin
  FSubTitle.Text := SubTitle;
end;

procedure TAlephMetropolisUIListBoxItem.SetTitle(const Title: String);
begin
  FTitle.Text := Title;
end;

procedure TAlephMetropolisUIListBoxItem.SkipAlign(Reader: TReader);
begin
  Reader.SkipValue;
end;

procedure TAlephMetropolisUIListBoxItem.SkipIconSize(Reader: TReader);
begin
  Reader.ReadInteger;
end;

{ TAlephListBoxItemData }

constructor TAlephListBoxItemData.Create(const HostItem: TAlephListBoxItem);
begin
  inherited Create;
  FItem := HostItem;
  Detail := string.Empty;
  Accessory := TAccessory.aNone;
end;

destructor TAlephListBoxItemData.Destroy;
begin
  inherited;
end;

procedure TAlephListBoxItemData.Assign(Source: TPersistent);
var
  Src: TAlephListBoxItemData;
begin
  if Source = nil then
  begin
    Text := string.Empty;
    Detail := string.Empty;
    Accessory := TAccessory.aNone;
    Bitmap := nil;
  end
  else if Source is TAlephListBoxItemData then
  begin
    Src := TAlephListBoxItemData(Source);
    Text := Src.Text;
    Detail := Src.Detail;
    Accessory := Src.Accessory;
    Bitmap := Src.Bitmap;
  end
  else
    inherited;
end;

procedure TAlephListBoxItemData.Disappear;
var
  B: TControl;
begin
  case FAccessory of
    TAlephListBoxItemData.TAccessory.aNone: ;
    TAlephListBoxItemData.TAccessory.aMore:
      if FItem.FindStyleResource<TControl>('accessorymore', B) then
        B.Visible := False;
    TAlephListBoxItemData.TAccessory.aDetail:
      if FItem.FindStyleResource<TControl>('accessorydetail', B) then
        B.Visible := False;
    TAlephListBoxItemData.TAccessory.aCheckmark:
      if FItem.FindStyleResource<TControl>('accessorycheckmark', B) then
        B.Visible := False;
  end;
end;

function TAlephListBoxItemData.GetBitmap: TBitmap;
begin
  Result := FItem.FBitmap;
end;

function TAlephListBoxItemData.GetDetail: String;
begin
  Result := FItem.StylesData['detail'].AsString;
end;

function TAlephListBoxItemData.GetText: String;
begin
  Result := FItem.Text;
end;

procedure TAlephListBoxItemData.SetBitmap(const Bitmap: TBitmap);
begin
  FItem.FBitmap.Assign(Bitmap);
end;

procedure TAlephListBoxItemData.SetAccessory(const Accessory: TAccessory);
begin
  Self.FAccessory := Accessory;
  case Accessory of
    TAccessory.aNone: begin
      FItem.StylesData[StyleSelectorMore] := False;
      FItem.StylesData[StyleSelectorDetail] := False;
      FItem.StylesData[StyleSelectorCheckmark] := False;
    end;
    TAccessory.aMore: begin
      FItem.StylesData[StyleSelectorMore] := True;
      FItem.StylesData[StyleSelectorDetail] := False;
      FItem.StylesData[StyleSelectorCheckmark] := False;
      end;
    TAccessory.aDetail: begin
      FItem.StylesData[StyleSelectorMore] := False;
      FItem.StylesData[StyleSelectorDetail] := True;
      FItem.StylesData[StyleSelectorCheckmark] := False;
      end;
    TAccessory.aCheckmark: begin
      FItem.StylesData[StyleSelectorMore] := False;
      FItem.StylesData[StyleSelectorDetail] := False;
      FItem.StylesData[StyleSelectorCheckmark] := True;
    end;
  end
end;

function TAlephListBoxItemData.GetAccessory: TAccessory;
begin
  Exit(FAccessory);
end;

procedure TAlephListBoxItemData.SetDetail(const Detail: string);
begin
  FItem.StylesData['detail'] := Detail;
end;

procedure TAlephListBoxItemData.SetText(const Text: string);
begin
  FItem.Text := Text;
end;

{ TListBoxSeparatorItem }

function TListBoxSeparatorItem.GetDefaultGroupHeaderStyle: string;
begin
  if ListBox <> nil then
    case ListBox.GroupingKind of
      TListGroupingKind.Plain:
        Result := 'listboxplainheader';  // do not localize
      TListGroupingKind.Grouped:
        Result := 'listboxgroupheader';  // do not localize
    end;
end;

{ TAlephListBoxGroupHeader }

constructor TAlephListBoxGroupHeader.Create(AOwner: TComponent);
begin
  inherited;
end;

destructor TAlephListBoxGroupHeader.Destroy;
begin
  if Owner is TAlephListBoxGroupHeader then
    TAlephListBoxGroupHeader(Owner).CloneRef := nil;
  inherited;
end;

function TAlephListBoxGroupHeader.DoGetDefaultStyleLookupName(const Defaults: TAlephListBoxItemStyleDefaults): string;
begin
  if (Defaults <> nil) and not Defaults.GroupHeaderStyle.IsEmpty then
    Result := Defaults.GroupHeaderStyle
  else
    Result := GetDefaultGroupHeaderStyle;
end;

procedure TAlephListBoxGroupHeader.DoTextChanged;
begin
  inherited;
  if CloneRef <> nil then
    TAlephListBoxGroupHeader(CloneRef).Text := Text;
end;

{ TListBoxGroupFooter }

constructor TListBoxGroupFooter.Create(AOwner: TComponent);
begin
  inherited;
end;

function TListBoxGroupFooter.DoGetDefaultStyleLookupName(const Defaults: TAlephListBoxItemStyleDefaults): string;
begin
  if (Defaults <> nil) and not Defaults.GroupHeaderStyle.IsEmpty then
    Result := Defaults.GroupFooterStyle
  else
    Result := 'listboxfooter';
end;

{ TAlephCustomListBox.TGroup }

constructor TAlephCustomListBox.TGroup.Create(const AFirst, ALength: Integer);
begin
  First := AFirst;
  Length := ALength;
end;

{ TAlephCustomListBox.TGroups }

function TAlephCustomListBox.TGroups.FindGroup(const Index: Integer): Integer;
var
  Blank: TGroup;
begin
  Blank := TGroup.Create(Index, 0);
  if not Self.BinarySearch(Blank, Result, TComparer<TGroup>.Construct(
    function(const G, R: TGroup):Integer
    begin
      if (G.First <= R.First) and (G.First+G.Length > R.First) then
        Result := 0
      else
        Result := G.First - R.First
    end
    )) then Result := -1;
end;

{ TDefaultListBoxItemStyles }

procedure TAlephListBoxItemStyleDefaults.Assign(Source: TPersistent);
var
  Src: TAlephListBoxItemStyleDefaults;
begin
  if Source is TAlephListBoxItemStyleDefaults then
  begin
    Src := TAlephListBoxItemStyleDefaults(Source);
    FItemStyle := Src.FItemStyle;
    FFooterStyle := Src.FFooterStyle;
    FHeaderStyle := Src.FHeaderStyle;
  end;
end;

constructor TAlephListBoxItemStyleDefaults.Create(const ListBox: TAlephCustomListBox);
var
  DefaultValueService: IInterface;
begin
  FListBox := ListBox;

  if (csDesigning in ListBox.ComponentState) and
    ListBox.SupportsPlatformService(IFMXDefaultPropertyValueService, DefaultValueService) then
  begin
    ItemStyle := IFMXDefaultPropertyValueService(DefaultValueService).GetDefaultPropertyValue(Self.ClassName, 'itemstyle').AsString;
    GroupHeaderStyle := IFMXDefaultPropertyValueService(DefaultValueService).GetDefaultPropertyValue(Self.ClassName, 'groupheaderstyle').AsString;
    GroupFooterStyle := IFMXDefaultPropertyValueService(DefaultValueService).GetDefaultPropertyValue(Self.ClassName, 'groupfooterstyle').AsString;
  end;
end;

function TAlephListBoxItemStyleDefaults.GetGroupFooterStyle: string;
begin
  Result := FFooterStyle;
end;

function TAlephListBoxItemStyleDefaults.GetGroupHeaderStyle: string;
begin
  Result := FHeaderStyle;
end;

function TAlephListBoxItemStyleDefaults.GetItemStyle: string;
begin
  Result := FItemStyle;
end;

procedure TAlephListBoxItemStyleDefaults.SetGroupFooterStyle(const Value: string);
begin
  if FFooterStyle <> Value then
  begin
    FFooterStyle := Value;
    RefreshListBox;
  end;
end;

procedure TAlephListBoxItemStyleDefaults.SetGroupHeaderStyle(const Value: string);
begin
  if FHeaderStyle <> Value then
  begin
    FHeaderStyle := Value;
    RefreshListBox;
  end;
end;

procedure TAlephListBoxItemStyleDefaults.SetItemStyle(const Value: string);
begin
  if FItemStyle <> Value then
  begin
    FItemStyle := Value;
    RefreshListBox;
  end;
end;

procedure TAlephListBoxItemStyleDefaults.RefreshListBox;
var
  Item: TAlephListBoxItem;
begin
  for Item in TControlsFilter<TAlephListBoxItem>.Filter(FListBox.Content.Controls) do
    Item.NeedStyleLookup;
end;

{ TFmxFilteredChildrenList }

constructor TFilteredChildrenList.Create(const Children: TFmxObjectList);
begin
  inherited Create(Children);
  FBaseChildren := Children;
end;

procedure TFilteredChildrenList.ApplyFilter(const Filter: TPredicate<string>);
var
  Item: TFmxObject;
  HeaderIndex, FooterIndex, SectionSize: Integer;
begin
  if not Assigned(Filter) then
    FreeAndNil(FFilteredChildren)
  else
  begin
    if FFilteredChildren = nil then
      FFilteredChildren := TFmxObjectList.Create
    else
      FFilteredChildren.Clear;

    HeaderIndex := -1;
    FooterIndex := -1;
    SectionSize := 0;
    for Item in FBaseChildren do
    begin
      if Item is TAlephListBoxGroupHeader then
      begin
        if SectionSize = 0 then
        begin
          if FooterIndex <> -1  then
            FFilteredChildren.Delete(FooterIndex);
          if HeaderIndex <> -1 then
            FFilteredChildren.Delete(HeaderIndex);
        end;

        FFilteredChildren.Add(Item);
        HeaderIndex := FFilteredChildren.Count - 1;
        FooterIndex := -1;
        SectionSize := 0;
      end
      else if Item is TListBoxGroupFooter then
      begin
        FFilteredChildren.Add(Item);
        FooterIndex := FFilteredChildren.Count - 1;
        if FooterIndex < HeaderIndex then
        begin
          FooterIndex := HeaderIndex;
          HeaderIndex := FFilteredChildren.Count - 1;
        end;
      end
      else if Filter(TAlephListBoxItem(Item).Text) or Filter(TAlephListBoxItem(Item).ItemData.Detail) then
      begin
        FFilteredChildren.Add(Item);
        Inc(SectionSize);
      end;
    end;

    if SectionSize = 0 then
    begin
      if FooterIndex <> -1 then
        FFilteredChildren.Delete(FooterIndex);
      if HeaderIndex <> -1 then
        FFilteredChildren.Delete(HeaderIndex);
    end;
  end;
end;

destructor TFilteredChildrenList.Destroy;
begin
  FreeAndNil(FFilteredChildren);
  inherited;
end;

function TFilteredChildrenList.DoGetEnumerator: TEnumerator<TFmxObject>;
begin
  if FFilteredChildren = nil then
    Result := inherited DoGetEnumerator
  else
    Result := FFilteredChildren.GetEnumerator;
end;

function TFilteredChildrenList.GetChildCount: Integer;
begin
  if FFilteredChildren = nil then
    Result := inherited GetChildCount
  else
    Result := FFilteredChildren.Count;
end;

function TFilteredChildrenList.IndexOf(const Obj: TFmxObject): Integer;
begin
  if FFilteredChildren = nil then
    Result := inherited IndexOf(Obj)
  else
    Result := FFilteredChildren.IndexOf(Obj);
end;

function TFilteredChildrenList.GetChild(AIndex: Integer): TFmxObject;
begin
  if FFilteredChildren = nil then
    Result := inherited GetChild(AIndex)
  else
    Result := FFilteredChildren[AIndex];
end;

{ TAlephListBoxHeader }

function TAlephListBoxHeader.GetDefaultStyleLookupName: string;
begin
  Result := 'toolbarstyle';
end;

type
  TSelectionTimer = class(TTimer)
  private
    [Weak] FSelector: TAlephListBoxSelector;
    [Weak] FItem: TAlephListBoxItem;
    FShift: TShiftState;
    procedure TimerProc(Sender: TObject);
  public
    class function CreateTimer(const Target: TAlephListBoxSelector): TSelectionTimer;
    procedure Reload(const Item: TAlephListBoxItem; const Shift: TShiftState);
    procedure FireIfEquals(const Item: TAlephListBoxItem);
  end;

{ TAlephListBoxSelector }

constructor TAlephListBoxSelector.Create(const ListBox: TAlephCustomListBox);
begin
  FCurrent := -1;
  FListBox := ListBox;
  FFirst := ListBox.ItemIndex;
end;

destructor TAlephListBoxSelector.Destroy;
begin
  AbortDelayed;
  FreeAndNil(FSelectionTimer);
  inherited;
end;

function TAlephListBoxSelector.GetCurrent: Integer;
begin
  Result := FCurrent;
end;

function TAlephListBoxSelector.GetCurrentItem: TAlephListBoxItem;
begin
  Result := FListBox.ItemByIndex(FCurrent);
end;

function TAlephListBoxSelector.GetFirst: Integer;
begin
  Result := FFirst;
end;

procedure TAlephListBoxSelector.KeyboardSelect(const KeyAction: TKeyAction; const Shift: TShiftState;
  const Item: TAlephListBoxItem);
begin
  if Item <> nil then
    DoKeyboardSelect(KeyAction, Shift, Item);
end;

function TAlephListBoxSelector.SelectRange(const Item1, Item2: TAlephListBoxItem): Boolean;
var
  I, First, Last: Integer;
begin
  Result := False;
  if (MultiSelectStyle <> TMultiSelectStyle.None) and (Item1 <> nil) and (Item2 <> nil)
    or ((Item1 <> nil) and (Item1 = Item2))  then
  begin
    First := Min(Item1.Index, Item2.Index);
    Last := Max(Item1.Index, Item2.Index);
    for I := 0 to FListBox.Count - 1 do
      Result := SetSelected(FListBox.ItemByIndex(I), InRange(I, First, Last)) or Result;
  end;
  if Result then
    Change;
end;

procedure TAlephListBoxSelector.SelectAll;
var
  I: Integer;
begin
  if MultiSelectStyle <> TMultiSelectStyle.None then
    for I := 0 to FListBox.Count - 1 do
      SetSelected(FListBox.ItemByIndex(I), True);
end;

procedure TAlephListBoxSelector.Change;
begin
  FListBox.DoChange;
end;

procedure TAlephListBoxSelector.ClearSelection;
var
  I: Integer;
begin
  for I := 0 to FListBox.Count - 1 do
    SetSelected(FListBox.ItemByIndex(I), False);
end;

function TAlephListBoxSelector.SetSelected(const Item: TAlephListBoxItem; const Value: Boolean): Boolean;
begin
  if Item = nil then
    Exit(False);
  Result := Item.IsSelected <> Value;
  FInternalChange := True;
  try
    Item.SetIsSelectedInternal(Value, False);
  finally
    FInternalChange := False;
  end;
end;

procedure TAlephListBoxSelector.UpdateSelection;
begin
  FListBox.UpdateSelection;
end;

procedure TAlephListBoxSelector.ItemStateChanged(const Item: TAlephListBoxItem; const UserChange: Boolean);
begin
  DoItemStateChanged(Item, UserChange);
  UpdateSelection;
  if not FInternalChange then
    Change;
end;

procedure TAlephListBoxSelector.DoItemStateChanged(const Item: TAlephListBoxItem; const UserChange: Boolean);
begin
end;

function TAlephListBoxSelector.SetCurrent(const Index: Integer): Boolean;
begin
  Result := FCurrent <> Index;
  FCurrent := Index;
end;

procedure TAlephListBoxSelector.MouseSelectStart(const Item: TAlephListBoxItem; const Button: TMouseButton;
  const Shift: TShiftState);
begin
  if Button <> TMouseButton.mbLeft then
    Exit;
  if (FListBox.AniCalculations.TouchTracking <> []) and (Item.Index <> FCurrent) then
    DelayedMouseDown(Item, Shift)
  else
    DoMouseSelectStart(Item, Shift);
end;

procedure TAlephListBoxSelector.MouseSelectMove(const Item: TAlephListBoxItem; const Shift: TShiftState);
begin
  if (FListBox.AniCalculations.TouchTracking <> []) then
  begin
    if (FListBox.ItemDown <> nil) and (Item.Index <> FListBox.ItemDown.Index) then
      AbortDelayed;
    Exit;
  end;
  DoMouseSelectMove(Item, Shift);
end;

procedure TAlephListBoxSelector.MouseSelectFinishing(const Item: TAlephListBoxItem; const Button: TMouseButton;
  const Shift: TShiftState);
begin
  if FSelectionTimer <> nil then
    TSelectionTimer(FSelectionTimer).FireIfEquals(Item);
  DoMouseSelectFinishing(Item, Shift);
end;

procedure TAlephListBoxSelector.DoMouseSelectFinishing(const Item: TAlephListBoxItem; const Shift: TShiftState);
begin
end;

procedure TAlephListBoxSelector.MouseSelectFinish(const Item: TAlephListBoxItem; const Button: TMouseButton;
  const Shift: TShiftState);
begin
  DoMouseSelectFinish(Item, Shift);
end;

procedure TAlephListBoxSelector.UserSetIndex(const Index: Integer);
begin
  DoUserSetIndex(Index);
end;

procedure TAlephListBoxSelector.DelayedMouseDown(const ItemDown: TAlephListBoxItem; const Shift: TShiftState);
begin
  if FSelectionTimer = nil then
    FSelectionTimer := TSelectionTimer.CreateTimer(Self);
  TSelectionTimer(FSelectionTimer).Reload(ItemDown, Shift);
end;

procedure TAlephListBoxSelector.AbortDelayed;
begin
  if (FSelectionTimer <> nil) and TSelectionTimer(FSelectionTimer).Enabled then
    TSelectionTimer(FSelectionTimer).Enabled := False;
end;

procedure TAlephListBoxSelector.SetMouseSelectActive(const Value: Boolean);
begin
  FMouseSelectActive := Value;
end;

function TAlephListBoxSelector.GetMouseSelectActive: Boolean;
begin
  Result := FMouseSelectActive;
end;

{ TSelectionTimer }

class function TSelectionTimer.CreateTimer(const Target: TAlephListBoxSelector): TSelectionTimer;
begin
  Result := TSelectionTimer.Create(nil);
  Result.FSelector := Target;
  Result.OnTimer := Result.TimerProc;
  Result.Enabled := False;
end;

procedure TSelectionTimer.FireIfEquals(const Item: TAlephListBoxItem);
begin
  if Enabled and (Item = FItem) then
    TimerProc(Self);
end;

procedure TSelectionTimer.Reload(const Item: TAlephListBoxItem; const Shift: TShiftState);
begin
  if Enabled then
    Enabled := False;
  FItem := Item;
  FShift := Shift;
  Interval := 250;
  Enabled := True;
end;

procedure TSelectionTimer.TimerProc(Sender: TObject);
begin
  Enabled := False;
  FSelector.DoMouseSelectStart(FItem, FShift);
end;

{ TListBoxSelectorFactory }

class function TListBoxSelectorFactory.CreateSelector(const ListBox: TAlephCustomListBox;
  const MultiSelectStyle: TMultiSelectStyle): TAlephListBoxSelector;
begin
  Exit(FSelectors[MultiSelectStyle].Create(ListBox));
end;

class procedure TListBoxSelectorFactory.RegisterSelector(MultiSelectStyle: TMultiSelectStyle;
  Selector: TListBoxSelectorClass);
begin
  FSelectors[MultiSelectStyle] := Selector;
end;

{ TAlephCustomListBox.TStyleSelectionObjects }

procedure TAlephCustomListBox.TStyledSelection.ClearPools;

  procedure ClearList(var AList: TControlList);
  var
    I: Integer;
    Sel: TFmxObject;
  begin
    for I := AList.Count - 1 downto 0 do
    begin
      Sel := AList[I];
      FListBox.RemoveComponent(Sel);
      Sel.Parent := nil;
      Sel.Free;
    end;
    AList.Clear;
  end;

begin
  FListBox.BeginUpdate;
  try
    ClearList(FFocusedObjectsPool);
    ClearList(FUnfocusedObjectsPool);
  finally
    FListBox.EndUpdate;
  end;
end;

constructor TAlephCustomListBox.TStyledSelection.Create(const AListBox: TAlephCustomListBox);
begin
  Assert(AListBox <> nil);

  FListBox := AListBox;
  FUnfocusedObjectsPool := TControlList.Create;
  FFocusedObjectsPool := TControlList.Create;
  FCurrentObjects := FUnfocusedObjectsPool;
end;

function TAlephCustomListBox.TStyledSelection.CreateSelectionControl(const AIsFocused: Boolean): TControl;
var
  Etalon: TControl;
begin
  if AIsFocused and (FFocusedSelection <> nil) then
    Etalon := FFocusedSelection
  else
    Etalon := FUnfocusedSelection;

  Result := TControl(Etalon.Clone(FListBox));
  Result.StyleName := '';  // remove Clone from ResourceList
  Result.Parent := Etalon.Parent;
  Result.Stored := False;
end;

destructor TAlephCustomListBox.TStyledSelection.Destroy;
begin
  FCurrentObjects := nil;
  FUnfocusedSelection := nil;
  FFocusedSelection := nil;
  FListBox := nil;
  FreeAndNil(FUnfocusedObjectsPool);
  FreeAndNil(FFocusedObjectsPool);
  inherited;
end;

procedure TAlephCustomListBox.TStyledSelection.Realign(const ASelectionRects: TList<TRectF>);

  procedure HideExtraSelectionControls(const AList: TControlList; const ASelectionRects: TList<TRectF>);
  var
    I: Integer;
  begin
    if ASelectionRects.Count < AList.Count then
      for I := ASelectionRects.Count to AList.Count - 1 do
        AList[I].Visible := False;
  end;

var
  I: Integer;
  Clone: TControl;
begin
  if FFocusedSelection = nil then
    Exit;

  // create missed selections controls
  for I := FCurrentObjects.Count to ASelectionRects.Count - 1 do
  begin
    Clone := CreateSelectionControl(IsFocused);
    FCurrentObjects.Add(Clone);
  end;
  HideExtraSelectionControls(FCurrentObjects, ASelectionRects);

  // align selections
  for I := 0 to ASelectionRects.Count - 1 do
  begin
    FCurrentObjects[I].Visible := True;
    FCurrentObjects[I].BoundsRect := ASelectionRects[I];
  end;
end;

procedure TAlephCustomListBox.TStyledSelection.SetIsFocused(const Value: Boolean);

  procedure HideControls(const AList: TControlList);
  var
    I: Integer;
  begin
    for I := 0 to AList.Count - 1 do
      AList[I].Visible := False;
  end;

begin
  if FIsFocused <> Value then
  begin
    FIsFocused := Value;
    HideControls(FCurrentObjects);
    if FIsFocused then
      FCurrentObjects := FFocusedObjectsPool
    else
      FCurrentObjects := FUnfocusedObjectsPool;
  end;
end;

initialization
  RegisterSelectionControllers;
  RegisterFmxClasses([TAlephCustomListBox, TAlephCustomComboBox, TAlephListBoxItem, TAlephListBox,
    TAlephComboBox, TAlephMetropolisUIListBoxItem, TAlephListBoxHeader, TAlephListBoxGroupHeader, TListBoxGroupFooter]);
end.

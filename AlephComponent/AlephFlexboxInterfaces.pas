unit AlephFlexboxInterfaces;

interface

uses
  System.Generics.Collections, FMX.Controls, AlephFlexboxEnums;

type
//  IContainer = interface
//    ['{1F1E2AD2-ED97-459A-9D12-202B36560C29}']
//    function GetWidth: Single;
//    function GetHeight: Single;
//    property Width: Single read GetWidth;
//    property Height: Single read GetHeight;
//  end;
  IFlexContainer = interface
    ['{4B84BB9A-59CB-4BA9-96F3-95C8F12BE894}']
    procedure CalculateLayout;
    procedure AddItem(AControl: TControl);
    procedure RemoveItem(AControl: TControl);
    function GetItems: TList<TFlexItem>;
    function GetFlexDirection: TFlexDirection;
    procedure SetFlexDirection(Value: TFlexDirection);
    function GetJustifyContent: TJustifyContent;
    procedure SetJustifyContent(Value: TJustifyContent);
    function GetAlignItems: TAlignItems;
    procedure SetAlignItems(Value: TAlignItems);
    property FlexDirection: TFlexDirection read GetFlexDirection write SetFlexDirection;
    property JustifyContent: TJustifyContent read GetJustifyContent write SetJustifyContent;
    property AlignItems: TAlignItems read GetAlignItems write SetAlignItems;
  end;

implementation

end.


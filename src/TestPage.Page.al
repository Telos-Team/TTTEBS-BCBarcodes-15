page 80283 "TTTEBS-BCTestPage"
{
    PageType = Card;
    Caption = 'Test Page';

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Item No."; r_Item."No.")
                {
                    ApplicationArea = All;
                    TableRelation = Item;
                }
                field("Customer No."; r_Cust."No.")
                {
                    ApplicationArea = All;
                    TableRelation = Customer;
                }
                field("Barcode Value"; v_BarcodeValue)
                {
                    ApplicationArea = All;
                }
            }
            group(Parameters)
            {
                field("Type"; v_Type)
                {
                    ApplicationArea = All;
                }
                field("Barcode Type"; v_BarcodeType)
                {
                    ApplicationArea = All;
                    TableRelation = "TTTEBS-BCBarcodeType";
                }
                field("Height"; v_Height)
                {
                    ApplicationArea = All;
                }
                field("Width"; v_Width)
                {
                    ApplicationArea = All;
                }
                field("With Text"; v_WithText)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group(InGeneral)
            {
                Caption = 'In General';
                Image = DataEntry;
                action(BarcodeList)
                {
                    Promoted = true;
                    PromotedIsBig = true;
                    Caption = 'Barcode List';
                    ApplicationArea = All;
                    PromotedCategory = Process;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        Page.Run(page::"TTTEBS-BCBarcodeList");
                    end;
                }
                action(BarcodeEntriesList)
                {
                    Promoted = true;
                    PromotedIsBig = true;
                    Caption = 'Barcode Entries List';
                    ApplicationArea = All;
                    PromotedCategory = Process;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        Page.Run(page::"TTTEBS-BCBarcodeEntriesList");
                    end;
                }
                action(BarcodeTypeList)
                {
                    Promoted = true;
                    PromotedIsBig = true;
                    Caption = 'Barcode Type List';
                    ApplicationArea = All;
                    PromotedCategory = Process;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        Page.Run(page::"TTTEBS-BCBarcodeTypeList");
                    end;
                }
            }
            group(Testing)
            {
                Caption = 'Testing';
                Image = DataEntry;
                action("CreateTestBarcode")
                {
                    Promoted = true;
                    PromotedIsBig = true;
                    Caption = 'Create Test Barcode';
                    ApplicationArea = All;
                    PromotedCategory = Process;
                    PromotedOnly = true;

                    trigger OnAction()
                    var
                        lc_BarcodeFromURL: Codeunit "TTTEBS-BCBarcodeURL";
                        lr_BarcodeEntries: Record "TTTEBS-BCBarcodeEntries";
                        lr_Item: Record Item;
                        lr_Cust: Record Customer;
                    begin
                        if not confirm(Text001Lbl, true) then
                            error(Text002Lbl);

                        if strpos(v_BarcodeType, 'EAN13') > 0 then
                            if StrLen(v_BarcodeValue) <> 12 then
                                Error(Text003Lbl);

                        if lr_Item.get(r_Item."No.") then begin
                            lc_BarcodeFromURL.CreateBarcode(lr_BarcodeEntries,
                                                            lr_Item.RecordId,
                                                            v_BarcodeValue,
                                                            v_Type,
                                                            format(v_BarcodeType),
                                                            v_Height,
                                                            v_Width,
                                                            v_WithText
                                                            );
                        end;
                        if lr_Cust.get(r_Cust."No.") then begin
                            lc_BarcodeFromURL.CreateBarcode(lr_BarcodeEntries,
                                                            lr_Cust.RecordId,
                                                            v_BarcodeValue,
                                                            v_Type,
                                                            format(v_BarcodeType),
                                                            v_Height,
                                                            v_Width,
                                                            v_WithText
                                                            );
                        end;
                    end;
                }
                action("BarCodeReport01")
                {
                    Promoted = true;
                    PromotedIsBig = true;
                    Caption = 'Barcode report';
                    ApplicationArea = All;
                    PromotedCategory = Report;
                    PromotedOnly = true;

                    trigger OnAction();

                    begin
                        Report.Run(report::"TTTEBS-BCItemLabels");
                    end;
                }

            }
        }
    }
    trigger OnOpenPage()
    begin
        v_BarcodeValue := '123456789012';  // TEST
    end;

    var
        r_Item: record Item;
        r_Cust: record Customer;
        v_BarcodeValue: Code[20];
        v_Type: code[20];
        // v_BarcodeType: Enum "TTTEBS-BCBarcodeTypeEnum2";
        v_BarcodeType: Code[20];
        v_Height: Integer;
        v_Width: Integer;
        v_WithText: Boolean;
        Text001Lbl: Label 'Create Test Barcode!';
        Text002Lbl: Label 'Function terminated!';
        Text003Lbl: Label 'Barcode Value must be 12 sign long!';
}

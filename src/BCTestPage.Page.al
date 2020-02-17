page 80283 "TTT-EBS-BCTestPage"
{
    PageType = Card;
    Caption = 'Test Page';
    ApplicationArea = all;
    UsageCategory = Lists;

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
                    Caption = 'Item No.';
                    ToolTip = 'Specifies Item No. - Only for testing';
                }
                field("Customer No."; r_Cust."No.")
                {
                    ApplicationArea = All;
                    TableRelation = Customer;
                    Caption = 'Customer No.';
                    ToolTip = 'Specifies Customer No. - Only for testing';
                }
                field("Barcode Value"; v_BarcodeValue)
                {
                    ApplicationArea = All;
                    Caption = 'Barcode Value';
                    ToolTip = 'Specifies the Barcode Value, on wich we generate the Barcode picture - Only for testing';
                }
            }
            group(Parameters)
            {
                field("Type"; v_Type)
                {
                    ApplicationArea = All;
                    Caption = 'Type';
                    ToolTip = 'Specifies Type - Only for testing';
                }
                field("Barcode Type"; v_BarcodeType)
                {
                    ApplicationArea = All;
                    TableRelation = "TTT-EBS-BCBarcodeType";
                    Caption = 'Barcode Type';
                    ToolTip = 'Specifies Barcode Type - Only for testing';
                }
                field("Height"; v_Height)
                {
                    ApplicationArea = All;
                    Caption = 'Height';
                    ToolTip = 'Specifies Height - Only for testing';
                }
                field("Width"; v_Width)
                {
                    ApplicationArea = All;
                    Caption = 'Width';
                    ToolTip = 'Specifies Width - Only for testing';
                }
                field("With Text"; v_WithText)
                {
                    ApplicationArea = All;
                    Caption = 'With Text';
                    ToolTip = 'Specifies With Text - Only for testing';
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
                    Image = ListPage;
                    ToolTip = 'View Barcode List - Only for testing';

                    trigger OnAction()
                    begin
                        Page.Run(page::"TTT-EBS-BCBarcodeList");
                    end;
                }
                action(BarcodeEntryList)
                {
                    Promoted = true;
                    PromotedIsBig = true;
                    Caption = 'Barcode Entry List';
                    ApplicationArea = All;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    Image = EntriesList;
                    ToolTip = 'View Barcode Entry List - Only for testing';

                    trigger OnAction()
                    begin
                        Page.Run(page::"TTT-EBS-BCBarcodeEntryList");
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
                    Image = SetupList;
                    ToolTip = 'View Barcode Type List - Only for testing';

                    trigger OnAction()
                    begin
                        Page.Run(page::"TTT-EBS-BCBarcodeTypeList");
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
                    Image = TestFile;
                    ToolTip = 'Create Test Barcode - Only for testing';

                    trigger OnAction()
                    var
                        lr_BarcodeEntries: Record "TTT-EBS-BCBarcodeEntry";
                        lr_Item: Record Item;
                        lr_Cust: Record Customer;
                        lc_BarcodeFromURL: Codeunit "TTT-EBS-BCBarcodeURL";
                    begin
                        if not confirm(CreateTestBarcodeLbl, true) then
                            error(FunctionTerminatedErr);

                        if strpos(v_BarcodeType, 'EAN13') > 0 then
                            if StrLen(v_BarcodeValue) <> 12 then
                                Error(BarcodeMustBe12CharactersLongErr, v_BarcodeValue);

                        if lr_Item.get(r_Item."No.") then
                            lc_BarcodeFromURL.CreateBarcode(lr_BarcodeEntries,
                                                            lr_Item.RecordId(),
                                                            v_BarcodeValue,
                                                            v_Type,
                                                            format(v_BarcodeType),
                                                            v_Height,
                                                            v_Width,
                                                            v_WithText
                                                            );
                        if lr_Cust.get(r_Cust."No.") then
                            lc_BarcodeFromURL.CreateBarcode(lr_BarcodeEntries,
                                                            lr_Cust.RecordId(),
                                                            v_BarcodeValue,
                                                            v_Type,
                                                            format(v_BarcodeType),
                                                            v_Height,
                                                            v_Width,
                                                            v_WithText
                                                            );
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
                    Image = TestReport;
                    ToolTip = 'Run test report - "Item Labels", that also generate barcodes - Only for testing';

                    trigger OnAction();
                    begin
                        Report.Run(Report::"TTT-EBS-BCItemLabels");
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
        v_BarcodeType: Code[20];
        v_Height: Integer;
        v_Width: Integer;
        v_WithText: Boolean;
        CreateTestBarcodeLbl: Label 'Create Test Barcode!';
        FunctionTerminatedErr: Label 'Function terminated!';
        BarcodeMustBe12CharactersLongErr: Label 'Barcode Value %1, must be 12 characters long!', Comment = '%1 = Barcode Value';
}

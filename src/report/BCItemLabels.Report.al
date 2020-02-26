report 80281 "TTT-EBS-BCItemLabels"
{
    UsageCategory = Lists;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = '.\layout\BCItemLabels.Report.rdl';
    Caption = 'Item Labels';
    UseRequestPage = true;

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.";

            column(No_Item; "No.")
            {
            }
            column(Description_Item; Description)
            {
            }
            column(Description2_Item; "Description 2")
            {
            }
            column(Picture_Item; Picture)
            {
            }
            column(PackingDate; Format(Today()))
            {
            }
            dataitem("Item Cross Reference"; "Item Cross Reference")
            {
                DataItemLink = "Item No." = field("No.");
                DataItemLinkReference = "Item";
                DataItemTableView = sorting("Item No.");

                column(Barcode; r_BarcodeEntries."Barcode")
                {
                }
                column(BarcodeValue_BarcodeEntries; r_BarcodeEntries."BarcodeValue")
                {
                }
                column(PrintWOBarcode; v_PrintWOBarcode)
                {
                }
                trigger OnAfterGetRecord()
                begin
                    IF v_PrintWOBarcode then
                        exit;
                    if StrPos(v_BarcodeType, 'EAN13') > 0 then
                        if StrLen("Cross-Reference No.") <> 12 then
                            Error(BarcodeMustBe12CharactersLongErr);
                    c_BarCodeFromURL.CreateBarcode(r_BarcodeEntries,
                                                    RecordId(),
                                                    "Cross-Reference No.",
                                                    v_Type,
                                                    Format(v_BarcodeType),
                                                    v_Height,
                                                    v_Width,
                                                    v_WithText
                                                    );
                end;
            }
        }
    }

    requestpage
    {
        // SaveValues = true;
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PrintWOBarcode; v_PrintWOBarcode)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Without Barcode';
                        ToolTip = 'If set, then reports are printed without Barcode';
                    }
                    field("Type"; v_Type)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Type';
                        ToolTip = 'Set type';
                    }
                    field("BarcodeType"; v_BarcodeType)
                    {
                        ApplicationArea = Basic, Suite;
                        TableRelation = "TTT-EBS-BCBarcodeType";
                        Caption = 'Barcode Type';
                        ToolTip = 'Set Barcode Type';
                    }
                    field("Height"; v_Height)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Height';
                        ToolTip = 'Set Height';
                    }
                    field("Width"; v_Width)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Width';
                        ToolTip = 'Set Width';
                    }
                    field("WithText"; v_WithText)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'With Text';
                        ToolTip = 'Set With Text';
                    }
                }
            }
        }
    }

    labels
    {
        PackingDateLbl = 'Packing Date';
    }

    var
        r_BarcodeEntries: record "TTT-EBS-BCBarcodeEntry";
        c_BarCodeFromURL: Codeunit "TTT-EBS-BCBarCodeURL";
        v_PrintWOBarcode: Boolean;
        v_Type: code[20];
        v_BarcodeType: Code[20];
        v_Height: Integer;
        v_Width: Integer;
        v_WithText: Boolean;
        BarcodeMustBe12CharactersLongErr: Label 'Barcode Value must be 12 characters long!';

}

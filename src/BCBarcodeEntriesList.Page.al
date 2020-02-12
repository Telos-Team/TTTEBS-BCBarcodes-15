page 80282 "TTT-EBS-BCBarcodeEntriesList"
{

    PageType = List;
    SourceTable = "TTT-EBS-BCBarcodeEntries";
    Caption = 'Barcode Entries List';
    ApplicationArea = All;
    UsageCategory = Lists;

    InsertAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Link SID"; "LinkSID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the System ID from the linked table Barcode (Part of primary key)';
                }
                field("Entry No."; "EntryNo.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies several Barcode Entries per Barcode (Part of primary key)';
                }
                field(Type; Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a type - Optional';
                }
                field("Barcode Type"; "BarcodeType")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies wich Barcode Type used (EAN13, Code128, QR, and so on..)';
                }
                field(Height; Height)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Hight of the Barcode Blob - Optional';
                }
                field(Width; Width)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Width of the Barcode Blob - Optional';
                }
                field("With Text"; "WithText")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the Barcode Blob is With Text - Optional';
                }
                field("Barcode Value"; "BarcodeValue")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Barcode';
                }
                field("Barcode HasValue"; v_Barcode)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Barcode HasValue';
                    ToolTip = 'Specifies if the Barcode has value';
                }
                field("SID"; Format(SystemId))
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the System ID of the current record';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group(VariousFunctions)
            {
                Caption = 'Various Functions';
                Image = DataEntry;
                action(ShowBarcode)
                {
                    Promoted = true;
                    PromotedIsBig = true;
                    Caption = 'Show Barcode';
                    ApplicationArea = All;
                    PromotedCategory = Process;
                    Image = "8ball";
                    PromotedOnly = true;
                    ToolTip = 'View the Barcode';

                    trigger OnAction()
                    var
                        lr_BarcodeEntries: Record "TTT-EBS-BCBarcodeEntries";
                    begin
                        lr_BarcodeEntries.setrange("LinkSID", "LinkSID");
                        lr_BarcodeEntries.SetRange("EntryNo.", "EntryNo.");
                        report.Run(report::"TTT-EBS-BCBarcodeEntriesPictur", true, true, lr_BarcodeEntries);
                    end;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        CalcFields(Barcode);
        IF barcode.HasValue() then
            v_Barcode := true;
    end;

    var
        v_Barcode: Boolean;
}
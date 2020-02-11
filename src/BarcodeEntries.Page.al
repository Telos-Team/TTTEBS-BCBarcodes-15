page 80282 "TTTEBS-BCBarcodeEntriesList"
{

    PageType = List;
    SourceTable = "TTTEBS-BCBarcodeEntries";
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
                field("Link SID"; "Link SID")
                {
                    ApplicationArea = All;
                }
                field("Entry No."; "Entry No.")
                {
                    ApplicationArea = All;
                }
                field(Type; Type)
                {
                    ApplicationArea = All;
                }
                field("Barcode Type"; "Barcode Type")
                {
                    ApplicationArea = All;
                }
                field(Height; Height)
                {
                    ApplicationArea = All;
                }
                field(Width; Width)
                {
                    ApplicationArea = All;
                }
                field("With Text"; "With Text")
                {
                    ApplicationArea = All;
                }
                field("Barcode Value"; "Barcode Value")
                {
                    ApplicationArea = All;
                }
                field("Barcode HasValue"; v_Barcode)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("SID"; Format(SystemId))
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

                    trigger OnAction()
                    var
                        lr_BarcodeEntries: Record "TTTEBS-BCBarcodeEntries";
                    begin
                        lr_BarcodeEntries.setrange("Link SID", "Link SID");
                        lr_BarcodeEntries.SetRange("Entry No.", "Entry No.");
                        report.Run(report::"TTTEBS-BCBarcodeEntriesPicture", true, true, lr_BarcodeEntries);
                    end;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        CalcFields(Barcode);
        IF barcode.HasValue then
            v_Barcode := true;
    end;

    var
        v_Barcode: Boolean;
}

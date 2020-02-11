page 80281 "TTTEBS-BCBarcodeList"
{
    PageType = List;
    SourceTable = "TTTEBS-BCBarcode";
    Caption = 'Barcode List';
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
                field("Table ID"; "Table ID")
                {
                    ApplicationArea = All;
                }
                field("Link SID"; "Link SID")
                {
                    ApplicationArea = All;
                }
                field("Link RID"; "Link Record ID")
                {
                    ApplicationArea = All;
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
            group("Barcode")
            {
                Caption = 'Barcode';
                Image = DataEntry;
                action("BarcodeEntries")
                {
                    Promoted = true;
                    PromotedIsBig = true;
                    Caption = 'Barcode Entries';
                    ApplicationArea = All;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        lr_BarcodeEntries: Record "TTTEBS-BCBarcodeEntries";
                    begin
                        lr_BarcodeEntries.setrange("Link SID", format(SystemId));
                        Page.Run(page::"TTTEBS-BCBarcodeEntriesList", lr_BarcodeEntries);
                    end;
                }
            }
        }
    }
}

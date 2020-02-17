page 80281 "TTT-EBS-BCBarcodeList"
{
    PageType = List;
    SourceTable = "TTT-EBS-BCBarcode";
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
                field("Table ID"; "TableID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Table ID of which table the Barcode is generated (Part of primary key)';
                }
                field("Link SID"; "LinkSID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unik System ID from the linked Table-ID (Part of primary key)';

                }
                field("Link RID"; "LinkRecordID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unik Record ID from wich the Barcode is generated';
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
                    Image = "8ball";
                    PromotedOnly = true;
                    ToolTip = 'View the linked Barcode Entries';

                    trigger OnAction()
                    var
                        lr_BarcodeEntries: Record "TTT-EBS-BCBarcodeEntry";
                    begin
                        lr_BarcodeEntries.SetRange("LinkSID", format(SystemId));
                        Page.Run(page::"TTT-EBS-BCBarcodeEntryList", lr_BarcodeEntries);
                    end;
                }
            }
        }
    }
}

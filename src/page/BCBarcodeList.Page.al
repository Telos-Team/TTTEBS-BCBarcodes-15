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
                field(TableID; TableID)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Table ID of which table the Barcode is generated (Part of primary key).';
                }
                field(LinkSystemID; LinkSystemID)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique System ID from the linked Table-ID (Part of primary key).';

                }
                field(LinkRecordID; Format(LinkRecordID))
                {
                    ApplicationArea = All;
                    Caption = 'Link Record ID';
                    ToolTip = 'Specifies the unique Record ID from wich the Barcode is generated.';
                }
                field(SystemID; Format(SystemId))
                {
                    ApplicationArea = All;
                    Caption = 'System ID';
                    ToolTip = 'Specifies the System ID of the current record.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("BarcodeEntries")
            {
                Caption = 'Barcode Entries';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Image = EntriesList;
                ToolTip = 'View the linked Barcode Entries.';

                trigger OnAction()
                var
                    lr_BarcodeEntries: Record "TTT-EBS-BCBarcodeEntry";
                begin
                    lr_BarcodeEntries.SetRange(LinkSystemID, format(SystemId));
                    Page.Run(page::"TTT-EBS-BCBarcodeEntryList", lr_BarcodeEntries);
                end;
            }
        }
    }
}

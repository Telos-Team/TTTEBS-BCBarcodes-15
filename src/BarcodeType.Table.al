table 80283 "TTTEBS-BCBarcodeType"
{
    Caption = 'Barcode Types';
    DataClassification = CustomerContent;

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(10; URL; Text[250])
        {
            Caption = 'URL';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
}

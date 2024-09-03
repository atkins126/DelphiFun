object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 158
  ClientWidth = 628
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 21
  object lblUUID: TLabel
    Left = 0
    Top = 57
    Width = 628
    Height = 24
    Alignment = taCenter
    AutoSize = False
    Caption = 'lblUUID'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 628
    Height = 41
    Align = alTop
    Caption = 'Your MachineUUID is:'
    TabOrder = 0
    ExplicitLeft = 200
    ExplicitTop = 96
    ExplicitWidth = 185
  end
  object Panel2: TPanel
    Left = 0
    Top = 104
    Width = 628
    Height = 54
    Align = alBottom
    Padding.Left = 6
    Padding.Top = 3
    Padding.Right = 6
    Padding.Bottom = 3
    TabOrder = 1
    ExplicitTop = 95
    object Label1: TLabel
      Left = 7
      Top = 4
      Width = 614
      Height = 46
      Align = alClient
      Caption = 
        'The MachineUUID is stored in your BIOS. It will stay the same ev' +
        'en after reinstalling Windows.'
      WordWrap = True
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitWidth = 580
      ExplicitHeight = 42
    end
  end
end

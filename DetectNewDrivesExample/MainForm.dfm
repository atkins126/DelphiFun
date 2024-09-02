object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'How to detect newly attached drives'
  ClientHeight = 442
  ClientWidth = 628
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 628
    Height = 57
    Align = alTop
    Padding.Left = 6
    Padding.Top = 6
    Padding.Right = 3
    Padding.Bottom = 3
    TabOrder = 0
    object Label1: TLabel
      Left = 7
      Top = 7
      Width = 617
      Height = 46
      Align = alClient
      Caption = 
        'Attach a new USB drive or double click some *.iso file in Window' +
        's Explorer and see the drives appearing and disappearing here.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      WordWrap = True
      ExplicitWidth = 601
      ExplicitHeight = 42
    end
  end
  object log: TMemo
    Left = 0
    Top = 57
    Width = 628
    Height = 385
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    ExplicitLeft = 192
    ExplicitTop = 208
    ExplicitWidth = 185
    ExplicitHeight = 89
  end
end

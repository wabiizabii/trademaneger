//+------------------------------------------------------------------+
//|                                                   ui_handler.mqh |
//|                     Handles all UI Creation and Management       |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Your Name"
#property link      "https://www.mql5.com"

//--- นำเข้าไฟล์ตั้งค่าและไลบรารี UI ที่จำเป็น ---
#include "../config/config.mqh" // ** แก้ไข path ให้ถูกต้อง **
#include <Controls/Dialog.mqh>
#include <Controls/Label.mqh>
#include <Controls/Edit.mqh>
#include <Controls/Button.mqh>
#include <Controls/CheckBox.mqh>
#include <Controls/Groupbox.mqh> // ** เพิ่ม GroupBox **

//--- ประกาศตัวแปร Global สำหรับ UI Controls ---
CAppDialog ExtDialog;

//--- Mode Selection ---
CButton ModeCustomButton;
CButton ModeFiboButton;
CButton ModeManageButton;

//--- Container for each mode's controls ---
CGroupBox CustomGroup;

//--- CUSTOM Mode Controls ---
CLabel    CustomRiskLabel;
CEdit     CustomRiskEdit;
CLabel    CustomEntryTypeLabel;
CButton   CustomMarketRadio;
CButton   CustomPendingRadio;
CLabel    CustomPendingPriceLabel;
CEdit     CustomPendingPriceEdit;
CLabel    CustomSlLabel;
CEdit     CustomSlEdit;
CLabel    CustomTpLabel;
CEdit     CustomTpEdit; // For RR Ratio
CLabel    CustomOptionsLabel;
CCheckBox CustomBeCheck;
CEdit     CustomBePipsEdit;
CCheckBox CustomTsCheck;
CEdit     CustomTsPipsEdit;

//--- ส่วนแสดงผลและปุ่มหลัก ---
CButton ExecuteButton;


//+------------------------------------------------------------------+
//| Creates the entire control panel                                 |
//+------------------------------------------------------------------+
bool CreatePanel(long chart_id)
  {
//--- สร้าง Panel หลัก ---
   if(!ExtDialog.Create(chart_id,"TradeManagerPanel",0,50,50,PANEL_WIDTH,PANEL_HEIGHT)) return(false);
   ExtDialog.Caption("Trade Manager v3.0");

//--- สร้างส่วนสลับโหมด ---
   int y_pos = 10;
   if(!ModeCustomButton.Create(0,"ModeCustomButton",0,15,y_pos,80,25)) return(false);
   ModeCustomButton.Text("CUSTOM"); ModeCustomButton.Id(IDC_MODE_CUSTOM_BUTTON); ModeCustomButton.Pressed(true);
   if(!ExtDialog.Add(GetPointer(ModeCustomButton))) return(false);

   if(!ModeFiboButton.Create(0,"ModeFiboButton",0,100,y_pos,80,25)) return(false);
   ModeFiboButton.Text("FIBO"); ModeFiboButton.Id(IDC_MODE_FIBO_BUTTON);
   if(!ExtDialog.Add(GetPointer(ModeFiboButton))) return(false);

   if(!ModeManageButton.Create(0,"ModeManageButton",0,185,y_pos,80,25)) return(false);
   ModeManageButton.Text("MANAGE"); ModeManageButton.Id(IDC_MODE_MANAGE_BUTTON);
   if(!ExtDialog.Add(GetPointer(ModeManageButton))) return(false);
   
   y_pos+=35;

//--- สร้าง GroupBox สำหรับโหมด CUSTOM ---
   if(!CustomGroup.Create(0,"CustomGroup",0,5,y_pos,PANEL_WIDTH-10,PANEL_HEIGHT-y_pos-50)) return(false);
   if(!ExtDialog.Add(GetPointer(CustomGroup))) return(false);

//--- สร้าง Controls ทั้งหมดของโหมด CUSTOM (แล้วแอดเข้า GroupBox) ---
   int y_group_pos=10;
   // Risk
   if(!CustomRiskLabel.Create(0,"CustomRiskLabel",0,10,y_group_pos,80,20)) return(false);
   CustomRiskLabel.Text("Risk %:");
   if(!CustomGroup.Add(GetPointer(CustomRiskLabel))) return(false);
   if(!CustomRiskEdit.Create(0,"CustomRiskEdit",0,90,y_group_pos,80,20)) return(false);
   CustomRiskEdit.Text(DoubleToString(DEFAULT_RISK_PERCENT,1));
   if(!CustomGroup.Add(GetPointer(CustomRiskEdit))) return(false);
   y_group_pos+=30;
   
   // Entry Type
   if(!CustomEntryTypeLabel.Create(0,"CustomEntryTypeLabel",0,10,y_group_pos,80,20)) return(false);
   CustomEntryTypeLabel.Text("Entry Type:");
   if(!CustomGroup.Add(GetPointer(CustomEntryTypeLabel))) return(false);
   if(!CustomMarketRadio.Create(0,"CustomMarketRadio",0,90,y_group_pos,80,20)) return(false);
   CustomMarketRadio.Text("Market"); CustomMarketRadio.Type(BUTTON_TYPE_RADIO); CustomMarketRadio.Group(2); CustomMarketRadio.Pressed(true);
   if(!CustomGroup.Add(GetPointer(CustomMarketRadio))) return(false);
   if(!CustomPendingRadio.Create(0,"CustomPendingRadio",0,175,y_group_pos,80,20)) return(false);
   CustomPendingRadio.Text("Pending"); CustomPendingRadio.Type(BUTTON_TYPE_RADIO); CustomPendingRadio.Group(2);
   if(!CustomGroup.Add(GetPointer(CustomPendingRadio))) return(false);
   y_group_pos+=30;

   // SL / TP
   if(!CustomSlLabel.Create(0,"CustomSlLabel",0,10,y_group_pos,80,20)) return(false);
   CustomSlLabel.Text("SL (Pips):");
   if(!CustomGroup.Add(GetPointer(CustomSlLabel))) return(false);
   if(!CustomSlEdit.Create(0,"CustomSlEdit",0,90,y_group_pos,80,20)) return(false);
   CustomSlEdit.Text(IntegerToString(DEFAULT_SL_PIPS));
   if(!CustomGroup.Add(GetPointer(CustomSlEdit))) return(false);

   if(!CustomTpLabel.Create(0,"CustomTpLabel",0,180,y_group_pos,50,20)) return(false);
   CustomTpLabel.Text("TP (RR):");
   if(!CustomGroup.Add(GetPointer(CustomTpLabel))) return(false);
   if(!CustomTpEdit.Create(0,"CustomTpEdit",0,235,y_group_pos,80,20)) return(false);
   CustomTpEdit.Text(DoubleToString(DEFAULT_RR_RATIO,1));
   if(!CustomGroup.Add(GetPointer(CustomTpEdit))) return(false);
   y_group_pos+=30;
   
   // Options
   if(!CustomBeCheck.Create(0,"CustomBeCheck",0,10,y_group_pos,100,20)) return(false);
   CustomBeCheck.Text("Break Even");
   if(!CustomGroup.Add(GetPointer(CustomBeCheck))) return(false);
   if(!CustomBePipsEdit.Create(0,"CustomBePipsEdit",0,115,y_group_pos,60,20)) return(false);
   CustomBePipsEdit.Text("200");
   if(!CustomGroup.Add(GetPointer(CustomBePipsEdit))) return(false);

   if(!CustomTsCheck.Create(0,"CustomTsCheck",0,185,y_group_pos,100,20)) return(false);
   CustomTsCheck.Text("Trailing Stop");
   if(!CustomGroup.Add(GetPointer(CustomTsCheck))) return(false);
   if(!CustomTsPipsEdit.Create(0,"CustomTsPipsEdit",0,290,y_group_pos,60,20)) return(false);
   CustomTsPipsEdit.Text("200");
   if(!CustomGroup.Add(GetPointer(CustomTsPipsEdit))) return(false);


//--- สร้างปุ่ม Execute หลัก ---
   if(!ExecuteButton.Create(0,"ExecuteButton",0,15,PANEL_HEIGHT-45,PANEL_WIDTH-30,30)) return(false);
   ExecuteButton.Text("EXECUTE PLAN"); ExecuteButton.Id(IDC_EXECUTE_BUTTON);
   if(!ExtDialog.Add(GetPointer(ExecuteButton))) return(false);

//--- สั่งให้ Panel เริ่มทำงานและแสดงผล ---
   if(!ExtDialog.Run())
     {
      ExtDialog.Destroy();
      return(false);
     }
   ChartRedraw();
   return(true);
  }

//+------------------------------------------------------------------+
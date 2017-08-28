--message('Hello World!');

CHARACTER_FRAME_DEFAULT_WIDTH = 384;
CHARACTER_FRAME_NEW_WIDTH = 564;

isPopoutExpanded = true;

function HelloWorld() 
  print("CataStats v0.1 loaded."); 
end


function CStats_RegisterEvents(self)

  --self:RegisterEvent("VARIABLES_LOADED");
  --self:RegisterEvent("ADDON_LOADED");

  --self:RegisterEvent("CHAT_MSG_ADDON");
  --self:RegisterEvent("WHO_LIST_UPDATE");
  --self:RegisterEvent("PLAYER_ENTERING_WORLD");
  print("Registered events");
      
end

--CStatsContainer
--CStatsContainer
function InitStatWindow()
  
  for i=1, getn(PLAYERSTAT_DROPDOWN_OPTIONS) do
    local name = _G[PLAYERSTAT_DROPDOWN_OPTIONS[i]];
    local frame = CreateFrame("Frame", "CStats"..name, CStats_ScrollChild, "");
    local label = frame:CreateFontString("CStatsGroup"..i, 'OVERLAY');

    label:SetFont("Fonts\\ARIALN.ttf", 12)
    label:SetWidth(236)
    label:SetHeight(28)
    label:SetJustifyH("LEFT")
    label:SetText(_G[PLAYERSTAT_DROPDOWN_OPTIONS[i]]);
    label:SetPoint("TOPLEFT", frame);
     if i == 1 then
        label:SetPoint("TOPLEFT", CStats_ScrollChild) 
    else
        label:SetPoint("TOPLEFT", _G["CStatsGroup"..i-1], "BOTTOMLEFT")
    end
  --  print(PLAYERSTAT_DROPDOWN_OPTIONS[i]);
  --  print(_G[PLAYERSTAT_DROPDOWN_OPTIONS[i]]);
  --  --print(UnitStat("player", i)); -- Attributes
  --[[
    print(frame:GetName());
    frame:SetFrameLevel(frame:GetParent():GetFrameLevel() + 2);
    frame:Show();
    frame.StatLabel
    print(frame.StatLabel:GetText());
    frame:SetHeight(30);
    frame:SetWidth(179);
    DebugShowFrameSize(frame);--]]
  end

  --[[
  for i = 1, 30 do
    local addonText = CStats_ScrollChild:CreateFontString("Childlist"..i, 'OVERLAY')
    if i == 1 then
        addonText:SetPoint("TOPLEFT", CStats_ScrollChild) 
    else
        addonText:SetPoint("TOPLEFT", _G["Childlist"..i-1], "BOTTOMLEFT")
    end
    
    addonText:SetText("Child #"..i)
end--]]

  --SetStats(CChild1,1);
  --SetStats(CChild2,2);
  --SetStats(CChild3,3);
  --SetStats(CChild4,4);
  --SetStats(CChild5,5);

--CStats_ScrollChild:SetSize(128,600);
--CStats_ScrollChild.texture = texture;

print("-------");
print(getn(CStats_ScrollChild:GetChildren()));

end




function SetStats(statFrame, statIndex)
  local label = _G[statFrame:GetName().."Label"];
  local text = _G[statFrame:GetName().."StatText"];
  local stat;
  local effectiveStat;
  local posBuff;
  local negBuff;
  stat, effectiveStat, posBuff, negBuff = UnitStat("player", statIndex);
  local statName = _G["SPELL_STAT"..statIndex.."_NAME"];
  label:SetText(format(STAT_FORMAT, statName));
end

function ResizeCharacterFrame()

  

end

function ExpandCharacterFrame()
  isPopoutExpanded = true;

  CharacterFrame:SetWidth(CHARACTER_FRAME_NEW_WIDTH);
  CharacterFrameCloseButton:SetPoint("TOPRIGHT", -6, -9);

  CStatsOverlayPopoutButton:SetNormalTexture("Interface/Buttons/UI-SpellbookIcon-PrevPage-Up");
  CStatsOverlayPopoutButton:SetPushedTexture("Interface/Buttons/UI-SpellbookIcon-PrevPage-Down");
  CStatsOverlayPopoutButton:SetDisabledTexture("Interface/Buttons/UI-SpellbookIcon-PrevPage-Disabled");

  CStats:Show();
end

function CollapseCharacterFrame()
  isPopoutExpanded = false;

  CharacterFrame:SetWidth(CHARACTER_FRAME_DEFAULT_WIDTH);
  CharacterFrameCloseButton:SetPoint("TOPRIGHT", -28, -9);


  CStatsOverlayPopoutButton:SetNormalTexture("Interface/Buttons/UI-SpellbookIcon-NextPage-Up");
  CStatsOverlayPopoutButton:SetPushedTexture("Interface/Buttons/UI-SpellbookIcon-NextPage-Down");
  CStatsOverlayPopoutButton:SetDisabledTexture("Interface/Buttons/UI-SpellbookIcon-NextPage-Disabled");

  CStats:Hide();
end



function OnPopoutButton()
  if(isPopoutExpanded) then
    CollapseCharacterFrame();
  else
    ExpandCharacterFrame();
  end
end

function DebugShowFrameSize(frame)
  frame:SetBackdrop( { 
          bgFile = "Interface/FrameGeneral/UI-Background-Rock", 
          edgeFile = "Interface/DialogFrame/UI-DialogBox-Border", tile = false, tileSize = 32, edgeSize = 16, 
          insets = { left = 11, right = 12, top = 11, bottom = 11 }
        });

end

function tprint (tbl, indent)
  if not indent then indent = 0 end
  for k, v in pairs(tbl) do
    formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      print(formatting)
      tprint(v, indent+1)
    elseif type(v) == 'boolean' then
      print(formatting .. tostring(v))      
    else
      print(formatting .. v)
    end
  end
end


function TokenButton_OnLoad(self)
  local name = self:GetName();
  self.count = _G[name.."Count"];
  self.name = _G[name.."Name"];
  self.icon = _G[name.."Icon"];
  self.check = _G[name.."Check"];
  self.expandIcon = _G[name.."ExpandIcon"];
  self.categoryLeft = _G[name.."CategoryLeft"];
  self.categoryRight = _G[name.."CategoryRight"];
  self.highlight = _G[name.."Highlight"];
  self.stripe = _G[name.."Stripe"];
end



function CStats_OnShow(self)
  SetButtonPulse(CharacterFrameTab5, 0, 1); --Stop the button pulse
  CStatsUpdate();
end

function CStatsInit()
  CStatsUpdate();
  HybridScrollFrame_CreateButtons(CStatsContainer, "TokenButtonTemplate", 0, -2, "TOPLEFT", "TOPLEFT", 0, -3);
end

CSTATS_BUTTON_WIDTH = 164

function CStats_OnLoad()
  CharacterFrame:Show();
  CStatsContainerScrollBar.Show = 
    function (self)
      CStatsContainer:SetWidth(220);
      for _, button in next, _G["CStatsContainer"].buttons do
        button:SetWidth(CSTATS_BUTTON_WIDTH);
      end
      getmetatable(self).__index.Show(self);
    end
    
  CStatsContainerScrollBar.Hide = 
    function (self)
      --CStatsContainer:SetWidth(220);
      for _, button in next, CStatsContainer.buttons do
        button:SetWidth(CSTATS_BUTTON_WIDTH);
      end
      getmetatable(self).__index.Hide(self);
    end
    
  CStatsContainer.update = CStats_Update;
  --HybridScrollFrame_CreateButtons (self, buttonTemplate, initialOffsetX, initialOffsetY, 
                                  --initialPoint, initialRelative, offsetX, offsetY, point, relativePoint)
  HybridScrollFrame_CreateButtons(CStatsContainer, "TokenButtonTemplate", 7, -3, 
                                  "TOPLEFT", "TOPLEFT", 0, -3);

  local buttons = CStatsContainer.buttons;
  local numButtons = #buttons;
  for i=1, numButtons do
    if ( mod(i, 2) == 1 ) then
      buttons[i].stripe:Hide();
    end
  end
  --DebugShowFrameSize(CStatsContainer);
end

--name, isHeader, isExpanded, isUnused, isWatched, count, extraCurrencyType, icon, itemID
function GetStatsInfo(index)
  if (index > 5) then
    return "", false, false, true, false, 0, 0, nil, 0
  else
    return _G[PLAYERSTAT_DROPDOWN_OPTIONS[index]], true, false, false, false, 0, 0, "Interface\\PVPFrame\\PVP-ArenaPoints-Icon", 0
  end

end

function CStatsUpdate()

   -- Setup the buttons
  local scrollFrame = CStatsContainer;
  local offset = HybridScrollFrame_GetOffset(scrollFrame);
  local buttons = scrollFrame.buttons;
  local numButtons = #buttons;
  local numTokenTypes = GetCurrencyListSize();
  local name, isHeader, isExpanded, isUnused, isWatched, count, extraCurrencyType, icon, itemID;
  local button, index;
  for i=1, numButtons do
    index = offset+i;
    name, isHeader, isExpanded, isUnused, isWatched, count, extraCurrencyType, icon, itemID = GetStatsInfo(index);

    button = buttons[i];
    button.check:Hide();
    if ( not name or name == "" ) then
      button:Hide();
    else

      --Header
      if ( isHeader ) then
        button.categoryLeft:Show();
        button.categoryRight:Show();
        button.expandIcon:Show();
        button.count:SetText("");
        button.icon:SetTexture("");
        if ( isExpanded ) then
          button.expandIcon:SetTexCoord(0.5625, 1, 0, 0.4375);
        else
          button.expandIcon:SetTexCoord(0, 0.4375, 0, 0.4375);
        end
        button.highlight:SetTexture("Interface\\TokenFrame\\UI-TokenFrame-CategoryButton");
        --button.highlight:SetPoint("TOPLEFT", button, "TOPLEFT", 3, -2);
        --button.highlight:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -3, 2);
        button:SetText(name);
        button.name:SetText("");
        print(name);
        button.itemID = nil;
        button.LinkButton:Hide();
      --Regular stat
      else
        button.categoryLeft:Hide();
        button.categoryRight:Hide();
        button.expandIcon:Hide();
        button.count:SetText(count);
        button.extraCurrencyType = extraCurrencyType;
        if ( extraCurrencyType == 1 ) then  --Arena points
          button.icon:SetTexture("Interface\\PVPFrame\\PVP-ArenaPoints-Icon");
          button.icon:SetTexCoord(0, 1, 0, 1);
        elseif ( extraCurrencyType == 2 ) then --Honor points
          local factionGroup = UnitFactionGroup("player");
          if ( factionGroup ) then
            button.icon:SetTexture("Interface\\TargetingFrame\\UI-PVP-"..factionGroup);
            button.icon:SetTexCoord( 0.03125, 0.59375, 0.03125, 0.59375 );
          else
            button.icon:Hide() --We don't know their faction yet!
            button.icon:SetTexCoord(0, 1, 0, 1);
          end
        else
          button.icon:SetTexture(icon);
          button.icon:SetTexCoord(0, 1, 0, 1);
        end
        if ( isWatched ) then
          button.check:Show();
        end
        button.highlight:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight");
        button.highlight:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0);
        button.highlight:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0);
        --Gray out the text if the count is 0
        if ( count == 0 ) then
          button.count:SetFontObject("GameFontDisable");
          button.name:SetFontObject("GameFontDisable");
        else
          button.count:SetFontObject("GameFontHighlight");
          button.name:SetFontObject("GameFontHighlight");
        end
        button:SetText("");
        button.name:SetText(name);
        button.itemID = itemID;
        button.LinkButton:Show();
      end
      --Manage highlight
      if ( name == TokenFrame.selectedToken ) then
        TokenFrame.selectedID = index;
        button:LockHighlight();
      else
        button:UnlockHighlight();
      end

      button.index = index;
      button.isHeader = isHeader;
      button.isExpanded = isExpanded;
      button.isUnused = isUnused;
      button.isWatched = isWatched;
      button:Show();
    end
  end
  local totalHeight = numTokenTypes * (button:GetHeight()+TOKEN_BUTTON_OFFSET);
  local displayedHeight = #buttons * (button:GetHeight()+TOKEN_BUTTON_OFFSET);

  HybridScrollFrame_Update(scrollFrame, totalHeight, displayedHeight);
  
  if ( numTokenTypes == 0 ) then
    CharacterFrameTab5:Hide();
  else
    CharacterFrameTab5:Show();
  end
end



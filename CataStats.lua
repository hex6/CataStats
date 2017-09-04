--message('Hello World!');

CHARACTER_FRAME_DEFAULT_WIDTH = 384;
CHARACTER_FRAME_NEW_WIDTH = 564;

CSTAT_CATEGORIES = {
  ["PLAYERSTAT_BASE_STATS"] = {
    "STRENGTH",
    "AGILITY",
    "STAMINA",
    "INTELLECT",
    "SPIRIT"
  },
  ["PLAYERSTAT_MELEE_COMBAT"] = {
    "MELEE_DAMAGE",
    "MELEE_SPEED",
    "MELEE_POWER",
    "MELEE_HIT",
    "MELEE_CRIT",
    "MELEE_EXPERTISE"
  },
  ["PLAYERSTAT_RANGED_COMBAT"] = {
    "RANGED_DAMAGE",
    "RANGED_SPEED",
    "RANGED_POWER",
    "RANGED_HIT",
    "RANGED_CRIT"
  },
  ["PLAYERSTAT_SPELL_COMBAT"] = {
    "SPELL_DAMAGE",
    "SPELL_HEALING",
    "SPELL_HIT",
    "SPELL_CRIT",
    "SPELL_HASTE",
    "MANA_REGEN"
  },
  ["PLAYERSTAT_DEFENSES"] = {
    "ARMOR",
    "DEFENSE",
    "DODGE",
    "PARRY",
    "BLOCK",
    "RESILIENCE"
  }
};

CSTAT_SORTING_ORDER = {"PLAYERSTAT_BASE_STATS","PLAYERSTAT_MELEE_COMBAT",
                      "PLAYERSTAT_RANGED_COMBAT","PLAYERSTAT_SPELL_COMBAT","PLAYERSTAT_DEFENSES"};

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

local round = function (num) return math.floor(num + .5); end

function GetTotalButtonHeight(buttons)
  local totalHeight = 0;
  for i =1, #buttons do
    totalHeight = totalHeight + buttons[i]:GetHeight();
  end

  return totalHeight;
end

function CreateCStatCategory(self, buttonTemplate, initialOffsetX, initialOffsetY, initialPoint, initialRelative, offsetX, offsetY, point, relativePoint)
  local scrollChild = self.scrollChild;
  local button, buttonHeight, buttons, numButtons;
  
  local labelHeight = 15;
  local buttonName = self:GetName() .. "Button";
  
  initialPoint = initialPoint or "TOPLEFT";
  initialRelative = initialRelative or "TOPLEFT";
  point = point or "TOPLEFT";
  relativePoint = relativePoint or "BOTTOMLEFT";
  offsetX = offsetX or 0;
  offsetY = offsetY or 0;
  
  if ( self.buttons ) then
    buttons = self.buttons;
    buttonHeight = GetTotalButtonHeight(buttons);
  else

    button = CreateFrame("BUTTON", buttonName .. 1, scrollChild, buttonTemplate);

    local firstButtonHeight = #CSTAT_CATEGORIES[PLAYERSTAT_DROPDOWN_OPTIONS[1]]*labelHeight;
    button:SetHeight(firstButtonHeight);
    buttonHeight = firstButtonHeight;

    button:SetPoint(initialPoint, scrollChild, initialRelative, initialOffsetX, initialOffsetY);
    buttons = {}
    tinsert(buttons, button);
  end
  
  self.buttonHeight = round(buttonHeight);
  
  local numButtons = #PLAYERSTAT_DROPDOWN_OPTIONS;
  
  for i = #buttons + 1, numButtons do
    print("Button number "..i)
    button = CreateFrame("BUTTON", buttonName .. i, scrollChild, buttonTemplate);
    local currentButtonHeight = #CSTAT_CATEGORIES[PLAYERSTAT_DROPDOWN_OPTIONS[i]]*labelHeight;
    button:SetHeight(currentButtonHeight);
    buttonHeight = buttonHeight + currentButtonHeight;
    button:SetPoint(point, buttons[i-1], relativePoint, offsetX, offsetY);
    tinsert(buttons, button);
  end
  
  scrollChild:SetWidth(self:GetWidth())
  scrollChild:SetHeight(buttonHeight);
  self:SetVerticalScroll(0);
  self:UpdateScrollChildRect();
  
  self.buttons = buttons;
  local scrollBar = self.scrollBar; 
  scrollBar:SetMinMaxValues(0, buttonHeight);
  scrollBar:SetValueStep(.005);
  scrollBar:SetValue(0);
end


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
  CreateCStatCategory(CStatsContainer, "CStatsButtonTemplate", 7, -3, 
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

--name, isHeader, isExpanded, isUnused, count, extraCurrencyType, itemID
function GetStatsInfo(index)
  if (index > 5) then
    return "asd", false, false, true, 0, 0
  else
    return _G[PLAYERSTAT_DROPDOWN_OPTIONS[index]], true, false, false, false, 0, 0
  end

end

function CStatsUpdate()

   -- Setup the buttons
  local scrollFrame = CStatsContainer;
  local offset = HybridScrollFrame_GetOffset(scrollFrame);
  local buttons = scrollFrame.buttons;
  local numButtons = #buttons;
  local numTokenTypes = GetCurrencyListSize();
  local name, isHeader, isExpanded, isUnused, count, extraCurrencyType, itemID;
  local button, index;
  for i=1, numButtons do
    index = offset+i;
    name, isHeader, isExpanded, isUnused, count, itemID = GetStatsInfo(index);

    button = buttons[i];

    if ( not name or name == "" ) then
      button:Hide();
    else

      --Header
      if ( isHeader ) then
        button.expandIcon:Show();
        button.count:SetText("");
        if ( isExpanded ) then
          button.expandIcon:SetTexCoord(0.5625, 1, 0, 0.4375);
        else
          button.expandIcon:SetTexCoord(0, 0.4375, 0, 0.4375);
        end
        button.highlight:SetTexture("Interface\\TokenFrame\\UI-TokenFrame-CategoryButton");
        button.highlight:SetPoint("TOPLEFT", button, "TOPLEFT", 3, -2);
        button.highlight:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -3, 2);
        button:SetText(name);
        button.name:SetText("");
        button.itemID = nil;
        button.LinkButton:Hide();
      --Regular stat
      else
        button.expandIcon:Hide();
        button.count:SetText(count);

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



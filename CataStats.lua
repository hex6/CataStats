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

function ResizeCharacterFrame()

  

end

function ExpandCharacterFrame()
  isPopoutExpanded = true;

  CharacterFrame:SetWidth(CHARACTER_FRAME_NEW_WIDTH);
  CharacterFrameCloseButton:SetPoint("TOPRIGHT", -6, -9);

  CStats_PopoutButton:SetNormalTexture("Interface/Buttons/UI-SpellbookIcon-PrevPage-Up");
  CStats_PopoutButton:SetPushedTexture("Interface/Buttons/UI-SpellbookIcon-PrevPage-Down");
  CStats_PopoutButton:SetDisabledTexture("Interface/Buttons/UI-SpellbookIcon-PrevPage-Disabled");

  CStats_Popout:Show();
end

function CollapseCharacterFrame()
  isPopoutExpanded = false;

  CharacterFrame:SetWidth(CHARACTER_FRAME_DEFAULT_WIDTH);
  CharacterFrameCloseButton:SetPoint("TOPRIGHT", -28, -9);

  CStats_PopoutButton:SetNormalTexture("Interface/Buttons/UI-SpellbookIcon-NextPage-Up");
  CStats_PopoutButton:SetPushedTexture("Interface/Buttons/UI-SpellbookIcon-NextPage-Down");
  CStats_PopoutButton:SetDisabledTexture("Interface/Buttons/UI-SpellbookIcon-NextPage-Disabled");

  CStats_Popout:Hide();
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
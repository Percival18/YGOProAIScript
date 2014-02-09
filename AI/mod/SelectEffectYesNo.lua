--- OnSelectEffectYesNo() ---
--
-- Called when AI has to decide whether to activate a card effect
-- 
-- Parameters:
-- id = card id of the effect
--
-- Return: 
-- 1 = yes
-- 0 = no
function OnSelectEffectYesNo(id)
  local result = FireFistOnSelectEffectYesNo(id)
     
  if id  == 72989439 then  -- Black Luster Soldier - Envoy of the Beginning
      result = 1
     end
  
  if id  == 84013237 then -- Number 39: Utopia
    if GlobalIsAIsTurn == 0 and AI.GetCurrentPhase() == PHASE_BATTLE and Get_Card_Att_Def(AIMon(),"attack",">",POS_FACEUP,"attack") < Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") then 
      GlobalActivatedEffectID = id
      result = 1
      end
   end
  
  if id  == 40619825 then -- Axe of Despair
    if Get_Card_Count(AIMon()) >= 2 then 
      GlobalActivatedEffectID = id
      GlobalCardMode = 1 
	  result = 1
      end
   end
  
   if id  == 79867938 then  -- Battlin' Boxer Headgeared
    if Get_Card_Count_ID(AIDeck(),05361647,nil) > 0 and Get_Card_Count_ID(AIHand(),68144350,nil) > 0 then -- Battlin' Boxer Glassjaw, Battlin' Boxer Switchitter  
      GlobalActivatedEffectID = id
	  result = 1
      end
   end
   
   if id  == 73580471 then  -- Black Rose Dragon
    if Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP,"attack") > Get_Card_Att_Def(AIMon(),"attack",">",POS_FACEUP,"attack") or Card_Count_Affected_By(EFFECT_INDESTRUCTABLE_BATTLE,OppMon()) > 0 then  
	  result = 1
      end
   end
    
	if id == 37742478 then -- Honest
      if Global1PTHonest ~= 1 then  
	    Global1PTHonest = 1
        result = 1
      end
    end

	if id == 15028680 then  -- HTS Psyhemuth
    if Get_Card_Att_Def_Pos(OppMon()) >= 2400 then
      return 1
    end
    return 0
  end
	
	------------------------------------------------------------
    -- If effects activation conditions aren't specified above, return "yes"
    ------------------------------------------------------------
	if id ~= 72989439 and id ~= 84013237 and  -- Black Luster Soldier , Number 39: Utopia 
     id ~= 40619825 and id ~= 79867938 and  -- Axe of Despair, Battlin' Boxer Headgeared
	   id ~= 37742478 and id ~= 73580471 and  -- Honest, Black Rose Dragon 
     id ~= 96381979 then  -- Tiger King           
	 GlobalActivatedEffectID = id
	 result = 1
   end	 
 
  return result

end

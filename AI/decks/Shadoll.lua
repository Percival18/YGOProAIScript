Shadoll = nil
function ShadollCheck()
  if Shadoll == nil then
    Shadoll = HasID(UseLists({AIDeck(),AIHand()}),44394295,true) -- check if the deck has Shadoll Fusion
  end 
  return Shadoll
end
function Shuffle(t)
  local n = #t
  while n >= 2 do
    local k = math.random(n)
    t[n], t[k] = t[k], t[n]
    n = n - 1
  end
  return t
end
function WinsBattle(source,target)
  return source and target 
  and (target:IsPosition(POS_ATTACK) and source:GetAttack()>=target.GetAttack()
  or target:IsPosition(POS_DEFENCE) and source:GetAttack()>target.GetDefence())
end
function MoralltachFilter(c)
  return bit32.band(c.position,POS_FACEUP)>0 
  and c:is_affected_by(EFFECT_INDESTRUCTABLE_EFFECT)==0
  and bit32.band(c.status,STATUS_LEAVE_CONFIRMED)==0
  and not DestroyBlacklist(c.id)
end
function MoralltachCond(loc)
  if loc == PRIO_TOFIELD then 
    return CardsMatchingFilter(UseLists({OppMon(),OppST()}),MoralltachFilter)>0
  end
  return true
end
function BeagalltachCond(loc)
  if loc == PRIO_TOFIELD then 
    return MidrashCheck() and HasID(AIST(),85103922,true) and MoralltachCond(PRIO_TOFIELD)
  end
  return true
end
function ShadollFusionCond(loc)
  if loc == PRIO_TOHAND then
    return not HasID(AIHand(),44394295,true)
  end
  return true
end
function FalconCond(loc)
  if loc == PRIO_TOGRAVE then
    return OPTCheck(37445295) and GetMultiple(37445295)==0 and not HasID(AIMon(),37445295,true)
  end
  return true
end
function HedgehogCond(loc)
  if loc == PRIO_TOGRAVE then
    return OPTCheck(04939890) and NeedsCard(37445295,AIDeck(),UseLists({AIHand(),AIMon()}),true) and GetMultiple(04939890)==0
  end
  return true
end
function ShadollFilter(c)
  return IsSetCode(c.setcode,0x9d) and bit32.band(c.type,TYPE_MONSTER)>0
end
function LizardCond(loc)
  if loc == PRIO_TOGRAVE then
    return OPTCheck(30328508) and (HasID(AIGrave(),44394295,true) and HasID(AIDeck(),04904633,true)
    or CardsMatchingFilter(AIGrave(),ShadollFilter)<2) and GetMultiple(30328508)==0
  end
  return true
end
function DragonFilter(c)
  return c:is_affected_by(EFFECT_INDESTRUCTABLE_EFFECT)==0
  and c:is_affected_by(EFFECT_CANNOT_BE_EFFECT_TARGET)==0
  and bit32.band(c.status,STATUS_LEAVE_CONFIRMED)==0
end
function DragonCond(loc)
  if loc == PRIO_TOGRAVE then
    return OPTCheck(77723643) and CardsMatchingFilter(OppST(),DragonFilter)>0 and GetMultiple(77723643)==0
  end
  return true
end
function BeastCond(loc)
  if loc == PRIO_TOGRAVE then
    return OPTCheck(03717252) and GetMultiple(03717252)==0
  end
  return true
end
function NephilimFilter(c)
  return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
  and c:IsHasEffect(EFFECT_INDESTRUCTABLE_EFFECT)==0 or c:GetAttack()<2800
end
function NephilimCond(loc)
  if loc == PRIO_TOFIELD then
    return OppGetStrongestAttack() < 2800 or HasID(AIMon(),94977269,true)
    or Duel.IsExistingMatchingCard(NephilimFilter,1-player_ai,0,LOCATION_MZONE,1,nil)
  end
  return true
end
function MidrashCond(loc)
  if loc == PRIO_TOFIELD then
    return OppGetStrongestAttack() < 2200 or HasID(AIMon(),20366274,true)
    and ShadollPriorityCheck(UseLists({AIHand(),AIMon()}),PRIO_TOGRAVE,2,ShadollFilter)>2
  end
  return true
end
function RootsCond(loc)
  if loc == PRIO_TOGRAVE then
    return NeedsCard(44394295,AIGrave(),AIHand(),true) or HasID(AIMon(),04904633,true)
  end
  return true
end
ShadollPrio = {
[37445295] = {6,3,3,1,6,1,6,1,1,FalconCond}, -- Shadoll Falcon
[04939890] = {5,2,2,1,5,4,5,4,1,HedgehogCond}, -- Shadoll Hedgehog
[30328508] = {4,1,5,1,8,1,8,1,1,LizardCond}, -- Shadoll Lizard
[77723643] = {3,1,4,1,7,1,7,1,1,DragonCond}, -- Shadoll Dragon
[03717252] = {2,1,6,1,9,1,9,1,1,BeastCond}, -- Shadoll Beast
[85103922] = {1,1,6,5,3,1,3,1,1,MoralltachCond}, -- Artifact Moralltach
[12697630] = {1,1,7,4,4,1,4,1,1,BeagalltachCond}, -- Artifact Beagalltach
[24062258] = {1,1,1,1,1,1,1,1,1,nil}, -- Secret Sect Druid Dru

[05318639] = {1,1,1,1,1,1,1,1,1,nil}, -- Mystical Space Typhoon
[44394295] = {9,5,1,1,1,1,1,1,1,ShadollFusionCond}, -- Shadoll Fusion
[29223325] = {1,1,1,1,1,1,1,1,1,nil}, -- Artifact Ignition
[01845204] = {1,1,1,1,1,1,1,1,1,nil}, -- Instant Fusion
[77505534] = {3,1,1,1,1,1,1,1,1,nil}, -- Facing the Shadows
[04904633] = {4,2,1,1,9,1,9,1,1,RootsCond}, -- Shadoll Roots
[53582587] = {1,1,1,1,1,1,1,1,1,nil}, -- Torrential Tribute
[29401950] = {1,1,1,1,1,1,1,1,1,nil}, -- Bottomless Trap Hole
[84749824] = {1,1,1,1,1,1,1,1,1,nil}, -- Solemn Warning
[94192409] = {1,1,1,1,1,1,1,1,1,nil}, -- Compulsory Evacuation Device
[12444060] = {1,1,1,1,1,1,1,1,1,nil}, -- Artifact Sanctum
[78474168] = {1,1,1,1,1,1,4,1,1,nil}, -- Breakthrough Skill

[20366274] = {1,1,6,4,2,1,2,1,1,NephilimCond}, -- El-Shadoll Nephilim
[94977269] = {1,1,7,3,2,1,2,1,1,MidrashCond}, -- El-Shadoll Midrash
[72959823] = {1,1,1,1,1,1,1,1,1,nil}, -- Panzer Dragon
[73964868] = {1,1,1,1,1,1,1,1,1,nil}, -- Constellar Pleiades
[29669359] = {1,1,1,1,1,1,1,1,1,nil}, -- Number 61: Volcasaurus
[82633039] = {1,1,1,1,1,1,1,1,1,nil}, -- Skyblaster Castel
[00581014] = {1,1,1,1,1,1,1,1,1,nil}, -- Daigusto Emeral
[33698022] = {1,1,1,1,1,1,1,1,1,nil}, -- Moonlight Rose Dragon
[88033975] = {1,1,1,1,1,1,1,1,1,nil}, -- Armades
[04779823] = {1,1,1,1,1,1,1,1,1,nil}, -- Michael, Lightsworn Ark
[31924889] = {1,1,1,1,1,1,1,1,1,nil}, -- Arcanite Magician
[08561192] = {1,1,1,1,1,1,1,1,1,nil}, -- Leoh, Keeper of the Sacred Tree
}
function ShadollGetPriority(id,loc)
  local checklist = nil
  local result = 0
  if loc == nil then
    loc = PRIO_TOHAND
  end
  checklist = ShadollPrio[id]
  if checklist then
    if checklist[10] and not(checklist[10](loc)) then
      loc = loc + 1
    end
    result = checklist[loc]
  end
  return result
end
function ShadollAssignPriority(cards,loc,filter)
  local index = 0
  Multiple = nil
  for i=1,#cards do
    cards[i].index=i
    cards[i].prio=ShadollGetPriority(cards[i].id,loc)
    if filter and not filter(cards[i]) then
      cards[i].prio=-1
    end
    if loc==PRIO_GRAVE and cards[i].location==LOCATION_DECK then
      cards[i].prio=cards[i].prio+2
    end
     if loc==PRIO_GRAVE and cards[i].location==LOCATION_ONFIELD then
      cards[i].prio=cards[i].prio-1
    end
    SetMultiple(cards[i].id)
  end
end
function ShadollPriorityCheck(cards,loc,count,filter)
  if count == nil then count = 1 end
  if loc==nil then loc=PRIO_TOHAND end
  if cards==nil or #cards<count then return -1 end
  ShadollAssignPriority(cards,loc,filter)
  table.sort(cards,function(a,b) return a.prio>b.prio end)
  return cards[count].prio
end
function ShadollAdd(cards,loc,count,filter)
  local result={}
  if count==nil then count=1 end
  if loc==nil then loc=PRIO_TOHAND end
  local compare = function(a,b) return a.prio>b.prio end
  ShadollAssignPriority(cards,loc,filter)
  table.sort(cards,compare)
  for i=1,count do
    result[i]=cards[i].index
    --ShadollTargets[#ShadollTargets+1]=cards[i].cardid
  end
  return result
end
function MidrashCheck()
  -- returns true, if there is no Midrash on the field
  return not HasIDNotNegated(UseLists({AIMon(),OppMon()}),94977269,true)
end
function FalconFilter(c)
  return IsSetCode(c.setcode,0x9d) and c.id~= 37445295
end
function UseFalcon()
  return OPTCheck(37445295) and ShadollPriorityCheck(AIGrave(),PRIO_TOFIELD,1,FalconFilter)>1
end
function UseHedgehog()
  return OPTCheck(04939890) and HasID(AIDeck(),44394295,true)
end
function LizardFilter(c)
  return c:is_affected_by(EFFECT_INDESTRUCTABLE_EFFECT)==0
  and c:is_affected_by(EFFECT_CANNOT_BE_EFFECT_TARGET)==0
end
function UseLizard()
  return OPTCheck(37445295) and CardsMatchingFilter(OppMon(),LizardFilter)>0
end
function DragonFilter2(c)
  return c:is_affected_by(EFFECT_CANNOT_BE_EFFECT_TARGET)==0 and (c.level>4 
  or bit32.band(c.type,TYPE_FUSION+TYPE_RITUAL+TYPE_SYNCHRO+TYPE_XYZ)>0) 
end
function UseDragon()
  return OPTCheck(37445295) and CardsMatchingFilter(OppMon(),DragonFilter2)>0
end
function DragonFilter3(c)
  return c:is_affected_by(EFFECT_CANNOT_BE_EFFECT_TARGET)==0
end
function UseDragon2()
  return OPTCheck(37445295) and CardsMatchingFilter(OppMon(),DragonFilter3)>0
end
function UseBeast()
  return OPTCheck(03717252) --and ShadollPriorityCheck(AIHand(),PRIO_TOGRAVE)>3
end
function ShadollFusionFilter(c)
  return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL and c:IsPreviousLocation(LOCATION_EXTRA)
end
function ArtifactFilter(c)
  return bit32.band(c.attribute,ATTRIBUTE_LIGHT)>0 and bit32.band(c.type,TYPE_MONSTER)>0
end
function UseShadollFusion()
  return OverExtendCheck() and (ShadollPriorityCheck(UseLists({AIHand(),AIMon()}),PRIO_TOGRAVE,2,ShadollFilter)>2
  or ShadollPriorityCheck(UseLists({AIHand(),AIMon()}),PRIO_TOGRAVE,1,ShadollFilter)>2
  and ShadollPriorityCheck(UseLists({AIHand(),AIMon()}),PRIO_TOGRAVE,1,ArtifactFilter)>2
  or Duel.IsExistingMatchingCard(ShadollFusionFilter,1-player_ai,LOCATION_MZONE,0,1,nil))
end
function UseRoots()
  return HasID(AIHand(),44394295,true) and MidrashCheck()
  and not Duel.IsExistingMatchingCard(ShadollFusionFilter,1-player_ai,LOCATION_MZONE,0,1,nil)
end
function DruFilter(c)
  return bit32.band(c.attribute,ATTRIBUTE_DARK)>0 and c.level==4 and (c.attack==0 or c.defense==0)
end
function SummonDru()
  return CardsMatchingFilter(AIGrave(),DruFilter)>0 and MidrashCheck() 
  and (SummonSkyblaster() or SummonEmeral())
end
function EmeralFilter(c)
  return bit32.band(c.type,TYPE_MONSTER)>0
end
function SummonEmeral()
  return CardsMatchingFilter(AIGrave(),EmeralFilter)>7 and HasID(AIExtra(),00581014,true)
end
function SkyblasterFilter(c)
  return (bit32.band(c.type,TYPE_FUSION+TYPE_RITUAL+TYPE_SYNCHRO+TYPE_XYZ)>0 or c.attack>= 2800)
  and bit32.band(c.position,POS_FACEUP)>0 and c:is_affected_by(EFFECT_CANNOT_BE_EFFECT_TARGET)==0
end
function SummonSkyblaster()
  return CardsMatchingFilter(OppMon(),SkyblasterFilter)>0 and HasID(AIExtra(),82633039,true)
end
function UseSkyblaster()
  return CardsMatchingFilter(OppMon(),SkyblasterFilter)>0
end
function SetArtifacts()
  return Duel.GetTurnCount()==1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function InstantFusionFilter(c)
  return bit32.band(c.attribute,ATTRIBUTE_LIGHT)>0 and c.level==5
end
function UseInstantFusion()
  return MidrashCheck() and CardsMatchingFilter(AIMon(),InstantFusionFilter)==1 and HasID(AIExtra(),73964868,true)
end
function VolcasaurusFilter(c,lp)
  return c:is_affected_by(EFFECT_CANNOT_BE_EFFECT_TARGET)==0
  and c:is_affected_by(EFFECT_INDESTRUCTABLE_EFFECT)==0
  and bit32.band(c.position,POS_FACEUP)>0
  and (lp==nil or c.base_attack>=AI.GetPlayerLP(2))
end
function SummonVolcasaurus()
  return (MidrashCheck() or FieldCheck(5)>2) and HasID(AIExtra(),29669359,true)
  and CardsMatchingFilter(OppMon(),VolcasaurusFilter)>0 and MP2Check()
end
function SummonVolcasaurusFinish()
  return HasID(AIExtra(),29669359,true) and CardsMatchingFilter(OppMon(),VolcasaurusFilter,true)>0
end
function SummonPleiades()
  return true
end
function MoonlightRoseFilter(c)
  return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL 
  and not c:IsHasEffect(EFFECT_CANNOT_BE_EFFECT_TARGET)
  and not c:IsHasEffect(EFFECT_INDESTRUCTABLE_EFFECT)
end
function SummonMoonlightRose()
  return (MidrashCheck() or FieldCheck(5)>1)and HasID(AIExtra(),33698022,true)
  and Duel.IsExistingMatchingCard(MoonlightRoseFilter,1-player_ai,LOCATION_MZONE,0,1,nil) 
end
function SummonLeoh()
  return OppGetStrongestAttack() < 3100 and MP2Check and HasID(AIExtra(),08561192,true)
end
function MichaelFilter(c)
  return c:is_affected_by(EFFECT_CANNOT_BE_EFFECT_TARGET)==0
end
function SummonMichael()
  return CardsMatchingFilter(UseLists({OppMon(),OppST()}),MichaelFilter)>0 
  and AI.GetPlayerLP(1)>1000 and MP2Check() and HasID(AIExtra(),04779823,true)
end
function UseMichael()
  return CardsMatchingFilter(UseLists({OppMon(),OppST()}),MichaelFilter)>0
end
function ArcaniteFilter(c)
  return c:is_affected_by(EFFECT_CANNOT_BE_EFFECT_TARGET)==0
  and c:is_affected_by(EFFECT_INDESTRUCTABLE_EFFECT)==0
end
function SummonArcanite()
  return CardsMatchingFilter(UseLists({OppMon(),OppST()}),ArcaniteFilter)>1 
  and MP2Check() and HasID(AIExtra(),31924889,true)
end
function UseArcanite()
  return CardsMatchingFilter(UseLists({OppMon(),OppST()}),ArcaniteFilter)>0
end
function FalconFilter2(c)
  return bit32.band(c.attribute,ATTRIBUTE_LIGHT)>0 and c.level==5 and bit32.band(c.position,POS_FACEUP)>0
end
function FalconFilter3(c)
  return bit32.band(c.race,RACE_SPELLCASTER)>0 and c.level==5 and bit32.band(c.position,POS_FACEUP)>0
end
function SummonFalcon()
  return (SummonMichael() and CardsMatchingFilter(AIMon(),FalconFilter2)>0 
  or SummonArcanite() and CardsMatchingFilter(AIMon(),FalconFilter3)>0 
  or SummonArmades() and FieldCheck(3)>0)
  and (MidrashCheck() or not Duel.CheckSpecialSummonActivity(player_ai))
end
function SetFalcon()
  return (Duel.GetTurnCount()==1 or Duel.GetCurrentPhase()==PHASE_MAIN2) 
  and CardsMatchingFilter(AIGrave(),FalconFilter)>0 and not HasID(AIMon(),37445295,true)
end
function SummonDragon()
  return Duel.GetTurnCount()>1 and not OppHasStrongestMonster() and OverExtendCheck() 
  or FieldCheck(4) == 1 and (SummonSkyblaster() or SummonEmeral())
end
function SetDragon()
  return (Duel.GetTurnCount()==1 or Duel.GetCurrentPhase()==PHASE_MAIN2) 
  and not HasID(AIMon(),37445295,true) and OverExtendCheck()
end
function SummonHedgehog()
  return HasID(AIMon(),37445295,true,nil,nil,POS_FACEUP) and SummonArmades()
end
function SetHedgehog()
  return (Duel.GetTurnCount()==1 or Duel.GetCurrentPhase()==PHASE_MAIN2) 
  and not HasID(AIMon(),04939890,true) and not HasID(AIHand(),44394295,true) 
end
function SummonLizard()
  return Duel.GetTurnCount()>1 and not OppHasStrongestMonster() and OverExtendCheck() 
  or FieldCheck(4) == 1 and (SummonSkyblaster() or SummonEmeral())
end
function SetLizard()
  return (Duel.GetTurnCount()==1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
  and not HasID(AIMon(),37445295,true) and OverExtendCheck()
end
function SummonBeast()
  return false
end
function SetBeast()
  return false
end
function SetFacingTheShadows()
  return Duel.GetTurnCount()==1 or Duel.GetCurrentPhase()==PHASE_MAIN2 
  and not HasIDNotNegated(AIST(),77505534,true)
end
function UseSoulCharge()
  return #AIMon()==0 and AI.GetPlayerLP(1)>1000 
  and CardsMatchingFilter (AIGrave(),function(c) return bit32.band(c.type,TYPE_MONSTER)>2 end)
end
function ShadollOnSelectInit(cards, to_bp_allowed, to_ep_allowed)
  local Activatable = cards.activatable_cards
  local Summonable = cards.summonable_cards
  local SpSummonable = cards.spsummonable_cards
  local Repositionable = cards.repositionable_cards
  local SetableMon = cards.monster_setable_cards
  local SetableST = cards.st_setable_cards
  if HasID(SpSummonable,29669359) and SummonVolcasaurusFinish() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(Activatable,29669359) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Activatable,04904633) and UseRoots() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Activatable,82633039,false,1322128625) and UseSkyblaster() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Activatable,00581014,false,9296225) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Activatable,04779823) and UseMichael() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Activatable,31924889) and UseArcanite() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Activatable,01845204) and UseInstantFusion() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Activatable,44394295) and UseShadollFusion() then
    GlobalCardMode=1
    return {COMMAND_ACTIVATE,CurrentIndex}
  end

  
  if HasID(Repositionable,37445295,false,nil,nil,POS_FACEDOWN_DEFENCE) and UseFalcon() then
    return {COMMAND_CHANGE_POS,CurrentIndex}
  end
  if HasID(Repositionable,04939890,false,nil,nil,POS_FACEDOWN_DEFENCE) and UseHedgehog() then
    return {COMMAND_CHANGE_POS,CurrentIndex}
  end
  if HasID(Repositionable,30328508,false,nil,nil,POS_FACEDOWN_DEFENCE) and UseLizard() then
    return {COMMAND_CHANGE_POS,CurrentIndex}
  end
  if HasID(Repositionable,77723643,false,nil,nil,POS_FACEDOWN_DEFENCE) and UseDragon() then
    return {COMMAND_CHANGE_POS,CurrentIndex}
  end
  if HasID(Repositionable,03717252,false,nil,nil,POS_FACEDOWN_DEFENCE) and UseBeast() then
    return {COMMAND_CHANGE_POS,CurrentIndex}
  end
  if HasID(Repositionable,03717252,false,nil,nil,POS_FACEDOWN_DEFENCE) and UseBeast() then
    return {COMMAND_CHANGE_POS,CurrentIndex}
  end
    if HasID(Repositionable,20366274,false,nil,nil,POS_FACEDOWN_DEFENCE) then
    return {COMMAND_CHANGE_POS,CurrentIndex}
  end
    if HasID(Repositionable,94977269,false,nil,nil,POS_FACEDOWN_DEFENCE) then
    return {COMMAND_CHANGE_POS,CurrentIndex}
  end

  
  
  if HasID(SpSummonable,08561192) and SummonLeoh() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSummonable,31924889) and SummonArcanite() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSummonable,04779823) and SummonMichael() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSummonable,00581014) and SummonEmeral() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSummonable,82633039) and SummonSkyblaster() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSummonable,73964868) and SummonPleiades() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSummonable,29669359) and SummonVolcasaurus() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  
  if HasID(Summonable,24062258) and SummonDru() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Summonable,37445295) and SummonFalcon() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Summonable,04939890) and SummonHedgehog() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Summonable,30328508) and SummonLizard() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Summonable,77723643) and SummonDragon() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Summonable,03717252) and SummonBeast() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  
  if HasID(SetableMon,37445295) and SetFalcon() then
    return {COMMAND_SET_MONSTER,CurrentIndex}
  end
  if HasID(SetableMon,04939890) and SetHedgehog() then
    return {COMMAND_SET_MONSTER,CurrentIndex}
  end
  if HasID(SetableMon,30328508) and SetLizard() then
    return {COMMAND_SET_MONSTER,CurrentIndex}
  end  
  if HasID(SetableMon,77723643) and SetDragon() then
    return {COMMAND_SET_MONSTER,CurrentIndex}
  end
  if HasID(SetableMon,03717252) and SetBeast() then
    return {COMMAND_SET_MONSTER,CurrentIndex}
  end
  
  if HasID(SetableST,77505534) and SetFacingTheShadows() then
    return {COMMAND_SET_ST,CurrentIndex}
  end
  if HasID(SetableST,85103922) and SetArtifacts() then
    return {COMMAND_SET_ST,CurrentIndex}
  end
  if HasID(SetableST,12697630) and SetArtifacts() then
    return {COMMAND_SET_ST,CurrentIndex}
  end
  if HasID(SetableST,12444060) and SetArtifacts() then
    return {COMMAND_SET_ST,CurrentIndex}
  end
  if HasID(SetableST,29223325) and SetArtifacts() then
    return {COMMAND_SET_ST,CurrentIndex}
  end
  
  if HasID(Activatable,54447022) and UseSoulCharge() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  return nil
end
function SanctumTargetField(cards)
  return ShadollAdd(cards,PRIO_TOFIELD)
end
function SanctumTargetGrave(cards)
  return BestTargets(cards,1,true)
end
function BeagalltachTarget(cards)
  local result={}
  local targets=CardsMatchingFilter(UseLists({OppMon(),OppST()}),MoralltachFilter)
  for i=1,#cards do
    if cards[i].id == 85103922 and #result<math.min(targets,2) then
      result[#result+1]=i
    end
  end
  if #result==0 then result={math.random(#cards)} end
  return result
end
function FalconTarget(cards)
  return ShadollAdd(cards,PRIO_TOFIELD)
end
function HedgehogTarget(cards)
  return ShadollAdd(cards)
end
function LizardTarget(cards,onField)
  if onField then
    return BestTargets(cards,1,true)
  else
    return ShadollAdd(cards,PRIO_TOGRAVE)
  end
end
function DragonTarget(cards)
  return BestTargets(cards)
end
function BeastTarget(cards)
  return ShadollAdd(cards,PRIO_TOGRAVE)
end
function ShadollFusionTarget(cards)
  local result=nil
  if GlobalCardMode == 1 then
    result = ShadollAdd(cards,PRIO_TOFIELD)
  else
    result = ShadollAdd(cards,PRIO_TOGRAVE)
  end
  GlobalCardMode = nil
  if result == nil then result = {math.random(#cards)} end
  OPTSet(cards[1].id)
  return result
end
function NephilimTarget(cards,inGrave)
  if inGrave then
    return ShadollAdd(cards)
  else
    return ShadollAdd(cards,PRIO_TOGRAVE)
  end
end
function MidrashTarget(cards)
  return ShadollAdd(cards)
end
function RootsTarget(cards)
  return ShadollAdd(cards)
end
function FacingTheShadowsTarget(cards,min,max)
  local result = nil
  if GlobalCardMode == nil then
    result = ShadollAdd(cards,PRIO_TOGRAVE)
  else
    result={}
    for i=1,#cards do
      local id=cards[i].id
      if id==37445295 and UseFalcon()
      or id==04939890 and UseHedgehog()
      or id==30328508 and UseLizard()
      or id==77723643 and UseDragon2()
      or id==03717252 and UseBeast()
      then
        result[#result+1]=i
      end
    end
  end
  GlobalCardMode=nil
  if result == nil then result = {math.random(#cards)} end
  if #result>max then result = ShadollAdd(cards,PRIO_TOGRAVE) end
  return result
end
function EmeralTarget(cards,count)
  local result = {}
  for i=1,#cards do cards[i].index = i end
  Shuffle(cards)
  for i=1,count do result[i] = cards[i].index end
  return result
end
function SkyblasterTarget(cards,count)
  return BestTargets(cards,count)
end
function InstantFusionTarget(cards)
  local result = nil
  for i=1,#cards do
    if cards[i].id == 72959823 then
      result = {i}
    end
  end
  if result==nil then result={math.random(#cards)} end
  return result
end
function VolcasaurusTarget(cards)
  return BestTargets(cards,1,true)
end
function MichaelTarget(cards,onField)
  local result = {}
  if onField then
    result = BestTargets(cards)
  else
    for i=1,#cards do
      result[i]=i
    end
  end
  return result
end
function ArcaniteTarget(cards)
  return BestTargets(cards,1,true)
end
function PanzerDragonTarget(cards)
  return BestTargets(cards,1,true)
end
function CompulseTarget(cards)
  local result = nil
  if GlobalCardMode == 1 then
    for i=1,#cards do
      if cards[i].id == GlobalTargetID and cards[i].owner == GlobalPlayer then
        result={i}
      end
    end
  end
  GlobalCardMode = nil
  GlobalTargetID = nil
  GlobalPlayer = nil
  if result == nil then result = BestTargets(cards,1,TARGET_TOHAND) end
  return result
end
function IgnitionTarget(cards)
  local result = {}
  if GlobalCardMode == 2 then
    result = {IndexByID(cards,GlobalTargetID)}
  elseif GlobalCardMode == 1 then
    result = BestTargets(cards,1,true)
  else
    for i=1,#cards do
      if cards[i].id == 85103922 and #result<1 then
        result[#result+1]=i
      end
    end
  end 
  GlobalCardMode = nil
  if #result == 0 then result = {math.random(#cards)} end
  return result
end
function MSTTarget(cards)
  result = nil
  if GlobalCardMode == 1 then
    for i=1,#cards do
      if cards[i].id==GlobalTargetID and cards[i].owner==GlobalPlayer then
        result = {i}
      end
    end
  end
  GlobalCardMode=nil
  GlobalTargetID=nil
  GlobalPlayer=nil
  if result==nil then result=BestTargets(cards,1,TARGET_DESTROY) end
  return result
end
function SoulChargeTarget(cards,min,max)
  local result={}
  local count = max
  if AI.GetPlayerLP(1)>=7000 then
    count = math.min(3,max)
  elseif AI.GetPlayerLP(1)>=4000 then
    count = math.min(2,max)
  else
    count = 1
  end
  if SatellarknightCheck() then
    result = SatellarknightAdd(cards,PRIO_TOFIELD,count)
  else
    for i=1,#cards do
      cards[i].index=i
    end
    table.sort(cards,function(a,b) return a.attack>b.attack end)
    for i=1,count do
      result[i]=cards[i].index
    end
  end
  return result
end
function ShadollOnSelectCard(cards, minTargets, maxTargets,triggeringID,triggeringCard)
  local ID 
  local result=nil
  if triggeringCard then
    ID = triggeringCard.id
  else
    ID = triggeringID
  end
  if ID == 54447022 then
    return SoulChargeTarget(cards,minTargets,maxTargets)
  end
  if ID == 05318639 then
    return MSTTarget(cards)
  end
  if ID == 94192409 then
    return CompulseTarget(cards)
  end
  if ID == 12697630 then
    return BeagalltachTarget(cards)
  end
  if ID == 12444060 and bit32.band(triggeringCard.location,LOCATION_ONFIELD)>0 then
    return SanctumTargetField(cards)
  end
  if ID == 12444060 and bit32.band(triggeringCard.location,LOCATION_GRAVE)>0 then
    return SanctumTargetGrave(cards)
  end
  if ID == 85103922 then
    return BestTargets(cards,1,true)
  end
  if ID == 29223325 then
    return IgnitionTarget(cards)
  end
  if ID == 37445295 then
    return FalconTarget(cards)
  end
  if ID == 04939890 then
    return HedgehogTarget(cards)
  end
  if ID == 30328508 then
    return LizardTarget(cards,bit32.band(triggeringCard.location,LOCATION_ONFIELD)>0)
  end
  if ID == 77723643 then
    return DragonTarget(cards)
  end
  if ID == 03717252 then
    return BeastTarget(cards)
  end
  if ID == 44394295 then
    return ShadollFusionTarget(cards)
  end
  if ID == 20366274 then
    return NephilimTarget(cards,bit32.band(triggeringCard.location,LOCATION_GRAVE)>0)
  end
  if ID == 20366274 then
    return MidrashTarget(cards)
  end
  if ID == 04904633 then
    return RootsTarget(cards)
  end
  if ID == 77505534 then
    return FacingTheShadowsTarget(cards,minTargets,maxTargets)
  end
  if ID == 00581014 then
    return EmeralTarget(cards,minTargets)
  end
  if ID == 82633039 then
    return SkyblasterTarget(cards,minTargets)
  end
  if ID == 01845204 then
    return InstantFusionTarget(cards)
  end
  if ID == 29669359 then
    return VolcasaurusTarget(cards)
  end
  if ID == 04779823 then
    return MichaelTarget(cards,bit32.band(triggeringCard.location,LOCATION_ONFIELD)>0)
  end
  if ID == 31924889 then
    return ArcaniteTarget(cards)
  end
  if ID == 72959823 then
    return PanzerDragonTarget(cards)
  end
  return nil
end
function ChainWireTap()
  local e = Duel.GetChainInfo(Duel.GetCurrentChain(), CHAININFO_TRIGGERING_EFFECT)
  if e then
    local c = e:GetHandler()
    return c and c:IsControler(1-player_ai)
  end
  return false 
end
function ChainBookOfMoon() 
  return false
end
function SanctumFilter(c)
  return (c.level>=5 or bit32.band(c.type,TYPE_FUSION+TYPE_RITUAL+TYPE_SYNCHRO+TYPE_XYZ)>0)
  and c:is_affected_by(EFFECT_INDESTRUCTABLE_EFFECT)==0 and bit32.band(c.position,POS_FACEUP)>0 
end

function ChainSanctum()
  if RemovalCheck(12444060) and (HasID(AIDeck(),85103922,true) or HasID(AIDeck(),12697630,true) and HasID(AIST(),85103922,true) and MidrashCheck())then
    GlobalCardMode = 1
    return true
  end
  if not UnchainableCheck(12444060) then
    return false
  end
  local targets = CardsMatchingFilter(UseLists({OppMon(),OppST()}),SanctumFilter)
  local targets2=CardsMatchingFilter(UseLists({OppMon(),OppST()}),MoralltachFilter)
  local check = HasID(AIDeck(),85103922,true) or HasID(AIDeck(),12697630,true) 
  and HasID(AIST(),85103922,true) and MidrashCheck()
  if Duel.GetTurnPlayer()==1-player_ai and targets>0 and check
  then
    GlobalCardMode = 1
    return true
  end
  if Duel.GetTurnPlayer()==1-player_ai and targets2>0 and check then
    if Duel.GetCurrentPhase()==PHASE_BATTLE then
      local source = Duel.GetAttacker()
      if source and source:IsControler(1-player_ai) then
        GlobalCardMode = 1
        return true
      end
    end
    if Duel.GetCurrentPhase()==PHASE_END and targets2>0 and check then
      GlobalCardMode = 1
      return true
    end
  end
  return nil
end

function ChainFacingTheShadows()
  local result = false
  if RemovalCheck(77505534) then 
    result = true
  end
  if RemovalCheck(37445295) and UseFalcon()
  or RemovalCheck(04939890) and UseHedgehog()
  or RemovalCheck(30328508) and UseLizard()
  or RemovalCheck(77723643) and UseDragon2()
  or RemovalCheck(03717252) and UseBeast()
  then
    result = true
  end
  if Duel.GetCurrentPhase()==PHASE_END 
  and (HasID(AIDeck(),77723643,true) and DragonCond(PRIO_TOGRAVE) 
  or HasID(AIDeck(),04939890,true) and HedgehogCond(PRIO_TOGRAVE) ) then
    result = true
  end
  if Duel.GetCurrentPhase()==PHASE_BATTLE then
    local source=Duel.GetAttacker()
    local target=Duel.GetAttackTarget()
    if source and target then
      if target:IsSetCard(0x9d) and target:IsPosition(POS_FACEDOWN_DEFENCE) 
      and source:GetAttack()>target:GetDefence() and target:IsControler(player_ai)
      and (target:IsCode(77723643) and UseDragon2() or target:IsCode(30328508) and UseLizard())
      then
        result = true
      end
    end
  end
  return result
end
function ChainRoots()
  if Duel.GetCurrentPhase()==PHASE_BATTLE then
    local source=Duel.GetAttacker()
    return source and source:IsControler(1-player_ai) and source:GetAttack()<=1950 and #AIMon()==0 
  end
end

function CompulseFilter(c)
  return c:is_affected_by(EFFECT_CANNOT_BE_EFFECT_TARGET)==0
  and c:is_affected_by(EFFECT_IMMUNE_EFFECT)==0
end
function CompulseFilter2(c)
  return CompulseFilter(c) and not ToHandBlacklist(c.id) 
  and (c.level>4 or bit32.band(c.type,TYPE_FUSION+TYPE_SYNCHRO+TYPE_RITUAL+TYPE_XYZ)>0)
end
function ChainCompulse()
  local targets = CardsMatchingFilter(OppMon(),CompulseFilter)
  local targets2 = CardsMatchingFilter(OppMon(),CompulseFilter2)
  if RemovalCheck(94192409) and targets>0 then
    return true
  end
  if targets2 > 0 then
    return true
  end
  if Duel.GetCurrentPhase()==PHASE_BATTLE and targets>0 then
    local source=Duel.GetAttacker()
    local target=Duel.GetAttackTarget()
    if source and target then
      if source:IsControler(1-player_ai) and target:IsControler(player_ai) 
      and (target:IsPosition(POS_DEFENCE) and source:GetAttack()>target:GetDefence() 
      or target:IsPosition(POS_ATTACK) and source:GetAttack()>=target:GetAttack())
      and not source:IsHasEffect(EFFECT_CANNOT_BE_EFFECT_TARGET)
      and not source:IsHasEffect(EFFECT_IMMUNE_EFFECT)
      and not source:IsHasEffect(EFFECT_IMMUNE_EFFECT)
      then
        GlobalCardMode = 1
        GlobalTargetID = source:GetCode()
        GlobalPlayer = 2
        return true
      end
    end
  end
  return false
end
function ArtifactCheck(sanctum)
  local MoralltachCheck = HasID(AIST(),85103922,true) and Duel.GetTurnPlayer()==1-player_ai
  local BeagalltachCheck = HasID(AIST(),12697630,true) and (HasID(AIST(),85103922,true) 
  or sanctum and HasID(AIDeck(),85103922,true))
  and MidrashCheck() and Duel.GetTurnPlayer()==1-player_ai
  if BeagalltachCheck then
    if sanctum then
      GlobalCardMode = 2
    else 
      GlobalCardMode = 1
    end
    GlobalTargetID = 12697630
    GlobalPlayer = 1
    return true
  end
  if MoralltachCheck then
    if sanctum then
      GlobalCardMode = 2
    else 
      GlobalCardMode = 1
    end
    GlobalTargetID = 85103922
    GlobalPlayer = 1
    return true
  end
  return false
end
function MSTFilter(c)
  return c:is_affected_by(EFFECT_CANNOT_BE_EFFECT_TARGET)==0 
  and c:is_affected_by(EFFECT_INDESTRUCTABLE_EFFECT)==0 
  and not (DestroyBlacklist(c.id)
  and (bit32.band(c.position, POS_FACEUP)>0 
  or bit32.band(c.status,STATUS_IS_PUBLIC)>0))
end
function MSTEndPhaseFilter(c)
  return MSTFilter(c) and bit32.band(c.status,STATUS_SET_TURN)>0
end
function ChainMST()
  local targets=CardsMatchingFilter(OppST(),MSTFilter)
  local targets2=CardsMatchingFilter(UseLists({OppMon(),OppST()}),MoralltachFilter)
  local targets3=CardsMatchingFilter(UseLists({OppMon(),OppST()}),SanctumFilter)
  local targets4=CardsMatchingFilter(OppST(),MSTEndPhaseFilter)
  local e = Duel.GetChainInfo(Duel.GetCurrentChain(),CHAININFO_TRIGGERING_EFFECT)
  if RemovalCheck(05318639) then
    if e and e:GetHandler():IsCode(12697630) then
      return false
    end
    if targets2 > 0 and ArtifactCheck()
    then
      return true
    end
    if targets > 0 then
      return true
    end
  end
  if not UnchainableCheck(05318639) then
    return false
  end
  if targets3 > 0 and ArtifactCheck() then
    return true
  end
  if Duel.GetCurrentPhase()==PHASE_BATTLE then
    local source=Duel.GetAttacker()
    local target=Duel.GetAttackTarget()
    if source and source:IsControler(1-player_ai) then
      if targets2 > 0 and ArtifactCheck() then
        return true
      end
    end
  end
  if Duel.GetCurrentPhase()==PHASE_END then
    if targets2 > 0 and ArtifactCheck() then
      return true
    end
    if targets4 > 0 then
      local cards = SubGroup(OppST(),MSTEndPhaseFilter)
      GlobalTargetID=cards[math.random(#cards)].id
      GlobalPlayer=2
      GlobalCardMode=1
      return true
    end
  end
  if e then
    local c = e:GetHandler()
    if c:IsType(TYPE_CONTINUOUS+TYPE_EQUIP+TYPE_FIELD)
    and c:IsControler(1-player_ai)
    and not c:IsHasEffect(EFFECT_CANNOT_BE_EFFECT_TARGET)
    and not c:IsHasEffect(EFFECT_INDESTRUCTABLE_EFFECT)
    and not c:IsHasEffect(EFFECT_IMMUNE_EFFECT)
    and (not DestroyBlacklist(c:GetCode()) or c:GetCode()==19337371)
    then
      GlobalTargetID=c:GetCode()
      GlobalPlayer=2
      GlobalCardMode=1
      return true
    end
  end
  return false
end
function ChainIgnition()
local targets=CardsMatchingFilter(OppST(),MSTFilter)
  local targets2=CardsMatchingFilter(UseLists({OppMon(),OppST()}),MoralltachFilter)
  local targets3=CardsMatchingFilter(UseLists({OppMon(),OppST()}),SanctumFilter)
  local targets4=CardsMatchingFilter(OppST(),MSTEndPhaseFilter)
  local e = Duel.GetChainInfo(Duel.GetCurrentChain(),CHAININFO_TRIGGERING_EFFECT)
  if RemovalCheck(12444060) then
    if e and e:GetHandler():IsCode(12697630) then
      return false
    end
    if targets2 > 0 and ArtifactCheck(true)
    then
      return true
    end
    if targets > 0 then
      return true
    end
  end
  if not UnchainableCheck(12444060) then
    return false
  end
  if targets3 > 0 and ArtifactCheck(true) then
    return true
  end
  if Duel.GetCurrentPhase()==PHASE_BATTLE then
    local source=Duel.GetAttacker()
    local target=Duel.GetAttackTarget()
    if source and source:IsControler(1-player_ai) then
      if targets2 > 0 and ArtifactCheck(true) then
        return true
      end
    end
  end
  if Duel.GetCurrentPhase()==PHASE_END then
    if targets2 > 0 and ArtifactCheck(true) then
      return true
    end
    if targets4 > 0 then
      local cards = SubGroup(OppST(),MSTEndPhaseFilter)
      GlobalTargetID=cards[math.random(#cards)].id
      GlobalPlayer=2
      GlobalCardMode=2
      return true
    end
  end
  if e then
    local c = e:GetHandler()
    if c:IsType(TYPE_CONTINUOUS+TYPE_EQUIP+TYPE_FIELD)
    and c:IsControler(1-player_ai)
    and not c:IsHasEffect(EFFECT_CANNOT_BE_EFFECT_TARGET)
    and not c:IsHasEffect(EFFECT_INDESTRUCTABLE_EFFECT)
    and not c:IsHasEffect(EFFECT_IMMUNE_EFFECT)
    and (not DestroyBlacklist(c:GetCode()) or c:GetCode()==19337371)
    then
      GlobalTargetID=c:GetCode()
      GlobalPlayer=2
      GlobalCardMode=1
      return true
    end
  end
  return false
end
function ShadollOnSelectChain(cards,only_chains_by_player)
  if HasID(cards,05318639) and ChainMST() then
    return {1,CurrentIndex}
  end
  if HasID(cards,94192409) and ChainCompulse() then
    return {1,CurrentIndex}
  end
  if HasID(cards,77505534) and ChainFacingTheShadows() then
    return {1,CurrentIndex}
  end
  if HasID(cards,34507039) and ChainWireTap() then
    return {1,CurrentIndex}
  end
  if HasID(cards,14087893) and ChainBookOfMoon() then
    return {1,CurrentIndex}
  end
  if HasID(cards,12444060,false,nil,LOCATION_ONFIELD) and ChainSanctum() then
    return {1,CurrentIndex}
  end
  if HasID(cards,12444060,false,nil,LOCATION_GRAVE) and SanctumYesNo() then
    return {1,CurrentIndex}
  end
  if HasID(cards,29223325) and ChainIgnition() then
    return {1,CurrentIndex}
  end
  if HasID(cards,37445295,false,nil,LOCATION_ONFIELD) and UseFalcon() then
    OPTSet(37445295)
    return {1,CurrentIndex}
  end
  if HasID(cards,04939890,false,nil,LOCATION_ONFIELD) and UseHedgehog() then
    OPTSet(04939890)
    return {1,CurrentIndex}
  end
  if HasID(cards,30328508,false,nil,LOCATION_ONFIELD) and UseLizard() then
    OPTSet(30328508)
    return {1,CurrentIndex}
  end
  if HasID(cards,77723643,false,nil,LOCATION_ONFIELD) then
    OPTSet(77723643)
    return {1,CurrentIndex}
  end
  if HasID(cards,03717252,false,nil,LOCATION_ONFIELD) and UseBeast() then
    OPTSet(03717252)
    return {1,CurrentIndex}
  end
  if HasID(cards,37445295,false,nil,LOCATION_GRAVE) then
    OPTSet(37445295)
    return {1,CurrentIndex}
  end
  if HasID(cards,04939890,false,nil,LOCATION_GRAVE) then
    OPTSet(04939890)
    return {1,CurrentIndex}
  end
  if HasID(cards,30328508,false,nil,LOCATION_GRAVE) then
    OPTSet(30328508)
    return {1,CurrentIndex}
  end
  if HasID(cards,77723643,false,nil,LOCATION_GRAVE) and CardsMatchingFilter(OppST(),DragonFilter)>0 then
    OPTSet(77723643)
    return {1,CurrentIndex}
  end
  if HasID(cards,03717252,false,nil,LOCATION_GRAVE) then
    OPTSet(03717252)
    return {1,CurrentIndex}
  end
  if HasID(cards,20366274) then
    return {1,CurrentIndex}
  end
  if HasID(cards,94977269) then
    return {1,CurrentIndex}
  end
  if HasID(cards,04904633,false,nil,LOCATION_GRAVE) then
    return {1,CurrentIndex}
  end
  if HasID(cards,33698022) then
    return {1,CurrentIndex}
  end
  if HasID(cards,24062258) then
    return {1,CurrentIndex}
  end
  if HasID(cards,04904633) and ChainRoots() then
    return {1,CurrentIndex}
  end
  return nil
end
function SanctumYesNo()
  return CardsMatchingFilter(UseLists({OppMon(),OppST()}),IgnitionFilter)>0
end
function ShadollOnSelectEffectYesNo(id,triggeringCard)
  local result = nil
  local field = bit32.band(triggeringCard.location,LOCATION_ONFIELD)>0
  local grave = bit32.band(triggeringCard.location,LOCATION_GRAVE)>0
  if id == 85103922 then
    result = 1
  end
  if id == 12444060 and SanctumYesNo() then
    result = 1
  end
  if id == 37445295 and field and UseFalcon() then
    OPTSet(37445295)
    result = 1
  end
  if id == 04939890 and field and UseHedgehog() then
    OPTSet(04939890)
    result = 1
  end
  if id == 30328508 and field and UseLizard() then
    OPTSet(30328508)
    result = 1
  end
  if id == 77723643 and field then
    OPTSet(77723643)
    result = 1
  end
  if id == 03717252 and field and UseBeast() then
    OPTSet(03717252)
    result = 1
  end
  if id == 37445295 and grave then
    OPTSet(37445295)
    result = 1
  end
  if id == 04939890 and grave then
    OPTSet(04939890)
    result = 1
  end
  if id == 30328508 and grave then
    OPTSet(30328508)
    result = 1
  end
  if id == 77723643 and grave and CardsMatchingFilter(OppST(),DragonFilter)>0 then
    OPTSet(77723643)
    result = 1
  end
  if id == 03717252 and grave then
    OPTSet(03717252)
    result = 1
  end
  if id == 20366274 or id == 94977269 or id == 04904633 
  or id == 33698022 or id == 24062258 
  then
    result = 1
  end
  if id == 77505534 then
    GlobalCardMode=1
    result = 1
  end
  return result
end
ShadollAtt={
  85103922 -- Moralltach
}
ShadollDef={
  12697630,31924889,04904633 -- Beagalltach,Arcanite Magician,Shadoll Roots
}
function ShadollOnSelectPosition(id, available)
  result = nil
  for i=1,#ShadollAtt do
    if ShadollAtt[i]==id then result=POS_FACEUP_ATTACK end
  end
  for i=1,#ShadollDef do
    if ShadollDef[i]==id then result=POS_FACEUP_DEFENCE end
  end
  return result
end
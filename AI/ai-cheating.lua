
require("ai.mod.AICheckList")
require("ai.mod.AIHelperFunctions")
require("ai.mod.AICheckPossibleST")
require("ai.mod.AIOnDeckSelect")
require("ai.mod.DeclareAttribute")
require("ai.mod.DeclareCard")
require("ai.mod.DeclareMonsterType")
require("ai.mod.SelectBattleCommand")
require("ai.mod.SelectCard")
require("ai.mod.SelectChain")
require("ai.mod.SelectEffectYesNo")
require("ai.mod.SelectInitCommand")
require("ai.mod.SelectNumber")
require("ai.mod.SelectOption")
require("ai.mod.SelectPosition")
require("ai.mod.SelectTribute")
require("ai.mod.SelectYesNo")
require("ai.decks.FireFist")
require("ai.decks.HeraldicBeast")
require("ai.decks.Gadget")
require("ai.decks.Bujin")
require("ai.decks.Mermail")
require("ai.decks.Shadoll")

math.randomseed( require("os").time() )

function OnStartOfDuel()
  AI.Chat("You selected a cheating AI")
	AI.Chat("The AI will recover 1000 LP and draw an additional card each turn")
  --Debug.SetAIName("AI-Cheater")
  GlobalCheating = 1
  SaveState()
end

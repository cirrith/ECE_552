#Name: AppliedEnergistics.zs
#Author: Feed the Beast

print("Initializing 'AppliedEnergistics.zs'...");

#generator
recipes.remove(<appliedenergistics2:tile.BlockVibrationChamber>);
recipes.remove(<thaumicenergistics:thaumicenergistics.block.essentia.vibration.chamber>);
recipes.remove(<extracells:vibrantchamberfluid>);

#energy acceptor/controller
recipes.remove(<appliedenergistics2:tile.BlockController>);
recipes.remove(<appliedenergistics2:tile.BlockEnergyAcceptor>);
recipes.addShaped(<appliedenergistics2:tile.BlockController>, [[<ore:blockEnderium>, <StevesCarts:ModuleComponents:49>, <ore:blockPhasedGold>], [<appliedenergistics2:item.ItemMultiMaterial:23>, <AdvancedSolarPanel:asp_crafting_items:13>, <appliedenergistics2:item.ItemMultiMaterial:23>], [<ore:blockPhasedGold>, <StevesCarts:ModuleComponents:49>, <ore:blockEnderium>]]);
recipes.addShaped(<appliedenergistics2:tile.BlockEnergyAcceptor>, [[<ore:blockEnderium>, <StevesCarts:ModuleComponents:49>, <ore:blockPhasedGold>], [<appliedenergistics2:item.ItemMultiMaterial:24>, <AdvancedSolarPanel:asp_crafting_items:13>, <appliedenergistics2:item.ItemMultiMaterial:24>], [<ore:blockPhasedGold>, <StevesCarts:ModuleComponents:49>, <ore:blockEnderium>]]);

#energy cells
recipes.remove(<appliedenergistics2:tile.BlockEnergyCell>);
recipes.addShaped(<appliedenergistics2:tile.BlockEnergyCell>, [[<appliedenergistics2:tile.BlockQuartzLamp>, <ore:dustFluix>, <appliedenergistics2:tile.BlockQuartzLamp>], [<ore:dustFluix>, <appliedenergistics2:tile.BlockEnergyAcceptor>, <ore:dustFluix>], [<appliedenergistics2:tile.BlockQuartzLamp>, <ore:dustFluix>, <appliedenergistics2:tile.BlockQuartzLamp>]]);

#inscriber
recipes.remove(<appliedenergistics2:tile.BlockInscriber>);
recipes.addShaped(<appliedenergistics2:tile.BlockInscriber>, [[<ore:ingotIron>, <minecraft:sticky_piston>, <ore:ingotIron>], [<appliedenergistics2:item.ItemMultiMaterial:10>, <ThermalExpansion:Frame:3>, <IC2:upgradeModule>], [<ore:ingotIron>, <minecraft:sticky_piston>, <ore:ingotIron>]]);

#me chest
recipes.remove(<appliedenergistics2:tile.BlockChest>);
recipes.addShaped(<appliedenergistics2:tile.BlockChest>, [[<appliedenergistics2:item.ItemMultiPart:16>, <ore:chestWood>, <appliedenergistics2:item.ItemMultiPart:16>], [null, <appliedenergistics2:tile.BlockEnergyAcceptor>, null], [<appliedenergistics2:item.ItemMultiPart:16>, <ore:chestWood>, <appliedenergistics2:item.ItemMultiPart:16>]]);

#wireless controller
recipes.remove(<appliedenergistics2:item.ToolWirelessTerminal>);
recipes.addShaped(<appliedenergistics2:item.ToolWirelessTerminal>, [[<ore:pearlFluix>, <appliedenergistics2:item.ItemMultiMaterial:41>, <ore:pearlFluix>], [<ore:crystalPureFluix>, <appliedenergistics2:item.ItemMultiPart:380>, <ore:crystalPureFluix>], [<appliedenergistics2:item.ItemMultiMaterial:37>, <appliedenergistics2:item.ItemMultiMaterial:28>, <appliedenergistics2:item.ItemMultiMaterial:37>]]);

print("Initialized 'AppliedEnergistics.zs'");

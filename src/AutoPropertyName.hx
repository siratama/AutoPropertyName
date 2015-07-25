package;

import jsfl.Instance;
import jsfl.SymbolInstance;
import jsfl.SymbolType;
import jsfl.ElementType;
import jsfl.LayerType;
import jsfl.Lib;
import jsfl.Lib.fl;

class AutoPropertyName
{
	private var nameMap:Map<String, Bool>;
	private var duplicatedNameSet:Array<String>;

	public static function main()
	{
		new AutoPropertyName();
	}
	public function new()
	{
		if(fl.getDocumentDOM() == null) return;
		fl.trace("--- start AutoPropertyName ---");

		nameMap = new Map();
		duplicatedNameSet = [];

		execute();
		outputDuplicatedNameSet();
	}
	private function execute()
	{
		var documentDom = Lib.fl.getDocumentDOM();
		var layers = documentDom.getTimeline().layers;
		for(layer in layers)
		{
			if(layer.locked || !layer.visible) continue;

			var layerType = layer.layerType;
			if(layerType == LayerType.FOLDER || layerType == LayerType.GUIDE) continue;

			for(element in layer.frames[0].elements)
			{
				if(element.elementType != ElementType.INSTANCE) continue;
				var symbolType = cast(element, SymbolInstance).symbolType;
				if(symbolType != SymbolType.MOVIE_CLIP && symbolType != SymbolType.BUTTON) continue;

				var name = cast(element, Instance).libraryItem.name.split("/").pop();
				element.name = name;

				if(nameMap[name])
					duplicatedNameSet.push(name);
				else
					nameMap[name] = true;

				fl.trace(name);
			}
		}
	}
	private function outputDuplicatedNameSet()
	{
		if(duplicatedNameSet.length == 0) return;

		fl.trace("-- attention: duplicated name list --");
		for(duplicatedName in duplicatedNameSet)
		{
			fl.trace(duplicatedName);
		}
	}
}

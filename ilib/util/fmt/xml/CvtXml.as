package ilib.util.fmt.xml
{
	public class CvtXml
	{
		public function fromXml( node:XML ):Object
		{
			if ( node == null )
			{
				return null;
			}
			if ( node.nodeKind() == "text" )
			{
				return String( node );
			}
			var targetObject:Object = {};
			var attrXmlList:XMLList = node.attributes();
			for ( var attIndex:int = 0; attIndex < attrXmlList.length(); attIndex++ )
			{
				var attrXml:XML = attrXmlList[ attIndex ];
				var attrNameStr:String = String( attrXml.name());
				var attrValueStr:String = String( attrXml );
				if ( isNaN( parseFloat( attrValueStr )))
				{
					if ( attrValueStr == "true" )
					{
						targetObject[ attrNameStr ] = true;
					}
					else if ( attrValueStr == "false" )
					{
						targetObject[ attrNameStr ] = false;
					}
					else
					{
						targetObject[ attrNameStr ] = attrValueStr;
					}
				}
				else
				{
					targetObject[ attrNameStr ] = Number( attrXml );
				}
			}
			var nodeText:String = String( node.text());
			(nodeText != "") ? (targetObject["proto/text"] = nodeText) : void;
			var childXmlList:XMLList = node.children();
			var childObjects:Array = [];
			for ( var childIndex:int = 0; childIndex < childXmlList.length(); childIndex++ )
			{
				childObjects.push( fromXml( childXmlList[ childIndex ]));
			}
			(childObjects.length > 0) ? (targetObject["proto/child"] = childObjects) : void;
			return targetObject;
		}
	}
}

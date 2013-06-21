package ilib.util.fmt
{
	import ilib.util.fmt.json.CvtJson;
	import ilib.util.fmt.xml.CvtXml;

	public class Cvt
	{
		public static const xml:CvtXml = new CvtXml();
		public static const json:CvtJson = new CvtJson();
	}
}
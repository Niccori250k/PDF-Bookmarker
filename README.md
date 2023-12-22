# PDF-Bookmarker
A tool to add bookmarks and title/author to PDF using hexapdf
# Usage
```shell
ruby Bookmarker.rb "<filename (without extension)>"
```
**This program requires a correspondent json file with the same name as the PDF.**
The json files must follow the format below:
```json
{
	"Info": {
		"BookTitle": string,
		"BookAuthor": string
	},
	"Outline": array of outlines
}
```
where each element of `Outline` should contain
```json
"Title": string,
"Target": integer,
"Style": 0 or 1 or 2 or "Italic" or "Bold",
"Opened": boolean,
"Color": string,
"Bookmark": array of outlines
```
Some elements can be ommitted, for example,
```json
{
	"Info": {
		"BookTitle": "a",
		"BookAuthor": "a"
	},
	"Outline": [
		{
			"Target": 180,
			"Title": "a",
			"Style": 2
		},
		{
			"Target": 192,
			"Title": "a",
			"Bookmark": [
				{
					"Title": "a",
					"Target": 90
				},
				{
					"Title": "a",
					"Target": 29,
					"Style": 1,
					"Color": "red"
				}
			]
		}
	]
}
```
is valid.
# Future development
* <s>More options e.g. input/output filename, whether to optimize</s> -> done
* <s>Json file generator (perhaps from pdftk's dump data?)</s> -> partly done (from csv)
* Provide a conprehensive document

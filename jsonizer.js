const csv = require("csvtojson");
const fs = require("fs");
const util = require("util");

const argOptions = {
	"input": {
		type: "string",
		short: "i",
		multiple: false
	},
	"output": {
		type: "string",
		short: "o",
		multiple: false
	},
	"author": {
		type: "string",
		short: "a",
		multiple: false
	},
	"title": {
		type: "string",
		short: "t",
		multiple: false
	}
}

const preParse = process.argv.slice(2)
const options = util.parseArgs({options: argOptions});
const inputPath = options.values.input;
const outputPath = options.values.output;
const author = options.values.author;
const title = options.values.title;

function TreeNode(title, target, parent, style, opened, color, bookmark){
	this.Title = title;
	this.Target = target;
	this.Parent = parent;
	this.Style = style;
	this.Opened = opened;
	this.Color = color;
	this.Bookmark = bookmark;
}

let node = {}

csv().fromFile(inputPath).then((rows) => {
		rawnodes = rows.map((row) => {
			return new TreeNode(
				new String(row.Title),
				new Number(row.Target),
				new String(row.Parent),
				new String(row.Style),
				new Boolean(row.Opened),
				new String(row.Color),
				new Array()
			);
		});
		let meta = {"Info": {"BookTitle": author, "BookAuthor": title}, "Outline": []};
		let outline = [];
		rawnodes.map((node) => {
			if(node.Parent.toString() === ""){
				outline.push(node);
			} else {
				rawnodes.map((tmpnode) => {
					if(tmpnode.Title.toString() == node.Parent.toString()){
						tmpnode.Bookmark.push(node);
					}
				});
			}
		});
		meta.Outline = outline;
		fs.writeFile(outputPath, JSON.stringify(meta, null, 2), (e) => {if(e) throw(e)});
	})
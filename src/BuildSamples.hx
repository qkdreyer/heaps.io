package;

import sys.FileSystem;
import sys.io.File;
import sys.io.Process;

/**
 * @author Mark Knol
 */
class BuildSamples
{
	static var GIT_TAG = "1.2.0"; // tag name
	static var GIT_REPO = "https://github.com/HeapsIO/heaps.git";
	static var TEMPFILE = ".install-heaps.tmp";
	static var FOLDER = ".temp/";
	
	static function main() 
	{
		var sampleDir = FOLDER + "samples/";
		var sampleBuildDir = sampleDir + "/build/";
		trace( "** Git the samples");
		Sys.command('git', ["clone", "--branch",  GIT_TAG, "--depth", "1", "--single-branch", GIT_REPO, FOLDER]);
		
		trace( "** Build the samples");
		
		Sys.setCwd(sampleDir);
		Sys.command('haxe', ["all.hxml"]);
		
		trace( "** Copy the samples");
		Sys.setCwd("../../");
		trace(sampleBuildDir, "assets/includes/samples/");
		copyDirectory(sampleBuildDir, "assets/includes/samples/");
		
		trace( "** Samples done!");
	}
	
	static function runCommand(cmd:String, ?args:Array<String>):String
	{
		var p = new Process(cmd, args);
		var out:String = p.stdout.readAll().toString();
		p.close();
		//File.saveContent(TEMPFILE, out);
		return out;
	}
	
	static function copyDirectory(dir:String, path:String) {
		FileSystem.createDirectory(path);
		trace("include directory: " + path);
		
		for (file in FileSystem.readDirectory(dir)) {
			var srcPath = '$dir/$file';
			var dstPath = '$path/$file';
			if (FileSystem.isDirectory(srcPath)) {
				FileSystem.createDirectory(dstPath);
				copyDirectory(srcPath, dstPath);
			} else {
				File.copy(srcPath, dstPath);
			}
		}
	}
}

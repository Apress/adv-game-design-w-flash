To be able to modify and recompile these example files, you'll first need to install the custom class library. These instructions explain how to do this.

This book’s source files contain a folder called com. Open it, and you’ll see that its path structure looks something like this: 

com/friendsofed/lotsOfClassFolders

Take a look in the friendsofed folder. There, you’ll find a lot of different AS files and subfolders. This is a class library. The folders contain custom classes that are used by most of the examples and projects in this book. If you want to use them, they need to be available to any AS program you write. This means you need to set up your IDE so that it can always find the class library, no matter where on your hard drive you’re working.
Setting the path to the class library:
If you’re using Flash or Flash Builder, it’s easy to set up the IDE to find the class library. In Flash Professional, follow these steps:
	1. Open Flash’s Preferences dialog box. In Windows, select File > Preferences. In Mac OS X, select Flash > Preferences.	2. Select ActionScript > ActionScript 3 Settings. The Advanced Settings dialog box will open. 	3. The first setting is Source Path. Click the folder icon, and browse to the location on your system where the com folder that you downloaded from the friends of ED website is located.
In Flash Builder, specify the source path when you create a new ActionScript project. You can change or modify this after the project has been created through the project properties.
If you’re using the Flex SDK and an alternative IDE or the command-line compiler, you need to make changes to the flex-config.xml file. You can find this file in the SDK’s frameworks folder. The path to it might look something like this: 

flex_sdk_4/frameworks/flex-config.xml. 

Open flex-config.xml. It contains all the settings that are used to compile your code. Look for a tag called <source-path>. If this is your first time modifying flex-config, it will probably be commented (surrounded by <!-- and --> tags). Remove the comment tags and change the <source-path> and <path-element> tags so that they look something like this:
<source-path append="true">  <path-element>/absolute/path/to/your/classFolder</path-element></source-path>
The attribute append="true" means that the path you specify will be an absolute path—the complete path to the com folder from your hard drive’s root. You’ll generally want the path to your class libraries to be absolute so that the compiler can always find them. Let’s imagine that you’ve saved the com folder in another folder called classes. The complete path to the classes folder might look something like this: 

/username/code/classes.
If you’re using Windows, your <path-element> tag should look like this:
<path-element>C:\username\code\classes</path-element>
In Mac OS X, it should look like this:
<path-element>/username/code/classes</path-element>
You can add as many <path-element> tags for as many class libraries as you need.Finally, save the flex-config.xml file.

You should now be able to import and use any class from the class library following this format:

import com.friendsofed.directoryName.ClassName;
# cmsas
Content Management Systems are Shit - Thats my opinion. And all of them are so slow for that stuff that i am doing. 
But writing plain html is somehow... not what i wanted to do, either. So i wrote cmsas - a CMS, written in bash.

### Pure bash?
No, not pure bash. cmsas makes use of standard tools:
  * awk
  * sed
  * cat / find / ... default stuff 
  * markdown - not a standard tool but available on the places i looked at 

If you system dosnt have these, you probably dont want to use cmsas! 

## Installation 
The installation of cmas should be simple. Clone this repo and start using it!

However its possible that markdown will be missing. For apt systems, you can try running the install script or simply by `apt-get install markdown`. If your system dosnt use apt i dont know how to install it but im sure its either available there or you can compile it there.

## More Instructions - how to use cmsas
cmsas generates static html out of .md files - but theses files are not pure markdown. 
If you simply want to get started here, try running `generate test/ someOutputFolder/` to get started, ill go into detail below. 

So the syntax for the generate-script is `generate <source folder> <destination folder>`. The destination folder should be an empty folder where the scripts puts all its stuff into. Note that it will rm -rf dst/* the folder to take care of that its empty! REALLY IT WILL. 

The source folder should have a fixed structure: 
  * site: the site definition file. See below. 
  * sites/ : holds the .md files that make up the site (can be modified)
  * news/ : holds the news (if news are enabled)  (can be modified)
  * static/ : holds static files. Will be copied into the destination folder (can be modified)

The first thing that `generate` will do is source the site file into the bash script. Usually that is used to load the config variables, but you could place additional commands in that file, too. 
The settings in the site file that are required are:
  * `title`: The title of the website. 
  * `hasNews`: If news should be parsed
  * `newsLimit`: unused. yet. 
  * `newsPrefix`: Html/whatever to put before writing the parsed news, per file
  * `newsSuffix`: Ditto
  * `template`: The html template from what every page will be generated 
  * `staticFolder`: The folder where the static files are
  * `newsFolder`: The folder where the news files are
  * `markdownFolder`: The folder in wich the files are placed
  * `fileReown`: If the owner of the files put into the output-dir should be changed (helpfull when writing intp /var/www/... for www-data etc. )
  * `fileOwner`: The owner of the file if reowned
  * `filePermissions`: The permissions that the files should be set to if they are reowned

### Parsing of the Sites
The next thing that happens is that every site file is thrown into `parser.bash`. Now you need to know what these markdown files are - they arnt pure markdown. 
.md files in the markdownFolder are split in two parts: A bash part and a markdown part. This split happens at the first empty newline the parser finds. The upper part is then sourced into the parser script. 
The second half of the file is then thrown into an evaled echo command - that means you can put `$something` there and it will replace that with the actual variables (or nothing if the variable is not found). Yes, you can do `$(some comand)` here, too!
If you want to use an `$`, doube prefix it (see below why): `\\$`

The bash section has some variables that should be set (otherwise the ugly defaults will be used):
  * `title` The title of the page 
  * `createMenuEntry` if a menu entry should be generated for this site
  * `menuPriority` some number, lower means shows up higher in the menu 

Actually, you only need title if you dont care about position in the menu. 
After that the parser script puts the stuff on stdout, what is used back in the generate script. 

### Menu
Now the menu is parsed. That is done by reading the files generated by the parser script. Also all files in the local "menu" folder will be copied, so you can add your own menu entries. 
Menu definition files look like that: `000-somename.dontcare` and should just be `title of the entry : link to the entry`

If you want mutly layer menu entries, this can be achived by encapsulating entries with `{}` and if you want more then one you must seperate them with `;`. If you want to create a deeper hirarchy, you can, however the parser.bash script only supports two layer hirarchys for now. But that script dosnt care about what you write into your custom mdef files, you could surpress menu generation completly and write it on your own. Its up to you really. 

After parsing the menu is put into the $menu variable, wich can be accessed from the template or the markdown. 

### News
News are parsed by simply converting the news-folders markdown (without the bash header i talked about above!) into html. They are then prefixed and suffixed with that content of these settings (see above) and then put into the $news variable. 

### Output and "higher-scope vars"
After the news-step the ouput file is parsed once more, the same way the markdown is parsed the first time: put into an echoed $eval. Thats the reason that you have to escape `$` with two `\`! 
However that also causes that you can create placeholders/script-calles that will be executed in this second step. This is actually needed if you dont want your news on every possible site: simply put `\$news` on the site where you want them. 

After that the static folder is copied and permissions of all ouput files will be reset (if enabled) and the program finishes. 

### Something about the template
In the template there MUST be the `$content` variable, otherwise you will not get any output. Also you should put `$menu` into the template. If you want to use the letter `$` in the template, you only neet to escape it once. 

### Questions?
  * Contact me at mkalte [at]mkalte.me 
  * Open an issue if you want
  * Pull requests will be accepted if usefull
  * Yes i coded this in an afternoon because i just needed a cms and was pissed. 

I really dont care how. 

%% ---------------------------------------------------------------------------------------------
%% LaTeX Class Reykjavík University Theses/Dissertations/Books,
%% Created for Departments Computer Science, and Science and Engineering
%% ---------------------------------------------------------------------------------------------
%% Official Distribution from:
%% http://www.ru.is/tvd/reglur/ritgerdir
%% http://en.ru.is/sse/rules/template
%% http://en.ru.is/departments/school-of-computer-science/ph.d-studies/theses/thesis-template/
%% http://en.ru.is/scs/graduate/why/thesis-template/
%% http://en.ru.is/departments/computer-science/student-information/thesis/thesis-template/
%% http://en.ru.is/scs/graduate/phd/#tab5
%% $Header: https://repository.cs.ru.is/svn/thesis-template/trunk/ruthesis/latex/ruthesis.cls 289 2016-02-17 12:49:46Z foley $
%% Initial version by Joe Foley <foley AT RU dot IS>
%% Questions, comments, complaints: latex@LIST.RU.IS
%% Created on 2015-02-27
%% This code is distributed under the Perl Artistic License
%% http://language.per.com/misc/Artistic.html
%% This template is heavily derived from the RUCSMSc.sty developed by Bjorn Thor Jonsson, bjorn@ru.is
%%
%% Reference for class/package writers
%% http://ctan.uib.no/macros/latex/doc/clsguide.pdf
%%


%% --------------- Identification ----------------------------
\newcommand{\fileversion@ruthesis}{$Revision: 289 $}
\newcommand{\filedate@ruthesis}{2016/02/08}% must be YYYY/MM/DD!
\newcommand{\fileauthor@ruthesis}{Joseph Timothy Foley, foley at R U dot I S}
\ProvidesClass{ruthesis}[\filedate@ruthesis by \fileauthor@ruthesis]
\NeedsTeXFormat{LaTeX2e}
\typeout{Thesis Class for Reykjavik University \fileversion@ruthesis <\filedate@ruthesis>, by \fileauthor@ruthesis}

%% ---------------- Critical packages -----------------------------
% This package allows you to create conditionals on booleans
\RequirePackage{ifthen}

% detect pdflatex vs latex
\RequirePackage{ifpdf}

%% XeTeX can allow for nicer fonts, but we really don't need it
%% Because we use standard fonts to be consistent
%% Doing the XeTeX tests causes AUCTex to keep asking if you want XeTeX, which is annoying
%\RequirePackage{ifxetex}

%% Morewrites packages allows more programs to generate external files
%% because there is an internal limit
%% Needed if you get a "No room for a new \write" error
%% Unfortunately, it appears to be incompatible with DropBox.  Bug filed with developed 2016-2-17 --foley
%\RequirePackage{morewrites}

%% Command to remove things if we are draft mode
\RequirePackage{ifdraft}

% ignore warnings and errors temporarily
%\RequirePackage{silence}

%% LaTeX3
%% Some of this may already be included as a dependancy from another package
% Better handling of arguments, particularly for defaults
\RequirePackage{xargs}

% Specialized commands for constructing macros
\RequirePackage{xparse}


%% ---------------- Boolean switches -----------------------------
%% Booleans make it easy to enable and disable parts of the template
\newboolean{fakedraft}
\newboolean{booklet}
\newboolean{svn}
\newboolean{icelandic}
\newboolean{projectreport}
\newboolean{oldstyle} % some elements from the old CS template that people might still want
\newboolean{yngvihack} % yngvi changed the style, we need a hack until I can talk to him
\newboolean{bachelors}
\newboolean{masters}
\newboolean{doctorate}
\newboolean{online}
\newboolean{forcegraphics}
\newboolean{proof}
\newboolean{debug}
\newboolean{miktex}
\newboolean{glossary}


%% ---------------- Declaration of Class Options--------------------
%% Remember that we have \AtEndOfClass{},\AtEndOfPackage{}
%%     \AtBeginDocument{}, \AtEndDocument{}
%% If you want execution conditional on file existence
%%     \IfFileExists{filename}{true}{false}
%%     \InputIfFileExists{filename}{true}{false}
%% For error reporting
%%     \ClassError{class-name}{error-text}{help-text}
%%     \PackageError{class-name}{error-text}{help-text}
%% otherwise, just a generic title page

%% Boolean for which language is dominant
%% Mostly affects which language is shown in multi-lingual
%%  and which abstract comes first.
\DeclareOption{icelandic}{\setboolean{icelandic}{true}}

\DeclareOption{svn}{\setboolean{svn}{true}}

%% Which documenttype is this?
\DeclareOption{projectreport} {\setboolean{projectreport}{true}}
\DeclareOption{oldstyle} {\setboolean{oldstyle}{true}}
\DeclareOption{bachelors}{\setboolean{bachelors}{true}}
\DeclareOption{masters}{\setboolean{masters}{true}}
\DeclareOption{doctorate}{\setboolean{doctorate}{true}}

% Generalized settings
\DeclareOption{online} {\setboolean{online}{true}}
\DeclareOption{forcegraphics} {\setboolean{forcegraphics}{true}}
\DeclareOption{proof} {\setboolean{proof}{true}}
\DeclareOption{debug} {\setboolean{debug}{true}}
\DeclareOption{miktex} {\setboolean{miktex}{true}}
\DeclareOption{glossary} {\setboolean{glossary}{true}}

\DeclareOption{booklet}{\setboolean{booklet}{true}}
\DeclareOption{yngvihack}{\setboolean{yngvihack}{true}}

%% We need to set a "fakedraft" boolean because the
%%  normal draft behaviour (which uses the boolean "draft") is
%%  too limiting.
\ifdraft{\setboolean{fakedraft}{true}}

%% DEVELOPMENT: DO NOT USE!!! --foley
%% Working on making the template prepare a booklet size
\ifthenelse{\boolean{booklet}}{ %
  %% TODO:  expand the booklet options to rescale other elements
  \PassOptionsToClass{10pt,b5paper}{memoir}
}{
  \PassOptionsToClass{12pt,a4paper}{memoir}
}

%% Note, if you are writing a PhD thesis, it will be reduced at the
%% printers when it is bound into a book: B5 240x170mm (aka Programme
%% or Book economy) See the README.TXT for details.  Plan your figures
%% and diagrams for this size.  Small text can quickly become unreadible.

\DeclareOption*{
  \PassOptionsToClass{\CurrentOption}{memoir}
  %% now we pass the remaining unused options to our parent class
  %% If you need to make warnings about options regarding packages
  %% \PackageWarning{packagename}{Unknown option '\CurrentOption'}%
}

\ifthenelse{\boolean{online}}{}{
  \ExecuteOptions{openright}}
%% All of our printed formats are going to be opening to the right

%% ---------------- Execution of Options -----------------------------
\ProcessOptions\relax% this stops searching for a * in
                       % \ProcessOtions*

%% Alternative way to subclass.  Disable the other option processing
%% if you enable it.  This will dump all options onto the parent class
%\ProcessOptions\LoadClassWithOptions{article}
%% Read page 20 of http://latex-project.org/guides/clsguide.pdf
%% carefully before modifying any of the execution and previous section.
%% ---------------- Package Loading -----------------------------
\LoadClass{memoir}  % our parent class.

%% ---------------- XeTeX setup -----------------------------
%% This is disabled for now because you would only need XeTeX if you
%% were going to modify the fonts, which you shouldn't!
%\ifxetex%
%  \RequirePackage{fontspec} % font selecting commands
%  \RequirePackage{xunicode} % unicode character macros
%  \RequirePackage{xltxtra} % a few fixes and extras
%\else % pdftex or latex
  \RequirePackage[T1]{fontenc}
  \RequirePackage[utf8]{inputenc}  % allows UTF encoding, needed for Icelandic characters
%\fi

%% ---------------- Internationalization -----------------------------
\RequirePackage[autostyle,strict]{csquotes}
%% http://mirrors.concertpass.com/tex-archive/macros/latex/contrib/csquotes/csquotes.pdf
%% You invoke with \enquote{} and \blockquote{}
%% csquotes must be loaded before babel for AUCTeX
%% autostyle: update style as language changes in document
%% strict: any warnings become errors
\DeclareQuoteAlias{german}{icelandic}
%% Unfortunately, csquotes does not understand Icelandic quotation marks
%%   so we must create an alias.  German is close enough.

\@nameuse{RequirePackage}[english,german,icelandic]{babel}
%% Babel allows various automatic text to be in selected languages
%% But to use the options, you have to always load it, even for english
%% The languages must be specified in order.

%% We load german because it seems to be needed for the special Icelandic quotation marks.
%% Smart quotation marks
%% The \@nameuse magic is to prevent AUCTeX from using the semi-broken icelandic mode.
%% If you don't have a keyboard to type the Icelandic characters, there are macros:
%% "` or \glqq  (startquote)
%% "' or \grqq  (endquote)
%% \TH          Þ
%% \th          þ
%% \DH          Ð
%% \dh          ð
%%

% set language based upon the class setting
\newcommand{\resetlanguage}{%
  \ifthenelse{\boolean{icelandic}}%
  {\selectlanguage{icelandic}}%
  {\selectlanguage{english}}}%
\resetlanguage{}

\RequirePackage{iflang}
%% iflang allows us to put multiple translations together
%% e.g. \IfLanguageName{icelandic}{Já}{Yes}


%% ---------------- Fonts -----------------------------
%%%  For help, read http://latex-project.org/guides/fntguide.pdf
%%

%% You can manually load the packages, but a better way is shown later.
%%
%\RequirePackage{times}  % times is not recommended due to some spacing/math issues
%\RequirePackage{helvet}
%\RequirePackage{courier}
%\RequirePackage{lmodern}  % updated Computer Modern Roman, similar to original Computer Modern
%\RequirePackage{palatino}
%\RequirePackage{bookman}
%\RequirePackage{newcent}

% save the current font size
\newlength{\normaltextsize}
\setlength{\normaltextsize}{\f@size pt}

%% The Typewriter Text font often seems huge, here's how we would reduce it
%% http://tex.stackexchange.com/questions/158778/all-ttfamily-font-change-font-size
%\DeclareRobustCommand\ttfamily
%        {\not@math@alphabet\ttfamily\mathtt
%         \fontfamily\ttdefault\small\selectfont}


\RequirePackage{bm}
% bold math, which doesn't exist in some fonts

\RequirePackage{lipsum}% generates some test text
%% usage: \lipsum[STARTNUM-ENDNUM]

%% Font guide at
%% http://latex-project.org/guides/fntguide.pdf

% set the font defaults (if they need to be further adjusted)
%\renewcommand{\encodingdefault}{t1}

%\renewcommand{\rmdefault}{ptm}  % adobe times
%\renewcommand{\sfdefault}{phv}  % adobe helvetica?
%\renewcommand{\ttdefault}{pcr}  % adobe courier
%% cmr  : computer modern roman
%% cmss : computer modern sans oblique
%% cmm  : computer modern math
%% ptm  : (postscript) Adobe Times
%% phv  : (postscript) Adobe Helvetica
%% pcr  : (postscript) Adobe Courier

%\renewcommand{\familydefault}{\sfdefault} % switch to \sfdefault if you want to force sanserif
%% \familydefault should be one of the short letter codes such as "lm" or "ptm"
%\renewcommand{\familydefault}{\rmdefault}

%\renewcommand{\seriesdefault}{m}
%% m  : medium
%% b  : bold
%% bx : bold extended
%% sb : semi bold
%% c  : condensed

%\renewcommand{\shapedefault}{n}
%% n  : upshape (normal)
%% it : italics
%% sl : slanted
%% sc : small caps

%%\fontsize{12pt}{14pt}  % args: fontsize, baselineskip (font+space)
%% normal sequence of increasing sizes:  5,7,8,9,10,12,14.4,17.28,20.74,24.88


%%  Specific fonts
%%  Note that you can leave off elements and it will use the last value set (or default??)
% \def\myfont{\fontencoding{T1}\fontfamily{lm}\fontseries{m}\fontshape{n}\fontsize{14pt}{16pt}\selectfont}
%  \fontsize{SIZE}{BASELINESKIP}

%% Outside PhD cover we hardcode for consistency
\def\frontcovertitlefont{\fontfamily{phv}\fontseries{b}\fontshape{n}\fontsize{20.74}{24}\selectfont}
\def\frontcovertitletext{\fontfamily{phv}\fontseries{m}\fontshape{n}\fontsize{14.4}{16}\selectfont}

%% BSc has different fonts than normal, only on the title page
\newcommand{\bscfonts}{
  %% The rest of the fonts are based upon what the defaults were selected
  \def\titletitlefont{\fontfamily{phv}\fontseries{b}\fontshape{n}\fontsize{16}{18}\selectfont}
  \def\titletextfont{\fontfamily{phv}\fontseries{m}\fontshape{n}\fontsize{14}{16}\selectfont}
  \def\titleinfofont{\fontfamily{phv}\fontseries{m}\fontshape{n}\fontsize{12}{14}\selectfont}
}
\newcommand{\notbscfonts}{
  %% The rest of the fonts are based upon what the defaults were selected
  %% TODO: adjust for booklet option
  \def\titletitlefont{\fontseries{b}\fontsize{17pt}{20pt}\selectfont}
  \def\titletextfont{\fontsize{14pt}{16pt}\selectfont}
  \def\titleinfofont{\fontsize{12}{14}\selectfont}
}
\ifthenelse{\boolean{bachelors}}{\bscfonts}{\notbscfonts}

\def\sigtextfont{\fontsize{12pt}{14pt}\selectfont}
\def\warningfont{\fontseries{b}\fontsize{24pt}{28pt}\selectfont}
%%%%%%%%%%%%%%%%%%%%%%%%%%% TABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{booktabs}
%% Book quality tables
%% Do not use \hrule.  Instead:
%% \toprule, \midrule, \bottomrule

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{svn-multi}
%% With svn-multi you can have svn information on each of your files
%% and the package will aggregate it to be shown in headers

%% WARNING:  Watermarks never worked, needs more investigation --foley
%\RequirePackage[printwatermark]{xwatermark}
%% Make warning marks on what kind of document this is
%% Note: got lots of conflicts, skipping for now
% \newwatermark[allpages,color=red!50,angle=45,scale=3,xpos=0,ypos=0]{DRAFT}
%\RequirePackage{draftwatermark}  % loads graphicx automatically
%\SetWatermarkText{Test}
%\SetWatermarkScale{5}
%\SetWatermarkAngle{30}

%% Detect PDF mode to include the right graphics settings
%% We use \PassOptionsToPackage{option1,option2}{package} to avoid conflicts with packages that
%% load graphicx, because we can \RequirePackage{} without options.
%% http://tex.loria.fr/ctan-doc/macros/latex/doc/html/clsguide/node31.html

%% We create \finalifforcegraphics because draft mode usually just puts boxes
%% This will pass a "final" option to any package specified even when in draft mode.
\newcommand{\finalifforcegraphics}[1]{\ifthenelse{\boolean{forcegraphics}}%
  {\PassOptionsToPackage{final}{#1}}{}}

%% This convenience macro is to force the "final" option on a package
%%   if forcegraphics boolean is true
\finalifforcegraphics{graphicx}
\ifpdf%
  \PassOptionsToPackage{pdftex}{graphicx}
  %% We give the "final" option so that it always includes graphics
  %% Take out "final" if you want draft mode to skip pics
  \RequirePackage{graphicx}
  \DeclareGraphicsExtensions{.pdf,.jpeg,.jpg,.png,.PDF,.JPEG,.JPG,.PNG,}
  %% The extensions that it will search for as valid graphics files
  %% We need To include the UPPERCASE versions For windows people
\else % latex in DVI mode
  \RequirePackage{graphicx}
  \DeclareGraphicsExtensions{.eps,.ps,.EPS,.PS}
\fi


\graphicspath{{graphics/}{Graphics/}{./}}
%% This is a list of folders to search for graphics files to include
%% Each path should be in a {}.
%% Make sure that the upper/lowercase of the letters matches the folder or
%% you may have weird problems with partners using OSX or Linux.
%% Note that you don't have to put the folder where the .tex file is, it is
%% included automatically, though it is bad practice to put your
%% graphics there
%% LaTeX will search from left to right in the list, so you can put "cropped" versions
%% in the first directory and it will grab them first. e.g.
%\graphicspath{{graphics-cropped/}{graphics/}{Graphics/}{./}}
%%
%% If you put a // at the end of the path, it will recursively search for graphics
%% files on some platforms.

\finalifforcegraphics{pdfpages}
\RequirePackage{pdfpages}
%% The "pdfpages" package lets you include PDF documents into your
%% document but keeps the formatting consistent (headers, footers,
%% etc.)
\includepdfset{pagecommand=\thispagestyle{plain}}
% pagecommand is run on every page.
% This one puts page numbers on included pdfs

\PassOptionsToPackage{obeyspaces,spaces,hyphens,allowmove}{url}
\RequirePackage{url}
%% The url package typesets url's and unix file paths nicely when they
%% become long.  \url{}
%% Also defines \path{}  which works with filepaths including windows paths.
%% Watch out that you leave a space after a last \ e.g. \path{C:\ }
%% You need another verbatim environment to make those typeset properly.
%% Also defines the \path{} command for paths
%% Option: obeyspace to deal with spaces in a path/url
%% Option: spaces to do lccinebreaks at the spaces.
%% Option: hyphens to do linebreaks at hyphens.
%% Option: allowmove makes URLs not-fragile, so they can go in things that move
%%         WARNING: If this breaks you will get very very weird errors

%% Hyperlinks break with the smallurl style, disabling --foley 2015-10-30
%%
%% Define a new 'smallurl' style for the package that will use a smaller font.
%\def\url@smallurlstyle{%
%  \@ifundefined{selectfont}{\def\UrlFont{\sf}}{\def\UrlFont{\scriptsize}}}
%\DeclareUrlCommand\smallurl{\urlstyle{smallurl}}
%% Now actually use the newly defined style.
%\urlstyle{smallurl}



\RequirePackage{siunitx}  % replacement for SIunits, less problems
%% examples: \SI{9.8}{\meter\per\second\square}

\ifthenelse{\boolean{debug}}{
    \RequirePackage[absolute, showboxes, verbose]{textpos}
    \RequirePackage{printlen} % display lengths in arbitrary units
  }{
    \RequirePackage[absolute, verbose]{textpos}
  }
  %% The textpos package allows you to place blocks of text explicitly
  %% rather than letting LaTeX put them somewhere.

%% These commands set the units in \begin{textblock} when not
%%  directly specified
%% We set them to the page sizes so we can align from them
\setlength{\TPHorizModule}{\paperwidth}
\setlength{\TPVertModule}{\paperheight}
%\setlength{\TPMargin}{2mm} %% margins inside the textblock*
\textblockorigin{0mm}{0mm} % start everything near the top-left corner

%% Setting colors in text
%% Usage:
%% \textcolor{rured}{Some text.}
%% {\color{rured}Some text.}
\RequirePackage{xcolor}
\definecolor{rugray}{rgb}{0.2,0.2,0.2}
\definecolor{rured}{rgb}{0.84,0.10,0.13}


%% ---------------- Main Code -----------------------------
%%  Remember that we can declare commands (to make fragile things safe)
%%  The * form is for ``short'' commands, not longer than a paragraph
%%       \DeclareRobustCommand{cmd}[num][default]{definition}
%%       \DeclareRobustCommand*{cmd}[num][default]{definition}
%%  For checking if commands are redefined
%%       \CheckCommand{cmd}[num][default]{definition}

%% Spacing modes from the memoir class
%\SingleSpacing{} % single spacing
%\OnehalfSpacing{} % one and a half
%\DoubleSpacing{} % Double spacing, very ugly.

%% Multilingual macros
%\newML{macroname}{englishword}{icelandicword}
%  creates \macronameML
%    \MLmacroname[english] - returns the englishword
%    \MLmacroname[icelandic] - returns the icelandicword
%    \MLmacroname  - uses the current language setting
\newcommand{\newML}[3]{%
  %% IMPORTANT:  !!Make sure there are no blank lines!!!
  %% The next black magic allows us to create the macro names dynamically
  %% The %'s at the end of each line avoids adding spaces when expanded
  %%
  %% We also want to force a replacement of an existing macro (from a previous default)
  %% which providecommand will just skip
  %\expandafter\@ifundefined\csname ML#1\endcsname{%
  %  \expandafter\newcommand\csname ML#1\endcsname[1]{Uninitialized #1}}
  %% Not sure why this doesn't work, splitting into two for now --foley
  \expandafter\let\csname ML#1\endcsname\relax% undefine if it already exists
  \expandafter\newcommand\csname ML#1\endcsname[1][\languagename]{%
    %% We have to manually expand the contents of the macro for comparison
    %% using \expandafter and \ifstrequal in etoolbox
    %% http://tex.stackexchange.com/questions/24922/comparing-an-argument-to-a-string-when-argument-is-a-result-of-a-command-with-et
    \expandafter\ifstrequal\expandafter{##1}{english}{#2}{}%
    \expandafter\ifstrequal\expandafter{##1}{icelandic}{#3}{}%
    %% Warning, this has some limitations due to the way the \languagename macro is defined
    %% See Babel documentation Section 1.3 and iflang package documentation
    %% German seems to be the main problem
  }
}
\newcommand{\renewML}[3]{
  %% The next black magic allows us to create the macro names dynamically
  %% The %'s at the end of each line avoids adding spaces when expanded
  %%
  %% We also want to force a replacement of an existing macro (from a previous default)
  %% which providecommand will just skip
  %\expandafter\@ifundefined\csname ML#1\endcsname{%
  %  \expandafter\newcommand\csname ML#1\endcsname[1]{Uninitialized #1}}
  %% Not sure why this doesn't work, splitting into two for now --foley
  \expandafter\renewcommand\csname ML#1\endcsname[1][\languagename]{%
    %% We have to manually expand the contents of the macro for comparison
    %% using \expandafter and \ifstrequal in etoolbox
    %% http://tex.stackexchange.com/questions/24922/comparing-an-argument-to-a-string-when-argument-is-a-result-of-a-command-with-et
    \expandafter\ifstrequal\expandafter{##1}{english}{#2}{}%
    \expandafter\ifstrequal\expandafter{##1}{icelandic}{#3}{}%
  }
}
\newcommand{\newMLwarning@ruthesis}[2]{
  % args: internal name,  access name
  %% setup variable with a warning
  \newML{#1}{??\#1(EN)??\@warning{***  \noexpand\ #2 not set ***}}{??#1(IS)??\@warning{*** \noexpand\ #2 not set ***}}
  %% I can't figure out how to escape the backslash properly.  This is good enough. --foley
}

%% combine to make one that sets up the accessor
%% TODO:  Fix this, I can't figure out what expansion is failing
% \newcommand{\newMLaccessor@ruthesis}[1]{
%   %\newMLwarning@ruthesis{get#1}{get#1}
%   %\newMLwarning@ruthesis{#1@ruthesis}{#1@ruthesis}

%   % global accessor
%   \expandafter\newcommand\csname set#1\endcsname[2]{%
%     \expandafter\newML{get#1}{##1}{##2}%
%   }%
%   % local accessor
%   \expandafter\newcommand\csname #1@ruthesis\endcsname[2]{%
%     \expandafter\newML{#1@ruthesis}{##1}{##2}%
%   }%
%   %
% }

%% Common words we will use MultiLingual
\newML{Iceland}{Iceland}{Ísland}
\newML{Supervisor}{Supervisor}{Leiðbeinandi}
\newML{Supervisors}{Supervisors}{Leiðbeinendur}
\newML{ThesisCommittee}{Thesis Committee}{IS:``Thesis Committee''}
\newML{Examiner}{Examiner}{Prófdómari}
\newML{Examiners}{Examiners}{Prófdómarar}
\newML{ExaminingCommittee}{Examining Committee}{Prófnefnd}
\newML{Student}{Student}{Nemandi}
\newML{date}{date}{dagsetning}
\newML{Date}{Date}{Dagsetning}
\newML{Abstract}{Abstract}{Útdráttur}
\newML{Copyright}{Copyright}{Höfundarréttur}
\newML{Semester}{Semester}{Önn} % year-number
\newML{Author}{Author}{Höfundur}
\newML{Program}{Program}{Námsbraut}% Vel- o orkutæknifræði BSc
\newML{TypeOfWork}{Type of work}{Tegund verkefnis}%Lokaverkefni 'i takenifræði BSc
\newML{SupervisorTeacher}{Supervisor Teacher}{Umsjónarkennari}
%% RU faculty, not associated with project
\newML{CompanyOrganization}{Company/organization}{Fyrirtæki/stofnun}
\newML{IcelandicPassword}{Icelandic Password}{Lykilorð íslensk}
\newML{EnglishPassword}{Icelandic Password}{Lykilorð ensk}
\newML{Distribution}{Distribution}{Dreifing}
\newML{open}{open}{opin}
\newML{closed}{closed}{lokuð}

\newML{SeniorProfessor}{Senior professor}{prófessor}
\newML{Professor}{Professor}{dósent}
\newML{AssistantProfessor}{Assistant Professor}{lektor}
\newML{AssociateProfessor}{Associate Professor}{IS:``Associate Professor''}
\newML{AdjunctProfessor}{Adjunct Professor}{aðjúnkt}
\newML{EmeritusProfessor}{Professor Emeritus}{emeritus prófessor}

\newML{UniversityIceland}{University of Iceland}{Háskóli Íslands}
\newML{ReykjavikUniversity}{Reykjavík University}{Háskólinn í Reykjavík}

\newML{BSc}{Bachelor of Science}{IS:``Bachelor of Science''}
\newML{MSc}{Master of Science}{meistaraprófs}
\newML{Phd}{Doctor of Philosophy}{doktor}

\newML{BScAbbrv}{B.Sc.}{BSc}
\newML{MScAbbrv}{M.Sc.}{MSc}
\newML{PhDAbbrv}{Ph.D.}{PhD}

\newML{FinalReport}{Final Report}{Lokaverkefni}
\newML{in}{in}{í}
\newML{to}{to}{til}

%% Bachelors
\newML{Name}{Name}{Höfundur/höfundar}
\newML{ID}{Kennitala}{Kennitala}


\newML{SCS}{School of Computer Science}{Tölvunarfræðideild}
\newML{SSE}{School of Science and Engineering}{Tækni- og verkfræðideild}

\newML{jan}{January}{janúar}
\newML{feb}{February}{febrúar}
\newML{mar}{March}{mars}
\newML{apr}{April}{apríl}
\newML{may}{May}{maí}
\newML{jun}{June}{júní}
\newML{jul}{July}{júlí}
\newML{aug}{August}{ágúst}
\newML{sep}{September}{september}
\newML{oct}{October}{október}
\newML{nov}{November}{nóvember}
\newML{dec}{December}{desember}


%% ---------------- Internal variables -----------------------------
\newcommand{\program}[1]{\renewcommand{\program@ruthesis}{#1}}
%% set date to today as needed
\newcommand{\whensignedday@ruthesis}{\the\day}
\newcommand{\whensignedyear@ruthesis}{\the\year}
\newcommand{\whensignedmonth@ruthesis}{\monthname}
\newcommand{\whensigned}[3]{
  \renewcommand{\whensignedday@ruthesis}{#1}
  \renewcommand{\whensignedmonth@ruthesis}{#2}
  \renewcommand{\whensignedyear@ruthesis}{#3}
}
\ifthenelse{\boolean{bachelors}}{
  \newcommand{\whensigned@ruthesis}{\whensignedyear@ruthesis}
}{
  \newcommand{\whensigned@ruthesis}{\whensignedmonth@ruthesis~\whensignedyear@ruthesis}
}

%% Defaults (with warnings)
%% This first set is used on the back cover, so we can't seem to use @ in the name
%%  So instead, we use \getVariable notation
%%     and we should probably refactor to \setVariable for the assignment
\newcommand{\Institution}{?INSTITUTION?\@warning{*** No institution set. ***}}
\newcommand{\InstitutionAddress}{?ADDRESS?\@warning{*** No address ***}}
\newcommand{\InstitutionPhone}{?PHONE?\@warning{*** No phone ***}}
\newcommand{\InstitutionURL}{?URL?\@warning{*** No URL ***}}
\newcommand{\Bookidnumber}{}

\newcommand{\title@ruthesis}{?TITLE?\@warning{*** No main title set. ***}}
\newcommand{\titleCover@ruthesis}{?TITLECOVER?\@warning{*** No cover title set. ***}}
\newcommand{\titlePaper@ruthesis}{?TITLEPAPER?\@warning{*** No paper title set. ***}}
\newcommand{\titleInternal@ruthesis}{?TITLEINTERNAL?\@warning{*** No internal title set. ***}}

\newcommand{\documenttype@ruthesis}{?DOCTYPE?\@warning{*** No Document Type ***}}
\newcommand{\ects@ruthesis}{?ECTS?\@warning{*** No ECTS set ***}}
\newcommand{\program@ruthesis}{?PROGRAM?\@warning{*** No Program. ***}}

\newcommand{\degreeabbrv@ruthesis}{?DEGREEABBRV?\@warning{*** No Degree abbrv. ***}}
\newcommand{\degreelong@ruthesis}{?DEGREE?\@warning{*** No Degree. ***}}


%% Accessor methods
\newcommand{\setInstitution}[1]{\renewcommand{\Institution}{#1}}
\newcommand{\setInstitutionAddress}[1]{\renewcommand{\InstitutionAddress}{#1}}
\newcommand{\setInstitutionPhone}[1]{\renewcommand{\InstitutionPhone}{#1}}
\newcommand{\setInstitutionURL}[1]{\renewcommand{\InstitutionURL}{\url{#1}}}
\newcommand{\bookidnumber}[1]{\renewcommand{\Bookidnumber}{#1\\}}
%% We need the newline because some documents don't have the ID

\newcommand{\degreeabbrv}[1]{\renewcommand{\degreeabbrv@ruthesis}{#1}}
\newcommand{\setDegreelong}[1]{\renewcommand{\degreelong@ruthesis}{#1}}

\newML{adddegree@ruthesis}{}{}  % default is blank
\newcommand{\adddegree}[2]{\renewML{adddegree@ruthesis}{#1}{#2}}

\newcommand{\setDocumentType}[1]{\renewcommand{\documenttype@ruthesis}{#1}}
\newcommand{\ects}[1]{\renewcommand{\ects@ruthesis}{#1}}

%% TODO: online and projectreport are related
\ifthenelse{\boolean{projectreport}}{
  \renewcommand{\documenttype@ruthesis}{Project report}
}{}%

\ifthenelse{\boolean{bachelors}}{%
  \degreeabbrv{\MLBScAbbrv}%
  \renewcommand{\documenttype@ruthesis}{\MLFinalReport}%
  \setDegreelong{\MLBSc}%
}{}%
\ifthenelse{\boolean{masters}}{%
  \degreeabbrv{\MLMScAbbrv}%
  \setDegreelong{\MLMSc}%
  \renewcommand{\documenttype@ruthesis}{Thesis}%
}{}%
\ifthenelse{\boolean{doctorate}}{%
  \setDegreelong{\MLPhd}
  \renewcommand{\documenttype@ruthesis}{Dissertation}%
  \degreeabbrv{\MLPhDAbbrv}%
}{}

%% Default is at RU
\setInstitution{\MLReykjavikUniversity}%
\newML{InstitutionAddress}{Menntavegur 1\\101 Reykjavík, Iceland}%
{Menntavegi 1\\101 Reykjavík, Ísland}%
\setInstitutionAddress{\MLInstitutionAddress}%
\newML{Tel}{Tel.}{Sími}%
\setInstitutionPhone{\MLTel{} +354 599 6200\\%
Fax +354 599 6201}%
\setInstitutionURL{www.ru.is}%

%% Some may need a different front logo
%% TODO: separate internal logo
\newcommand{\frontlogo@ruthesis}{ru-logo}
\newcommand{\setFrontLogo}[1]{\renewcommand{\frontlogo@ruthesis}{#1}}

\newcommand{\setTitle}[1]{%
  \setMainTitle{#1}
  \setTitleCover{#1}
  \setTitleInternal{#1}
}
\newcommand{\setMainTitle}[1]{\renewcommand{\title@ruthesis}{#1}}
\newcommand{\setTitleCover}[1]{\renewcommand{\titleCover@ruthesis}{\expandafter\MakeUppercase{#1}}}
\newcommand{\setTitleInternal}[1]{\renewcommand{\titleInternal@ruthesis}{#1}}

\def\abstract@ruthesis {??\@warning{*** No English abstract. ***}}
\newcommand{\setAbstract}[1]{\renewcommand{\abstract@ruthesis}{#1}}


\def\author#1{\def\and{, }
  \gdef\author@ruthesis{#1}
  \gdef\authorSignature@ruthesis{#1}
  \gdef\authorHeader@ruthesis{#1}
}
\def\setAuthorSignature#1{\gdef\authorSignature@ruthesis{#1}}
\def\setAuthorHeader#1{\gdef\authorHeader@ruthesis{#1}}
\def\author@ruthesis{??\@warning{***No author name.***}}

\def\ID@ruthesis{??\@warning{***No ID number.***}}
\newcommand{\setID}[1]{\renewcommand{\ID@ruthesis}{#1}}

\newcommand{\setSchool}[1]{
  \newcommand{\School}{#1}
  \newcommand{\School@ruthesis}{#1}
}

\newlength{\savedparindent}
\newcommand{\disableindents}{\setlength{\parindent}{0pt}}
\newcommand{\enableindents}{\setlength{\parindent}{\savedparindent}}

%% Clean up some formatting for the text
\renewcommand{\thepage}{\roman{page}}

%% Footnote adjustments. These are mostly unnecessary
% \let\footnoterule\relax \null % Turn off the footnote rule line
%\renewcommand{\thefootnote}{\scriptsize\arabic{footnote}} %to fix large footnote text errors in some documents

\renewcommand{\bibname}{Bibliography} %Renaming the bibliography section (if omitted it will be named "references")

%% ---------------------------------------------------------------------------------------------
%%  Setup the formatting at the beginning of the document (Front material)
%% TODO: use the memoir \frontmatter \mainmatter \backmatter
%%  See documentation, page 73


\AtBeginDocument{
  \frontmatter
  \setlength{\savedparindent}{\parindent}  % save the current parindent
  \SingleSpacing%
  % set language based upon the class setting
  \resetlanguage%
}

\ifdraft{\renewcommand{\clearforchapter}{\clearpage}}
  % waste less blank pages in draft mode
  % see p123 http://ctan.uib.no/macros/latex/contrib/memoir/memman.pdf

\newenvironment{cover}% commonalities for the cover material
{\thispagestyle{cover}%
\pagestyle{cover}%
  \clearforchapter% clear to chapter setting
  \disableindents%
  \titletextfont\SingleSpacing}%
{\setlength{\TPMargin}{0mm} %% margins inside the textblock
  \enableindents{}\newpage}%

\newenvironment{covernonum}% commonalities for the cover material
{\thispagestyle{empty}%
\pagestyle{empty}%
\thispagestyle{empty}%
  \clearforchapter% clear to chapter setting
  \disableindents%
  \titletextfont\SingleSpacing}%
{\setlength{\TPMargin}{0mm} %% margins inside the textblock
  \enableindents{}\newpage}%


\newcommand{\frontcover}{%% logic for which covers are used
  %% online or PhD (as a book) need a nice looking cover
  \ifthenelse{\boolean{projectreport}\or\boolean{online}\OR\boolean{doctorate}}{%
    \frontcovernowindow%
  }{%% MASTERS and BATCHELORS, not online uses the grey covers with the window
    \frontcoverwindow%
  }%
}%

%\RequirePackage{datetime}
%% allows us to generate monthnames, follows language setting
%% Unfortunately, it has a bug where desember becomes desember. (Reported by kaha@ru)
%% The package is status "obselete" and the new datetime2 package
%%   does not have any equivalent function.
%% Switched to doing date management manually using \ML macros.

%%%%%%%%%%%%%%%% MARGINS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% WARNING: memoir class has its own margin macros
%%    Do not use the geometry package unless you know what you are doing

%% The title page is not centered on the page on the covers with a window
%% This cover is cut when it is bound
%% Original dimensions: 297x210 mm (A4)
%% Cut dimensions: 293x206 mm, 2mm from top and bottom, 4mm from right

%% Geometry of the windows (holes) in the cover
\ifthenelse{\boolean{bachelors}}{%
  %% The window on the bachelors is in a different place and size!
  %% Tested with School of Law cover
  \newlength{\covermarginl}\setlength{\covermarginl}{41mm}%
  \newlength{\covermarginr}\setlength{\covermarginr}{45mm}%
  \newlength{\coverwindowwidth}\setlength{\coverwindowwidth}{124.5mm}%
  \newlength{\covermargint}\setlength{\covermargint}{159mm}%
  \newlength{\covermarginb}\setlength{\covermarginb}{62mm}%
  \newlength{\coverwindowheight}\setlength{\coverwindowheight}{74.5mm}%
}{%
  %% Masters cover has a more rounded shape
  \newlength{\covermarginl}\setlength{\covermarginl}{41.5mm}% actually 41, doing adjustment
  \newlength{\covermarginr}\setlength{\covermarginr}{45mm}%
  \newlength{\coverwindowwidth}\setlength{\coverwindowwidth}{124mm}%
  \newlength{\covermargint}\setlength{\covermargint}{160mm}%
  \newlength{\covermarginb}\setlength{\covermarginb}{63mm}%
  \newlength{\coverwindowheight}\setlength{\coverwindowheight}{74mm}%
}%
%% TODO: use the memoir stock vs text sizing to deal with bleeds
%% Don't put any of the calculated \setlengths earlier or you get errors.
\newlength{\trimright}
\setlength{\trimright}{\covermarginr-\covermarginl}
\newlength{\windowmargin}
\setlength{\windowmargin}{2mm}
\newlength{\coverwindowtextwidth}
\setlength{\coverwindowtextwidth}{\coverwindowwidth}
\newlength{\coverwindowtextheight}
\setlength{\coverwindowtextheight}{\coverwindowheight}
\addtolength{\coverwindowtextheight}{2\windowmargin}
%% I don't know why, but setting the TPmargin messes with the positioning
%% so we have to add the margin back in
\addtolength{\covermarginl}{\windowmargin}
\newlength{\pagecenterx}%
\setlength{\pagecenterx}{\stockwidth/2}
\newlength{\pagecentery}
\setlength{\pagecentery}{\stockheight/2}
\newlength{\windowcenterx}
\setlength{\windowcenterx}{\coverwindowwidth/2+\covermarginl}
\newlength{\windowcentery}
\setlength{\windowcentery}{\coverwindowheight/2+\covermargint}
\newlength{\covernowinmarginl}
\setlength{\covernowinmarginl}{30mm}

\setlength{\TPMargin}{0mm} %% margins inside the textblock*

\newcommand{\defaultmargins}{
  % \semiisopage
  \ifthenelse{\boolean{bachelors}}{
    % Template has 25mm margins except 10mm at bottom.
    % The 10cm doesn't make sense, so we set to an even 25mm
    \setlrmarginsandblock{25mm}{25mm}{*}
    % {left}{right}{ratio}, * for calculate

    \setulmarginsandblock{25mm}{25mm}{*}
    % {upper}{lower}{ratio} * for calculate
  }{  %% Non Bachlors
    % The MS word template uses even 25.4mm margins, this is not as good if is bound
    \setlrmarginsandblock{30mm}{25.4mm}{*}
    % {left}{right}{ratio}, * for calculate

    \setulmarginsandblock{25.4mm}{25.4mm}{*}
    % {upper}{lower}{ratio} * for calculate
  }
  \checkandfixthelayout% implement the margins
}
\defaultmargins{}  % this macro is in case something messes with the margins

%% Some debugging code to check length calculation.
\newcommand{\showlengths@ruthesis}{
  \uselengthunit{mm} % showlen package
  Lengths: (with round off error from floats)\\
  covermarginl:\printlength{\covermarginl}\\
  covermarginr:\printlength{\covermarginr}\\
  coverwindowwidth:\printlength{\coverwindowwidth}\\
  covermargint:\printlength{\covermargint}\\
  covermarginb:\printlength{\covermarginb}\\
  coverwindowheight:\printlength{\coverwindowheight}\\
  pagecenterx:\printlength{\pagecenterx}\\
  pagecentery:\printlength{\pagecentery}\\
  windowcenterx:\printlength{\windowcenterx}\\
  windowcentery:\printlength{\windowcentery}\\
  \\
  windowmargin:\printlength{\windowmargin}\\
  coverwindowtextheight:\printlength{\coverwindowtextheight}\\
  coverwindowtextwidth:\printlength{\coverwindowtextwidth}\\
  \\
  covernowinmarginl:\printlength{\covernowinmarginl}\\
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% DRAFT AND PROOF MARKS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\draftmark}{}
\newcommand{\draftbigmark}{}

\ifthenelse{\boolean{proof}}{
  \renewcommand{\draftmark}{{\color{blue}\textsc{Proof}}}{}
  \renewcommand{\draftbigmark}{{\color{blue}\warningfont{}*** \draftmark{} *** \\PLEASE DO NOT DISTRIBUTE\\}%
  }{}

}{}
\ifdraft{
  \renewcommand{\draftmark}{{\color{red}\textsc{Draft}}}{}
  \renewcommand{\draftbigmark}{{\color{red}\warningfont{}*** \draftmark{} *** \\PLEASE DO NOT DISTRIBUTE\\}%
  }{}
}


%% ----- PRINTED FRONT COVER ----------------------------------------------------------
%% This cover will be on the outside, not one that has a separate windowed cover
\newcommand{\frontcovernowindow}{
  \begin{covernonum}
    \setlength{\TPMargin}{0mm} %% margins inside the textblock*
    \sffamily
    \begin{textblock*}{\textwidth}[0.5,0.5](\pagecenterx,68mm)%
      {\centering\includegraphics[width=55mm]{\frontlogo@ruthesis}\\}%
    \end{textblock*}
    \begin{textblock*}{\textwidth}[0.5,0.5](\pagecenterx,170mm)%
      \begin{center}%
        \draftbigmark
      \end{center}%
    \end{textblock*}%
    %
    \setSingleSpace{1.8}\SingleSpacing%
    \begin{textblock*}{\textwidth}[0,0](\covernowinmarginl,120mm)%
      \textcolor{rugray}{\frontcovertitlefont\titleCover@ruthesis}\par%
      %% Originally title was forced uppercase, but no-one seems to have
      %%   noticed, so I'm removing it.
      %% The uppercase macros play very poorly with the multilingual, so that
      %%   would need to be reworked to put it back.
    \end{textblock*}%
    %
    \setSingleSpace{1.5}\SingleSpacing%
    \begin{textblock*}{\textwidth}[0,0](\covernowinmarginl,222mm)%
      \begin{minipage}{\textwidth}
        \textcolor{rugray}{
          \frontcovertitletext
          \textbf{\author@ruthesis}\\%
          \ifthenelse{\boolean{projectreport}}{\course@ruthesis}{\degreelong@ruthesis}\\%
          \whensigned@ruthesis\\%
          \School@ruthesis\\%
          \Institution%
        }\par
        \vspace*{5mm}
        \textcolor{rured}{
          \frontcovertitlefont
          \ifthenelse{\boolean{projectreport}}{}{\degreeabbrv@ruthesis{}} \documenttype@ruthesis
        }\par
        \vspace*{3mm}
        {\scriptsize\color{rugray}\Bookidnumber}%
      \end{minipage}
    \end{textblock*}
  \setSingleSpace{1.0}
  \end{covernonum}
  \newpage\quad%% I am not sure why we must put this to ensure that the covers don't overlap
  \newpage  % without this, page numbers show up.  Weird.
}

\newcommand{\DegreeAndDepartment@ruthesis}{\textbf{\degreelong@ruthesis{} (\degreeabbrv@ruthesis)  \MLin{} \program@ruthesis{}
    \MLadddegree@ruthesis}}

\newcommand{\placelogo@ruthesis}[2]{%
  \begin{textblock*}{\textwidth}[0.5,0.5](\windowcenterx,#1)%
    {\centering\includegraphics[width=#2]{\frontlogo@ruthesis}\\}%
  \end{textblock*}
}

%% ----- INTERNAL TITLE PAGE WITH COMMITTEE ---------------------------------------------------
%% TODO: make counter for supervisors in the very rare case that there
%%    is only one supervisor
\newcommand{\supervisors@ruthesis}{\item No Advisor}
\newcommand{\supervisors}[1]{\renewcommand{\supervisors@ruthesis}[1]{#1}}
\newcommand{\supervisorheading@ruthesis}{\MLSupervisor}
\newcommand{\setSupervisorHeading}[1]{\renewcommand{\supervisorheading@ruthesis}{#1}}

\newcommand{\examiners@ruthesis}{\item No Examiner}
\newcommand{\examiners}[1]{\renewcommand{\examiners@ruthesis}[1]{#1}}
\newcommand{\examinerheading@ruthesis}{%
  \ifthenelse{\boolean{yngvihack}}{\MLExaminingCommittee}{\MLExaminer}}
\newcommand{\setExaminerHeading}[1]{\renewcommand{\examinerheading@ruthesis}{#1}}

\newcommand{\personinfo}[5]{
  \item[]  #1, #2\\#3, #4, #5 %Stub to be customized later
}
% base definition, we redefine it when format changes

\newcommand{\internaltitlewithcommittee}{
  \begin{cover}
    \SingleSpacing%
    \begin{centering}
      \includegraphics[width=4cm]{ru-logo}\\
      \vspace{2\baselineskip}
      {\titletitlefont\titleInternal@ruthesis\\}%
      \vspace{2\baselineskip}
      {\titletextfont%
        \IfLanguageName{icelandic}{
          \ects@ruthesis{} ECTS eininga ritgerð lögð fram við \School@ruthesis{}\\
          \Institution{} til\\
          \ifthenelse{\boolean{doctorate}}{\textbf{\degreelong@ruthesis}}{
            \DegreeAndDepartment@ruthesis}\\
        }
        { % English mode
          \documenttype@ruthesis{} of \ects@ruthesis{} ECTS credits submitted to the \School@ruthesis\ \\%
          at \Institution{} in partial fulfillment of\\%
          the requirements for the degree of \\%
          \ifthenelse{\boolean{doctorate}}{\textbf{\degreelong@ruthesis}}{
          \DegreeAndDepartment@ruthesis}\\
        }
        \vspace{\baselineskip}
        \whensigned@ruthesis \\
      }
    \end{centering}
    \vfill
    %%\vspace{\baselineskip}
    {\sigtextfont%
      % change \personinfo to make the entries needed
      % Because this is inside a command, we escape the #1 as ##1
      \renewcommand{\personinfo}[5]{\item[]  ##1, ##2\\##3, ##4, ##5}
      \setlength{\pltopsep}{0.5\baselineskip}  % first/top space
      \setlength{\plparsep}{0.5\baselineskip} % space between entries
      \setlength{\plitemsep}{0.5\baselineskip} % space between lines
      \ifthenelse{\boolean{doctorate}}{
        \MLThesisCommittee{}:
        \begin{compactitem}[\hspace{10mm}]
          \supervisors@ruthesis{}
          \examiners@ruthesis{}
        \end{compactitem}
      }{%% anything except a doctorate separates them
        \ifthenelse{\boolean{yngvihack}}{
          %% HACK FOR YNGVI, TEMPORARY
          \vspace{\baselineskip}
          \examinerheading@ruthesis:
          \begin{compactitem}[\hspace{10mm}]
            \supervisors@ruthesis{}
            \examiners@ruthesis{}
          \end{compactitem}
        }{
          \supervisorheading@ruthesis:
          \begin{compactitem}[\hspace{10mm}]
            \supervisors@ruthesis{}
          \end{compactitem}
          \vspace{\baselineskip}
          \examinerheading@ruthesis:
          \begin{compactitem}[\hspace{10mm}]
            \examiners@ruthesis{}
          \end{compactitem}
        }
      }
  } % end sigtextfont
  \end{cover}
}


%% ----- TITLE PAGE (FOR WINDOWED COVER) ------------------------------------------------------------------------
\newcommand{\TitleWindow@ruthesis}{
  \begin{centering}
    {\titletextfont%
      {\titletitlefont\titleCover@ruthesis\\}
      \vspace{\baselineskip}
      \author@ruthesis\\
      \vspace{\baselineskip}
      \TitleWindowText@ruthesis\\
      \vspace{0.75\baselineskip}
      \whensigned@ruthesis{}\\
    }
  \end{centering}
}

%% The Bachelors thesis has a slightly different format, not sure why.
\ifthenelse{\boolean{bachelors}}{
  \renewcommand{\TitleWindow@ruthesis}{
    \begin{centering}
      {\titletextfont%
        {\titletitlefont\titleCover@ruthesis\\}
        \vspace{0.5\baselineskip}
        \author@ruthesis\\
        \vspace{1.2\baselineskip}
        {\titletitlefont%
          \documenttype@ruthesis{} \MLin{} \program@ruthesis{} \degreeabbrv@ruthesis\\
        }
        \vspace{0.75\baselineskip}
        \whensigned@ruthesis{}\\
      }
    \end{centering}
  }
}{}
\newML{gotECTS}{of \ects@ruthesis{} ECTS credits}{\ects@ruthesis{} ECTS eininga ritgerð til}
\newcommand{\TitleWindowText@ruthesis}{\documenttype@ruthesis{} \MLgotECTS{}\\
  \DegreeAndDepartment@ruthesis}%

\ifthenelse{\boolean{projectreport}}{\renewcommand{\TitleWindowText@ruthesis}{\documenttype@ruthesis{}}}{}

\newcommand{\frontcoverwindow}{
  \setlength{\TPMargin}{0mm}%% margins inside the textblock*
  \begin{covernonum}%
    \ifthenelse{\boolean{bachelors}}{\placelogo@ruthesis{46mm}{44mm}%
    }{\placelogo@ruthesis{80mm}{95mm}}%
    \begin{textblock*}{\textwidth}[0.5,0.5](\windowcenterx,15cm)%
      \begin{centering}
      \draftbigmark
      \end{centering}
    \end{textblock*}%
    % Thesis window is not centered!
    % which means we needed to calculate how best to place the text
    %
    % The rest of the format depends upon bachelors or not

    % We don't know what the size the title is limited to, assume cover windowwidth
    \setlength{\TPMargin}{\windowmargin} %% margins inside the textblock*
      \begin{textblock*}{\coverwindowtextwidth}[0.5,0.5](\windowcenterx,\windowcentery)%
        \TitleWindow@ruthesis%
      \end{textblock*}

      \ifthenelse{\boolean{bachelors}}{
        \renewcommand{\personinfo}[5]{ &##1\\}
        \quad
        \vfill%
        {\titleinfofont%
          \noindent%
          \begin{tabular}{ll}
            \MLName{}: &\author@ruthesis\\
            \MLID{}: &\ID@ruthesis\\
            \MLSupervisor{}: \supervisors@ruthesis{}\\
          \end{tabular}

          \begin{tabular}{l}
            \IfLanguageName{icelandic}{ % put the name in the right order
            \School@ruthesis[icelandic]\\
            \School@ruthesis[english]
            }
            { % english
            \School@ruthesis[english]\\
            \School@ruthesis[icelandic]\\
            }
            \\ % blank line on the template
          \end{tabular}
        }
      }{\quad} % Not bachelors, need a space to ensure that we go to next page
      \setlength{\TPMargin}{0mm}%%reset
    \end{covernonum}
    \clearpage
    \ifthenelse{\boolean{debug}}{
      \showlengths@ruthesis%
      \newpage
    }{}
}

%% Smart inclusion of required pages, mostly about BSc
\newcommand{\semester@ruthesis}{\the\year--1}
\newcommand{\setSemester}[1]{\renewcommand{\semester@ruthesis}{#1}}
\newcommand{\course@ruthesis}{**NO COURSE SET**}
\newcommand{\setCourse}[1]{\renewcommand{\course@ruthesis}{#1}}
\newcommand{\organization@ruthesis}{**NO ORGANIZATION SET**}
\newcommand{\setOrganization}[1]{\renewcommand{\organization@ruthesis}{#1}}
\newcommand{\subprogram@ruthesis}{**NO SUBPROGRAM SET**}
\newcommand{\setSubProgram}[1]{\renewcommand{\subprogram@ruthesis}{#1}}
%% spacing of blanks in mm (with 2mm margin)
%% Y=42,62,87,122,141,161,192,217,237
%% X=31,96,141
\newlength{\formfirstcol}\setlength{\formfirstcol}{31mm}
\newlength{\formsecondcol}\setlength{\formsecondcol}{66mm}
\newlength{\formthirdcol}\setlength{\formthirdcol}{96mm}
\newlength{\formfourthcol}\setlength{\formfourthcol}{141mm}
%% \placetext{Text}{width}{X}[Y]  % X and Y have defaults
\DeclareDocumentCommand{\placeformtext}{mmG{\formfirstcol}O{42mm}}
{\begin{textblock*}{#2}[0,1](#3,#4)#1\end{textblock*}}
\newcommand{\frontrequiredpages}{
  \ifthenelse{\boolean{bachelors}}{
    \begin{covernonum}
      %title
      \placeformtext{\titleCover@ruthesis}{105mm}[42mm]
      % degree program
      \placeformtext{\program@ruthesis~\degreeabbrv@ruthesis}{84mm}[62mm]
      % description
      \placeformtext{\documenttype@ruthesis~\MLin{}~\subprogram@ruthesis~\degreeabbrv@ruthesis}{84mm}{\formthirdcol}[62mm]
      % semester
      \placeformtext{\semester@ruthesis}{29mm}[87mm]
      % course
      \placeformtext{\course@ruthesis}{24mm}{\formsecondcol-2mm}[87mm]

      %author
      \placeformtext{\author@ruthesis}{59mm}[110mm]

      \renewcommand{\personinfo}[5]{##1}
      %primary advisor
      \placeformtext{\supervisors@ruthesis{}}{82mm}[161mm]
      %secondary advisor
      \placeformtext{\examiners@ruthesis{}}{82mm}[141mm]
      % organization (of secondary)
      \begin{textblock*}{82mm}[0,0](\formfirstcol,177mm)
        \organization@ruthesis
      \end{textblock*}
      %% Date
      \placeformtext{\whensignedday@ruthesis~\whensignedmonth@ruthesis~\whensignedyear@ruthesis}
      {24mm}[215mm]

      %% The abstract is put on this page
      \begin{textblock*}{83mm}[0,0](\formthirdcol,83mm)
        \abstract@ruthesis
      \end{textblock*}
    \includepdf[pagecommand=\thispagestyle{empty}]{BSc-Lykilsida}
    \end{covernonum}
    %\clearforchapter{}
  }{}
  %% projectreport doesn't need most of these pages
  \ifthenelse{\boolean{projectreport}}{
    \abstractpage{}
  }

  \ifthenelse{\boolean{bachelors}\or\boolean{projectreport}}{}
  {
    %% Bachelors do not need a lot of these elements
    \internaltitlewithcommittee{} %RUM: "Front page (standard format)"
    \copyrightpage{} %%RUM: Not mentioned
    \abstractpage{} %%RUM: "Abstract (in English and Icelandic)
    \signaturepage{} %%RUM: "Signature page (standard format)
  }
  \notbscfonts{}%Go back to normal fonts after the front cover
  \archivesigpage{} %%RUM: Not mentioned, optional, but should be required
}


%% ----- COPYRIGHT PAGE -----------------------------------------------------------------------
\newcommand{\copyrightpage}{
  \begin{cover}
    \begin{vplace}[1.0] % ratio of space above and below
      \centering
      \OnehalfSpacing%
      \MLCopyright\\
      \author@ruthesis\\
      \whensigned@ruthesis\\
      \selectlanguage{icelandic}
    \end{vplace}
  \end{cover}
}
%% ----- SIGNATURE PAGE, ONLY THESIS -----------------------------------------------------

\newlength{\signaturey}
\setlength{\signaturey}{8mm}
\newlength{\signaturex}
\setlength{\signaturex}{100mm}

\newcommand{\signaturepage}{
  \ifthenelse{\boolean{masters}\or\boolean{doctorate}}{
    \begin{cover}
      \ifthenelse{\boolean{doctorate}}{ % Doctorate has different style and roles
        \IfLanguageName{icelandic}{
          ***Icelandic legal agreement needed!***
        }{
          The undersigned hereby certify that they recommend to the
          \School@ruthesis at \Institution{} for acceptance this
          \documenttype@ruthesis{} entitled \textbf{\title@ruthesis}
          submitted by \textbf{\authorSignature@ruthesis{}} in partial fulfillment
          of the requirements for the degree of
          \DegreeAndDepartment@ruthesis%
        }
        %\vspace*{25mm}
        \newcommand{\signline}[2]{\item \hdashrule{##2}{1pt}{1pt}\\##1}
        \renewcommand{\personinfo}[5]{\item\hdashrule{\signaturex}{1pt}{1pt}\\##1, ##2\\##3, ##4, ##5\\\vspace{\signaturey}\\}
        \setlength{\pltopsep}{2\baselineskip}  % first/top space
        \setlength{\plparsep}{2\baselineskip} % space between entries
        \setlength{\plitemsep}{0.5\baselineskip} % space between lines
        \begin{compactitem}[]
        \signline{\MLdate}{50mm}
        \supervisors@ruthesis{}
        \examiners@ruthesis{}
        \end{compactitem}
      %\end{minipage} \\ \par% need \par for ending the paragraph

      }
      {% Masters
        {\centering
          {\titletitlefont\titleInternal@ruthesis{}\\}
          {\titletextfont%
            \vspace{\baselineskip}
            \authorSignature@ruthesis\\
            \vspace{\baselineskip}
            \IfLanguageName{icelandic}{
              \ects@ruthesis{} ECTS eininga ritgerð lögð fram við \School@ruthesis\\
              %% Uh oh.  Declination means that we can't use general macros for the
              %% Icelandic in some places--foley
              Háskólans í Reykjavík til\\
              \DegreeAndDepartment@ruthesis{}
            }
            {
              \documenttype@ruthesis{} of \ects@ruthesis{} ECTS credits submitted to the \School@ruthesis\ \\%
              at \Institution{} in partial fulfillment of\\%
              the requirements for the degree of \\%
              \DegreeAndDepartment@ruthesis{}
            }
            % \vspace{\baselineskip}
            \vfil
            \whensigned@ruthesis \\
            \vfil
            % \vspace{\baselineskip}
          }
        }
      % Space for the signatures
      {\sigtextfont%
        % change \personinfo to make the entries needed
        % Because this is inside a command, we escape the #1 as ##1
        \renewcommand{\personinfo}[5]{&\hdashrule{\signaturex}{1pt}{1pt}\\&##1\\\vspace{\signaturey}\\}
        \begin{tabular}{lll}
          \MLStudent:\\
          \personinfo{\author@ruthesis}{}{}{}{}\\
          \ifthenelse{\boolean{yngvihack}}{
          \examinerheading@ruthesis:\\
          \supervisors@ruthesis{}
          \examiners@ruthesis{}
          }{
          \supervisorheading@ruthesis:\\
          \supervisors@ruthesis{}\\
          \MLExaminer:\\
          \examiners@ruthesis{}
          }
        \end{tabular}
      }% end sigtextfont

      } % end if oldcs

    \end{cover}
  }{}
}


%% ----- ARCHIVAL SIGNATURE, ONLY THESIS ----------------------------------------------------
%% TODO:  Icelandic translation?
\newcommand{\archivesigpage}{
  \ifthenelse{\boolean{bachelors}\or\boolean{masters}\or\boolean{doctorate}}{
    \begin{cover}
      The undersigned hereby grants permission to
      the \Institution{} Library to reproduce single
      copies of this \documenttype@ruthesis{} entitled \textbf{\title@ruthesis{}}
      and to lend or sell such copies for private, scholarly or
      scientific research purposes only.

      The author reserves all other publication and
      other rights in association with the copyright in the
      \documenttype@ruthesis{}, and
      except as herein before provided, neither the
      \documenttype@ruthesis{} nor
      any substantial portion thereof may be printed or otherwise
      reproduced in any material form whatsoever without the
      author's prior written permission.

      \vspace*{25mm}
      \newcommand{\signline}[2]{\item \hdashrule{##2}{1pt}{1pt}\\##1}
      \setlength{\pltopsep}{2\baselineskip}  % first/top space
      \setlength{\plparsep}{2\baselineskip} % space between entries
      \setlength{\plitemsep}{0.5\baselineskip} % space between lines
      \begin{compactitem}[]
        \signline{\MLdate}{50mm}
        \signline{\author@ruthesis \\ \degreelong@ruthesis}{0.75\textwidth}
      \end{compactitem}
    \end{cover}
  }{}
}


%% ----- TITLE AND ABSTRACT ----------------------------------------------
%% Depending upon the selected language, one of the abstracts appears first
\newcommand{\abstractpage}{
  \ifthenelse{\boolean{icelandic}}{
    % icelandic mode, the Icelandic abstract comes first
    \abstractpagetemplate{icelandic}
    \abstractpagetemplate{english}
  }
  {
    \abstractpagetemplate{english}
    \abstractpagetemplate{icelandic}
  }
}

%% create an abstract template to minimize typing and increase
%% consistency
\newcommand{\abstractpagetemplate}[1]{
  \selectlanguage{#1}
  \begin{cover}%
    \vspace*{20mm}%
    \begin{center}%
      \begin{minipage}{0.90\textwidth}%
        {\centering%
          {\titletitlefont\title@ruthesis\\}%%
          \vspace{\baselineskip}
          \author@ruthesis\\%
          \vspace{\baselineskip}
          \whensigned@ruthesis\\%
        }%
        \par\vspace*{2\baselineskip}%
        \textbf{\MLAbstract}\par\vspace{1ex}%
        \abstract@ruthesis\par%
      \end{minipage}%
    \end{center}%
  \end{cover}%

 \resetlanguage%
}

%% ----- DEDICATIONS ---------- ---------------------------------------------------------------
\newenvironment{dedications}{\begin{cover}\begin{vplace}[0.33]% ratio of space above and below
      \begin{center}\em}
      {\end{center}\normalfont\end{vplace}\end{cover}}



%% ----- END OF FRONT MATERIALS ---------------------------------------------------------------
\RequirePackage{stackengine}
%% ---------------------------------------------------------------------------------------------
%% This command makes the back-cover materials
\newcommand{\backcover}{%
  \thispagestyle{empty}%
  \pagestyle{empty}%
  \cleartoevenpage{}% clear to chapter setting
  \disableindents%
  \titletextfont\SingleSpacing%
  \vplace[0.8]{
    {\centering
      \belowbaseline[-\normaltextsize]{
        \includegraphics[width=4cm]{ru-logo}
      }
      \quad
      \begin{minipage}[t]{10cm}%
        {\titletextfont\textcolor{rugray}{%
            \School\\
            \Institution\\
            \InstitutionAddress\\
            \InstitutionPhone\\
            \InstitutionURL\\  %% NO \\, it is in the ID macro
            \Bookidnumber%
          }
        }
      \end{minipage}\\%
    }
  }
  \setlength{\TPMargin}{0mm}%% margins inside the textblock
  \enableindents{}%
}

%% ----- END OF BACK MATERIALS ---------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  HEADERS AND FOOTERS
%% with this we ensure that the chapter and section
%% headings are in lowercase.
%\renewcommand{\chaptermark}[1]{\markboth{\thechapter\ #1}{}}
%\renewcommand{\sectionmark}[1]{\markright{\thesection\ #1}}

\makepagestyle{cover}  % we put the page number on the back to be less visually distracting
\makeoddfoot{cover}{}{}{}
\makeevenfoot{cover}{}{\thepage}{}

%% from the old cs template, if so desired
\makepagestyle{oldstyle}
\makeoddhead{oldstyle}{\footnotesize{\authorHeader@ruthesis}}{}{\footnotesize{\thepage}}
\makeevenhead{oldstyle}{\footnotesize{\thepage}}{}{\footnotesize{\title@ruthesis}}

%% The official guidelines say to put the page in the middle bottom, but
%% that was clearly written for the MS Word users.

%% Comprehensive list of styles for memoir is in 7.2 (page 106)
%% If you need to adjust the style on the chapters, modify chapter
%% predefined styles:
%% empty: no header nor fotter
%% plain: page num in bot center
%% siple:  pagenum and marks on top outer edges
%\makeoddhead{chapter}{}{}{} %to change only one side

\copypagestyle{book}{plain}
\copypagestyle{chapter}{empty}
\copypagestyle{cleared}{plain}
\copypagestyle{part}{simple}
\copypagestyle{title}{plain}
\copypagestyle{titlinpage}{empty}

%% If we are in draft or proof mode, make a mark saying so
\ifthenelse{\boolean{fakedraft}\OR\boolean{proof}}{
  \makeoddfoot{cover}{}{}{\draftmark}
  \makeevenfoot{cover}{\draftmark}{}{}
  \makeoddfoot{plain}{}{}{\draftmark}
  \makeevenfoot{plain}{\draftmark}{}{}
  \makeoddfoot{simple}{}{}{\draftmark}
  \makeevenfoot{simple}{\draftmark}{}{}
  \makeoddfoot{empty}{}{}{\draftmark}
  \makeevenfoot{empty}{\draftmark}{}{}
}{}

\newcommand{\coverchapter}[1]{\clearforchapter\chapter{#1}\thispagestyle{cover}}
\newcommand{\newtoclist}[1]{\chapter{List of #1}}
\newcommand{\thesislistoffigures}{\clearforchapter\listoffigures}
\newcommand{\thesislistoftables}{\clearforchapter\listoftables}

%%% Section numbering and the Table of Contents
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
\maxsecnumdepth{subsubsection}  % default by \mainmatter in preamble
%\setsecnumdepth{subsubsection}  % can be changed later
\maxtocdepth{subsubsection}  % default by \mainmatter in preamble
%\settocdepth{subsubsection}  % can be changed later

%% FORMATTING FOR TABLES
\newcommand{\starttables}{
%% Tables should just have simple formatting: pagenum in corners
    \clearforchapter%
    \copypagestyle{chapter}{simple}
    \copypagestyle{cleared}{simple}
    \pagestyle{simple}
}

\newcommand{\InputIfExists}[1]{\IfFileExists{#1}{\input{#1}}{}}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FORMAT OF THE NORMAL TEXT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\def\starttext{% this ends the front material and starts the document
  \mainmatter% which does a \cleartorecto
  \pagestyle{headings}

  \copypagestyle{cleared}{simple}
  % move pagenum to corner from center
  \ifthenelse{\boolean{oldstyle}}{
    \copypagestyle{headings}{oldstyle}
  }{}
  \ifdraft{\DoubleSpacing}{}%% if draft, need room to write comments

}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TWEAKS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Some adjustments to float placement
\setcounter{topnumber}{5} \def\topfraction{1} \setcounter{bottomnumber}{4}
\def\bottomfraction{1} \setcounter{totalnumber}{10} \def\textfraction{0}
\def\floatpagefraction{.5}

%\def\@makefnmark{\rlap{\@textsuperscript{\@thefnmark}}}
%% Not sure why there was a footnote adjustment on the cover
%% Disabling for now.

%% Penalties for various text placement issues
\clubpenalty=10000  %% orphan lines
\widowpenalty=10000 %% widow lines
\hfuzz=1pt %% avoid overfilled hboxes
\vfuzz=5pt %% avoid overfilled vboxes

\newcommand{\draftnote}[1]{\ifdraft{{\color{gray}#1}}}

\AtEndDocument{
\typeout{*******************************************************************}
\typeout{Make sure you print this at 100\% scaling on A4 paper.}
\typeout{This is not the default on many computers, so watch out!}
\typeout{Any adjustment to the size will mess up margins and text alignment.}
\typeout{If you are using a cover, check alignment with the left edge before}
\typeout{giving it to the binders.}
\typeout{*******************************************************************}
\typeout{}
}

%%% Local Variables:
%%% mode: latex
%%% TeX-master: "msc-tannock-2016"
%%% TeX-engine: default
%%% End:

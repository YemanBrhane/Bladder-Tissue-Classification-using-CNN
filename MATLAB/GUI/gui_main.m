
%=========================================================================
%  Implemented by     BY: YEMAN BRHANE HAGOS:
%  Bladder Structure Classification Using Convolutional Neural Network Graphical User Interface                         
%=========================================================================


clc;
close all;
clear;

%% ******************** CREATE fIGURE ****************************************
screensize = get( groot, 'Screensize' );
Wf = screensize(3)-200;
Hf = screensize(4)-100;

F= figure('Position',[50 50 Wf Hf],'Name','','menubar','none',...
		'resize','off','NumberTitle','off');

Background=get(F,'Color');




%% TITLE
Title= uicontrol('parent',F,'Style','text','Position',[20 Hf-60 Wf 50],...
		'string','Automatic Bladder Structure Classification Using CNN', 'background', Background ,...
		'horizontalAlignment','center', 'FontSize',18,'FontWeight','bold');

%% Panels

% FOR BUTTONS
WP1 = 300;
WP2 = Wf-WP1;
HP = Hf-80 ;
buttons_panel = uipanel('parent',F,'Title','','FontSize',12,...
				'BackgroundColor',Background,...
				'units','pixel','Position',[0 0 WP1 HP]);

% FOR AXES: image display
image_display_panel= uipanel('parent',F,'Title','','FontSize',12,...
					'BackgroundColor',Background,...
					'units','pixel','Position',[300 0 WP2 HP]);

%% Button Groups
X=50;
W=220;
H=60;
gap=40;
text1='Input';

LoadImage=uicontrol('parent',buttons_panel,'string','Load Image','callback',...
				[
					'Input_im=Load_image(display);'...
					'subplot(Axes1);'...
					'imshow(Input_im,[]);'...
				],'FontSize',18, 'Position',[X HP-0.2*HP W H]);


classify=uicontrol('parent',buttons_panel,'string','Classify Image','callback',...
				[
					'output = BladderStructureClassify(Input_im, display);',...
					'subplot(Axes2);'...
					'imshow(output, [])'...
				],'FontSize',18,'Position',[X HP-0.5*HP W H]);


%% Display
Background=get(buttons_panel,'backgroundColor');
label= uicontrol('parent',buttons_panel,'Style','text','Position',[X 170 W 30],...
				'string','Status', 'background', [0.5 0.5 0.5],'horizontalAlignment','center', 'FontSize',12); % create a listbox object
display = uicontrol('parent',buttons_panel,'Style','text','Position',[X 20 W 150],...
				'min',0,'max',2,'enable','inactive','background', [0.8 0.8 0.9],'horizontalAlignment','left','FontSize',12); % create a listbox object

set(display,'string',{});




%% *********** AXES TO DISPLAY images *****************

WAxis = WP2/2-10;

Axes1=axes('parent',image_display_panel,'units','pixel','position',[20,5,WAxis,HP-50],'Box','off');

Axes1.XTick=[]; Axes1.YTick=[];

Axes2=axes('parent',image_display_panel,'units','pixel','position',[WP2/2,5,WAxis,HP-50],'Box','off');
Axes2.XTick=[]; Axes2.YTick=[];
set(Axes1, 'box','off','XTickLabel',[],'XTick',[],'YTickLabel',[],'YTick',[])



%% *********** AXES Titles *****************

axi_title1= uicontrol('parent',image_display_panel,'Style','text','Position',[WAxis/2-50 HP-40 150 30],...
			'string','Input Image', 'background', Background ,...
			'horizontalAlignment','center', 'FontSize',18,'FontWeight','bold');


axi_title2= uicontrol('parent',image_display_panel,'Style','text','Position',[1.5*WAxis-50 HP-40 150 30],...
			'string','Output Image', 'background', Background ,...
			'horizontalAlignment','center', 'FontSize',18,'FontWeight','bold');




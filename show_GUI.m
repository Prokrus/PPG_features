function varargout = show_GUI(varargin)
% SHOW_GUI MATLAB code for show_GUI.fig
%      SHOW_GUI, by itself, creates a new SHOW_GUI or raises the existing
%      singleton*.
%
%      H = SHOW_GUI returns the handle to a new SHOW_GUI or the handle to
%      the existing singleton*.
%
%      SHOW_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SHOW_GUI.M with the given input arguments.
%
%      SHOW_GUI('Property','Value',...) creates a new SHOW_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before show_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to show_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help show_GUI

% Last Modified by GUIDE v2.5 05-Apr-2017 11:47:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @show_GUI_OpeningFcn, ...
    'gui_OutputFcn',  @show_GUI_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before show_GUI is made visible.
function show_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to show_GUI (see VARARGIN)

% Choose default command line output for show_GUI
handles.output = hObject;
handles.seg = evalin('base','ppgSeg');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes show_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = show_GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
%sliderValue = get(handles.slider1,'Value');
%set(handles.slider1,'Value',sliderValue);
Seg=evalin('base','ppgSeg');
ppgt=evalin('base','ppgt');
ppgs=evalin('base','ppgs');
ppg_processed=evalin('base','ppgs_preprocess');
interval=evalin('base','interval');

sliderValue = get(handles.slider1,'Value');
ang = int32(sliderValue);
set(handles.slider1,'Value',ang);

set(handles.edit1,'string',num2str(get(hObject,'value')));% show the current index
axes(handles.axes1);
plot(handles.axes1,Seg(ang).t,Seg(ang).s);
title('one pulse of processed PPG');
xlabel('time/s');
ylabel('magnitude');
grid on;


index=get(hObject,'value');

axes(handles.axes2);
begt=Seg(max(index-5,1)).t(1);
begi=find(ppgt==begt);
endt=Seg(min(index+5,end)).t(end);
endi=find(ppgt==endt);
plot(ppgt(begi:endi),ppgs(begi:endi));
hold on;
beg1=find(ppgt==Seg(index).t(1));
end1=find(ppgt==Seg(index).t(end));
area(ppgt(beg1:end1),ppgs(beg1:end1),'facecolor','r');
hold off;
title('original ppg signal around current pulse');
xlabel('time/s');
ylabel('magnitude');
grid on;

axes(handles.axes3);
plot(ppgt(begi:endi),ppg_processed(begi:endi));
hold on;
area(ppgt(beg1:end1),ppg_processed(beg1:end1),'facecolor','r');
hold off;


% orit=[Seg(max(index-10,1):min(index+10,end)).t];
% oris=[Seg(max(index-10,1):min(index+10,end)).s];
% plot(orit,oris);
title('processced ppg signal around current pulse');
xlabel('time/s');
ylabel('magnitude');
grid on;

axes(handles.axes1);

%get augmentation index
[m, p]=max(Seg(index).s);
minv = min(Seg(index).s);
h=(m-minv)*0.1+minv;
[v,i]=findpeaks(Seg(index).s(p+1:end),'MinPeakHeight',h);
i=i+p;
if ~isempty(v)
    augmentation_index=(v(1)-minv)/(m-minv);
    
else
    augmentation_index=nan;
end
set(handles.edit9,'string',num2str(augmentation_index));

onoff1=get(handles.radiobutton1,'value');
if onoff1
    line([Seg(index).t(1),Seg(index).t(end)],[m,m],'LineStyle','--','Color','r');
    line([Seg(index).t(1),Seg(index).t(end)],[minv,minv],'LineStyle','--','Color','r');
    line([Seg(index).t(p),Seg(index).t(p)],[minv,m],'LineStyle','--','Color','r');
    text(Seg(index).t(p)-0.1,(m-minv)*0.5+minv,'a \rightarrow');
    text('Units','normalized','Position',[0.7,0.8],'String','AI = b/a');
    hold on;
    scatter(Seg(index).t(p),m,'r');
    if ~isempty(v)
        line([Seg(index).t(i),Seg(index).t(i)],[minv,v(1)],'LineStyle','--','Color','r');
        line([Seg(index).t(p),Seg(index).t(i)],[v(1),v(1)],'LineStyle','--','Color','r');
        text(Seg(index).t(i(1))+0.03,(v(1)-minv)*0.5+minv,'\leftarrow b');
        hold on;
        scatter(Seg(index).t(i(1)),v(1),'r');
        hold off;
    end
    hold off;
    
    %second deritive of ppg
    ppg2deritive=diff(diff(Seg(index).s));
    t2deritive=Seg(index).t(1:end-2);
    axes(handles.axes4);
    plot(t2deritive,ppg2deritive);
    title('second deritive of this pulse');
    xlabel('time/s');
    ylabel('magnitude');
    grid on;
    [peaks2,loc2]=findpeaks(ppg2deritive);
    [peaks2_,loc2_] = findpeaks(-ppg2deritive);
    
    hold on;
    scatter(t2deritive(loc2),peaks2);
    hold on;
    scatter(t2deritive(loc2_),-peaks2_);
    line([t2deritive(loc2),t2deritive(loc2_);t2deritive(loc2),t2deritive(loc2_)],[zeros(1,length(loc2)+length(loc2_));peaks2,-peaks2_],'LineStyle','--','Color','r');
    hold off;
end

%get Time Delay
[m, p]=max(Seg(index).s);
[v,i]=findpeaks(Seg(index).s(p+1:end),'MinPeakHeight',(m-min(Seg(index).s))*0.1+min(Seg(index).s));
i=i+p;
if ~isempty(v)
    TimeDelay=Seg(index).t(i(1))-Seg(index).t(p);
else
    TimeDelay=nan;
end
set(handles.edit10,'string',num2str(TimeDelay));

onoff2=get(handles.radiobutton2,'value');
if onoff2
    line([Seg(index).t(p),Seg(index).t(p)],[min(Seg(index).s),m],'LineStyle','--','Color','r');
    line([Seg(index).t(1),Seg(index).t(end)],[minv,minv],'LineStyle','--','Color','r');
text(Seg(index).t(p),minv-0.1,'t1');
text('Units','normalized','Position',[0.7,0.8],'String','TD = t2-t1');
    hold on;
    scatter(Seg(index).t(p),m,'r');
    if ~isempty(v)
        line([Seg(index).t(i),Seg(index).t(i)],[min(Seg(index).s),v(1)],'LineStyle','--','Color','r');
            text(Seg(index).t(i(1)),minv-0.1,'t2');
        hold on;
        scatter(Seg(index).t(i(1)),v(1),'r');
        hold off;
    end
    hold off;
end

%get systolic amplitude
[m,p]=max(Seg(index).s);
SystolicAmplitude=m-Seg(index).s(1);
set(handles.edit11,'string',num2str(SystolicAmplitude));

onoff3=get(handles.radiobutton3,'value');
if onoff3
    line([Seg(index).t(1),Seg(index).t(p)],[Seg(index).s(1),Seg(index).s(1)],'LineStyle','--','Color','r');
    line([Seg(index).t(p),Seg(index).t(p)],[Seg(index).s(1),m],'LineStyle','--','Color','r');
    text(Seg(index).t(p)+0.03,(m-Seg(index).s(1))*0.5+Seg(index).s(1),'\leftarrow a');
text('Units','normalized','Position',[0.7,0.8],'String','SA = a');
    hold on
    scatter([Seg(index).t(1),Seg(index).t(p)],[Seg(index).s(1),m],'r');
    hold off
end

%get Pulse Width
[m,p]=max(Seg(index).s);
mid=(m+min(Seg(index).s))/2;%mid punkt finden
x=interp1(Seg(index).s(1:p),Seg(index).t(1:p),mid);
y=interp1(Seg(index).s(p+1:end),Seg(index).t(p+1:end),mid);
PW=y-x;%pulsewidth
set(handles.edit12,'string',num2str(PW));

onoff4=get(handles.radiobutton4,'value');
if onoff4
    line([x,x],[min(Seg(index).s),mid],'LineStyle','--','Color','r');
    line([y,y],[min(Seg(index).s),mid],'LineStyle','--','Color','r');
    line([Seg(index).t(1),Seg(index).t(end)],[min(Seg(index).s),min(Seg(index).s)],'LineStyle','--','Color','r');
    text(x,minv-0.1,'t1');
text(y,minv-0.1,'t2');
text('Units','normalized','Position',[0.7,0.8],'String','PW = t2-t1');
    hold on;
    scatter([x,y],[mid,mid],'r');
    hold off;
end

%get Half Rise to Dicrotic Notch(HRDN)
[~,p]=max(diff(Seg(index).s));
[~,minP]=findpeaks(-Seg(index).s(p+1:round(0.9*end)));
if ~isempty(minP)
    minP(1)=minP(1)+p;
    HRDN=Seg(index).t(minP(1))-Seg(index).t(p);
else
    HRDN=nan;
end
set(handles.edit13,'string',num2str(HRDN));

onoff5=get(handles.radiobutton5,'value');
if onoff5
    line([Seg(index).t(p),Seg(index).t(p)],[min(Seg(index).s),Seg(index).s(p)],'LineStyle','--','Color','r');
    line([Seg(index).t(1),Seg(index).t(end)],[min(Seg(index).s),min(Seg(index).s)],'LineStyle','--','Color','r');
    text(Seg(index).t(p),minv-0.1,'t1');
    text('Units','normalized','Position',[0.65,0.8],'String','HRDN = t2-t1');
    hold on;
    scatter(Seg(index).t(p),Seg(index).s(p),'r');
    if ~isempty(minP)
        line([Seg(index).t(minP(1)),Seg(index).t(minP(1))],[min(Seg(index).s),Seg(index).s(minP(1))],'LineStyle','--','Color','r');
        text(Seg(index).t(minP(1)),minv-0.1,'t2');
        hold on;
        scatter(Seg(index).t(minP(1)),Seg(index).s(minP(1)),'r');
        hold off;
    end
    hold off;
end

%get Inflection point area ratio(IPA)
[~,minP]=findpeaks(-Seg(index).s(1:round(0.9*end)));
if ~isempty(minP)
    A1=trapz(Seg(index).t(1:minP(1)),Seg(index).s(1:minP(1))-min(Seg(index).s));
    A2=trapz(Seg(index).t(minP(1):end),Seg(index).s(minP(1):end)-min(Seg(index).s));
    IPA=A2/A1;
else
    IPA=nan;
end
set(handles.edit14,'string',num2str(IPA));
onoff6=get(handles.radiobutton6,'value');
if onoff6
    axes(handles.axes4);
    cla reset;
    set(handles.axes4,'Visible','off');
    axes(handles.axes1);
    minv = min(Seg(index).s);
    line([Seg(index).t(1),Seg(index).t(end)],[minv,minv],'LineStyle','--','Color','r');
        text('Units','normalized','Position',[0.7,0.8],'String','IPA = A2/A1');
    if ~isempty(minP)
        line([Seg(index).t(minP(1)),Seg(index).t(minP(1))],[minv,Seg(index).s(minP(1))],'LineStyle','--','Color','r');
        hold on;
        scatter(Seg(index).t(minP(1)),Seg(index).s(minP(1)),'g');
        hold on;
        area(Seg(index).t(1:minP(1)),Seg(index).s(1:minP(1)),min(Seg(index).s));
        hold on;
        area(Seg(index).t(minP(1):end),Seg(index).s(minP(1):end),minv,'facecolor','r');
        text((Seg(index).t(1)+Seg(index).t(minP(1)))*0.5,Seg(index).s(minP(1)),'A1','Color','w');
        text(Seg(index).t(minP(1))*0.7+Seg(index).t(end)*0.3,(Seg(index).s(minP(1))-minv)*0.5+minv,'A2','Color','w')
        hold off;
    end
end

%get peak-peak interval
if index==1
    PPI=nan;
else
    [~,mindex]=max(Seg(index).s);
    [~,mindex_]=max(Seg(index-1).s);
    PPI=Seg(index).t(mindex)-Seg(index-1).t(mindex_);
    if PPI>1.5*interval/500
        PPI=nan;
    end
end

set(handles.edit15,'string',num2str(PPI));

onoff7=get(handles.radiobutton7,'value');
if onoff7
    axes(handles.axes4);
    if index==1
        plot(Seg(index).t,Seg(index).s);
    else
        plot(Seg(index-1).t,Seg(index-1).s,'r');
        hold on;
        plot(Seg(index).t,Seg(index).s);
        hold on;
        
        mmin=min([Seg(index-1).s,Seg(index).s]);
        scatter([Seg(index-1).t(mindex_),Seg(index).t(mindex)],[Seg(index-1).s(mindex_),Seg(index).s(mindex)],'g');
        line([Seg(index-1).t(mindex_),Seg(index-1).t(mindex_)],[mmin,Seg(index-1).s(mindex_)],'LineStyle','--','Color','r');
        line([Seg(index).t(mindex),Seg(index).t(mindex)],[mmin,Seg(index).s(mindex)],'LineStyle','--','Color','r');
        line([Seg(index-1).t(1),Seg(index).t(end)],[mmin,mmin],'LineStyle','--','Color','r');
        line([Seg(index-1).t(mindex_),Seg(index).t(mindex)],[min(Seg(index-1).s(mindex_),Seg(index).s(mindex)),min(Seg(index-1).s(mindex_),Seg(index).s(mindex))],'LineStyle','--','Color','r');
            text(Seg(index-1).t(mindex_),mmin-0.1,'t1');
    text(Seg(index).t(mindex),mmin-0.1,'t2');
    text('Units','normalized','Position',[0.7,0.8],'String','PPI = t2-t1');
        hold off;
    end
    grid on;
    title('this and the previous pulse');
    xlabel('time/s');
    ylabel('magnitude');
end

% get pulse arrivring time
ecgs=evalin('base','ecgs');
if index==1
    pat=nan;
else
    ppg1derive=diff(Seg(index).s);
    [~,l]=max(ppg1derive);
    eind=find(ppgt==Seg(index).t(l));
    [~,le]=max(ecgs(max(eind-interval,1):eind));
    
    pat=Seg(index).t(l)-ppgt(max(eind-interval,1)-1+le);
end
set(handles.edit16,'string',num2str(pat));

onoff8=get(handles.radiobutton8,'value');
if onoff8
    axes(handles.axes4);
    cla reset;
    %     if index==1
    %   plot(Seg(index).t,Seg(index).s);
    %   hold on;
    %   plot()
    %     end
    refe=find(ppgt==Seg(index).t(end));
    %     plot(ppgt(max(refe-2*interval,1):refe),ppg_processed(max(refe-2*interval,1):refe));
    %     hold on;
    %     plot(ppgt(max(refe-3*interval,1):refe),ecgs(max(refe-3*interval,1):refe),'r');
    %     hold on;
    %     scatter(Seg(index).t(l),Seg(index).s(l));
    %     hold on;
    %     scatter(ppgt(max(eind-interval,1)-1+le),ecgs(max(eind-interval,1)-1+le));
    %     line([ppgt(max(refe-3*interval,1)),ppgt(refe)],[0,0],'LineStyle','--','Color','k');
    %     line([ppgt(max(eind-interval,1)-1+le),ppgt(max(eind-interval,1)-1+le)],[0,ecgs(max(eind-interval,1)-1+le)],'LineStyle','--','Color','k');
    %     line([Seg(index).t(l),Seg(index).t(l)],[Seg(index).s(l),Seg(index).s(l)],'LineStyle','--','Color','k');
    %     title('present of PAT');
    %     xlabel('time/s');
    %     ylabel('magnitude of ecg and ppg');
    %     grid on;
    %     hold off;
    ah=plotyy(ppgt(max(refe-2*interval,1):refe),ppg_processed(max(refe-2*interval,1):refe),ppgt(max(refe-3*interval,1):refe),ecgs(max(refe-3*interval,1):refe));
    grid on;
    legend('ppg','ecg','Location','northwest');
    line([ppgt(max(refe-3*interval,1)),ppgt(refe)],[0,0],'LineStyle','--','Color','k');
    title('present of PAT');
    xlabel('time/s');
    text(ppgt(max(eind-interval,1)-1+le),-0.1,'t1');
text(Seg(index).t(l),-0.1,'t2');
text('Units','normalized','Position',[0.7,0.85],'String','PAT = t2-t1');

    axes(ah(1));
    ylabel('magnitude of ppg');
    line([Seg(index).t(l),Seg(index).t(l)],[0,Seg(index).s(l)],'LineStyle','--','Color','k');
    hold on;
    scatter(ah(1),Seg(index).t(l),Seg(index).s(l),'MarkerEdgeColor','b');
    hold on;
    
    axes(ah(2));
    ylabel(ah(2),'magnitude of ecg');
    line([ppgt(max(eind-interval,1)-1+le),ppgt(max(eind-interval,1)-1+le)],[0,ecgs(max(eind-interval,1)-1+le)],'LineStyle','--','Color','k');
    hold on;
    scatter(ah(2),ppgt(max(eind-interval,1)-1+le),ecgs(max(eind-interval,1)-1+le),'MarkerEdgeColor','r');
    hold off;
end

%get Inflection and Harmonic area ratio
ihar_value = evalin('base','ihar');
set(handles.edit17, 'String',num2str(ihar_value(index)));

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
Seg=evalin('base','ppgSeg');
l=length(Seg);
set(hObject,'Min',1,'Max',l);
set(hObject,'value',1);
set(hObject,'SliderStep',[1/l,2/l]);

guidata(hObject,handles);



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
Seg=evalin('base','ppgSeg');
set(handles.slider1,'value',str2num(get(hObject,'string')));
index=get(hObject,'string');
plot(handles.axes1,Seg(str2num(index)).t,Seg(str2num(index)).s);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'string','1');
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function text2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
Seg=evalin('base','ppgSeg');
l=length(Seg);
set(hObject,'string',num2str(l));
guidata(hObject,handles);


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1
%show augmentation index in axis1
set(hObject,'value',1);
set(handles.radiobutton2,'value',0);
set(handles.radiobutton3,'value',0);
set(handles.radiobutton4,'value',0);
set(handles.radiobutton5,'value',0);
set(handles.radiobutton6,'value',0);
set(handles.radiobutton7,'value',0);
set(handles.radiobutton8,'value',0);

Seg=evalin('base','ppgSeg');
index=get(handles.slider1,'value');
axes(handles.axes1);
plot(Seg(index).t,Seg(index).s);
title('one pulse of processed PPG');
xlabel('time/s');
ylabel('magnitude');
grid on;

[m, p]=max(Seg(index).s);
minv = min(Seg(index).s);
h=(m-minv)*0.1+minv;
[v,i]=findpeaks(Seg(index).s(p+1:end),'MinPeakHeight',h);
i=i+p;
line([Seg(index).t(1),Seg(index).t(end)],[m,m],'LineStyle','--','Color','r');
line([Seg(index).t(1),Seg(index).t(end)],[minv,minv],'LineStyle','--','Color','r');
line([Seg(index).t(p),Seg(index).t(p)],[minv,m],'LineStyle','--','Color','r');
text(Seg(index).t(p)-0.1,(m-minv)*0.5+minv,'a \rightarrow');
text('Units','normalized','Position',[0.7,0.8],'String','AI = b/a');
hold on;
scatter(Seg(index).t(p),m,'r');
if ~isempty(v)
    line([Seg(index).t(i(1)),Seg(index).t(i(1))],[minv,v(1)],'LineStyle','--','Color','r');
    line([Seg(index).t(p),Seg(index).t(i(1))],[v(1),v(1)],'LineStyle','--','Color','r');
    text(Seg(index).t(i(1))+0.03,(v(1)-minv)*0.5+minv,'\leftarrow b');
    hold on;
    scatter(Seg(index).t(i(1)),v(1),'r');
    hold off;
end
hold off;

%second deritive of ppg
ppg2deritive=diff(diff(Seg(index).s));
t2deritive=Seg(index).t(1:end-2);
axes(handles.axes4);
plot(t2deritive,ppg2deritive);
title('second deritive of this pulse');
xlabel('time/s');
ylabel('magnitude');
grid on;
[peaks2,loc2]=findpeaks(ppg2deritive);
[peaks2_,loc2_] = findpeaks(-ppg2deritive);

hold on;
scatter(t2deritive(loc2),peaks2);
hold on;
scatter(t2deritive(loc2_),-peaks2_)
line([t2deritive(loc2),t2deritive(loc2_);t2deritive(loc2),t2deritive(loc2_)],[zeros(1,length(loc2)+length(loc2_));peaks2,-peaks2_],'LineStyle','--','Color','r');
hold off;
guidata(hObject,handles);


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2
% show time delay in axis1
set(hObject,'value',1);
set(handles.radiobutton1,'value',0);
set(handles.radiobutton3,'value',0);
set(handles.radiobutton4,'value',0);
set(handles.radiobutton5,'value',0);
set(handles.radiobutton6,'value',0);
set(handles.radiobutton7,'value',0);
set(handles.radiobutton8,'value',0);

axes(handles.axes4)
cla reset;
set(handles.axes4,'Visible','off');
Seg = evalin('base','ppgSeg');
index = get(handles.slider1,'value');
axes(handles.axes1);
plot(Seg(index).t,Seg(index).s)
title('one pulse of processed PPG');
xlabel('time/s');
ylabel('magnitude');
grid on;
[m, p]=max(Seg(index).s);
minv = min(Seg(index).s);
h=(m-minv)*0.1+minv;
[v,i]=findpeaks(Seg(index).s(p+1:end),'MinPeakHeight',h);
i=i+p;
line([Seg(index).t(p),Seg(index).t(p)],[minv,m],'LineStyle','--','Color','r');
line([Seg(index).t(1),Seg(index).t(end)],[minv,minv],'LineStyle','--','Color','r');
text(Seg(index).t(p),minv-0.1,'t1');
text('Units','normalized','Position',[0.7,0.8],'String','TD = t2-t1');
hold on;
scatter(Seg(index).t(p),m,'r');
if ~isempty(v)
    line([Seg(index).t(i(1)),Seg(index).t(i(1))],[minv,v(1)],'LineStyle','--','Color','r');
    text(Seg(index).t(i(1)),minv-0.1,'t2');
    hold on;
    scatter(Seg(index).t(i(1)),v(1),'r');
    hold off;
end
hold off;

guidata(hObject,handles);

% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3
% show systolic amplitude in axes 1
set(hObject,'value',1);
set(handles.radiobutton2,'value',0);
set(handles.radiobutton1,'value',0);
set(handles.radiobutton4,'value',0);
set(handles.radiobutton5,'value',0);
set(handles.radiobutton6,'value',0);
set(handles.radiobutton7,'value',0);
set(handles.radiobutton8,'value',0);
axes(handles.axes4);
cla reset;
set(handles.axes4,'Visible','off');

Seg=evalin('base','ppgSeg');
index=get(handles.slider1,'value');
axes(handles.axes1);
plot(Seg(index).t,Seg(index).s)
title('one pulse of processed PPG');
xlabel('time/s');
ylabel('magnitude');
grid on;
[m,p]=max(Seg(index).s);

line([Seg(index).t(1),Seg(index).t(p)],[Seg(index).s(1),Seg(index).s(1)],'LineStyle','--','Color','r');
line([Seg(index).t(p),Seg(index).t(p)],[Seg(index).s(1),m],'LineStyle','--','Color','r');
text(Seg(index).t(p)+0.03,(m-Seg(index).s(1))*0.5+Seg(index).s(1),'\leftarrow a');
text('Units','normalized','Position',[0.7,0.8],'String','SA = a');
hold on
scatter([Seg(index).t(1),Seg(index).t(p)],[Seg(index).s(1),m],'r');
hold off

guidata(hObject,handles);

% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4
% show pulse width in axes1
set(hObject,'value',1);
set(handles.radiobutton2,'value',0);
set(handles.radiobutton3,'value',0);
set(handles.radiobutton1,'value',0);
set(handles.radiobutton5,'value',0);
set(handles.radiobutton6,'value',0);
set(handles.radiobutton7,'value',0);
set(handles.radiobutton8,'value',0);
axes(handles.axes4);
cla reset;
set(handles.axes4,'Visible','off');

Seg=evalin('base','ppgSeg');
index=get(handles.slider1,'value');
axes(handles.axes1);
plot(Seg(index).t,Seg(index).s);
title('one pulse of processed PPG');
xlabel('time/s');
ylabel('magnitude');
grid on;

[m,p]=max(Seg(index).s);
minv = min(Seg(index).s);
mid=(m+minv)/2;%mid punkt finden
x=interp1(Seg(index).s(1:p),Seg(index).t(1:p),mid);
y=interp1(Seg(index).s(p+1:end),Seg(index).t(p+1:end),mid);

line([x,x],[minv,mid],'LineStyle','--','Color','r');
line([y,y],[minv,mid],'LineStyle','--','Color','r');
line([Seg(index).t(1),Seg(index).t(end)],[minv,minv],'LineStyle','--','Color','r');
text(x,minv-0.1,'t1');
text(y,minv-0.1,'t2');
text('Units','normalized','Position',[0.7,0.8],'String','PW = t2-t1');
hold on;
scatter([x,y],[mid,mid],'r');
hold off;
guidata(hObject,handles);

% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5

% show HRDN feature
set(hObject,'value',1);
set(handles.radiobutton2,'value',0);
set(handles.radiobutton3,'value',0);
set(handles.radiobutton4,'value',0);
set(handles.radiobutton1,'value',0);
set(handles.radiobutton6,'value',0);
set(handles.radiobutton7,'value',0);
set(handles.radiobutton8,'value',0);
axes(handles.axes4);
cla reset;
set(handles.axes4,'Visible','off');

Seg = evalin('base','ppgSeg');
index = get(handles.slider1,'value');
axes(handles.axes1);
plot(Seg(index).t,Seg(index).s);
title('one pulse of processed PPG');
xlabel('time/s');
ylabel('magnitude');
grid on;

[~,p] = max(diff(Seg(index).s));
[~,minP]=findpeaks(-Seg(index).s(p+1:round(0.9*end)));
minv = min(Seg(index).s);
line([Seg(index).t(p),Seg(index).t(p)],[minv,Seg(index).s(p)],'LineStyle','--','Color','r');
line([Seg(index).t(1),Seg(index).t(end)],[minv,minv],'LineStyle','--','Color','r');
text(Seg(index).t(p),minv-0.1,'t1');
text('Units','normalized','Position',[0.65,0.8],'String','HRDN = t2-t1');
hold on;
scatter(Seg(index).t(p),Seg(index).s(p),'r');
if ~isempty(minP)
    line([Seg(index).t(minP(1)+p),Seg(index).t(minP(1)+p)],[minv,Seg(index).s(minP(1)+p)],'LineStyle','--','Color','r');
    text(Seg(index).t(minP(1)+p),minv-0.1,'t2');
    hold on;
    scatter(Seg(index).t(minP(1)+p),Seg(index).s(minP(1)+p),'r');
    hold off;
end
hold off;
guidata(hObject,handles);


% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6

% show Inflection point area ratio(IPA) in axes1
set(hObject,'value',1);
set(handles.radiobutton2,'value',0);
set(handles.radiobutton3,'value',0);
set(handles.radiobutton4,'value',0);
set(handles.radiobutton5,'value',0);
set(handles.radiobutton1,'value',0);
set(handles.radiobutton7,'value',0);
set(handles.radiobutton8,'value',0);
axes(handles.axes4);
cla reset;
    set(handles.axes4,'Visible','off');
    
Seg=evalin('base','ppgSeg');
index=get(handles.slider1,'value');
axes(handles.axes1);
plot(Seg(index).t,Seg(index).s);
title('one pulse of processed PPG');
xlabel('time/s');
ylabel('magnitude');
grid on;

[~,minP]=findpeaks(-Seg(index).s(1:round(0.9*end)));
minv = min(Seg(index).s);
line([Seg(index).t(1),Seg(index).t(end)],[min(Seg(index).s),min(Seg(index).s)],'LineStyle','--','Color','r');
        text('Units','normalized','Position',[0.7,0.8],'String','IPA = A2/A1');
if ~isempty(minP)
    line([Seg(index).t(minP(1)),Seg(index).t(minP(1))],[min(Seg(index).s),Seg(index).s(minP(1))],'LineStyle','--','Color','r');
    hold on;
    scatter(Seg(index).t(minP(1)),Seg(index).s(minP(1)),'g');
    hold on;
    area(Seg(index).t(1:minP(1)),Seg(index).s(1:minP(1)),min(Seg(index).s));
    hold on;
    area(Seg(index).t(minP(1):end),Seg(index).s(minP(1):end),min(Seg(index).s),'facecolor','r');
            text((Seg(index).t(1)+Seg(index).t(minP(1)))*0.5,Seg(index).s(minP(1)),'A1','Color','w');
        text(Seg(index).t(minP(1))*0.7+Seg(index).t(end)*0.3,(Seg(index).s(minP(1))-minv)*0.5+minv,'A2','Color','w')
    hold off;
end
guidata(hObject,handles);

% --- Executes on button press in radiobutton7.
function radiobutton7_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton7
% show peak to peak interval(PPI) in axes4
set(hObject,'value',1);
set(handles.radiobutton2,'value',0);
set(handles.radiobutton3,'value',0);
set(handles.radiobutton4,'value',0);
set(handles.radiobutton5,'value',0);
set(handles.radiobutton6,'value',0);
set(handles.radiobutton1,'value',0);
set(handles.radiobutton8,'value',0);

Seg=evalin('base','ppgSeg');
index=get(handles.slider1,'value');
axes(handles.axes1);
plot(Seg(index).t,Seg(index).s);
title('one pulse of processed PPG');
xlabel('time/s');
ylabel('magnitude');
grid on;

axes(handles.axes4);
cla reset;
if index==1
    plot(Seg(index).t,Seg(index).s);
else
    [~,mindex]=max(Seg(index).s);
    [~,mindex_]=max(Seg(index-1).s);
    plot(Seg(index-1).t,Seg(index-1).s,'r');
    hold on;
    plot(Seg(index).t,Seg(index).s);
    hold on;
    
    mmin=min([Seg(index-1).s,Seg(index).s]);
    scatter([Seg(index-1).t(mindex_),Seg(index).t(mindex)],[Seg(index-1).s(mindex_),Seg(index).s(mindex)],'g');
    line([Seg(index-1).t(mindex_),Seg(index-1).t(mindex_)],[mmin,Seg(index-1).s(mindex_)],'LineStyle','--','Color','r');
    line([Seg(index).t(mindex),Seg(index).t(mindex)],[mmin,Seg(index).s(mindex)],'LineStyle','--','Color','r');
    line([Seg(index-1).t(1),Seg(index).t(end)],[mmin,mmin],'LineStyle','--','Color','r');
    line([Seg(index-1).t(mindex_),Seg(index).t(mindex)],[min(Seg(index-1).s(mindex_),Seg(index).s(mindex)),min(Seg(index-1).s(mindex_),Seg(index).s(mindex))],'LineStyle','--','Color','r');
    text(Seg(index-1).t(mindex_),mmin-0.1,'t1');
    text(Seg(index).t(mindex),mmin-0.1,'t2');
    text('Units','normalized','Position',[0.7,0.8],'String','PPI = t2-t1');
    hold off;
end
grid on;
title('this and the previous pulse');
xlabel('time/s');
ylabel('magnitude');
guidata(hObject,handles);


function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double



% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, ~, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton8.
function radiobutton8_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton8

% show pulse arrival time(PAT) in axes4
set(hObject,'value',1);
set(handles.radiobutton2,'value',0);
set(handles.radiobutton3,'value',0);
set(handles.radiobutton4,'value',0);
set(handles.radiobutton5,'value',0);
set(handles.radiobutton6,'value',0);
set(handles.radiobutton7,'value',0);
set(handles.radiobutton1,'value',0);

Seg=evalin('base','ppgSeg');
index=get(handles.slider1,'value');
axes(handles.axes1);
plot(Seg(index).t,Seg(index).s);
title('one pulse of processed PPG');
xlabel('time/s');
ylabel('magnitude');
grid on;

axes(handles.axes4);
cla reset;
ppgt=evalin('base','ppgt');
ppg_processed=evalin('base','ppgs_preprocess');
ecgs=evalin('base','ecgs');
interval=evalin('base','interval');
ppg1derive=diff(Seg(index).s);
[~,l]=max(ppg1derive);
eind=find(ppgt==Seg(index).t(l));
[~,le]=max(ecgs(max(eind-interval,1):eind));
refe = find(ppgt==Seg(index).t(end));
ah = plotyy(ppgt(max(refe-2*interval,1):refe),ppg_processed(max(refe-2*interval,1):refe),ppgt(max(refe-3*interval,1):refe),ecgs(max(refe-3*interval,1):refe));
grid on;
legend('ppg','ecg','Location','northwest');
line([ppgt(max(refe-3*interval,1)),ppgt(refe)],[0,0],'LineStyle','--','Color','k');
title('present of PAT');
xlabel('time/s');
text(ppgt(max(eind-interval,1)-1+le),-0.1,'t1');
text(Seg(index).t(l),-0.1,'t2');
text('Units','normalized','Position',[0.7,0.85],'String','PAT = t2-t1');
axes(ah(1));
ylabel('magnitude of ppg');
line([Seg(index).t(l),Seg(index).t(l)],[0,Seg(index).s(l)],'LineStyle','--','Color','k');
hold on;
scatter(ah(1),Seg(index).t(l),Seg(index).s(l),'MarkerEdgeColor','b');
hold on;

axes(ah(2));
ylabel(ah(2),'magnitude of ecg');
line([ppgt(max(eind-interval,1)-1+le),ppgt(max(eind-interval,1)-1+le)],[0,ecgs(max(eind-interval,1)-1+le)],'LineStyle','--','Color','k');
   hold on;
scatter(ah(2),ppgt(max(eind-interval,1)-1+le),ecgs(max(eind-interval,1)-1+le),'MarkerEdgeColor','r');
hold off;
guidata(hObject,handles);



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double



% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
dap_value = evalin('base','dap');
set(hObject,'string',num2str(dap_value));
guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function text4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


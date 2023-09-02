function varargout = load_ECG(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @load_ECG_OpeningFcn, ...
                   'gui_OutputFcn',  @load_ECG_OutputFcn, ...
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


function load_ECG_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
guidata(hObject, handles);
function varargout = load_ECG_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;


function pushbutton1_Callback(hObject, eventdata, handles)
[file,path] = uigetfile('*.mat');

if path==0
msgbox('Nothing selected');
else
    ecg=importdata([path file]);
           
ecg = detrend(ecg);
   plot(ecg,'Color','green')
    set(gca,'Color','k')
     xlabel('Samples')
    ylabel('Amplitude')               
peaks = islocalmax(ecg,'MinProminence',185);
hold on
plot(find(peaks),ecg(peaks),'*','Color',[0 0 0]/255,'MarkerFaceColor',[0 0 0]/255)
pause(0.5)
plot(find(peaks),ecg(peaks),'*','Color',[60 60 60]/255,'MarkerFaceColor',[60 60 60]/255)
pause(0.1)
plot(find(peaks),ecg(peaks),'*','Color',[120 120 120]/255,'MarkerFaceColor',[120 120 120]/255)
pause(0.1)
plot(find(peaks),ecg(peaks),'*','Color',[180 180 180]/255,'MarkerFaceColor',[180 180 180]/255)
pause(0.1)
plot(find(peaks),ecg(peaks),'*','Color',[240 240 240]/255,'MarkerFaceColor',[240 240 240]/255)
pause(0.1)
plot(find(peaks),ecg(peaks),'*','Color','white','MarkerFaceColor','white')
    hold off
%mean of differences of first possible four R-R intervals' durations

freq=findobj(0,'tag','freq');
samplingFreq=str2double(get(freq,'string'));
format short;
samplingTime=1./samplingFreq;

peaksSamples = find(peaks);
if 5 <= length(peaksSamples) 
    timeOfAnIntervalInSecond = ((peaksSamples(5)-peaksSamples(4)  +  peaksSamples(4)-peaksSamples(3)  +   peaksSamples(3)-peaksSamples(2)    +     peaksSamples(2)-peaksSamples(1))/4)*samplingTime;
heartRateM=60/timeOfAnIntervalInSecond;
heartRateS=1/timeOfAnIntervalInSecond;
if  abs((peaksSamples(5)-peaksSamples(4))  -  (peaksSamples(4)-peaksSamples(3))) < 60  && abs((peaksSamples(4)-peaksSamples(3))  -  (peaksSamples(3)-peaksSamples(2))) < 60 &&  abs((peaksSamples(3)-peaksSamples(2))  -  (peaksSamples(2)-peaksSamples(1))) < 60
HRM=findobj(0,'tag','HRM');
set(HRM,'string',num2str(heartRateM));
HRS=findobj(0,'tag','HRS');
set(HRS,'string',num2str(heartRateS));
acc=findobj(0,'tag','acc');
set(acc,'string','very good accuracy');
else
    HRM=findobj(0,'tag','HRM');
set(HRM,'string',num2str(heartRateM));
HRS=findobj(0,'tag','HRS');
set(HRS,'string',num2str(heartRateS));
acc=findobj(0,'tag','acc');
set(acc,'string','good accuracy');
end
end
if 4 == length(peaksSamples) 
timeOfAnIntervalInSecond = ((peaksSamples(4)-peaksSamples(3)  +   peaksSamples(3)-peaksSamples(2)    +     peaksSamples(2)-peaksSamples(1))/3)*samplingTime;
heartRateM=60/timeOfAnIntervalInSecond;
heartRateS=1/timeOfAnIntervalInSecond;

HRM=findobj(0,'tag','HRM');
set(HRM,'string',num2str(heartRateM));
HRS=findobj(0,'tag','HRS');
set(HRS,'string',num2str(heartRateS));
acc=findobj(0,'tag','acc');
set(acc,'string','good accuracy');


elseif 3 == length(peaksSamples) 
timeOfAnIntervalInSecond = ((  peaksSamples(3)-peaksSamples(2)    +     peaksSamples(2)-peaksSamples(1))/2)*samplingTime;
heartRateM=60*1/timeOfAnIntervalInSecond;
heartRateS=1/timeOfAnIntervalInSecond;
HRM=findobj(0,'tag','HRM');
set(HRM,'string',num2str(heartRateM));
HRS=findobj(0,'tag','HRS');
set(HRS,'string',num2str(heartRateS));
acc=findobj(0,'tag','acc');
set(acc,'string','medium accuracy ._.');
    elseif 2 == length(peaksSamples) 
timeOfAnIntervalInSecond = (peaksSamples(2)-peaksSamples(1))*samplingTime;
heartRateM=60*1/timeOfAnIntervalInSecond;
heartRateS=1/timeOfAnIntervalInSecond;
HRM=findobj(0,'tag','HRM');
set(HRM,'string',num2str(heartRateM));
HRS=findobj(0,'tag','HRS');
set(HRS,'string',num2str(heartRateS));
acc=findobj(0,'tag','acc');
set(acc,'string','bad accuracy :( ');
elseif 1 == length(peaksSamples) 
   acc=findobj(0,'tag','acc');
set(acc,'string','no enough peaks to calculate');

end
%detect bi dysfunction..range of approximation = 50
count=0;
for i= 1:length(peaksSamples)-3
   if ((peaksSamples(i+1)-peaksSamples(i))-(peaksSamples(i+3)-peaksSamples(i+2)))<50 && ((peaksSamples(i+1)-peaksSamples(i))-(peaksSamples(i+2)-peaksSamples(i+1)))>50 count=count+1; 
   end
end

if count > 1 
    bi=findobj(0,'tag','bi');
set(bi,'string','BIGEMINY!!');
else
    bi=findobj(0,'tag','bi');
    set(bi,'string','--');
end


ccount=0;
peaksValues=ecg(peaksSamples);
for i=1+1:length(peaksValues)-1
    if abs(peaksValues(i)-peaksValues(i+1))>90 && abs(peaksValues(i)-peaksValues(i-1))>90
     
    ccount=ccount+1;

end

end
  if ccount>=1 && ccount/length(peaksValues) <= 1/8.5
     
        pvc=findobj(0,'tag','pvc');
  set(pvc,'string','PVC!!');
  else
    pvc=findobj(0,'tag','pvc');
    set(pvc,'string','--');
  end

  end

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over HRM.
% hObject    handle to HRM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function HRS_Callback(hObject, eventdata, handles)
% hObject    handle to HRS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of HRS as text
%        str2double(get(hObject,'String')) returns contents of HRS as a double


% --- Executes during object creation, after setting all properties.
function HRS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HRS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function HRM_Callback(hObject, eventdata, handles)
% hObject    handle to HRM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of HRM as text
%        str2double(get(hObject,'String')) returns contents of HRM as a double


% --- Executes during object creation, after setting all properties.
function HRM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HRM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function freq_Callback(hObject, eventdata, handles)
% hObject    handle to freq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of freq as text
%        str2double(get(hObject,'String')) returns contents of freq as a double


% --- Executes during object creation, after setting all properties.
function freq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to freq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

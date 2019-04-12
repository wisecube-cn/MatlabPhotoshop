function varargout = myPS(varargin)
% MYPS MATLAB code for myPS.fig
%      MYPS, by itself, creates a new MYPS or raises the existing
%      singleton*.
%
%      H = MYPS returns the handle to a new MYPS or the handle to
%      the existing singleton*.
%
%      MYPS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MYPS.M with the given input arguments.
%
%      MYPS('Property','Value',...) creates a new MYPS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before myPS_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to myPS_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help myPS

% Last Modified by GUIDE v2.5 12-Apr-2019 08:45:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @myPS_OpeningFcn, ...
                   'gui_OutputFcn',  @myPS_OutputFcn, ...
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

% --- Executes just before myPS is made visible.
function myPS_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to myPS (see VARARGIN)

% Choose default command line output for myPS
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes myPS wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = myPS_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% ---- 打开文件
function openfile_ClickedCallback(hObject, eventdata, handles)
global filename path img;
[filename,path]=uigetfile('.jpg','读取一张图片');
img=imread([path,filename]);
axes(handles.axes1)
imshow(img);


% --- 退出按钮
function exit_ClickedCallback(hObject, eventdata, handles)
close(myPS);


% --- 显示原图
function pushbutton1_Callback(hObject, eventdata, handles)
global img;
axes(handles.axes1)
imshow(img);


% --- 显示灰度图
function pushbutton2_Callback(hObject, eventdata, handles)
global img;
global img_gray;
img_gray=rgb2gray(img);
axes(handles.axes1)
imshow(img_gray);


% --- 归一化
function pushbutton3_Callback(hObject, eventdata, handles)
global img_gray;
global img_gray_norm;
img_gray_norm=mat2gray(img_gray);
axes(handles.axes1)
imshow(img_gray_norm);


% --- 设定二值化阈值
function edit1_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
global value;
value=str2double(get(hObject,'String'));



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


% --- 二值化
function pushbutton4_Callback(hObject, eventdata, handles)
global value;
global img_gray_norm;

blackSum=0;
whiteSum=0;
if not(value>0 && value<1)
    msgbox('请输入一个0-1数字!');
else
    i=1;j=1;
    [H,W]=size(img_gray_norm);
    myWaitbar=waitbar(0,'图片处理中...');
    while i<=H
        waitbar(i/H);
        j=1;
        while j<=W
            if img_gray_norm(i,j)>value
                img_gray_normBN(i,j)=1;
                whiteSum=whiteSum+1;
            elseif img_gray_norm(i,j)<value
                img_gray_normBN(i,j)=0;
                blackSum=blackSum+1;
            end
            j=j+1;
        end
        i=i+1;
    end
    axes(handles.axes1)
    imshow(img_gray_normBN);
end
delete(myWaitbar);
set(handles.edit2,'String',blackSum/(blackSum+whiteSum));
set(handles.edit3,'String',whiteSum/(blackSum+whiteSum));


% --- 进度条选择阈值
function slider1_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global value;
global img_gray_norm;
value=get(hObject,'Value');
set(handles.edit1,'String',value);
i=1;j=1;
[H,W]=size(img_gray_norm);
myWaitbar=waitbar(0,'图片处理中...');
blackSum=0;
whiteSum=0;
while i<=H
    waitbar(i/H);
    j=1;
    while j<=W %1是白色，0是黑色
        if img_gray_norm(i,j)>value
            img_gray_normBN(i,j)=1;
            whiteSum=whiteSum+1;
        elseif img_gray_norm(i,j)<value
            img_gray_normBN(i,j)=0;
            blackSum=blackSum+1;
        end
        j=j+1;
    end
    i=i+1;
end
delete(myWaitbar);
axes(handles.axes1)
imshow(img_gray_normBN);
set(handles.edit2,'String',blackSum/(blackSum+whiteSum));
set(handles.edit3,'String',whiteSum/(blackSum+whiteSum));


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function uipushtool3_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img_gray_norm;
global filename;
dirname=uigetdir('C:\Users\24283\Desktop\0-毕业设计\00-实验数据');
filepath=pwd;           %保存当前工作目录
cd(dirname)             %把当前工作目录切换到图片存储文件夹
imwrite(img_gray_norm,filename);
cd(filepath)            %切回原工作目录

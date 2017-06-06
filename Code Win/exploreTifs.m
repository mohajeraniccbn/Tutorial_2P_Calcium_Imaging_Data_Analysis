function varargout = exploreTifs(varargin)
% EXPLORETIFS MATLAB code for exploreTifs.fig
%      EXPLORETIFS, by itself, creates a new EXPLORETIFS or raises the existing
%      singleton*.
%
%      H = EXPLORETIFS returns the handle to a new EXPLORETIFS or the handle to
%      the existing singleton*.
%
%      EXPLORETIFS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXPLORETIFS.M with the given input arguments.
%
%      EXPLORETIFS('Property','Value',...) creates a new EXPLORETIFS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before exploreTifs_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to exploreTifs_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help exploreTifs

% Last Modified by GUIDE v2.5 24-May-2017 17:26:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @exploreTifs_OpeningFcn, ...
                   'gui_OutputFcn',  @exploreTifs_OutputFcn, ...
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


% --- Executes just before exploreTifs is made visible.
function exploreTifs_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to exploreTifs (see VARARGIN)

% Choose default command line output for exploreTifs
handles.output = hObject;
handles.fileNames = varargin{1};
if iscell(handles.fileNames)
    handles.totalFiles = length(varargin{1});
else
    handles.totalFiles = varargin{3};
end
if iscell(handles.fileNames)
    img = double(imread(handles.fileNames{1}));
else
    img = double(imread(handles.fileNames,1));
end
set(handles.slider1,'userdata',varargin{1});
imagesc(handles.axes1,img);
colormap(gray);
set(handles.folderName,'String',varargin{2});
fct = sprintf('%d/%d',1,handles.totalFiles);
set(handles.frameCounter,'String',fct);
min_step = 1/handles.totalFiles;
max_step = 10/handles.totalFiles;
set(handles.slider1,'Max',handles.totalFiles);
set(handles.slider1,'Min',1);
set(handles.slider1,'SliderStep',[min_step max_step]);
set(handles.slider1,'value',1);
addlistener(handles.slider1,'ContinuousValueChange',@slider_frames_Callback1);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes exploreTifs wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = exploreTifs_OutputFcn(hObject, eventdata, handles) 
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
fileNumber = round(get(hObject,'Value'));
set(hObject,'Value',fileNumber);
if iscell(handles.fileNames)
    img = double(imread(handles.fileNames{fileNumber}));
else
    img = double(imread(handles.fileNames,fileNumber));
end
handles.axes1;
imagesc(img);
fct = sprintf('%d/%d',fileNumber,handles.totalFiles);
set(handles.frameCounter,'String',fct);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_frames_Callback1(hObject, eventdata, handles)
% hObject    handle to slider_frames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles = guidata(hObject);
fileNumber = round(get(hObject,'Value'));
set(hObject,'Value',fileNumber);
fileNames = get(hObject,'userdata');
if iscell(handles.fileNames)
    img = double(imread(fileNames{fileNumber}));
else
    img = double(imread(fileNames,fileNumber));
end
imagesc(handles.axes1,img);
fct = sprintf('%d/%d',fileNumber,handles.totalFiles);
set(handles.frameCounter,'String',fct);
refresh(handles.figure1);


% --- Executes when selected object is changed in uibuttongroup1.
function uibuttongroup1_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup1 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
type = get(hObject,'String')
colormap(type);

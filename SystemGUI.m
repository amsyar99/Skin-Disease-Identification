function varargout = SystemGUI(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SystemGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @SystemGUI_OutputFcn, ...
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

% --- Executes on button press in inputBtn.
function inputBtn_Callback(~, ~, handles)
startingFolder = 'C:\Users\Amsyar\Documents\cs230\part5\Dataset';
if ~exist(startingFolder, 'dir')
  % If that folder doesn't exist, just start in the current folder.
  startingFolder = pwd;
end
% Get the name of the file that the user wants to use.
defaultFileName = fullfile(startingFolder, '*.*');
[baseFileName, folder] = uigetfile(defaultFileName, 'Select a file');
if baseFileName == 0
  % User clicked the Cancel button.
  return;
end

global imgInput;
fullFileName = fullfile(folder, baseFileName);
myImage = imread(fullFileName);
imgInput = myImage;
axes(handles.axes1);
imshow(imgInput);title('Input image');

set(handles.inputBtn,'Enable','off');
set(handles.ImgFilterBtn,'Enable','on');
set(handles.resetBtn,'Enable','on');
drawnow;



% --- Executes on button press in ImgFilterBtn.
function ImgFilterBtn_Callback(hObject,eventdata, handles)
global imgInput;
I= im2double(imgInput);
im2= imadjust(I,[.2 .3 0; .6 .7 1],[]);
J = imnoise(im2,'salt & pepper',0.02);
K = J;
for c = 1 : 3
   K(:, :, c) = medfilt2(J(:, :, c), [3, 3]);
end
imgInput=im2;
axes(handles.axes2);
imshow(im2);
title('Image Filtering');
set(handles.ImgFilterBtn,'Enable','off');
set(handles.ImgSegmentBtn,'Enable','on');
drawnow; 

% --- Executes on button press in ImgSegmentBtn.
function ImgSegmentBtn_Callback(hObject, eventdata, handles)
global imgInput;
I = imgInput;
gray = rgb2gray(I);
I_eq= adapthisteq(gray);
bw= imbinarize(I_eq, graythresh(I_eq));
bw3 = imopen(bw, ones(3,3));
bw4 = bwareaopen(bw3, 20);
bw4_perim = bwperim(bw4);
overlay1 = imoverlay(I_eq, bw4_perim, [.3 1 .3]);
mask_em = imregionalmax(~bw4); %fgm
fgm = labeloverlay(I,mask_em);
mask_em = imclose(mask_em, ones(3,3));
mask_em = imerode(mask_em, ones(3,3));
mask_em = bwareaopen(mask_em, 30);
overlay2 = imoverlay(I_eq, bw4_perim | mask_em, [.3 1 .3])
D = bwdist(mask_em);
DL = watershed(D);
bgm = DL == 0;
gmag=imgradient(gray);
gmag2 = imimposemin(gmag, bgm | mask_em);
L = watershed(gmag2);
labels = imdilate(L==0,ones(3,3)) + 2*bgm + 3*mask_em;
I4 = labeloverlay(gray,labels);
label = imdilate(L==0,ones(3,3)) + 2*mask_em;
bb= imbinarize(label, graythresh(label));
Lrgb = label2rgb(L,'jet','w','shuffle');
I = mask_em;
imgInput = I;
axes(handles.axes3);
imshow(I);
title('Image Segmentation');
set(handles.ImgSegmentBtn,'Enable','off');
set(handles.GLCMBtn,'Enable','on');
drawnow; 


function SystemGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% varargin   command line arguments to SystemGUI (see VARARGIN)

% Choose default command line output for SystemGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SystemGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SystemGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in GLCMBtn.
function GLCMBtn_Callback(hObject, eventdata, handles)
global imgInput;
I= imgInput;
I=double(I);
I = reshape(I.',1,[]);
e=entropy(I);
set(handles.edit3, 'String', e)
gg=graycomatrix(I);
contrast=gg(1,1);
set(handles.edit2, 'String',contrast )
core=gg(1,8);
set(handles.edit1, 'String', core)
energy=gg(8,1);
set(handles.edit4, 'String', energy)


features = [e, contrast, core, energy];

T = array2table(features,....
    'VariableNames', {'VarName1', 'VarName2', 'VarName3', 'VarName4'});

filename = 'Test.xlsx';
writetable(T,filename)
set(handles.GLCMBtn,'Enable','off');
set(handles.SVMBtn,'Enable','on');
drawnow; 



% --- Executes on button press in SVMBtn.
function SVMBtn_Callback(hObject, eventdata, handles)
load ('trained.mat');

testdata=readtable("Test.xlsx");

yfit = trainedModel.predictFcn(testdata);
set(handles.edit6, 'String', char(yfit));
set(handles.SVMBtn,'Enable','off');
set(handles.resetBtn,'Enable','on');
drawnow; 



% --- Executes on button press in resetBtn.
function resetBtn_Callback(hObject, eventdata, handles)
cla(handles.axes1);
cla(handles.axes2);
cla(handles.axes3);
set(handles.edit1, 'String', '');
set(handles.edit2, 'String', '');
set(handles.edit3, 'String', '');
set(handles.edit4, 'String', '');
set(handles.edit6, 'String', '');
set(handles.resetBtn,'Enable','off');
set(handles.inputBtn,'Enable','on');
drawnow;


% --- Executes during object creation, after setting all properties.
function uibuttongroup5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uibuttongroup5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% --- Executes during object creation, after setting all properties.

function uibuttongroup7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uibuttongroup5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in ExitBtn.
function ExitBtn_Callback(hObject, eventdata, handles)
closereq();



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


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



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

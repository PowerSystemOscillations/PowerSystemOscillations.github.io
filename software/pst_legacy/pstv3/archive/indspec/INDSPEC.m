function varargout = INDSPEC(varargin)
% INSPECT M-file for INDSPEC.fig
%      INDSPEC, by itself, creates a new INDSPEC or raises the existing
%      singleton*.
%
%      H = INDSPEC returns the handle to a new INDSPEC or the handle to
%      the existing singleton*.
%
%      INDSPEC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INDSPEC.M with the given input arguments.
%
%      INDSPEC('Property','Value',...) creates a new INDSPEC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before INSPECT_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to INSPECT_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help INDSPEC

% Last Modified by GUIDE v2.5 31-Jan-2003 10:27:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @INSPECT_OpeningFcn, ...
                   'gui_OutputFcn',  @INSPECT_OutputFcn, ...
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


% --- Executes just before INDSPEC is made visible.
function INSPECT_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to INDSPEC (see VARARGIN)
% Choose default command line output for INDSPEC
global eflag hfig
hfig = hObject;
eflag = 0;
handles.output = hObject;
handles.parameters.rs = [];
handles.parameters.xs = [];
handles.parameters.Xm = [];
handles.parameters.xr = [];
handles.parameters.rr = [];
handles.parameters.xr2 = [];
handles.parameters.rr2 = [];
handles.parameters.dbf = [];
handles.parameters.dr = 1;
handles.parameters.isat = 10;
handles.rating.V = [];
handles.rating.I = [];
handles.rating.BasMva = [];
handles.specifications.fleff = [];
handles.specifications.flpf = [];
handles.specifications.flslip = [];
handles.specifications.stc = [];
handles.specifications.stt = [];
handles.specifications.nll = 0;
handles.Type = 1; % starts with single cage; Type=2 double cage; Type = 3 deep bar
handles.plotopt = 'separate';
handles.tplot = 0;
handles.iplot = 0;
handles.pplot = 0;
handles.qplot = 0;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes INDSPEC wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = INSPECT_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes during object creation, after setting all properties.
function rs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function rs_Callback(hObject, eventdata, handles)
% hObject    handle to rs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rs as text
%        str2double(get(hObject,'String')) returns contents of rs as a
%        double
rs = str2double(get(hObject,'String'));
handles.parameters.rs = rs;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function xs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function xs_Callback(hObject, eventdata, handles)
% hObject    handle to xs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xs as text
%        str2double(get(hObject,'String')) returns contents of xs as a
%        double
xs = str2double(get(hObject,'String'));
handles.parameters.xs = xs;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Xm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Xm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Xm_Callback(hObject, eventdata, handles)
% hObject    handle to Xm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Xm as text
%        str2double(get(hObject,'String')) returns contents of Xm as a double

Xm = str2double(get(hObject,'String'));
handles.parameters.Xm = Xm;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function xr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function xr_Callback(hObject, eventdata, handles)
% hObject    handle to xr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xr as text
%        str2double(get(hObject,'String')) returns contents of xr as a double

xr = str2double(get(hObject,'String'));
handles.parameters.xr = xr;
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function rr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function rr_Callback(hObject, eventdata, handles)
% hObject    handle to rr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rr as text
%        str2double(get(hObject,'String')) returns contents of rr as a double

rr = str2double(get(hObject,'String'));
handles.parameters.rr = rr;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function xr2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xr2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
set(hObject,'Visible','off');% starts as single cage



function xr2_Callback(hObject, eventdata, handles)
% hObject    handle to xr2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xr2 as text
%        str2double(get(hObject,'String')) returns contents of xr2 as a double
xr2 = str2double(get(hObject,'String'));
handles.parameters.xr2 = xr2;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function rr2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rr2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function rr2_Callback(hObject, eventdata, handles)
% hObject    handle to rr2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rr2 as text
%        str2double(get(hObject,'String')) returns contents of rr2 as a double
rr2 = str2double(get(hObject,'String'));
handles.parameters.rr2 = rr2;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function fleff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fleff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function fleff_Callback(hObject, eventdata, handles)
% hObject    handle to fleff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fleff as text
%        str2double(get(hObject,'String')) returns contents of fleff as a double
fleff = str2double(get(hObject,'String'));
handles.specifications.fleff = fleff;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function flpf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to flpf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function flpf_Callback(hObject, eventdata, handles)
% hObject    handle to flpf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of flpf as text
%        str2double(get(hObject,'String')) returns contents of flpf as a double
flpf = str2double(get(hObject,'String'));
handles.specifications.flpf = flpf;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function flslip_CreateFcn(hObject, eventdata, handles)
% hObject    handle to flslip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function flslip_Callback(hObject, eventdata, handles)
% hObject    handle to flslip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of flslip as text
%        str2double(get(hObject,'String')) returns contents of flslip as a double

flslip = str2double(get(hObject,'String'));
handles.specifications.flslip = flslip;
guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function stc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function stc_Callback(hObject, eventdata, handles)
% hObject    handle to stc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stc as text
%        str2double(get(hObject,'String')) returns contents of stc as a double
stc = str2double(get(hObject,'String'));
handles.specifications.stc = stc;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function stt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','c');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function stt_Callback(hObject, eventdata, handles)
% hObject    handle to stt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stt as text
%        str2double(get(hObject,'String')) returns contents of stt as a double
if handles.Type==1
    stt = [];
    set(handles.stt,'String','')
    handles.specifications.stt = [];
    uiwait(msgbox('starting toque may not be specified for a single cage motor','stt warning','modal'))
else
    stt = str2double(get(hObject,'String'));
    handles.specifications.stt = stt;
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function nll_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function nll_Callback(hObject, eventdata, handles)
% hObject    handle to nll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nll as text
%        str2double(get(hObject,'String')) returns contents of nll as a double
nll = str2double(get(hObject,'String'));
handles.specifications.nll = nll;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function isat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to isat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function isat_Callback(hObject, eventdata, handles)
% hObject    handle to isat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of isat as text
%        str2double(get(hObject,'String')) returns contents of isat as a double
isat = str2double(get(hObject,'String'));
if isat == 0
    isat = 10;set(hObject,'String',num2str(10));
    uiwait(msgbox('for zero leakage inductance saturation isat = 10','isat warning','modal'))
end
handles.parameters.isat = isat;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function vrated_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vrated (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function vrated_Callback(hObject, eventdata, handles)
% hObject    handle to vrated (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vrated as text
%        str2double(get(hObject,'String')) returns contents of vrated as a double
Vr = str2double(get(hObject,'String'));
handles.rating.V = Vr;
Ir = handles.rating.I;
if ~isempty(Ir)
    set(handles.BasMva,'String',num2str(sqrt(3)*Vr*Ir))
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function cfl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cfl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function cfl_Callback(hObject, eventdata, handles)
% hObject    handle to cfl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cfl as text
%        str2double(get(hObject,'String')) returns contents of cfl as a double
Ir = str2double(get(hObject,'String'));
Vr = handles.rating.V;
handles.rating.I = Ir;
if~isempty(Vr)    
    BasMva = sqrt(3)*Vr*Ir;
    handles.rating.BasMva = BasMva;
    set(handles.BasMva,'String',num2str(BasMva));
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function dr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function dr_Callback(hObject, eventdata, handles)
% hObject    handle to dr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dr as text
%        str2double(get(hObject,'String')) returns contents of dr as a double
dr = str2double(get(hObject,'String'));
handles.parameters.dr = dr;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function dbf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dbf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function dbf_Callback(hObject, eventdata, handles)
% hObject    handle to dbf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dbf as text
%        str2double(get(hObject,'String')) returns contents of dbf as a double
dbf = str2double(get(hObject,'String'));
handles.parameters.dbf = dbf;
guidata(hObject, handles);


% --------------------------------------------------------------------
function calcpar_Callback(hObject, eventdata, handles)
% hObject    handle to calcpar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
deflag=0;
fleff = handles.specifications.fleff;
if isempty(fleff)||fleff==0;deflag = 1;end
flpf = handles.specifications.flpf;
if isempty(flpf)||flpf==0;deflag = 1;end
flslip = handles.specifications.flslip;
if isempty(flslip)||flslip==0;deflag = 1;end
stc = handles.specifications.stc;
if isempty(stc)||stc==0;deflag = 1;end
stt = handles.specifications.stt;
nll = handles.specifications.nll;
isat = handles.parameters.isat;
vr = handles.rating.V;flc = handles.rating.I;
if isempty(vr)||vr==0;deflag = 1;end
if isempty(flc)||flc==0;deflag = 1;end
if deflag==1
    uiwait(msgbox('insufficient specifications','calcpar error','modal'));
    return
end
Type = handles.Type;
switch Type
case 1
    % single cage
    [rs,xs,Xm,rr,xr,nll,VoltAmp,tfl,isfl,flpf,fleff,tst,ist,eflag]=calcsc(vr,flc,fleff,flpf,flslip,stc,nll,isat);
    if eflag;
        uiwait(msgbox('failed to solve, check specifications','calcsc error','modal'))
        return
    end
    stt = tst/tfl;
    handles.specifications.stt = stt;
    set(handles.stt,'String',num2str(stt));
case 2
    % double cage
    dr = handles.parameters.dr;
    if isempty(dr)||dr==0;
        dr=1;
        handles.parameters.dr = 1;
        set(handles.dr,'String','1');
    end
    if isempty(stt)||stt==0;
       uiwait(msgbox('starting torque not specified','double cage error','modal'));
       return 
    end
    [rs,xs,Xm,rr,xr,rr2,xr2,nll,VoltAmp,tfl,isfl,flpf,fleff,tst,ist,eflag]=calcdc(vr,flc,fleff,flpf,flslip,stt,stc,nll,dr,isat);
    if eflag;
        uiwait(msgbox('failed to solve, check specifications','calcdc error','modal'))
        return
    end
case 3
    % deep bar
    if isempty(stt)||stt==0;
       uiwait(msgbox('starting torque not specified','deep bar error','modal'));
       return 
    end
    [rs,xs,Xm,rr,xr,dbf,nll,VoltAmp,tfl,isfl,flpf,fleff,tst,ist,eflag]=calcdb(vr,flc,fleff,flpf,flslip,stt,stc,nll,isat);
    if eflag;
        uiwait(msgbox('failed to solve, check specifications','calcdb error','modal'))
        return
    end
end
if eflag; return;end
handles.parameters.rs = rs;set(handles.rs,'String',num2str(rs));
handles.parameters.xs = xs;set(handles.xs,'String',num2str(xs));
handles.parameters.Xm = Xm;set(handles.Xm,'String',num2str(Xm));
handles.parameters.rr = rr;set(handles.rr,'String',num2str(rr));
handles.parameters.xr = xr;set(handles.xr,'String',num2str(xr));
handles.specifications.nll = nll;set(handles.nll,'String',num2str(nll));
if Type == 1
    handles.parameters.xr2 = [];set(handles.xr2,'String','');
    handles.parameters.rr2 = [];set(handles.rr2,'String','');
    handles.parameters.dbf = [];set(handles.dbf,'String','');
    handles.parameters.dr = [];set(handles.dr,'String','');
end
if Type==2
    handles.parameters.xr2 = xr2;set(handles.xr2,'String',num2str(xr2));
    handles.parameters.rr2 = rr2;set(handles.rr2,'String',num2str(rr2));
    handles.parameters.dbf = [];set(handles.dbf,'String','');
end
if Type == 3
    handles.parameters.dbf = dbf;set(handles.dbf,'String',num2str(dbf));
    handles.parameters.dr = [];set(handles.dr,'String','');
    handles.parameters.xr2 = [];set(handles.xr2,'String','');
    handles.parameters.rr2 = [];set(handles.rr2,'String','');
end
guidata(hObject, handles);

switch handles.Type
case 1
    'single cage'
    handles.parameters.dr = [];
    handles.parameters.dbf = [];
case 2
    'double cage'
    handles.parameters.dbf = [];
case 3
    'deep bar'
    handles.parameters.dr = [];
end
'parameters'
handles.parameters
'specifications'
handles.specifications
'rating'
handles.rating
% --------------------------------------------------------------------
function calcspec_Callback(hObject, eventdata, handles)
% hObject    handle to calcspec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rs = handles.parameters.rs;
if rs==0
    uiwait(msgbox('all parameters must be specified','calcspec error','modal'))
    return
end
xs = handles.parameters.xs;
Xm = handles.parameters.Xm;
xr = handles.parameters.xr;
rr = handles.parameters.rr;
nll = handles.specifications.nll;
isat = handles.parameters.isat;
Type = handles.Type;
if Type==2
    rr2 = handles.parameters.rr2;
    xr2 = handles.parameters.xr2;
    dr = handles.parameters.dr;
end
if Type ==3
    dbf = handles.parameters.dbf;
end
switch Type
case 1
    %single cage
    [flslip,fleff,flpf,flt,stc,stt,eflag]=perfsc(rs,xs,Xm,rr,xr,nll,isat);
case 2
    % double cage
    [flslip,fleff,flpf,flt,stc,stt,eflag]=perfdc(rs,xs,Xm,rr,xr,rr2,xr2,nll,isat);
case 3
    % deep bar
    [flslip,fleff,flpf,flt,stc,stt,eflag]=perfdb(rs,xs,Xm,rr,xr,dbf,nll,isat);
end
nll = handles.specifications.nll;
flc = 1;
handles.specifications.flslip = flslip;set(handles.flslip,'String',num2str(flslip));
handles.specifications.flpf = flpf;set(handles.flpf,'String',num2str(flpf));
handles.specifications.fleff = flpf;set(handles.fleff,'String',num2str(fleff));
handles.specifications.stc = stc;set(handles.stc,'String',num2str(stc));
handles.specifications.stt = stt;set(handles.stt,'String',num2str(stt));
guidata(hObject,handles);
handles.parameters
handles.specifications
handles.rating

%_____________________________________________________________________
function popt_Callback(hObject, eventdata, handles)
% hObject    handle to plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Tag = get(hObject,'Tag');
switch Tag
case 'overlay'	
	handles.plotopt = 'overlay';
case 'separate'
	handles.plotopt = 'separate';
end
guidata(hObject,handles);
% --------------------------------------------------------------------
function plot_Callback(hObject, eventdata, handles)
% hObject    handle to plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Type = handles.Type;
rs = handles.parameters.rs;
if isempty(rs)
    uiwait(msgbox('the parameters must be avaiable to plot torque','plot error','modal'))
    return
end
xs = handles.parameters.xs;
Xm = handles.parameters.Xm;
xr = handles.parameters.xr;
rr = handles.parameters.rr;
isat = handles.parameters.isat;
sfl = handles.specifications.flslip;
nll = handles.specifications.nll;
switch Type
case 1
    [t,p,q,pfact,is,s,tfl,is1]=scimtspeed(1,rs,xs,Xm,rr,xr,nll,isat,sfl,1);
case 2
    xr2 = handles.parameters.xr2;
    rr2= handles.parameters.rr2;
    [t,p,q,pfact,rre,xre,is,s,tfl,is1]=dcimtspeed(1,rs,xs,Xm,rr,xr,rr2,xr2,nll,isat,sfl,1);
case 3
    dbf = handles.parameters.dbf;
    [t,p,q,pfact,rre,xre,is,s,tfl,is1]=dbimtspeed(1,rs,xs,Xm,rr,xr,dbf,nll,isat,sfl,1);
end
Tag = get(hObject,'Tag');
switch Tag
case 'plttorque'
    if strcmp(handles.plotopt,'separate');
    	figure
    	plot(s,t/tfl);
		xlabel('speed pu');
		ylabel('torque/full load torque')
    	title('torque speed charactersitics')
    else
        if handles.tplot==0;figure;hold;end
        handles.htp = gcf;
    	handles.tplot = handles.tplot+1;
    	tplot = handles.tplot;
    	trange = ceil(tplot/5);
    	if trange>1; tplot = tplot-5;end
    	switch tplot
    	case 1
    		cplot = 'k';
        case 2
        	cplot = 'b';
        case 3
        	cplot = 'g';
        case 4
        	cplot = 'm';
        case 5
        	cplot = 'c';
      	end
    	plot(s,t/tfl,cplot);
    	xlabel('speed pu');
    	ylabel('torque/full load torque')
    	title('torque speed charactersitics')
    end
    guidata(hObject,handles);
case 'pltcur'
    if strcmp(handles.plotopt,'separate');
    	figure
    	plot(s,is/is1);
		xlabel('speed pu');
		ylabel('current/full load current')
    	title('current speed charactersitics')
    else
    	handles.iplot = handles.iplot+1;
    	if handles.iplot ==1;figure;hold;end
    	iplot = handles.iplot;
    	irange = ceil(iplot/5);
    	if irange>1; iplot = iplot-5;end
    	switch iplot
    	case 1
    		cplot = 'k';
        case 2
        	cplot = 'b';
        case 3
        	cplot = 'g';
        case 4
        	cplot = 'm';
        case 5
        	cplot = 'c';
      	end
    	plot(s,is/is1,cplot);
        xlabel('speed pu');
        ylabel('current/full load current')
        title('current speed charactersitics')
    end
    guidata(hObject,handles); 
case 'pltp'
    if strcmp(handles.plotopt,'separate');
    	figure
    	plot(s,p);
		xlabel('speed pu');
		ylabel('power pu')
    	title('power speed charactersitics')
    else
    	handles.pplot = handles.pplot+1;
    	if handles.pplot ==1;figure;hold;end
    	pplot = handles.pplot;
    	prange = ceil(pplot/5);
    	if prange>1; pplot = pplot-5;end
    	switch pplot
    	case 1
    		cplot = 'k';
        case 2
        	cplot = 'b';
        case 3
        	cplot = 'g';
        case 4
        	cplot = 'm';
        case 5
        	cplot = 'c';
      	end
    	plot(s,p,cplot);
        xlabel('speed pu');
        ylabel('power pu')
        title('power speed charactersitics')
    end
    guidata(hObject,handles); 
case 'pltq'
    if strcmp(handles.plotopt,'separate');
    	figure
    	plot(s,q);
		xlabel('speed pu');
		ylabel('reactive power pu')
    	title('reactive power speed charactersitics')
    else
    	handles.qplot = handles.qplot+1;
    	if handles.qplot ==1;figure;hold;end
    	qplot = handles.qplot;
    	qrange = ceil(plot/5);
    	if prange>1; qplot = qplot-5;end
    	switch qplot
    	case 1
    		cplot = 'k';
        case 2
        	cplot = 'b';
        case 3
        	cplot = 'g';
        case 4
        	cplot = 'm';
        case 5
        	cplot = 'c';
      	end
    	plot(s,q,cplot);
        xlabel('speed pu');
        ylabel('reactive power pu')
        title('reactive power speed charactersitics')
    end
    guidata(hObject,handles); 
case 'All'
    figure
    tlab = 'torque/torque full load and power factor';
	ilab = 'p and q pu, and i/i full load';
	[AX,H1,H2]=plotyy(s,[t/tfl;pfact],s,[p;q;is/is1]);hold
	xlabel('speed pu');
	set(get(AX(1),'Ylabel'),'String',tlab)
	set(get(AX(2),'Ylabel'),'String',ilab)
	title('induction motor steady state speed charateristics');
	legend(AX(1),{'torque' 'power factor'},2);legend(AX(2),{'power' 'reactive power' 'current'},1)
end


% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global hfig
Tag = get(hObject,'Tag');
switch Tag
case 'close'
    delete(hfig);
case 'save'
    motname = inputdlg('input motor name','INDSPEC save');
    [fname,pname]=uiputfile('*.mat','save INDSPEC data');
    mot.motname = char(motname);
    mot.specifications = handles.specifications;
    mot.parameters = handles.parameters;
    mot.rating = handles.rating;
    filename = [pname fname];
    mot.Type = handles.Type;
	if fname~=0
        save(filename,'mot');   
	else
        uiwait(msgbox('save cancelled by user','warn','modal'))
	end   
end



% --- Executes on button press in scbut.
function scbut_Callback(hObject, eventdata, handles)
% hObject    handle to scbut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of scbut
value = get(hObject,'Value');
if value == 1
    set(handles.dcbut,'Value',0)
    set(handles.dbbut,'Value',0)
    set(handles.rr2,'Visible','off')
    set(handles.xr2,'Visible','off')
    set(handles.stt,'BackGroundColor','c')
    set(handles.dbf,'Visible','off');set(handles.dbf,'String'.'');
    handles.parameters.dbf = [];
    set(handles.dr,'Visible','off');set(handles.dr,'String','');
    handles.Type = 1;
else
    set(handles.dbbut,'Value',1);
    set(handles.dcbut,'Value',0);
    set(handles.stt,'Visible','on')
    set(handles.dr,'Visible','off');set(handles.dr,'String','');
    handles.parameters.dr = [];
    set(handles.dbf,'Visible','on')
    set(handles.stt,'BackGroundColor',[1 1 1])
    handles.Type = 3;
end
guidata(hObject,handles);
% --- Executes on button press in dcbut.
function dcbut_Callback(hObject, eventdata, handles)
% hObject    handle to dcbut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dcbut
value = get(hObject,'Value');
if value == 1
    set(handles.scbut,'Value',0)
    set(handles.dbbut,'Value',0)
    set(handles.xr2,'Visible','on')
    set(handles.rr2,'Visible','on')
    set(handles.stt,'Visible','on')
    set (handles.dr,'Visible','on')
    set(handles.dbf,'Visible','off')
    set(handles.stt,'BackGroundColor',[1 1 1])
    set(handles.dr,'String','1');
    handles.parameters.dr = 1;
    handles.Type = 2;
else
    set(handles.dbbut,'Value',1);
    set(handles.xr2,'Visible','off')
    set(handles.rr2,'Visible','off')
    set(handles.stt,'Visible','on')
    set(handles.dbf,'Visible','on')
    set(handles.dr,'Visible','off')
    set(handles.scbut,'Value',0)
    set(handles.stt,'BackGroundColor',[1 1 1])
    set(handles.dr,'String','');
    handles.parameters.dr = [];
    handles.Type=3;
end
guidata(hObject,handles);
% --- Executes on button press in dbbut.
function dbbut_Callback(hObject, eventdata, handles)
% hObject    handle to dbbut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dbbut
value = get(hObject,'Value');
if value == 1
    set(handles.scbut,'Value',0)
    set(handles.dcbut,'Value',0)
    set(handles.xr2,'Visible','off')
    set(handles.rr2,'Visible','off')
    set(handles.stt,'Visible','on')
    set(handles.dr,'Visible','off');
    set(handles.dr,'String','');handles.parameters.dr = [];
    set(handles.dbf,'Visible','on');
    set(handles.dbf,'String','');handles.parameters.dbf = [];
    set(handles.stt,'BackGroundColor',[1 1 1])
    handles.Type=3;
else
    set(handles.dcbut,'Value',1);
    set(handles.xr2,'Visible','on')
    set(handles.rr2,'Visible','on')
    set(handles.scbut,'Value',0)
    set(handles.stt,'Visible','on')
    set(handles.dr,'Visible','on');
    set(handles.dbf,'Visible',off);handles.parameters.dbf = [];
    set(handles.dbf,'String','');
    set(handles.dr,'String','1');handles.parameters.dr=1;
    set(handles.stt,'BackGroundColor',[1 1 1])
    handles.Type=2;
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function BasMva_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BasMva (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function BasMva_Callback(hObject, eventdata, handles)
% hObject    handle to BasMva (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BasMva as text
%        str2double(get(hObject,'String')) returns contents of BasMva as a double


% --- Executes on button press in clearpar.
function clearpar_Callback(hObject, eventdata, handles)
% hObject    handle to clearpar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.parameters.rs = [];set(handles.rs,'String','');
handles.parameters.xs = [];set(handles.xs,'String','');
handles.parameters.rr = [];set(handles.rr,'String','');
handles.parameters.xr = [];set(handles.xr,'String','');
handles.parameters.rr2 = [];set(handles.rr2,'String','');
handles.parameters.xr2 = [];set(handles.xr2,'String','');
handles.parameters.Xm = [];set(handles.Xm,'String','');
handles.parameters.dbf = [];set(handles.dbf,'String','');
guidata(hObject,handles);

% --- Executes on button press in clearspec.
function clearspec_Callback(hObject, eventdata, handles)
% hObject    handle to clearspec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.specifications.fleff = [];set(handles.fleff,'String','');
handles.specifications.flpf = [];set(handles.flpf,'String','');
handles.specifications.flslip = [];set(handles.flslip,'String','');
handles.specifications.stc = [];set(handles.stc,'String','');
handles.specifications.stt = [];set(handles.stt,'String','');
guidata(hObject,handles);


% --------------------------------------------------------------------
function dynsim_Callback(hObject, eventdata, handles)
% hObject    handle to dynsim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% runs dynamic simulation
tsim = inputdlg('enter the required simulation time in s');tsim = str2num(tsim{1});
if isempty(tsim)
    tsim = 10;
    uiwait(msgbox('simulation time set to 10s','INDSPEC Simulation Message','.modal'))
end
H = inputdlg('enter the inertia constant'); H = str2num(H{1});
if isempty(H);
    H=1;
    uiwait(msgbox('inertia constant set to 1s','INDSPEC Simulation Message','modal'))
end
f = inputdlg('enter the supply frequency Hz');f=str2num(f{1});
if isempty(f);
    f=60;
    uiwait(msgbox('frequency set to 60 Hz','INDSPEC Simulation Message','modal'))
end
tfr = inputdlg('enter the load stiction coefficient');tfr = str2num(tfr{1});
if isempty(tfr);
    tfr = 0;
    uiwait(msgbox('tfr set to zero','INDSPEC Simulation Message','modal'))
end
tld = inputdlg('enter the load  coefficient');tld = str2num(tld{1});
if isempty(tld);
    tld = 0;
    uiwait(msgbox('tld set to zero','INDSPEC Simulation Message','modal'))
end
rs = handles.parameters.rs;
xs = handles.parameters.xs;
Xm = handles.parameters.Xm;
xr = handles.parameters.xr;
rr = handles.parameters.rr;
isat = handles.parameters.isat;
if get(handles.scbut,'Value')
    % simulate single cage motor start-up
    [xff,mcurr,xslow,te,tes,tff,ts]= sc2simu(1,f,tfr,tld,rs,xs,Xm,rr,xr,isat,H,tsim);
    figure
    plot(tff,te);
    title('starting torque')
    xlabel('time s')
    ylabel('torque pu')
    motname = inputdlg('input motor name','INDSPEC save');
    [fname,pname]=uiputfile('*.mat','save INDSPEC data');
    mot.motname = char(motname);
    mot.specifications = handles.specifications;
    mot.parameters = handles.parameters;
    mot.rating = handles.rating;
    mot.response.xff = xff;
    mot.response.mcurr = mcurr;
    mot.response.xslow = xslow;
    mot.response.te = te;
    mot.response.tes = tes;
    mot.response.tff = tff;
    mot.response.ts = ts;
    filename = [pname fname];
    mot.Type = handles.Type;
	if fname~=0
        save(filename,'mot');   
	else
        uiwait(msgbox('save cancelled by user','warn','modal'))
	end
end
if get(handles.dcbut,'Value')
    xr2 = handles.parameters.xr2;
    rr2 = handles.parameters.rr2;
    % simulate double cage motor start-up
    [xff,mcurr,xslow,te,tes,requ,xequ,tff,ts]= dc2simu(1,f,tfr,tld,rs,xs,Xm,rr,rr2,xr,xr2,isat,H,tsim);
    figure
    plot(tff,te);
    title('starting torque')
    xlabel('time s')
    ylabel('torque pu')
    motname = inputdlg('input motor name','INDSPEC save');
    [fname,pname]=uiputfile('*.mat','save INDSPEC data');
    mot.motname = char(motname);
    mot.specifications = handles.specifications;
    mot.parameters = handles.parameters;
    mot.rating = handles.rating;
    mot.response.xff = xff;
    mot.response.mcurr = mcurr;
    mot.response.xslow = xslow;
    mot.response.te = te;
    mot.response.tes = tes;
    mot.response.tff = tff;
    mot.response.ts = ts;
    mot.response.requ = requ;
    mot.response.xequ = xequ;
    filename = [pname fname];
    mot.Type = handles.Type;
	if fname~=0
        save(filename,'mot');   
	else
        uiwait(msgbox('save cancelled by user','warn','modal'))
	end 
end
if get(handles.dbbut,'Value')
    dbf = handles.parameters.dbf;
    % simulate double cage motor start-up
    [xff,mcurr,xslow,te,tes,requ,xequ,tff,ts]= db2simu(1,f,tfr,tld,rs,xs,Xm,rr,xr,dbf,isat,H,tsim);
    figure
    plot(tff,te);
    title('starting torque')
    xlabel('time s')
    ylabel('torque pu')
    motname = inputdlg('input motor name','INDSPEC save');
    [fname,pname]=uiputfile('*.mat','save INDSPEC data');
    mot.motname = char(motname);
    mot.specifications = handles.specifications;
    mot.parameters = handles.parameters;
    mot.rating = handles.rating;
    mot.response.xff = xff;
    mot.response.mcurr = mcurr;
    mot.response.xslow = xslow;
    mot.response.te = te;
    mot.response.tes = tes;
    mot.response.tff = tff;
    mot.response.ts = ts;
    mot.response.requ = requ;
    mot.response.xequ = xequ;
    filename = [pname fname];
    mot.Type = handles.Type;
	if fname~=0
        save(filename,'mot');   
	else
        uiwait(msgbox('save cancelled by user','warn','modal'))
	end 
end   


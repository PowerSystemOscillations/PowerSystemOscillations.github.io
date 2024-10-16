function varargout = INSPECT_export(varargin)
% INSPECT_export M-file for INSPECT_export.fig
%      INSPECT_export, by itself, creates a new INSPECT_export or raises the existing
%      singleton*.
%
%      H = INSPECT_export returns the handle to a new INSPECT_export or the handle to
%      the existing singleton*.
%
%      INSPECT_export('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INSPECT_export.M with the given input arguments.
%
%      INSPECT_export('Property','Value',...) creates a new INSPECT_export or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before INSPECT_export_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to INSPECT_export_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help INSPECT_export

% Last Modified by GUIDE v2.5 08-May-2003 08:38:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @INSPECT_export_OpeningFcn, ...
                   'gui_OutputFcn',  @INSPECT_export_OutputFcn, ...
                   'gui_LayoutFcn',  @INSPECT_export_LayoutFcn, ...
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


% --- Executes just before INSPECT_export is made visible.
function INSPECT_export_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to INSPECT_export (see VARARGIN)
% Choose default command line output for INSPECT_export
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

% UIWAIT makes INSPECT_export wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = INSPECT_export_OutputFcn(hObject, eventdata, handles)
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
set(handles.BasMva,'String',num2str(sqrt(3)*Vr*Ir))
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
BasMva = sqrt(3)*Vr*Ir;
handles.rating.BasMva = BasMva;
set(handles.BasMva,'String',num2str(BasMva));
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
if isempty(fleff)|fleff==0;deflag = 1;end
flpf = handles.specifications.flpf;
if isempty(flpf)|flpf==0;deflag = 1;end
flslip = handles.specifications.flslip;
if isempty(flslip)|flslip==0;deflag = 1;end
stc = handles.specifications.stc;
if isempty(stc)|stc==0;deflag = 1;end
stt = handles.specifications.stt;
nll = handles.specifications.nll;
isat = handles.parameters.isat;
vr = handles.rating.V;flc = handles.rating.I;
if isempty(vr)|vr==0;deflag = 1;end
if isempty(flc)|flc==0;deflag = 1;end
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
    if isempty(dr)|dr==0;
        dr=1;
        handles.parameters.dr = 1;
        set(handles.dr,'String','1');
    end
    if isempty(stt)|stt==0;
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
    if isempty(stt)|stt==0;
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
nll = handles.specifications.nll
isat = handles.parameters.isat;
Type = handles.Type
if Type==2
    rr2 = handles.parameters.rr2;
    xr2 = handles.parameters.xr2;
    dr = handles.parameters.dr;
end
if Type ==3
    dbf = handles.parameters.dbf
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
Tag = get(hObject,'Tag')
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
    motname = inputdlg('input motor name','INSPECT save');
    [fname,pname]=uiputfile('*.mat','save INSPECT data');
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
    uiwait(msgbox('simulation time set to 10s','INSPECT Simulation Message','.modal'))
end
H = inputdlg('enter the inertia constant'); H = str2num(H{1});
if isempty(H);
    H=1;
    uiwait(msgbox('inertia constant set to 1s','INSPECT Simulation Message','modal'))
end
f = inputdlg('enter the supply frequency Hz');f=str2num(f{1});
if isempty(f);
    f=60;
    uiwait(msgbox('frequency set to 60 Hz','INSPECT Simulation Message','modal'))
end
tfr = inputdlg('enter the load stiction coefficient');tfr = str2num(tfr{1});
if isempty(tfr);
    tfr = 0;
    uiwait(msgbox('tfr set to zero','INSPECT Simulation Message','modal'))
end
tld = inputdlg('enter the load  coefficient');tld = str2num(tld{1});
if isempty(tld);
    tld = 0;
    uiwait(msgbox('tld set to zero','INSPECT Simulation Message','modal'))
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
    motname = inputdlg('input motor name','INSPECT save');
    [fname,pname]=uiputfile('*.mat','save INSPECT data');
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
    motname = inputdlg('input motor name','INSPECT save');
    [fname,pname]=uiputfile('*.mat','save INSPECT data');
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
    motname = inputdlg('input motor name','INSPECT save');
    [fname,pname]=uiputfile('*.mat','save INSPECT data');
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



% --- Creates and returns a handle to the GUI figure. 
function h1 = INSPECT_export_LayoutFcn(policy)
% policy - create a new figure or use a singleton. 'new' or 'reuse'.

persistent hsingleton;
if strcmpi(policy, 'reuse') & ishandle(hsingleton)
    h1 = hsingleton;
    return;
end

h1 = figure(...
'Units','characters',...
'Color',[0.831372549019608 0.815686274509804 0.784313725490196],...
'Colormap',[0 0 0.5625;0 0 0.625;0 0 0.6875;0 0 0.75;0 0 0.8125;0 0 0.875;0 0 0.9375;0 0 1;0 0.0625 1;0 0.125 1;0 0.1875 1;0 0.25 1;0 0.3125 1;0 0.375 1;0 0.4375 1;0 0.5 1;0 0.5625 1;0 0.625 1;0 0.6875 1;0 0.75 1;0 0.8125 1;0 0.875 1;0 0.9375 1;0 1 1;0.0625 1 1;0.125 1 0.9375;0.1875 1 0.875;0.25 1 0.8125;0.3125 1 0.75;0.375 1 0.6875;0.4375 1 0.625;0.5 1 0.5625;0.5625 1 0.5;0.625 1 0.4375;0.6875 1 0.375;0.75 1 0.3125;0.8125 1 0.25;0.875 1 0.1875;0.9375 1 0.125;1 1 0.0625;1 1 0;1 0.9375 0;1 0.875 0;1 0.8125 0;1 0.75 0;1 0.6875 0;1 0.625 0;1 0.5625 0;1 0.5 0;1 0.4375 0;1 0.375 0;1 0.3125 0;1 0.25 0;1 0.1875 0;1 0.125 0;1 0.0625 0;1 0 0;0.9375 0 0;0.875 0 0;0.8125 0 0;0.75 0 0;0.6875 0 0;0.625 0 0;0.5625 0 0],...
'IntegerHandle','off',...
'InvertHardcopy',get(0,'defaultfigureInvertHardcopy'),...
'MenuBar','none',...
'Name','INSPECT',...
'NumberTitle','off',...
'PaperPosition',get(0,'defaultfigurePaperPosition'),...
'Position',[103.8 29.1538461538462 112 32.3076923076923],...
'Renderer',get(0,'defaultfigureRenderer'),...
'RendererMode','manual',...
'Resize','off',...
'HandleVisibility','off',...
'Tag','figure1',...
'UserData',zeros(1,0));

setappdata(h1, 'GUIDEOptions', struct(...
'active_h', 1.020033e+002, ...
'taginfo', struct(...
'figure', 2, ...
'pushbutton', 8, ...
'edit', 20, ...
'text', 28, ...
'frame', 2, ...
'radiobutton', 4), ...
'override', 1, ...
'release', 13, ...
'resize', 'none', ...
'accessibility', 'off', ...
'mfile', 1, ...
'callbacks', 1, ...
'singleton', 1, ...
'syscolorfig', 1, ...
'lastSavedFile', 'C:\MATLAB6p5\inspect\INSPECT.m'));


h2 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','INSPECT_export(''rs_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[19.8 23 9.8 1.61538461538462],...
'String','',...
'Style','edit',...
'CreateFcn','INSPECT_export(''rs_CreateFcn'',gcbo,[],guidata(gcbo))',...
'Tag','rs');


h3 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','INSPECT_export(''xs_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[19.8 21.3846153846154 9.8 1.61538461538462],...
'String','',...
'Style','edit',...
'CreateFcn','INSPECT_export(''xs_CreateFcn'',gcbo,[],guidata(gcbo))',...
'Tag','xs');


h4 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','INSPECT_export(''Xm_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[19.8 19.7692307692308 9.8 1.61538461538462],...
'String',' ',...
'Style','edit',...
'CreateFcn','INSPECT_export(''Xm_CreateFcn'',gcbo,[],guidata(gcbo))',...
'Tag','Xm');


h5 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','INSPECT_export(''xr_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[19.8 18 9.8 1.69230769230769],...
'String',' ',...
'Style','edit',...
'CreateFcn','INSPECT_export(''xr_CreateFcn'',gcbo,[],guidata(gcbo))',...
'Tag','xr');


h6 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','INSPECT_export(''rr_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[19.8 16.5384615384615 9.8 1.61538461538462],...
'String',' ',...
'Style','edit',...
'CreateFcn','INSPECT_export(''rr_CreateFcn'',gcbo,[],guidata(gcbo))',...
'Tag','rr');


h7 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','INSPECT_export(''xr2_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[20 15 9.6 1.53846153846154],...
'String',' ',...
'Style','edit',...
'CreateFcn','INSPECT_export(''xr2_CreateFcn'',gcbo,[],guidata(gcbo))',...
'Tag','xr2',...
'Visible','off');


h8 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','INSPECT_export(''rr2_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[19.8 13.3076923076923 9.8 1.61538461538462],...
'String',' ',...
'Style','edit',...
'CreateFcn','INSPECT_export(''rr2_CreateFcn'',gcbo,[],guidata(gcbo))',...
'Tag','rr2',...
'Visible','off');


h9 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'ListboxTop',0,...
'Position',[8.6 23.2307692307692 10.2 1.15384615384615],...
'String','rs',...
'Style','text',...
'Tag','text1');


h10 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'ListboxTop',0,...
'Position',[8.6 21.4615384615385 10.2 1.15384615384615],...
'String','xs',...
'Style','text',...
'Tag','text2');


h11 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'ListboxTop',0,...
'Position',[8.6 19.6153846153846 10.2 1.15384615384615],...
'String','Xm',...
'Style','text',...
'Tag','text3');


h12 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'ListboxTop',0,...
'Position',[8.6 17.9230769230769 10.2 1.15384615384615],...
'String','xr',...
'Style','text',...
'Tag','text4');


h13 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'ListboxTop',0,...
'Position',[8.6 16.2307692307692 10.2 1.15384615384615],...
'String','rr',...
'Style','text',...
'Tag','text5');


h14 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'ListboxTop',0,...
'Position',[8.6 14.7692307692308 10.2 1.15384615384615],...
'String','xr2',...
'Style','text',...
'Tag','text6');


h15 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'ListboxTop',0,...
'Position',[8.6 13.2307692307692 10.2 1.15384615384615],...
'String','rr2',...
'Style','text',...
'Tag','text7');


h16 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','INSPECT_export(''fleff_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[79.8 22.9230769230769 9.8 1.61538461538462],...
'String',' ',...
'Style','edit',...
'CreateFcn','INSPECT_export(''fleff_CreateFcn'',gcbo,[],guidata(gcbo))',...
'Tag','fleff');


h17 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','INSPECT_export(''flpf_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[79.8 21.3076923076923 9.8 1.61538461538462],...
'String',' ',...
'Style','edit',...
'CreateFcn','INSPECT_export(''flpf_CreateFcn'',gcbo,[],guidata(gcbo))',...
'Tag','flpf');


h18 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','INSPECT_export(''flslip_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[79.8 19.6923076923077 9.8 1.61538461538462],...
'String',' ',...
'Style','edit',...
'CreateFcn','INSPECT_export(''flslip_CreateFcn'',gcbo,[],guidata(gcbo))',...
'Tag','flslip');


h19 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','INSPECT_export(''stc_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[79.8 17.9230769230769 10 1.76923076923077],...
'String',' ',...
'Style','edit',...
'CreateFcn','INSPECT_export(''stc_CreateFcn'',gcbo,[],guidata(gcbo))',...
'Tag','stc');


h20 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[0 1 1],...
'Callback','INSPECT_export(''stt_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[79.8 16.4615384615385 9.8 1.61538461538462],...
'String',' ',...
'Style','edit',...
'CreateFcn','INSPECT_export(''stt_CreateFcn'',gcbo,[],guidata(gcbo))',...
'Tag','stt');


h21 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','INSPECT_export(''nll_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[79.8 14.7692307692308 10 1.69230769230769],...
'String',' 0',...
'Style','edit',...
'CreateFcn','INSPECT_export(''nll_CreateFcn'',gcbo,[],guidata(gcbo))',...
'Tag','nll');


h22 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','INSPECT_export(''isat_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[79.8 13.2307692307692 9.8 1.61538461538462],...
'String',' 10',...
'Style','edit',...
'CreateFcn','INSPECT_export(''isat_CreateFcn'',gcbo,[],guidata(gcbo))',...
'Tag','isat');


h23 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'ListboxTop',0,...
'Position',[60.6 23.1538461538462 17.6 1.15384615384615],...
'String','full load efficiency',...
'Style','text',...
'Tag','text8');


h24 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'ListboxTop',0,...
'Position',[57.4 21.3846153846154 20.8 1.15384615384615],...
'String','full load power factor',...
'Style','text',...
'Tag','text9');


h25 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'ListboxTop',0,...
'Position',[61 19.8461538461538 17.4 1.15384615384615],...
'String','full load slip',...
'Style','text',...
'Tag','text10');


h26 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'ListboxTop',0,...
'Position',[47.4 17.9230769230769 31 1.46153846153846],...
'String','starting current /full load current',...
'Style','text',...
'Tag','text11');


h27 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'ListboxTop',0,...
'Position',[49.8 16.5384615384615 28.8 1.15384615384615],...
'String','starting torque/full load torque',...
'Style','text',...
'Tag','text12');


h28 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'ListboxTop',0,...
'Position',[66.4 14.9230769230769 11.6 1.15384615384615],...
'String','no load loss',...
'Style','text',...
'Tag','text13');


h29 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'ListboxTop',0,...
'Position',[45.4 13.1538461538462 32.8 1.15384615384615],...
'String','saturation current/full load current',...
'Style','text',...
'Tag','text14');


h30 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'ListboxTop',0,...
'Position',[3.4 25.7692307692308 45 1.23076923076923],...
'String','Equivalent Circuit Parameters PU on MVA base',...
'Style','text',...
'Tag','text15');


h31 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'ListboxTop',0,...
'Position',[67 25.7692307692308 28 1.30769230769231],...
'String','Performace Specifications',...
'Style','text',...
'Tag','text16');


h32 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','INSPECT_export(''vrated_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[20.2 2.46153846153846 9.4 1.61538461538462],...
'String',' ',...
'Style','edit',...
'CreateFcn','INSPECT_export(''vrated_CreateFcn'',gcbo,[],guidata(gcbo))',...
'Tag','vrated');


h33 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','INSPECT_export(''cfl_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[53.6 2.38461538461538 9.4 1.61538461538462],...
'String',' ',...
'Style','edit',...
'CreateFcn','INSPECT_export(''cfl_CreateFcn'',gcbo,[],guidata(gcbo))',...
'Tag','cfl');


h34 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'ListboxTop',0,...
'Position',[1.8 2.61538461538462 17.8 1.23076923076923],...
'String','rated voltage (KV)',...
'Style','text',...
'Tag','text17');


h35 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'ListboxTop',0,...
'Position',[31.6 2.53846153846154 21.6 1.23076923076923],...
'String','full load current (KA)',...
'Style','text',...
'Tag','text18');


h36 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','INSPECT_export(''dr_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[58.4 7.46153846153846 9.4 1.61538461538462],...
'String',' 1',...
'Style','edit',...
'CreateFcn','INSPECT_export(''dr_CreateFcn'',gcbo,[],guidata(gcbo))',...
'Tag','dr',...
'Visible','off');


h37 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','INSPECT_export(''dbf_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[58.2 9.46153846153846 9.4 1.61538461538462],...
'String',' ',...
'Style','edit',...
'CreateFcn','INSPECT_export(''dbf_CreateFcn'',gcbo,[],guidata(gcbo))',...
'Tag','dbf',...
'Visible','off');


h38 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'ListboxTop',0,...
'Position',[42 9.69230769230769 15 1.15384615384615],...
'String','deep bar factor',...
'Style','text',...
'Tag','text19');


h39 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'ListboxTop',0,...
'Position',[44 7.53846153846154 14.2 1.23076923076923],...
'String','design ratio',...
'Style','text',...
'Tag','text20');


h40 = uimenu(...
'Parent',h1,...
'Label','File',...
'Tag','File');

h41 = uimenu(...
'Parent',h40,...
'Callback','INSPECT_export(''File_Callback'',gcbo,[],guidata(gcbo))',...
'Label','save',...
'Tag','save');

h42 = uimenu(...
'Parent',h40,...
'Callback','INSPECT_export(''File_Callback'',gcbo,[],guidata(gcbo))',...
'Label','close',...
'Separator','on',...
'Tag','close');

h43 = uimenu(...
'Parent',h1,...
'Callback','INSPECT_export(''plot_Callback'',gcbo,[],guidata(gcbo))',...
'Label','Plot',...
'Tag','plot');

h44 = uimenu(...
'Parent',h43,...
'Callback','INSPECT_export(''plot_Callback'',gcbo,[],guidata(gcbo))',...
'Label','torque',...
'Tag','plttorque');

h45 = uimenu(...
'Parent',h43,...
'Callback','INSPECT_export(''plot_Callback'',gcbo,[],guidata(gcbo))',...
'Label','current',...
'Tag','pltcur');

h46 = uimenu(...
'Parent',h43,...
'Callback','INSPECT_export(''plot_Callback'',gcbo,[],guidata(gcbo))',...
'Label','active power',...
'Tag','pltp');

h47 = uimenu(...
'Parent',h43,...
'Callback','INSPECT_export(''plot_Callback'',gcbo,[],guidata(gcbo))',...
'Label','reactive power',...
'Tag','pltq');

h48 = uimenu(...
'Parent',h43,...
'Callback','INSPECT_export(''plot_Callback'',gcbo,[],guidata(gcbo))',...
'Label','All',...
'Tag','All');

h49 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'FontSize',14,...
'ListboxTop',0,...
'Position',[29.8 28.4615384615385 40.2 2.53846153846154],...
'String','INSPECT',...
'Style','text',...
'Tag','text21');


h50 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'ListboxTop',0,...
'Position',[70 5.07692307692308 26.6 7.46153846153846],...
'String','',...
'Style','frame',...
'Tag','frame1');


h51 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','INSPECT_export(''scbut_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[74.4 9.07692307692308 16 1.15384615384615],...
'String','single cage',...
'Style','radiobutton',...
'Value',1,...
'Tag','scbut');


h52 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','INSPECT_export(''dcbut_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[74.4 7.92307692307692 16 1.15384615384615],...
'String','double cage',...
'Style','radiobutton',...
'Tag','dcbut');


h53 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','INSPECT_export(''dbbut_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[74.4 6.61538461538462 16 1.15384615384615],...
'String','deep bar',...
'Style','radiobutton',...
'Tag','dbbut');


h54 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'ListboxTop',0,...
'Position',[77.2 10.6153846153846 11 1.15384615384615],...
'String','Motor Type',...
'Style','text',...
'Tag','text22');


h55 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','INSPECT_export(''calcpar_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[1.4 9.07692307692308 15.6 1.84615384615385],...
'String','parameters',...
'Tag','calcpar');


h56 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','INSPECT_export(''calcspec_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[1.6 6.61538461538462 15 2],...
'String','specifications',...
'Tag','calcspec');


h57 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'ListboxTop',0,...
'Position',[4.2 11.3846153846154 10.2 1.15384615384615],...
'String','calculate',...
'Style','text',...
'Tag','text23');


h58 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'ListboxTop',0,...
'Position',[79 2.61538461538462 10.2 1.15384615384615],...
'String','Base MVA',...
'Style','text',...
'Tag','text25');


h59 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'ListboxTop',0,...
'Position',[92.6 2.61538461538462 10.2 1.15384615384615],...
'String',' ',...
'Style','text',...
'Tag','BasMva');


h60 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','INSPECT_export(''clearpar_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[21.4 9.15384615384616 14.8 1.76923076923077],...
'String','parameters',...
'Tag','clearpar');


h61 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'ListboxTop',0,...
'Position',[23.2 11.2307692307692 10.2 1.15384615384615],...
'String','clear',...
'Style','text',...
'Tag','text27');


h62 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','INSPECT_export(''clearspec_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[21.2 6.92307692307692 15 1.76923076923077],...
'String','specifications',...
'Tag','clearspec');


h63 = uimenu(...
'Parent',h1,...
'Callback','INSPECT_export(''popt_Callback'',gcbo,[],guidata(gcbo))',...
'Label','Plot Options',...
'Tag','popt');

h64 = uimenu(...
'Parent',h63,...
'Callback','INSPECT_export(''popt_Callback'',gcbo,[],guidata(gcbo))',...
'Label','overlay new plots',...
'Tag','overlay');

h65 = uimenu(...
'Parent',h63,...
'Callback','INSPECT_export(''popt_Callback'',gcbo,[],guidata(gcbo))',...
'Checked','on',...
'Label','separate plots',...
'Tag','separate');

h66 = uimenu(...
'Parent',h1,...
'Callback','INSPECT_export(''dynsim_Callback'',gcbo,[],guidata(gcbo))',...
'Label','Simulate Start',...
'Tag','dynsim');


hsingleton = h1;


% --- Handles default GUIDE GUI creation and callback dispatch
function varargout = gui_mainfcn(gui_State, varargin)


%   GUI_MAINFCN provides these command line APIs for dealing with GUIs
%
%      INSPECT_EXPORT, by itself, creates a new INSPECT_EXPORT or raises the existing
%      singleton*.
%
%      H = INSPECT_EXPORT returns the handle to a new INSPECT_EXPORT or the handle to
%      the existing singleton*.
%
%      INSPECT_EXPORT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INSPECT_EXPORT.M with the given input arguments.
%
%      INSPECT_EXPORT('Property','Value',...) creates a new INSPECT_EXPORT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".

%   Copyright 1984-2002 The MathWorks, Inc.
%   $Revision: 1.4 $ $Date: 2002/05/31 21:44:31 $

gui_StateFields =  {'gui_Name'
                    'gui_Singleton'
                    'gui_OpeningFcn'
                    'gui_OutputFcn'
                    'gui_LayoutFcn'
                    'gui_Callback'};
gui_Mfile = '';
for i=1:length(gui_StateFields)
    if ~isfield(gui_State, gui_StateFields{i})
        error('Could not find field %s in the gui_State struct in GUI M-file %s', gui_StateFields{i}, gui_Mfile);        
    elseif isequal(gui_StateFields{i}, 'gui_Name')
        gui_Mfile = [getfield(gui_State, gui_StateFields{i}), '.m'];
    end
end

numargin = length(varargin);

if numargin == 0
    % INSPECT_EXPORT
    % create the GUI
    gui_Create = 1;
elseif numargin > 3 & ischar(varargin{1}) & ishandle(varargin{2})
    % INSPECT_EXPORT('CALLBACK',hObject,eventData,handles,...)
    gui_Create = 0;
else
    % INSPECT_EXPORT(...)
    % create the GUI and hand varargin to the openingfcn
    gui_Create = 1;
end

if gui_Create == 0
    varargin{1} = gui_State.gui_Callback;
    if nargout
        [varargout{1:nargout}] = feval(varargin{:});
    else
        feval(varargin{:});
    end
else
    if gui_State.gui_Singleton
        gui_SingletonOpt = 'reuse';
    else
        gui_SingletonOpt = 'new';
    end
    
    % Open fig file with stored settings.  Note: This executes all component
    % specific CreateFunctions with an empty HANDLES structure.
    
    % Do feval on layout code in m-file if it exists
    if ~isempty(gui_State.gui_LayoutFcn)
        gui_hFigure = feval(gui_State.gui_LayoutFcn, gui_SingletonOpt);
    else
        gui_hFigure = local_openfig(gui_State.gui_Name, gui_SingletonOpt);            
        % If the figure has InGUIInitialization it was not completely created
        % on the last pass.  Delete this handle and try again.
        if isappdata(gui_hFigure, 'InGUIInitialization')
            delete(gui_hFigure);
            gui_hFigure = local_openfig(gui_State.gui_Name, gui_SingletonOpt);            
        end
    end
    
    % Set flag to indicate starting GUI initialization
    setappdata(gui_hFigure,'InGUIInitialization',1);

    % Fetch GUIDE Application options
    gui_Options = getappdata(gui_hFigure,'GUIDEOptions');
    
    if ~isappdata(gui_hFigure,'GUIOnScreen')
        % Adjust background color
        if gui_Options.syscolorfig 
            set(gui_hFigure,'Color', get(0,'DefaultUicontrolBackgroundColor'));
        end

        % Generate HANDLES structure and store with GUIDATA
        guidata(gui_hFigure, guihandles(gui_hFigure));
    end
    
    % If user specified 'Visible','off' in p/v pairs, don't make the figure
    % visible.
    gui_MakeVisible = 1;
    for ind=1:2:length(varargin)
        if length(varargin) == ind
            break;
        end
        len1 = min(length('visible'),length(varargin{ind}));
        len2 = min(length('off'),length(varargin{ind+1}));
        if ischar(varargin{ind}) & ischar(varargin{ind+1}) & ...
                strncmpi(varargin{ind},'visible',len1) & len2 > 1
            if strncmpi(varargin{ind+1},'off',len2)
                gui_MakeVisible = 0;
            elseif strncmpi(varargin{ind+1},'on',len2)
                gui_MakeVisible = 1;
            end
        end
    end
    
    % Check for figure param value pairs
    for index=1:2:length(varargin)
        if length(varargin) == index
            break;
        end
        try, set(gui_hFigure, varargin{index}, varargin{index+1}), catch, break, end
    end

    % If handle visibility is set to 'callback', turn it on until finished
    % with OpeningFcn
    gui_HandleVisibility = get(gui_hFigure,'HandleVisibility');
    if strcmp(gui_HandleVisibility, 'callback')
        set(gui_hFigure,'HandleVisibility', 'on');
    end
    
    feval(gui_State.gui_OpeningFcn, gui_hFigure, [], guidata(gui_hFigure), varargin{:});
    
    if ishandle(gui_hFigure)
        % Update handle visibility
        set(gui_hFigure,'HandleVisibility', gui_HandleVisibility);
        
        % Make figure visible
        if gui_MakeVisible
            set(gui_hFigure, 'Visible', 'on')
            if gui_Options.singleton 
                setappdata(gui_hFigure,'GUIOnScreen', 1);
            end
        end

        % Done with GUI initialization
        rmappdata(gui_hFigure,'InGUIInitialization');
    end
    
    % If handle visibility is set to 'callback', turn it on until finished with
    % OutputFcn
    if ishandle(gui_hFigure)
        gui_HandleVisibility = get(gui_hFigure,'HandleVisibility');
        if strcmp(gui_HandleVisibility, 'callback')
            set(gui_hFigure,'HandleVisibility', 'on');
        end
        gui_Handles = guidata(gui_hFigure);
    else
        gui_Handles = [];
    end
    
    if nargout
        [varargout{1:nargout}] = feval(gui_State.gui_OutputFcn, gui_hFigure, [], gui_Handles);
    else
        feval(gui_State.gui_OutputFcn, gui_hFigure, [], gui_Handles);
    end
    
    if ishandle(gui_hFigure)
        set(gui_hFigure,'HandleVisibility', gui_HandleVisibility);
    end
end    

function gui_hFigure = local_openfig(name, singleton)
if nargin('openfig') == 3 
    gui_hFigure = openfig(name, singleton, 'auto');
else
    % OPENFIG did not accept 3rd input argument until R13,
    % toggle default figure visible to prevent the figure
    % from showing up too soon.
    gui_OldDefaultVisible = get(0,'defaultFigureVisible');
    set(0,'defaultFigureVisible','off');
    gui_hFigure = openfig(name, singleton);
    set(0,'defaultFigureVisible',gui_OldDefaultVisible);
end


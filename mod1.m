function varargout = mod1(varargin)
% MOD1 M-file for mod1.fig
%      MOD1, by itself, creates a new MOD1 or raises the existing
%      singleton*.
%
%      H = MOD1 returns the handle to a new MOD1 or the handle to
%      the existing singleton*.
%
%      MOD1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MOD1.M with the given input arguments.
%
%      MOD1('Property','Value',...) creates a new MOD1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mod1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mod1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mod1

% Last Modified by GUIDE v2.5 21-Jan-2014 22:26:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mod1_OpeningFcn, ...
                   'gui_OutputFcn',  @mod1_OutputFcn, ...
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


% --- Executes just before mod1 is made visible.
function mod1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mod1 (see VARARGIN)

handles.img_original = cell(1,3);
handles.img_actual = cell(1,3);

handles.axes = cell(1,3);
handles.axes{1} = handles.axes_img_1;
handles.axes{2} = handles.axes_img_2;
handles.axes{3} = handles.axes_img_3;

handles.axes_position = cell(1,3);
handles.axes_colorbar_position = cell(1,3);

for i=1:3
    handles.axes_position{i} = get(handles.axes{i},'Position');
    colorbar('Peer', handles.axes{i});
    handles.axes_colorbar_position{i} = get(handles.axes{i},'Position');
    colorbar('delete', 'Peer', handles.axes{i});
    set(handles.axes{i}, 'Position', handles.axes_position{i});
    axes(handles.axes{i});
    axis off;
end    


handles.color_seleccion = cell(1,2);
handles.color_seleccion{1} = [0.9 0.9 0.9];
handles.color_seleccion{2} = get(handles.panel_img_1,'BackgroundColor');
handles.img_seleccionada = 1;

handles.sizes = cell(1,3);
handles.sizes{1} = handles.img_size_1;
handles.sizes{2} = handles.img_size_2;
handles.sizes{3} = handles.img_size_3;

handles.panels = cell(1,2);
handles.panels{1} = handles.panel_img_1;
handles.panels{2} = handles.panel_img_2;
set(handles.panels{1},'BackgroundColor',handles.color_seleccion{1});
set(handles.sizes{1},'BackgroundColor',handles.color_seleccion{1});

set(handles.popup_gama,'Value',7);
colormap(gray);

set(handles.mse, 'Value', 0.0);
set(handles.mse, 'String', '0.0');
set(handles.snr, 'Value', 0.0);
set(handles.snr, 'String', '0.0');
set(handles.isnr, 'Value', 0.0);
set(handles.isnr, 'String', '0.0');

%Modulo 2
handles.ruidoUA_label = 'Uniforme aditivo';
handles.ruidoGA_label = 'Gaussiano aditivo';
handles.ruidoSP_label = 'Sal y pimienta';
handles.ruidoGM_label = 'Gaussiano multiplicativo';

handles.filtroP_label = 'Alisamiento promedio';
handles.filtroG_label = 'Alisamiento Gaussiano';
handles.filtroOMed_label = 'Orden mediana';
handles.filtroOMax_label = 'Orden maximo';
handles.filtroOMin_label = 'Orden minimo';

%Modulo 3
handles.impl_matlab = 'Matlab';
handles.impl_propia = 'Propia';

handles.filtro_roberts = 'Roberts';
handles.filtro_sobel = 'Sobel';
handles.filtro_prewitt = 'Prewitt';
handles.filtro_canny = 'Canny';


% Choose default command line output for mod1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mod1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mod1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in button_abrir.
function button_abrir_Callback(hObject, eventdata, handles)
% hObject    handle to button_abrir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    [Imagen, cancelado] = abrirImagen();

    if ~cancelado
       handles.img_original{handles.img_seleccionada} = Imagen;
       handles.img_actual{handles.img_seleccionada} = handles.img_original{handles.img_seleccionada};
       pintar_imagen(handles, handles.img_seleccionada);
       actualizar_sizes(handles, handles.img_seleccionada);
    end

    guidata(hObject, handles);
    
% --- Pintar imagen
function pintar_imagen(handles, indice)
    axes(handles.axes{indice});
    imagesc(handles.img_actual{indice}), axis image, axis off;
    colorbar_aux(handles.colorbar, handles, indice);
    
function actualizar_sizes(handles, indice)
    m = 0;
    n = 0;
    if ~isempty(handles.img_actual{indice})
        [m, n] = size(handles.img_actual{indice});
    end
    set(handles.sizes{indice},'String', strcat(num2str(m),{' x '},num2str(n)));

% --- Executes on button press in button_reset.
function button_reset_Callback(hObject, eventdata, handles)
% hObject    handle to button_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

   handles.img_actual{handles.img_seleccionada} = handles.img_original{handles.img_seleccionada};
   if ~isempty(handles.img_actual{handles.img_seleccionada})
       pintar_imagen(handles, handles.img_seleccionada);
   end

   actualizar_sizes(handles, handles.img_seleccionada);
    
   guidata(hObject, handles);   


% --- Executes on button press in button_guardar.
function button_guardar_Callback(hObject, eventdata, handles)
% hObject    handle to button_guardar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(handles.img_actual{3})
    guardarImagen(handles.img_actual{3});
end


% --- Executes on selection change in popup_gama.
function popup_gama_Callback(hObject, eventdata, handles)
% hObject    handle to popup_gama (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popup_gama contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_gama

    lista = get(hObject,'String');
    indice = get(hObject,'Value');
    
    colormap(strcat(lista{indice},'(',get(handles.niveles,'String'),')'));


% --- Executes during object creation, after setting all properties.
function popup_gama_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_gama (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radio_img_2.
function radio_img_2_Callback(hObject, eventdata, handles)
% hObject    handle to radio_img_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_img_2

handles.img_seleccionada = 2;
set(handles.panels{1},'BackgroundColor',handles.color_seleccion{handles.img_seleccionada});
set(handles.sizes{1},'BackgroundColor',handles.color_seleccion{handles.img_seleccionada});
set(handles.panels{2},'BackgroundColor',handles.color_seleccion{3 - handles.img_seleccionada});
set(handles.sizes{2},'BackgroundColor',handles.color_seleccion{3 - handles.img_seleccionada});
 
guidata(hObject, handles);

% --- Executes on button press in radio_img_1.
function radio_img_1_Callback(hObject, eventdata, handles)
% hObject    handle to radio_img_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_img_1

handles.img_seleccionada = 1;
set(handles.panels{1},'BackgroundColor',handles.color_seleccion{handles.img_seleccionada});
set(handles.sizes{1},'BackgroundColor',handles.color_seleccion{handles.img_seleccionada});
set(handles.panels{2},'BackgroundColor',handles.color_seleccion{3 - handles.img_seleccionada});
set(handles.sizes{2},'BackgroundColor',handles.color_seleccion{3 - handles.img_seleccionada});
 
guidata(hObject, handles);


% funcion auxiliar colobar para no repetir codigo
function colorbar_aux(hObject, handles, i)
    valor = get(hObject,'Value');
    if valor == 0
        if ~isempty(handles.img_actual{i})
            colorbar('delete','peer',handles.axes{i});
        end
        set(handles.axes{i}, 'Position', handles.axes_position{i});
    else
        if ~isempty(handles.img_actual{i})
            colorbar('peer',handles.axes{i});
        end
        set(handles.axes{i}, 'Position', handles.axes_colorbar_position{i});

    end
    
guidata(hObject, handles);

% --- Executes on button press in colorbar.
function colorbar_Callback(hObject, eventdata, handles)
% hObject    handle to colorbar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of colorbar
    

    valor = get(hObject,'Value');
    for i=1:3
        colorbar_aux(hObject, handles, i);
    end


% --- Executes on button press in copiar_img.
function copiar_img_Callback(hObject, eventdata, handles)
% hObject    handle to copiar_img (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if  ~isempty(handles.img_actual{3})
    handles.img_actual{handles.img_seleccionada} = handles.img_actual{3};
    if isempty(handles.img_original{handles.img_seleccionada})
        handles.img_original{handles.img_seleccionada} = handles.img_actual{3};
    end
    pintar_imagen(handles, handles.img_seleccionada);
    actualizar_sizes(handles, handles.img_seleccionada);
    guidata(hObject, handles);
end


% --- Executes on button press in diferencia.
function diferencia_Callback(hObject, eventdata, handles)
% hObject    handle to diferencia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.img_actual{1}) && ~isempty(handles.img_actual{2})
   if size(handles.img_actual{1}) == size(handles.img_actual{2})
        handles.img_actual{3} = double(handles.img_actual{1}) - double(handles.img_actual{2});
        
       pintar_imagen(handles, 3);
       actualizar_sizes(handles, 3);
       guidata(hObject, handles);
   else
       errordlg('No se pudo calcular la diferencia porque el tamaño de las imagenes no es el mismo', 'Error diferencia');
   end
else
   errordlg('No se pudo calcular la diferencia porque falta alguna imagen', 'Error diferencia'); 
end



% --- Executes on button press in MSE.
function MSE_Callback(hObject, eventdata, handles)
% hObject    handle to MSE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[m1,n1] = size(handles.img_actual{1});
[m2,n2] = size(handles.img_actual{2});

if m1 ~= 0 && n1 ~= 0 && m1 == m2 && n1 == n2
    mse = (sum(sum((double(handles.img_actual{1}) - double(handles.img_actual{2})) .^ 2))) / (m1 * n1);
    set(handles.mse, 'Value', mse);
    set(handles.mse, 'String', num2str(mse));
else
    errordlg('El tamaño de las imagenes es distinto o una de las dimensiones es nula','Error MSE');
end


% --- Executes on button press in swap.
function swap_Callback(hObject, eventdata, handles)
% hObject    handle to swap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
aux = handles.img_actual{1};
handles.img_actual{1} = handles.img_actual{2};
handles.img_actual{2} = aux;

aux = handles.img_original{1};
handles.img_original{1} = handles.img_original{2};
handles.img_original{2} = aux;

for i=1:2
    if ~isempty(handles.img_actual{i})
        pintar_imagen(handles, i);
    else
        cla(handles.axes{i});
        colorbar('delete','peer',handles.axes{i});
    end
    actualizar_sizes(handles, i);
end

guidata(hObject, handles);


% --- Executes on button press in button_subm.
function button_subm_Callback(hObject, eventdata, handles)
% hObject    handle to button_subm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

factor = floor(str2double(get(handles.factor_subm,'String')));
if factor > 0 && ~isempty(handles.img_actual{handles.img_seleccionada})
    [m, n] = size(handles.img_actual{handles.img_seleccionada});
    contenido = get(handles.list_subm,'String');
    if strcmp(contenido{get(handles.list_subm, 'Value')}, 'Simple')  %simple
        %handles.img_actual{3} = handles.img_actual{handles.img_seleccionada}(ceil(factor/2):factor:m, ceil(factor/2):factor:n);
        handles.img_actual{3} = handles.img_actual{handles.img_seleccionada}(1:factor:m, 1:factor:n);
    else %promedio
        h = fspecial('average', factor);
        if mod(factor,2) == 0
            h(factor+1,:) = 0;
            h(:,factor+1) = 0;
        end
        
        aux = imfilter(handles.img_actual{handles.img_seleccionada}, h, 'conv');
        handles.img_actual{3} = aux(ceil(factor/2):factor:m, ceil(factor/2):factor:n);
        
    end
    pintar_imagen(handles, 3);
    actualizar_sizes(handles, 3);
    guidata(hObject, handles);
else
    errordlg('Imagen no encontrada o el factor es menor que 1','Error submuestreo');
end


function factor_subm_Callback(hObject, eventdata, handles)
% hObject    handle to factor_subm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of factor_subm as text
%        str2double(get(hObject,'String')) returns contents of factor_subm as a double


% --- Executes during object creation, after setting all properties.
function factor_subm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to factor_subm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in list_subm.
function list_subm_Callback(hObject, eventdata, handles)
% hObject    handle to list_subm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns list_subm contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_subm


% --- Executes during object creation, after setting all properties.
function list_subm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_subm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function interp_Callback(hObject, eventdata, handles)
% hObject    handle to interp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of interp as text
%        str2double(get(hObject,'String')) returns contents of interp as a double


% --- Executes during object creation, after setting all properties.
function interp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to interp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function interp_n_Callback(hObject, eventdata, handles)
% hObject    handle to interp_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of interp_n as text
%        str2double(get(hObject,'String')) returns contents of interp_n as a double


% --- Executes during object creation, after setting all properties.
function interp_n_CreateFcn(hObject, eventdata, handles)
% hObject    handle to interp_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popup_interp.
function popup_interp_Callback(hObject, eventdata, handles)
% hObject    handle to popup_interp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popup_interp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_interp


% --- Executes during object creation, after setting all properties.
function popup_interp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_interp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_interp.
function button_interp_Callback(hObject, eventdata, handles)
% hObject    handle to button_interp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

factor = floor(str2double(get(handles.interp,'String')));
if factor >= 0 && ~isempty(handles.img_actual{handles.img_seleccionada})
    lista = get(handles.popup_interp, 'String');
    handles.img_actual{3} = imresize(handles.img_actual{handles.img_seleccionada}, factor, lista{get(handles.popup_interp, 'Value')});
    pintar_imagen(handles, 3);
    actualizar_sizes(handles, 3);
    guidata(hObject, handles);
else
    errordlg('Imagen no encontrada o los factores son menores que 1','Error interpolación');
end



function niveles_Callback(hObject, eventdata, handles)
% hObject    handle to niveles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of niveles as text
%        str2double(get(hObject,'String')) returns contents of niveles as a double
popup_gama_Callback(handles.popup_gama, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function niveles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to niveles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function radio_img_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radio_img_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on selection change in list_ruido.
function list_ruido_Callback(hObject, eventdata, handles)
% hObject    handle to list_ruido (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns list_ruido contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_ruido

    contenido = get(handles.list_ruido,'String');
    etiqueta = contenido{get(handles.list_ruido, 'Value')};


    switch etiqueta
        case handles.ruidoUA_label %UA
            set(handles.label_a,'String','C. Inferior');
            set(handles.input_a,'String','-5');
            set(handles.label_b,'String','C. Superior');
            set(handles.input_b,'String','5');
            set(handles.input_b,'Visible','on');
        case handles.ruidoGA_label %GA
            set(handles.label_a,'String','Media');
            set(handles.input_a,'String','0.0');
            set(handles.label_b,'String','Varianza');
            set(handles.input_b,'String','1.0');
            set(handles.input_b,'Visible','on');
        case handles.ruidoSP_label %SP
            set(handles.label_a,'String','% Pimienta');
            set(handles.input_a,'String','5');
            set(handles.label_b,'String','% Sal');
            set(handles.input_b,'String','5');
            set(handles.input_b,'Visible','on');
        case handles.ruidoGM_label %GM
            set(handles.label_a,'String','Alfa');
            set(handles.input_a,'String','0.1');
            set(handles.label_b,'String','');
            set(handles.input_b,'Visible','off');
       
        otherwise
            errordlg('Ruido no soportado', 'Error ruido');
    end
    
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function list_ruido_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_ruido (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_a_Callback(hObject, eventdata, handles)
% hObject    handle to input_a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_a as text
%        str2double(get(hObject,'String')) returns contents of input_a as a double


% --- Executes during object creation, after setting all properties.
function input_a_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_b_Callback(hObject, eventdata, handles)
% hObject    handle to input_b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_b as text
%        str2double(get(hObject,'String')) returns contents of input_b as a double


% --- Executes during object creation, after setting all properties.
function input_b_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ruidoUA(hObject, eventdata, handles)
    [m n] = size(handles.img_actual{handles.img_seleccionada});
    a = str2double(get(handles.input_a,'String'));
    b = str2double(get(handles.input_b,'String'));
    ruido = (a + (b - a) * rand(m, n));
    handles.img_actual{3} = uint8(min(max(double(handles.img_actual{handles.img_seleccionada}) + ruido, 0), 255));
    pintar_imagen(handles, 3);
    actualizar_sizes(handles, 3);
    guidata(hObject, handles);
    
function ruidoGA(hObject, eventdata, handles)
    [m n] = size(handles.img_actual{handles.img_seleccionada});
    media = str2double(get(handles.input_a,'String'));
    varianza = str2double(get(handles.input_b,'String'));
    ruido = (media + sqrt(varianza) * randn(m, n));
    handles.img_actual{3} = uint8(min(max(double(handles.img_actual{handles.img_seleccionada}) + ruido, 0), 255));
    pintar_imagen(handles, 3);
    actualizar_sizes(handles, 3);
    guidata(hObject, handles);
    
function ruidoSP(hObject, eventdata, handles)
    [m n] = size(handles.img_actual{handles.img_seleccionada});
    sal = str2double(get(handles.input_a,'String')) / 100;
    pimienta = 1 - (str2double(get(handles.input_b,'String')) / 100);
    ruido = rand(m, n);
    handles.img_actual{3} = handles.img_actual{handles.img_seleccionada};
    handles.img_actual{3}(ruido <= sal) = 0;
    handles.img_actual{3}(ruido >= pimienta) = 255;
    pintar_imagen(handles, 3);
    actualizar_sizes(handles, 3);
    guidata(hObject, handles);
    
function ruidoGM(hObject, eventdata, handles)
    [m n] = size(handles.img_actual{handles.img_seleccionada});
    I = handles.img_actual{handles.img_seleccionada};
    I2 = I.^2;
    alpha = str2double(get(handles.input_a,'String'));
    alpha2 = alpha^2;
    dist_gauss = randn(m, n);
    handles.img_actual{3} = uint8(min(max(double(I) + sqrt(double(alpha) * double(I)) .* dist_gauss, 0), 255));
    pintar_imagen(handles, 3);
    actualizar_sizes(handles, 3);   
    guidata(hObject, handles);

% --- Executes on button press in button_ruido.
function button_ruido_Callback(hObject, eventdata, handles)
% hObject    handle to button_ruido (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    if (~isempty(handles.img_actual{handles.img_seleccionada}))
        contenido = get(handles.list_ruido,'String');
        etiqueta = contenido{get(handles.list_ruido, 'Value')};

        
        switch etiqueta
            case handles.ruidoUA_label %UA
                ruidoUA(hObject, eventdata, handles);
            case handles.ruidoGA_label %GA
                ruidoGA(hObject, eventdata, handles);
            case handles.ruidoSP_label %SP
                ruidoSP(hObject, eventdata, handles);
            case handles.ruidoGM_label %GM
                ruidoGM(hObject, eventdata, handles);
            otherwise
                errordlg('Ruido no soportado','Error ruido');
        end
        
    else
        errordlg('Imagen no encontrada','Error ruido');
    end
    


% --- Executes on button press in SNR.
function SNR_Callback(hObject, eventdata, handles)
% hObject    handle to SNR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[m1,n1] = size(handles.img_actual{1});
[m2,n2] = size(handles.img_actual{2});

if m1 ~= 0 && n1 ~= 0 && m1 == m2 && n1 == n2
    dif_media = sum(sum((double(handles.img_actual{1}) - mean2(double(handles.img_actual{1}))) .^2));
    error = sum(sum((double(handles.img_actual{1}) - double(handles.img_actual{2})) .^2));

    snr = 10 * log10(dif_media / error);
    
    set(handles.snr, 'Value', snr);
    set(handles.snr, 'String', num2str(snr));
else
    errordlg('El tamaño de las imagenes es distinto o una de las dimensiones es nula','Error SNR');
end


% --- Executes on selection change in list_filtrado.
function list_filtrado_Callback(hObject, eventdata, handles)
% hObject    handle to list_filtrado (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns list_filtrado contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_filtrado

    contenido = get(handles.list_filtrado,'String');
    etiqueta = contenido{get(handles.list_filtrado, 'Value')};


    switch etiqueta
        case handles.filtroP_label
            set(handles.label_c,'String','Tamaño Vecindario');
            set(handles.input_c,'String','3');
            set(handles.label_d,'Visible','off');
            set(handles.input_d,'Visible','off');
        case handles.filtroG_label
            set(handles.label_c,'String','Tamaño Vecindario');
            set(handles.input_c,'String','3');
            set(handles.label_d,'Visible','on');
            set(handles.input_d,'String','3');
            set(handles.input_d,'Visible','on');
        case handles.filtroOMed_label
            set(handles.label_c,'String','Tamaño Vecindario');
            set(handles.input_c,'String','3');
            set(handles.label_d,'Visible','off');
            set(handles.input_d,'Visible','off');
        case handles.filtroOMax_label
            set(handles.label_c,'String','Tamaño Vecindario');
            set(handles.input_c,'String','3');
            set(handles.label_d,'Visible','off');
            set(handles.input_d,'Visible','off');
        case handles.filtroOMin_label
            set(handles.label_c,'String','Tamaño Vecindario');
            set(handles.input_c,'String','3');
            set(handles.label_d,'Visible','off');
            set(handles.input_d,'Visible','off');
            
       
        otherwise
            errordlg('Filtrado no soportado', 'Error filtrado');
    end
    
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function list_filtrado_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_filtrado (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_c_Callback(hObject, eventdata, handles)
% hObject    handle to input_c (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_c as text
%        str2double(get(hObject,'String')) returns contents of input_c as a double


% --- Executes during object creation, after setting all properties.
function input_c_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_c (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_d_Callback(hObject, eventdata, handles)
% hObject    handle to input_d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_d as text
%        str2double(get(hObject,'String')) returns contents of input_d as a double


% --- Executes during object creation, after setting all properties.
function input_d_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function [I] = filtroP(hObject, eventdata, handles)
    vecindario = str2num(get(handles.input_c,'String'));
    h = fspecial('average', vecindario);
    
    I = imfilter(handles.img_actual{handles.img_seleccionada}, h, 'replicate');

    
function [I] = filtroG(hObject, eventdata, handles)
    vecindario = str2num(get(handles.input_c,'String'));
    varianza = str2num(get(handles.input_d,'String'));
    h = fspecial('gaussian', vecindario, sqrt(double(varianza)));
   
    I = imfilter(handles.img_actual{handles.img_seleccionada}, h, 'replicate');
    
function [I] = filtroOMed(hObject, eventdata, handles)
    vecindario = str2num(get(handles.input_c,'String'));
    I = medfilt2(handles.img_actual{handles.img_seleccionada}, [vecindario vecindario]);

 
function [I] = filtroOMax(hObject, eventdata, handles)
    vecindario = str2num(get(handles.input_c,'String'));
    I = ordfilt2(handles.img_actual{handles.img_seleccionada}, vecindario^2, ones(vecindario, vecindario));

    
function [I] = filtroOMin(hObject, eventdata, handles)
    vecindario = str2num(get(handles.input_c,'String'));
    I = ordfilt2(handles.img_actual{handles.img_seleccionada}, 1, ones(vecindario, vecindario));


function [I] = filtrado_aux(hObject, eventdata, handles)
    contenido = get(handles.list_filtrado,'String');
    etiqueta = contenido{get(handles.list_filtrado, 'Value')};
    switch etiqueta
         case handles.filtroP_label
             I = filtroP(hObject, eventdata, handles);
         case handles.filtroG_label
             I = filtroG(hObject, eventdata, handles);
         case handles.filtroOMed_label
             I = filtroOMed(hObject, eventdata, handles);
         case handles.filtroOMax_label
             I = filtroOMax(hObject, eventdata, handles);
         case handles.filtroOMin_label
             I = filtroOMin(hObject, eventdata, handles);

         otherwise
             errordlg('Filtrado no soportado', 'Error filtrado');
     end


% --- Executes on button press in button_filtrado.
function button_filtrado_Callback(hObject, eventdata, handles)
% hObject    handle to button_filtrado (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    if (~isempty(handles.img_actual{handles.img_seleccionada}))

        handles.img_actual{3} = filtrado_aux(hObject, eventdata, handles);
        pintar_imagen(handles, 3);
        actualizar_sizes(handles, 3);   
        guidata(hObject, handles); 
        
    else
        errordlg('Imagen no encontrada','Error filtrado');
    end


% --- Executes on button press in ISNR.
function ISNR_Callback(hObject, eventdata, handles)
% hObject    handle to ISNR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    [m1,n1] = size(handles.img_actual{1});
    [m2,n2] = size(handles.img_actual{2});

    if m1 ~= 0 && n1 ~= 0 && m1 == m2 && n1 == n2
        dif_estim = sum(sum((double(handles.img_actual{1}) - double(handles.img_actual{3})) .^2));
        error = sum(sum((double(handles.img_actual{1}) - double(handles.img_actual{2})) .^2));

        isnr = 10 * log10(error / dif_estim);

        set(handles.isnr, 'Value', isnr);
        set(handles.isnr, 'String', num2str(isnr));
    else
        errordlg('El tamaño de las imagenes es distinto o una de las dimensiones es nula','Error ISNR');
    end


% --- Executes on selection change in implement_fronteras.
function implement_fronteras_Callback(hObject, eventdata, handles)
% hObject    handle to implement_fronteras (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns implement_fronteras contents as cell array
%        contents{get(hObject,'Value')} returns selected item from implement_fronteras
 
    contenido = get(handles.implement_fronteras,'String');
    etiqueta = contenido{get(handles.implement_fronteras, 'Value')};
    matlab_list = {'Roberts';'Sobel';'Prewitt';'Canny'};
    propia_list = {'Roberts';'Sobel';'Prewitt'};

    switch etiqueta
        case handles.impl_matlab
            set(handles.umbral_fronteras,'Enable','inactive');
            set(handles.alisamiento_fronteras,'Enable','inactive');
            set(handles.filtro_fronteras,'String',matlab_list);
        case handles.impl_propia
            set(handles.umbral_fronteras,'Enable','on');
            set(handles.alisamiento_fronteras,'Enable','on');
            set(handles.filtro_fronteras,'String',propia_list);
        otherwise
            errordlg('Implementación no soportada', 'Error fronteras');
    end
    
    set(handles.filtro_fronteras,'Value',1);
    
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function implement_fronteras_CreateFcn(hObject, eventdata, handles)
% hObject    handle to implement_fronteras (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in filtro_fronteras.
function filtro_fronteras_Callback(hObject, eventdata, handles)
% hObject    handle to filtro_fronteras (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns filtro_fronteras contents as cell array
%        contents{get(hObject,'Value')} returns selected item from filtro_fronteras


% --- Executes during object creation, after setting all properties.
function filtro_fronteras_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filtro_fronteras (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function umbral_fronteras_Callback(hObject, eventdata, handles)
% hObject    handle to umbral_fronteras (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of umbral_fronteras as text
%        str2double(get(hObject,'String')) returns contents of umbral_fronteras as a double


% --- Executes during object creation, after setting all properties.
function umbral_fronteras_CreateFcn(hObject, eventdata, handles)
% hObject    handle to umbral_fronteras (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in alisamiento_fronteras.
function alisamiento_fronteras_Callback(hObject, eventdata, handles)
% hObject    handle to alisamiento_fronteras (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of alisamiento_fronteras


function [I] = f_matlab(hObject,eventdata,handles,filtro)
    I = uint8(edge(handles.img_actual{handles.img_seleccionada},lower(filtro)));      

function [I] = f_Roberts(hObject, eventdata, handles)
    alisamiento = get(handles.alisamiento_fronteras,'Value');
    umbral = str2double(get(handles.umbral_fronteras,'String'));
    if alisamiento == 1
        I = filtrado_aux(hObject, eventdata, handles);
    else
        I = handles.img_actual{handles.img_seleccionada};
    end
    
    I = double(I);    
    h1 = [1 0; 0 -1]/sqrt(2);
    h2 = [0 -1; 1 0]/sqrt(2);
    I1 = imfilter(I,h1,'replicate');
    I2 = imfilter(I,h2,'replicate');
    G = sqrt(double(I1).^2 + double(I2).^2);
    I = (G > umbral);
    I = uint8(I)*255;


function [I] = f_Sobel(hObject, eventdata, handles)
    alisamiento = get(handles.alisamiento_fronteras,'Value');
    umbral = str2double(get(handles.umbral_fronteras,'String'));
    if alisamiento == 1
        I = filtrado_aux(hObject, eventdata, handles);
    else
        I = handles.img_actual{handles.img_seleccionada};
    end
    
    I = double(I);    
    h1 = [-1 -2 -1; 0 0 0; 1 2 1]/8;
    h2 = [-1 0 1; -2 0 2; -1 0 1]/8;
    I1 = imfilter(I,h1,'replicate');
    I2 = imfilter(I,h2,'replicate');
    G = sqrt(double(I1).^2 + double(I2).^2);
    I = (G > umbral);



function [I] = f_Prewitt(hObject, eventdata, handles)
    alisamiento = get(handles.alisamiento_fronteras,'Value');
    umbral = str2double(get(handles.umbral_fronteras,'String'));
    if alisamiento == 1
        I = filtrado_aux(hObject, eventdata, handles);
    else
        I = handles.img_actual{handles.img_seleccionada};
    end
    
    I = double(I);
    h1 = [-1 -1 -1; 0 0 0; 1 1 1]/6;
    h2 = [-1 0 1; -1 0 1; -1 0 1]/6;
    I1 = imfilter(I,h1,'replicate');
    I2 = imfilter(I,h2,'replicate');
    G = sqrt(double(I1).^2 + double(I2).^2);
    I = (G > umbral);
    I = uint8(I)*255;
    
    
% --- Executes on button press in button_fronteras.
function button_fronteras_Callback(hObject, eventdata, handles)
% hObject    handle to button_fronteras (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if (~isempty(handles.img_actual{handles.img_seleccionada}))
        contenido1 = get(handles.implement_fronteras,'String');
        implementacion = contenido1{get(handles.implement_fronteras, 'Value')};
        contenido2 = get(handles.filtro_fronteras,'String');
        filtro = contenido2{get(handles.filtro_fronteras, 'Value')};
        
        if strcmp(implementacion, handles.impl_matlab) == 1
            handles.img_actual{3} = f_matlab(hObject,eventdata,handles,filtro);
        else
            switch filtro
                case handles.filtro_roberts
                    handles.img_actual{3} = f_Roberts(hObject, eventdata, handles);
                case handles.filtro_sobel
                    handles.img_actual{3} = f_Sobel(hObject, eventdata, handles);
                case handles.filtro_prewitt
                    handles.img_actual{3} = f_Prewitt(hObject, eventdata, handles);
                otherwise
                    errordlg('Ruido no soportado','Error ruido');
            end
            
        end
        
        pintar_imagen(handles, 3);
        actualizar_sizes(handles, 3);   
        guidata(hObject, handles);
        

        
    else
        errordlg('Imagen no encontrada','Error fronteras');
    end



function v_esquinas_Callback(hObject, eventdata, handles)
% hObject    handle to v_esquinas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v_esquinas as text
%        str2double(get(hObject,'String')) returns contents of v_esquinas as a double


% --- Executes during object creation, after setting all properties.
function v_esquinas_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v_esquinas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function u_esquinas_Callback(hObject, eventdata, handles)
% hObject    handle to u_esquinas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of u_esquinas as text
%        str2double(get(hObject,'String')) returns contents of u_esquinas as a double


% --- Executes during object creation, after setting all properties.
function u_esquinas_CreateFcn(hObject, eventdata, handles)
% hObject    handle to u_esquinas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in button_esquinas.
function button_esquinas_Callback(hObject, eventdata, handles)
% hObject    handle to button_esquinas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    vecindario = str2num(get(handles.v_esquinas,'String'));
    umbral = str2num(get(handles.u_esquinas,'String'));
    supresion = get(handles.supr_esquinas,'Value');
    distancia = str2num(get(handles.dist_esquinas,'String'));
    
    
    I = double(handles.img_actual{handles.img_seleccionada});

    h = [-1,0,1];
    Ix = imfilter(I,h,'replicate'); %gh
    Iy = imfilter(I,h','replicate'); %gv

    if mod(vecindario,2) == 0
        vecindario = vecindario-1;
    end
    if mod(distancia,2) == 0
        distancia = distancia-1;
    end

    h = ones(vecindario, vecindario);
    Ix2 = imfilter(Ix.^2,h,'replicate');
    Iy2 = imfilter(Iy.^2,h,'replicate');
    Ixy = imfilter(Ix.*Iy,h,'replicate');

    [nf,nc] = size(I);
    Autovalores = zeros(nf,nc);
    for i=1:nf
        for j=1:nc
            C = ([Ix2(i,j) Ixy(i,j); Ixy(i,j) Iy2(i,j)]);
            Autovalores(i,j) = min(eig(C));
        end
    end

    %%
    
    if supresion == 1
        [fila columna minval] = find(Autovalores>umbral);
        col_aux = columna;
        fil_aux = fila;
        [aux1 indices] = sort(minval,'descend');

        limite = length(minval);
        for i=1:limite
            for j=(i+1):limite
                d = abs(fila(indices(i))-fila(indices(j)))+abs(columna(indices(i))-columna(indices(j)));

                if d < distancia
                    col_aux(indices(j)) = 0;
                    fil_aux(indices(j)) = 0;

                end
            end
        end

        [aux1 aux2 c] = find(col_aux); 
        [aux1 aux2 f] = find(fil_aux);
    else
        [f c] = find(Autovalores > umbral);
    end
    
  
    figure,imshow(handles.img_actual{handles.img_seleccionada},[]),colormap(gray(256)),hold on;
    plot(c,f,'ys'),title('Esquinas detectadas');
    
    

% --- Executes on button press in supr_esquinas.
function supr_esquinas_Callback(hObject, eventdata, handles)
% hObject    handle to supr_esquinas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of supr_esquinas
    supr = get(handles.supr_esquinas, 'Value');

    if supr == 1
        set(handles.dist_esquinas,'Enable','on');
    else
        set(handles.dist_esquinas,'Enable','inactive');
    end



function dist_esquinas_Callback(hObject, eventdata, handles)
% hObject    handle to dist_esquinas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dist_esquinas as text
%        str2double(get(hObject,'String')) returns contents of dist_esquinas as a double


% --- Executes during object creation, after setting all properties.
function dist_esquinas_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dist_esquinas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



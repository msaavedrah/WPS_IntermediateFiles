close all
clear all
clc
%*******************************************
%***	EDIT [intital - final] time		****
%*******************************************
dt = 03;								% Intervalo de tiempo
t_vec_o = [2001 11 16 03 00 00];		% Tiempo inicial de wrfout
t_vec_f = [2002 02 28 00 00 00];		% Tiempo final de wrfout
t_num_o = datenum(t_vec_o);
t_num_f = datenum(t_vec_f);
t_vec_inicio = [2001 11 26 03 00 00];	% Tiempo de inicio de simulacion para DOM 1km 
t_num_inicio = datenum(t_vec_inicio);
t_o = 0363;								% Nro asociado al 1er tiempo-wrfout/archivo-UPP
t_f = 2856;								% Nro asociado al ultimo tiempo-wrfout/archivo-UPP
%***	Ubicacion de archivos de entrada y salida
DIR_input  = './';
DIR_output = './';
%***	Prefijos de archivos de entrada y salida
pref_input  = 'WRFPRS_d02.';%'WRFPRS_d02.1497';
pref_output = 'WRFPRS_d02.';%'WRFPRS_d02.1497';
%**************************************************************************************
%***	Evaluar ventana de tiempo
%**************************************************************************************	
%***	fechas
t_num = t_num_o:3.*1./24.:t_num_f;
t_vec = datevec(t_num);
%***	numeracion
t = t_o:dt:t_f;

%***	Evaluacion	****
if (length(t_num) == length(t))
	disp('*********************************************************************')
	disp('El nro de archivos es IGUAL al nro de fechas de los archivos NETCDF !')
	disp('*********************************************************************')
else
	disp('*************************************************************************')
	disp('El nro de archivos es DIFERENTE al nro de fechas de los archivos NETCDF !')
	disp('*************************************************************************')
	break
end

%**************************************************************************************
%***	Convirtiendo nombre de archivos [Nros -> fechas]
%**************************************************************************************	

N = length(t_num);
for i = 1:N
	input_file  = [pref_input  num2str(t(i),'%4.4i')];
	output_file = [pref_output datestr(t_num(i),'yyyy-mm-dd_HH') '.grib1'];
	if (exist([DIR_input input_file])~=2);
		disp(['El archivo  ' [DIR_input input_file] '  no existe !!!'])
		break
	end
	if (t_num(i)<t_num_inicio)
		disp(['Out of window:  ' input_file])
	else
		disp([input_file '  --> ' output_file])
		%system(['cp ' DIR_input input_file ' ' DIR_output output_file])
		system(['ln -sf ' input_file ' ' output_file])
	end
end


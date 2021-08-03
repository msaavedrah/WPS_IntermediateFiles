  ;***	CREATING TIMES		*****************************************
  dt = 03										;DEFINIR editable
  tv_o = (/2001,11,26,03,00,00/)				;DEFINIR editable
  tv_f = (/2002,02,28,00,00,00/)				;DEFINIR editable
  un_str = "hours since " + sprinti("%0.4i",tv_o(0)) + "-" + sprinti("%0.2i",tv_o(1)) + "-" + sprinti("%0.2i",tv_o(2)) + " " \
                		  + sprinti("%0.2i",tv_o(3)) + ":" + sprinti("%0.2i",tv_o(4)) + ":" + sprinti("%0.2i",tv_o(4))
  print(un_str)
  tn_o = cd_inv_calendar(tv_o(0),tv_o(1),tv_o(2),tv_o(3),tv_o(4),tv_o(5),un_str,0)
  tn_f = cd_inv_calendar(tv_f(0),tv_f(1),tv_f(2),tv_f(3),tv_f(4),tv_f(5),un_str,0)
  t = ispan(tointeger(tn_o),tointeger(tn_f),dt)
  t@units = un_str
  ;t = ispan(0,597,3)
  ;t@units = "hours since 2001-11-16 03:00:00"
  nt = dimsizes(t)
	;DANDO FORMATO A CADA ELEMENTO DE t
    utc_date = cd_calendar(t, 0)
      year   = tointeger(utc_date(:,0))    ; Convert to integer for
      month  = tointeger(utc_date(:,1))    ; use sprinti 
      day    = tointeger(utc_date(:,2))
      hour   = tointeger(utc_date(:,3))
  date_str = sprinti("%0.4i", year) + "-" + sprinti("%0.2i", month) + "-" + \
              sprinti("%0.2i", day) + "_"  + sprinti("%0.2i", hour)
  print("The following files will be corrected (truelat)")
  print("-> " + date_str)

do i=0,nt-1
  wps_filename = "FILE:" + date_str(i)
  slabs = wrf_wps_read_int(wps_filename)
  slabs_dims = dimsizes(slabs)
  nfields    = slabs_dims(0)
  header     = slabs@rhead          ; Read into memory so we can subscript it
print(header)
  print("There are " + nfields + " fields in the " + wps_filename + " WPS file.")

  DATE             = tochar(slabs@hdate(0))
  WPS_IM_root_name = "FILET"
  output_file_name = WPS_IM_root_name 
  
  opt                   = True

  do ilev=0,nfields-1
	FIELD = slabs@field(ilev)
	UNITS = slabs@units(ilev)
	DESC  = slabs@description(ilev)
    opt@projection        = tointeger(header(ilev,5))     ; "MERCATOR"
    opt@level 			  = header(ilev,2)
    opt@date              = slabs@hdate(ilev)
    opt@map_source        = slabs@map_source(ilev)	;"CCSM 0.9 x 1.25"
    opt@startloc          = "SWCORNER"	            ; 8 chars exact
    opt@startlat          = header(ilev,6)
    opt@startlon          = header(ilev,7)
    opt@dy                = header(ilev,8)
    opt@dx                = header(ilev,9)
    opt@truelat1          = 7.5
    opt@is_wind_earth_relative = False
   ; opt@earth_radius      = header(ilev,11)

	X = slabs(ilev,:,:)
    wrf_wps_write_int(output_file_name,FIELD,UNITS,\
                      DESC,X(:,:),opt)
    delete([/FIELD,UNITS,DESC/])
  end do
delete([/slabs, slabs_dims, nfields, header,DATE,WPS_IM_root_name,output_file_name /])
end do

print("Falta adicionar el radio por defecto de WRFout")

;  _FillValue :  -1e+30
;  rhead :       <ARRAY of 2422 elements>
;  description : <ARRAY of 173 elements>
;  map_source :  <ARRAY of 173 elements>
;  units :       <ARRAY of 173 elements>
;  hdate :       <ARRAY of 173 elements>
;  field :       <ARRAY of 173 elements>

;(0,0)    5
;(0,1)    0
;(0,2)   201300
;(0,3)   369
;(0,4)   258
;(0,5)    1
;(0,6)   -26.988
;(0,7)   268.334
;(0,8)   15
;(0,9)   15
;(0,10)   0
;(0,11)  6371.229
;(0,12)  -999
;(0,13)  -999


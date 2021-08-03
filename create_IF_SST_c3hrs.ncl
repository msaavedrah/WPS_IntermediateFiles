;***    Este script genera "Intermediate files" para la SST
;***    1. Cambia las unidades de degC a K
;***    2. Cambia el fillvalue a -1.E-30

;begin
DIR_data  = "~/DATA/SST_OI/"

;Ir del anho 2000 al 2010 (Ojo)
do y = 2000,2011
    namefile = "sst.day.mean." + y +".nc"
    f = addfile(DIR_data + namefile,"r")
    ;***    TIEMPO  ****
    t = f->time
    ;printVarSummary(t)
    t_vec = cd_calendar(t,0)
    t_str = sprinti( "%0.4i", tointeger(t_vec(:,0))) + \
            sprinti( "-%0.2i", tointeger(t_vec(:,1))) + \
            sprinti( "-%0.2i", tointeger(t_vec(:,2))) + \
            sprinti( "_%0.2i", tointeger(t_vec(:,3)))
    ;Delimitando solo para el area de interes
    lat = f->lat
    lon = f->lon
    lat_o = 0.125 - 20.0
    lat_f = 0.125 +  0.0
    lon_o = 0.125 + 360.0-85.0
    lon_f = 0.125 + 360.0-70.0

    ny_o = ind(lat .eq. lat_o)
    ny_f = ind(lat .eq. lat_f) 
    nx_o = ind(lon .eq. lon_o)
    nx_f = ind(lon .eq. lon_f)

    do i_JF = 0,58
        print("day = "+t_str(i_JF))
        ;***    Cambiando unidades degC -> K
        SST = f->sst(i_JF,:,:)
        SST = SST + 273.15
        SST@valid_range = SST@valid_range + 273.15              ;valid_range
        SST@actual_range = (/min(SST),max(SST)/)                ;actual range
            old_FillValue = SST@_FillValue                          ;FillValua a ser cambiado
            new_FillValue = -1.E30                                  ;Fill value de acuerdo a METGRIB.TBL
        SST@_FillValue = new_FillValue                          ;Cambio de _FillValue
        SST = where(SST .eq. old_FillValue, SST@_FillValue,SST) ;Cambio de _FillValue
            ;printVarSummary(SST)
        ;***    Creando la variable a ser extrapolada en los bordes
        SST_x = SST
            ;printVarSummary(SST_x)
        ;***    (a) LLenando con datos (9_pts_avg), el borde de la linea de costa, (solo zona de interes) (Ojo)
        do j = ny_o,ny_f
        do i = nx_o,nx_f
            if ( num(.not.ismissing(SST(j-1:j+1,i-1:i+1))) .gt. 0 ) then
                SST_x(j,i) = avg(SST(j-1:j+1,i-1:i+1))
            end if
        end do
        end do
        ;***    (b) Imprimiendo en archivo con formato INTERMIDIATE FILE
        ;*** Las sst de un dia son similares
        do h = 0,21,3
        t_str_3hr = sprinti(  "%0.4i", tointeger(t_vec(i_JF,0))) + \
                    sprinti( "-%0.2i", tointeger(t_vec(i_JF,1))) + \
                    sprinti( "-%0.2i", tointeger(t_vec(i_JF,2))) + \
                    sprinti( "_%0.2i", tointeger(t_vec(i_JF,3)+h))
        print("      "+t_str_3hr)
        WPS_IM_root_name   = "SST"
        FIELD_SST          = "SST"
        UNITS_SST          = "K"
        DESC_SST           = "Sea Surface Temperature from OI-SST"
        opt                   = True
        opt@projection        = 0                   ; "Equidistant_Lat_Lon"  (Ojo)
        opt@date              = t_str_3hr;"2006-02-04_00"     ;date
        opt@map_source        = "OI 0.25 x 0.25"
        opt@startloc          = "SWCORNER"	        ; 8 chars exact
        opt@startlon          = lon(0)
        opt@startlat          = lat(0)
        opt@deltalon          = lon(1) - lon(0)
        opt@deltalat          = lat(1) - lat(0)
        opt@level             = 200100;pnew(ilev)
        opt@is_wind_earth_relative = False
        wrf_wps_write_int(WPS_IM_root_name,FIELD_SST,UNITS_SST,\
            DESC_SST,SST_x(:,:),opt)
        end do
        delete(SST)
        delete(SST_x)
    end do

    do i_ND = dimsizes(t)-46,dimsizes(t)-1
        print("day = "+t_str(i_ND))
        SST = f->sst(i_ND,:,:)
        SST = SST + 273.15
        SST@valid_range = SST@valid_range + 273.15              ;valid_range
        SST@actual_range = (/min(SST),max(SST)/)                ;actual range
            old_FillValue = SST@_FillValue                          ;FillValua a ser cambiado
            new_FillValue = -1.E30                                  ;Fill value de acuerdo a METGRIB.TBL
        SST@_FillValue = new_FillValue                          ;Cambio de _FillValue
        SST = where(SST .eq. old_FillValue, SST@_FillValue,SST) ;Cambio de _FillValue
            ;printVarSummary(SST)
        ;***    Creando la variable a ser extrapolada en los bordes
        SST_x = SST
            ;printVarSummary(SST_x)
        ;***    (a) LLenando con datos (9_pts_avg), el borde de la linea de costa, (solo zona de interes) (Ojo)
        do j = ny_o,ny_f
        do i = nx_o,nx_f
            if ( num(.not.ismissing(SST(j-1:j+1,i-1:i+1))) .gt. 0 ) then
                SST_x(j,i) = avg(SST(j-1:j+1,i-1:i+1))
            end if
        end do
        end do
        ;***    (b) Imprimiendo en archivo con formato INTERMIDIATE FILE
        ;*** Las sst de un dia son similares
        do h = 0,21,3
        t_str_3hr = sprinti(  "%0.4i", tointeger(t_vec(i_ND,0))) + \
                    sprinti( "-%0.2i", tointeger(t_vec(i_ND,1))) + \
                    sprinti( "-%0.2i", tointeger(t_vec(i_ND,2))) + \
                    sprinti( "_%0.2i", tointeger(t_vec(i_ND,3)+h))
        print("      "+t_str_3hr)
        WPS_IM_root_name   = "SST"
        FIELD_SST          = "SST"
        UNITS_SST          = "K"
        DESC_SST           = "Sea Surface Temperature from OI-SST"
        opt                   = True
        opt@projection        = 0                   ; "Equidistant_Lat_Lon"  (Ojo)
        opt@date              = t_str_3hr;"2006-02-04_00"     ;date
        opt@map_source        = "OI 0.25 x 0.25"
        opt@startloc          = "SWCORNER"	        ; 8 chars exact
        opt@startlon          = lon(0)
        opt@startlat          = lat(0)
        opt@deltalon          = lon(1) - lon(0)
        opt@deltalat          = lat(1) - lat(0)
        opt@level             = 200100;pnew(ilev)
        opt@is_wind_earth_relative = False
        wrf_wps_write_int(WPS_IM_root_name,FIELD_SST,UNITS_SST,\
            DESC_SST,SST_x(:,:),opt)
        end do
        delete(SST)
        delete(SST_x)
    end do
    delete(f)
    delete(t)
    delete(t_vec)
    delete(t_str)
end do
;end

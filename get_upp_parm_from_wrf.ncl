begin
;nc_file="wrfout_d02_2001-11-16_03:00:00"
;nc_file="wrfout_d02_2001-12-06_03:00:00"
;nc_file="wrfout_d02_2001-12-26_03:00:00"
nc_file="wrfout_d02_2002-01-15_03:00:00"
;nc_file="wrfout_d02_2002-02-04_03:00:00"
;nc_file="wrfout_d02_2002-02-24_03:00:00"
f=addfile("../../../../../DATA_DDAY/DEF_CTL/FORCING_CTL_5KM/F2001_2002/"+nc_file,"r")
tt=f->XTIME
printVarSummary(tt)
;Tiempo inicial
a=cd_calendar(tt(0),0)
print(a)

date_str = sprinti("%0.4i", tointeger(a(0,0))) + sprinti("%0.2i", tointeger(a(0,1))) + \
		   sprinti("%0.2i", tointeger(a(0,2))) + sprinti("%0.2i", tointeger(a(0,3))) 
print("startdate = "+date_str)

;Nro de tiempos guardados
n=dimsizes(tt)
dt = (tt(1)-tt(0))/60
print("incrementhr = "+dt)
nt = (tt(n-1)-tt(0))/180
print("lasthfr = " + nt*dt)
print("t_inicio = " + tt(0)/60)
end

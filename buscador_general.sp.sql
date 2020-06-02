
exec buscador_general 'raios',1
alter procedure buscador_general(@var_consulta varchar(500),@cantidadDatos int)
as
begin
declare @columnasConsulta varchar(500)
declare @nombreColumna varchar(100)
declare @nombreTabCol varchar(100)
declare @dataType varchar(30)
declare @likeDescripcion varchar(400)
declare @nombreTabla varchar(100)
declare @contador int
declare listTablas cursor LOCAL for select TABLE_NAME from INFORMATION_SCHEMA.TABLES

declare listColumn cursor LOCAL for select TABLE_NAME,COLUMN_NAME,DATA_TYPE from INFORMATION_SCHEMA.COLUMNS where DATA_TYPE in('varchar','char','text','nvarchar');
open listTablas
fetch next from listTablas into @nombreTabla
while @@FETCH_STATUS=0
begin
open listColumn

fetch next from listColumn into @nombreTabCol,@nombreColumna,@dataType
while @@FETCH_STATUS=0
begin
	if @nombreTabla=@nombreTabCol and @nombreTabla is not null
	begin
		exec('select count(*) into'+@contador+' from '+@nombreTabla+'where upper('+@nombreColumna+') like %'+@var_consulta+'%')
		print @contador
		if @contador>0
		begin
			exec('select * from '+@nombreTabla);
		end
	end
	fetch next from listColumn into @nombreTabCol,@nombreColumna,@dataType


end
close listColumn



fetch next from listTablas into @nombreTabla

end

close listTablas
deallocate listColumn
deallocate listTablas

end

EXEC buscador_general 'raios',1